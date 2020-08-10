({ 
    doInit : function(component, event, helper)
    {
        var category = "Engine Component";
        helper.getItems(component, category, false);
        
        var category = "Coverage Type";
        helper.getItems(component, category, false);
        
        var category = "Option";
        helper.getItems(component, category, false);
        
        var category = "Pricing Types";
        helper.getItems(component, category, true);
        
        var category = "Application Description";
        helper.getItems(component, category, true);
        
        var category = "Publication Status";
        helper.getItems(component, category, true);
        
        
        component.set("v.ExtendedCoverage.Active__c", true);
        component.set("v.ExtendedCoverage.Publication_Status__c", "Published");
        component.set("v.ExtendedCoverage.Deductable__c", "0");
    },
    
    checkMandatory : function(component, event, helper) 
    {        
        var dbCode = component.get("v.ExtendedCoverage.Name");
        var months = component.get("v.ExtendedCoverage.Months__c");
        var miles = component.get("v.ExtendedCoverage.Miles__c");
        var fmvDate = component.get("v.ExtendedCoverage.FMV_Date__c");
        var deduct = component.get("v.ExtendedCoverage.Deductable__c");
        var priceType = component.get("v.ExtendedCoverage.Pricing_Types__c");
        var publish = component.get("v.ExtendedCoverage.Publication_Status__c");
        var price = component.get("v.ExtendedCoverage.Price__c");
        
        var engCmp = component.get("v.ExtendedCoverage.Engine_Component__c");
        var appDesc = component.get("v.ExtendedCoverage.Usage__c");
        var cvgType = component.get("v.ExtendedCoverage.Coverage_Type__c");
        var option = component.get("v.ExtendedCoverage.Option__c");
        
        var allValid = true;
        var errorMessage = "";
        if(dbCode === undefined || dbCode === "")
        {
            allValid = false;
            errorMessage = "Databook code can't be left blank";
            component.find("UID_dbCode").showHelpMessageIfInvalid();
            component.find("UID_dbCode").focus();
        }
        if(months === undefined || months === "")
        {
            allValid = false;
            errorMessage = "Months can't be left blank";
            component.find("UID_Months").showHelpMessageIfInvalid();
            component.find("UID_Months").focus();
        }                
        if(miles === undefined || miles === "")
        {
            allValid = false;
            errorMessage = "Miles can't be left blank";
            component.find("UID_Miles").showHelpMessageIfInvalid();
            component.find("UID_Miles").focus();
        }                    
        if(fmvDate === undefined || fmvDate === "")
        {
            allValid = false;
            errorMessage = "FMV Date can't be left blank";
            component.find("UID_FMVDate").showHelpMessageIfInvalid();
            component.find("UID_FMVDate").focus();
        }                        
        if(deduct === undefined || deduct === "")
        {
            allValid = false;
            errorMessage = "Deductible can't be left blank";
            component.find("UID_Deductible").showHelpMessageIfInvalid();
            component.find("UID_Deductible").focus();
        }                            
        if(priceType === undefined || priceType === "")
        {
            allValid = false;
            errorMessage = "Please select pricing type";
            component.find("UID_PricingType").showHelpMessageIfInvalid();
            component.find("UID_PricingType").focus();
        }                                
        if(publish === undefined || publish === "")
        {
            allValid = false;
            errorMessage = "Please select publication status";
            component.find("UID_Publication").showHelpMessageIfInvalid();
            component.find("UID_Publication").focus();
        }                                    
        if(price === undefined || price === "")
        {
            allValid = false;
            errorMessage = "Price can't be left blank";
            component.find("UID_Price").showHelpMessageIfInvalid();
            component.find("UID_Price").focus();
        }                                        
        if(engCmp === undefined || engCmp === "")
        {
            allValid = false;
            errorMessage = "Please select engine component";
            component.find("UID_EngineComponent").showHelpMessageIfInvalid();
            component.find("UID_EngineComponent").focus();
        }
        if(appDesc === undefined || appDesc === "")
        {
            allValid = false;
            errorMessage = "Please select application description";
            component.find("UID_AppDescription").showHelpMessageIfInvalid();
            component.find("UID_AppDescription").focus();
        }
        if(cvgType === undefined || cvgType === "")
        {
            allValid = false;
            errorMessage = "Please select coverage type";
            component.find("UID_CoverageType").showHelpMessageIfInvalid();
            component.find("UID_CoverageType").focus();
        }
        if(cvgType === "Detroit Engines" && (option === undefined || option === ""))
        {
            allValid = false;
            errorMessage = "Please select option";
            component.find("UID_Option").showHelpMessageIfInvalid();
            component.find("UID_Option").focus();
        }                                                        
        
        if(!allValid)
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": errorMessage,
                "type" : "error"
            });
            toastEvent.fire(); 
        }
        
        var callback;
        var params = event.getParam('arguments');
        if (params)
        {
            callback = params.callback;
        }
        callback(allValid);
    },
    
    valueChange : function(component, event, helper)
    {
        var cvgType = component.get("v.ExtendedCoverage.Coverage_Type__c");
        if(cvgType != "Detroit Coverage")
        {
            var option = component.find("UID_Option");
            $A.util.removeClass(option, "slds-has-error");
            $A.util.addClass(option, "hide-error-message");
        }
    }
})