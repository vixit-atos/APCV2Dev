({
    doInit : function(component, event, helper) {
        var recordid = component.get("v.recordId");
        var objectcode = '';
        if(typeof(recordid) != 'undefined');
        {
            objectcode= recordid.substring(0,3);
        }       
        
        var methodname = "c.getExistingFilesInfo";
        if(objectcode== '500')
        {
            methodname = "c.getExistingFilesInfo1"; // On case page
        }else
        {
             helper.fetchUserId(component, event, helper);
        }
        console.log('methodname: ' + methodname);
        helper.fetchExistingFilesInfo(component, event, helper,methodname);
    },
    
    handleUploadFinished : function(component, event, helper) { 
        debugger;
        if(typeof(component.get("v.caseid")) != 'undefined')
        {
            helper.uploadTocaseRecord(component, event, helper);
             helper.fetchExistingFilesInfo(component, event, helper,"c.getExistingFilesInfo1");
        }else
        {
             helper.fetchExistingFilesInfo(component, event, helper,"c.getExistingFilesInfo");
        }
       
    },   
    
    getFilesList : function(component, event, helper) {
        return component.get("v.files");
    },
    
    handleDeleteFile : function(component, event, helper) {
        var file = event.getParam("detail").file;
    },
    
    uploadToRecord : function(component, event, helper) {
        const params = {
            files: component.get("v.files"),
            recordId: event.getParam('arguments').recordId
        };
        
        let action = component.get('c.createDocumentLinks');
        action.setParams({
            params: params
        });
       
        action.setCallback(this,function(response){
            let state = response.getState();
            
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
    
    getSelected : function(component,event,helper){
        // display modle and set seletedDocumentId attribute with selected record Id   
        component.set("v.hasModalOpen" , true);
        component.set("v.selectedDocumentId" , event.currentTarget.getAttribute("data-Id"));         
    },
    
    closeModel: function(component, event, helper) {  
        component.set("v.hasModalOpen", false);
        component.set("v.selectedDocumentId" , null); 
    },
    
        handlepillclick: function(component, event, helper){ 
        component.set("v.hasModalOpen",true);
        component.set("v.selectedDocumentId", event.getSource().get("v.name"));       
    },
    
})