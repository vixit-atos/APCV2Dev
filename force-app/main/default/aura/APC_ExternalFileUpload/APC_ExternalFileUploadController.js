({
    doInit : function(component, event, helper) {
        helper.fetchUserId(component, event, helper);
    },
    handleUploadFinished : function(component, event, helper) {              
        helper.fetchFilesInfo(component, event, helper);
    },
    refreshFiles : function(component, event, helper) {
        
        helper.fetchFilesInfo(component, event, helper);
    },
    getFilesList : function(component, event, helper) {
        return component.get("v.files");
    },
    handleDeleteFile : function(component, event, helper) {
        var file = event.getParam("detail").file;
        helper.handleDeleteFiles(component, event, helper, [file]);
    },
    uploadToRecord : function(component, event, helper) {
        const params = {
            files: component.get("v.files"),
            recordId: event.getParam('arguments').recordId
        };
        
        let action = component.get('c.createDocumentLinksExternal');
        action.setParams({
            params: params
        });
        //alert("params@@@@"+JSON.stringify(params));
        action.setCallback(this,function(response){
            let state = response.getState();
            //alert("state@@@@12333"+state);
            if(state=='SUCCESS'){
                component.getEvent("uploadToRecordDone").fire();
            } else {
                helper.apexCallbackElse(component,event,helper,response);
            }
        });
        $A.enqueueAction(action);
    },
    handlefileremove: function (component, event, helper){
             
        event.preventDefault();       
        var fileidclicked = event.getParam("name");
        var pillsoffiles = component.get("v.pillsoffiles");
        var file = "";
            pillsoffiles.forEach(function(pill){
                if(pill.file.Id === fileidclicked)
                {
                    file = pill.file;
                }
            });       
        helper.handleDeleteFiles(component, event, helper, [file]);
    },
    handlepillclick: function(component, event, helper){        
        debugger;
        component.set("v.hasModalOpen",true);
        component.set("v.selectedDocumentId", event.getSource().get("v.name"));       
    },
       closeModel: function(component, event, helper) {       
        component.set("v.hasModalOpen", false);
        component.set("v.selectedDocumentId" , null); 
    },
})