({
    doInit : function(component, event, helper) 
    {
        var URL = window.location.href;
        var recordID = component.get("v.recordId");
        if(recordID === undefined)
        {
            URL = URL.split("lightning/");
            URL = URL[0] + "lightning/r/QQ_Master__c/";
            component.set("v.recordURL", URL);
            
            var recordTypeID = component.get("v.pageReference").state.recordTypeId;
            component.set("v.recordTypeId", recordTypeID);
            component.set("v.ExtendedCoverage.RecordTypeId", recordTypeID);
            var action = component.get("c.getRecordType");
            action.setParams({
                "recordTypeId" : recordTypeID
            });
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (component.isValid() && state === "SUCCESS") {
                    var result = response.getReturnValue();
                    component.set("v.recordType", result);
                }
            });
            $A.enqueueAction(action);
        }
        else
        {
            URL = URL.split("edit");
            URL = URL[0] + "view";
            component.set("v.recordURL", URL);
            
            component.set("v.ExtendedCoverage.ID", recordID);
            var action = component.get("c.getQQMaster");
            action.setParams({
                "recordID" : recordID
            });
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (component.isValid() && state === "SUCCESS") {
                    var result = response.getReturnValue();
                    component.set("v.ExtendedCoverage", result);
                    component.set("v.recordType", result.RecordType.Name);
                    
                    if(result.Group__c != undefined)
                    {
                        var Groups = (result.Group__c).split(";");
                        component.set("v.selectedGroups", Groups);
                    }
                    
                    if(result.Level__c != undefined)
                    {
                        var Vocations = (result.Level__c).split(";");
                        component.set("v.selectedVocations", Vocations);
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },
    
    submitRecord : function(component, event, helper)
    {
        //-----------------  MANDATORY VALIDATION  --------------------------
        var allValid = false;
        var recordType = component.get("v.recordType");
        
        if(recordType === "Detroit Coverage")
        {
            var Detroit = component.find("Detroit");
            Detroit.checkMandatory(function(result){
                allValid = result;
            });
        }
        else
        {
            var Truck = component.find("Truck");
            Truck.checkMandatory(function(result){
                allValid = result;
            });
        }
        //-------------------------------------------------------------------
        
        if(allValid)
        {
            //-------------------------  DUPLICATE VALIDATION  ----------------------------
            var QQMasterID = component.get("v.ExtendedCoverage.Id");
            var dbCode = component.get("v.ExtendedCoverage.Name");
            var fmvDate = component.get("v.ExtendedCoverage.FMV_Date__c");
            
            var action = component.get('c.verifyDuplicate');
            action.setParams({
                "QQMasterID" : QQMasterID,
                "dbCode" : dbCode,
                "fmvDate" : fmvDate
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
                        var QQMaster = component.get("v.ExtendedCoverage");
                        var submitQQMaster = component.find("SubmitQQMaster");
                        submitQQMaster.submitQQMaster(QQMaster, function(result){        
                            var URL = component.get("v.recordURL");
                            if(!URL.includes("view"))
                            {
                                URL = URL + result + "/view";
                            }
                            location.assign(URL);
                        });
                        //-------------------------------------------------------
                    }
                }
            });
            
            $A.enqueueAction(action);
            //-----------------------------------------------------------------------------
        }
    },
    
	closePanel : function(component, event, helper) 
    {
        var URL = component.get("v.recordURL");
        if(!URL.includes("view"))
        {
            URL = URL.replace("lightning/r/QQ_Master__c/", "lightning/o/QQ_Master__c/list?filterName=Recent");
        }
        location.assign(URL);
    } 
})