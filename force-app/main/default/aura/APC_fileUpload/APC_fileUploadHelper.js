({
    fetchUserId: function(component,event,helper) {
        component.set("v.userId",  $A.get("$SObjectType.CurrentUser.Id"));        
    },
    handleDeleteFiles : function(component, event, helper, delFiles) {        
        var fileIds = [];
        var pillsoffiles = component.get("v.pillsoffiles");       
        var newFiles = [];
        delFiles.forEach(function(file){
            fileIds.push(file.Id);
            pillsoffiles = helper.removeByKeylabel(pillsoffiles, file);
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
            	helper.fetchExistingFilesInfo(component, event, helper,"c.getExistingFilesInfo1");
            } else {
                helper.apexCallbackElse(component,event,helper,response);
            }
        });
        $A.enqueueAction(action);
    },        
    removeByKeylabel : function (array, value)    {        
        array.some(function(item, index) {
            if(array[index].label === value.Title)
            {
                array.splice(index, 1);
                return true; // stops the loop
            }
            return false;
        });        
        return array;
    } ,    
    fetchDocuments : function(component, event, helper, newFiles) {
        let docIds = [];
        newFiles.forEach(function(file){
            docIds.push(file.Id)
        });
        $A.util.removeClass(component.find("spinner"), "slds-hide");
        let action = component.get('c.getDocuments');
        action.setParams({
            params: {
                docIds: docIds
            }
        });
        action.setCallback(this,function(response){
            $A.util.addClass(component.find("spinner"), "slds-hide");
            let state = response.getState();
            if(state=='SUCCESS' && response.getReturnValue()){
                component.set("v.hasfileuploaded", true);
                component.set("v.files", response.getReturnValue());
                let pillsoffiles = [];
                let files =  response.getReturnValue();
                files.forEach(function(elem){
                    let pill = {
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
    fetchExistingFilesInfo : function(component, event, helper, methodname) {
        let action = component.get(methodname);        
        if(methodname == 'c.getExistingFilesInfo1')
        {
            var recordid = component.get("v.recordId");
             var objectcode ='';
             if(typeof(recordid) != 'undefined')
            {
                objectcode= recordid.substring(0,3);
                //alert(objectcode);
            }       
            
            action.setParams({
                caseid:  objectcode == '500' ? component.get("v.recordId"): component.get("v.caseid")
            });
        }
        
        action.setCallback(this,function(response){
            let state = response.getState();
            if(state=='SUCCESS'){
                //alert(response.getReturnValue());
                component.set("v.hasfileuploaded", true);
                component.set("v.files", response.getReturnValue());
                
                let pillsoffiles = [];
                let files = response.getReturnValue();
                debugger;
                files.forEach(function(elem){
                    var pill = {
                        "label":elem.Title, 
                        "name":elem.Title,
                        "type": 'icon',
                        "iconName": 'doctype:attachment',
                        "onclick": '{!c.pillclicked}',
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
    apexCallbackElse : function(component,event,helper,response){
        let state = response.getState();
        if (state === "INCOMPLETE") {
            helper.showToast(component,"INCOMPLETE!","INCOMPLETE","warning");
        }
        else if (state === "ERROR") {
            let errors = response.getError();
            if (errors) {
                if (errors[0] && errors[0].message) {
                    helper.showToast(component,"ERROR!","Error message: " + errors[0].message,"error");
                }
            } else {
                
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
    uploadTocaseRecord : function(component, event, helper) {
        debugger;
        const params = {
            files: event.getParam("files"),
            recordId: component.get("v.caseid")
        };
        
        let action = component.get('c.createDocumentLinks1');
        action.setParams({
            params: params
        });       
        action.setCallback(this,function(response){
            let state = response.getState();            
            if(state=='SUCCESS')
            {
                if(typeof(component.get("v.caseid")) != 'undefined')
                {
                    var methodname = "c.getExistingFilesInfo1";
                    helper.fetchExistingFilesInfo(component, event, helper,methodname);            
                }else
                {
                    component.getEvent("uploadToRecordDone").fire();
                }
            } else 
            {
                helper.apexCallbackElse(component,event,helper,response);
            }
        });
        $A.enqueueAction(action);
    },
    
})