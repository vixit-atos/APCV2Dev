({
    fetchUserId: function(component,event,helper) {
        component.set("v.userId", $A.get("$SObjectType.CurrentUser.Id"));
    },
    handleDeleteFiles : function(component, event, helper, delFiles) {        
        var fileIds = [];
        var pillsoffiles = component.get("v.pillsoffiles");       
        var newFiles = [];
        delFiles.forEach(function(file){
            fileIds.push(file.Id);
            helper.removeByKeylabel(pillsoffiles, file);
        });        
        component.set("v.pillsoffiles", pillsoffiles);
        
        
        
        $A.util.removeClass(component.find("spinner"), "slds-hide");
        var action = component.get('c.deleteFiles');
        action.setParams({
            params: {
                fileIds: fileIds
            }
        });
        action.setCallback(this,function(response){
            $A.util.addClass(component.find("spinner"), "slds-hide");
            var state = response.getState();
            if(state=='SUCCESS' && response.getReturnValue()){ 
                //helper.fetchDocuments(component, event, helper, newFiles);
            } else {
                helper.apexCallbackElse(component,event,helper,response);
            }
        });
        $A.enqueueAction(action);
    },
    fetchDocuments : function(component, event, helper, newFiles) {
        var docIds = [];
        newFiles.forEach(function(file){
            docIds.push(file.Id)
        });
        $A.util.removeClass(component.find("spinner"), "slds-hide");
        var action = component.get('c.getDocuments');
        action.setParams({
            params: {
                docIds: docIds
            }
        });
        action.setCallback(this,function(response){
            $A.util.addClass(component.find("spinner"), "slds-hide");
            var state = response.getState();
            if(state=='SUCCESS' && response.getReturnValue()){
                component.set("v.hasfileuploaded", true);
                component.set("v.files", response.getReturnValue());
                var pillsoffiles = [];
                var files =  response.getReturnValue();
                files.forEach(function(elem){
                    var pill = {
                        "label":elem.Title, 
                        "name":elem.Title,
                        "type": 'icon',
                        "iconName": 'doctype:attachment',
                        "file":elem
                    };
                    pillsoffiles.push(pill);
                });
                component.set("v.pillsoffiles", pillsoffiles);
            } else {
                helper.apexCallbackElse(component,event,helper,response);
            }
        });
        $A.enqueueAction(action);
    },
    fetchFilesInfo : function(component, event, helper) {
        debugger;
        var previousfiles = [];
        // previousfiles = component.get("v.pillsoffiles");                
        const params = {
            files: event.getParam("files")
        };        
        console.log("params => ", JSON.stringify(params));        
        var action = component.get('c.getFilesInfoExternal');
        action.setParams({
            params: params
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state=='SUCCESS'){
                debugger;
                //component.set("v.hasfileuploaded", true);
                component.set("v.files", response.getReturnValue());
                
                var pillsoffiles = [];
                var fileids = [];
                
                if(component.get("v.pillsoffiles").length >0)
                {
                    pillsoffiles = component.get("v.pillsoffiles");
                }
                
                if(component.get("v.fileids").length >0)
                {
                    fileids = component.get("v.fileids");
                }
                
                var files =  response.getReturnValue();
                files.forEach(function(elem){
                    var pill = {
                        "label":elem.Title, 
                        "name":elem.Title,
                        "type": 'icon',
                        "iconName": 'doctype:attachment',
                        "file":elem
                    };
                    pillsoffiles.push(pill);
                    fileids.push(elem.Id);
                });
                
                component.set("v.pillsoffiles", pillsoffiles);
                if(fileids.length >0)
                {
                    component.set("v.fileids", fileids);
                   
                    var rowid = component.get("v.rowid");
                    if(typeof(rowid) != 'undefined'){
                        var compevent = component.getEvent("rowcheckevent");
                        compevent.setParams({"rowid":component.get("v.rowid"), 
                                             "documentids":fileids
                                            });
                        compevent.fire();
                    }                    
                }
                
            } else {
                helper.apexCallbackElse(component,event,helper,response);
            }
        });
        $A.enqueueAction(action);
    },
    apexCallbackElse : function(component,event,helper,response){
        var state = response.getState();
        if (state === "INCOMPLETE") {
            helper.showToast(component,"INCOMPLETE!","INCOMPLETE","warning");
        }
        else if (state === "ERROR") {
            var errors = response.getError();
            if (errors) {
                if (errors[0] && errors[0].message) {
                    helper.showToast(component,"ERROR!","Error message: " + errors[0].message,"error");
                }
            } else {
                console.log("Unknown error");
                helper.showToast(component,"ERROR!","Unknown error","error");
            }
        }
    },
    showToast : function(component,title,msg,variant){
        component.find('notifLib').showToast({
            title: title,
            message: msg,
            variant: variant
        });
    },
    removeByKeylabel : function (array, value)    {        
        array.some(function(item, index) {
            if(array[index].label === value.Title)
            {
                // found it!
                array.splice(index, 1);
                return true; // stops the loop
            }
            return false;
        });        
        return array;
    } ,
    handlenavigatetofile: function(component, event, helper){
        component.find("navService").navigate({    
            type: "standard__namedPage",
            attributes: {
                "pageName": 'filePreview'    
            },
            state: {
                recordIds:event.getSource().get("v.name"),
                selectedRecordId:event.getSource().get("v.name")
            }
        });
    }
})