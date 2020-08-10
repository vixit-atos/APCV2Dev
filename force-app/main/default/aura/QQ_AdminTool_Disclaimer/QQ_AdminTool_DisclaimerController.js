({
    doInit : function(component, event, helper) 
    {
        var category = "Quote Type";
        var action = component.get("c.getPicklistItem");
        action.setParams({
            "category" : category
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") 
            {
                var result = response.getReturnValue();
                component.set("v.QuoteTypes", result);
            }
        });
                
        $A.enqueueAction(action);
    },
   
    saveDisclaimer: function(component, event, helper) 
    {
        var errFlag = false;
        var errMessage = "";
        
        component.set("v.AdminTool.Active__c", true);
        var Disclaimer = component.get("v.AdminTool.Disclaimers__c");
        if(Disclaimer === undefined)
        {
            errFlag = true;
            errMessage = "Please enter disclaimer";
        }
        
        var quoteType = component.get("v.AdminTool.Quote_Type__c");
        if(quoteType === undefined)
        {
            errFlag = true;
            errMessage = "Please select Quote Type";
            component.find("UID_QuoteType").showHelpMessageIfInvalid();
            component.find("UID_QuoteType").focus();
        }
        
        var fromDate = component.get("v.AdminTool.Disclaimer_From_Date__c");
        if(fromDate === undefined)
        {
            errFlag = true;
            errMessage = "Please enter disclaimer from date";
            component.find("UID_FromDate").showHelpMessageIfInvalid();
            component.find("UID_FromDate").focus();
        }
        
        /*var toDate = component.get("v.AdminTool.Disclaimer_To_Date__c");
        if(toDate === undefined)
        {
            errFlag = true;
            errMessage = "Please enter disclaimer to date";
            component.find("UID_ToDate").showHelpMessageIfInvalid();
            component.find("UID_ToDate").focus();
        }*/
                
        if(!errFlag)
        {
            helper.validateDisclaimer(component);
        }
        else
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": errMessage,
                "type" : "error"
            });
            toastEvent.fire();
        }
    }
})