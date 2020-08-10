({
    doInit : function(component, event, helper)
    {
        var URL = window.location.href;
        URL = URL.split("lightning/");
        //URL = URL[0] + "lightning/r/Administrative_Tool__c/";
        URL = URL[0] + "lightning/n/Administrative_Tool/";
        component.set("v.recordURL", URL);
        
        var recordType = component.get("v.recordType");
        if(recordType != "PDF Policy Management")
        {
            var recordTypeID = component.get("v.pageReference").state.recordTypeId;
            component.set("v.recordTypeId", recordTypeID);
            component.set("v.AdminTool.RecordTypeId", recordTypeID);
            
            var action = component.get("c.getRecordType");
            action.setParams({
                "recordTypeId" : recordTypeID
            });
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (component.isValid() && state === "SUCCESS") {
                    var result = response.getReturnValue();
                    component.set("v.recordType", result);
                    
                    if(result != "Create New Model Relationship" && result != "PDF Disclaimer Management" )
                    {
                        helper.openStandard(component, event, recordTypeID);
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },
    
    submitRecord : function(component, event, helper) 
    {
        var allValid = false;
        var ModelRelation = component.find("ModelRelation");
        ModelRelation.checkMandatory(function(result){
            allValid = result;
        });
        
        if(allValid)
        {
            var AdminTool = component.get("v.AdminTool");
            
            var action = component.get("c.verifyDuplicate");
            action.setParams({
                "AdminTool" : AdminTool
            });
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (component.isValid() && state === "SUCCESS") 
                {
                    var duplicateExist = response.getReturnValue();
                    
                    if(duplicateExist)
                    {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": "Record you are trying to create is already exists",
                            "type" : "error"
                        });
                        toastEvent.fire(); 
                    }
                    else
                    {
                        //------------------  SUBMIT RECORD  ---------------------
                        var adminMethod = component.find("SubmitAdminTool");
                        adminMethod.submitAdminData(AdminTool, function(result){         
                            //alert(result);
                            
                            var URL = component.get("v.recordURL");
                            if(!URL.includes("view"))
                            {
                                // URL = URL + result + "/view";
                            }
                            location.assign(URL);                        
                        });
                        //-------------------------------------------------------
                    }
                }
            });
            
            $A.enqueueAction(action);
        }
    },
    
    closePanel : function(component, event, helper)
    {
        var URL = component.get("v.recordURL");
        if(!URL.includes("view"))
        {
            //URL = URL.replace("lightning/r/Administrative_Tool__c/", "lightning/o/Administrative_Tool__c/list?filterName=Recent");
            URL = URL.replace("lightning/r/Administrative_Tool__c/", "lightning/n/Administrative_Tool");
        }
        location.assign(URL);
    },
    
    uploadFile : function(component, event, helper)
    {
        var Disclaimers = component.find("PolicyManual");
        Disclaimers.uploadFile();
    },
    
    saveDisclaimer: function(component, event, helper) 
    {
        var Disclaimers = component.find("Disclaimers");
        Disclaimers.saveDisclaimer();
    }
})