({
    doInit : function(component, event, helper) 
    { 
        var category = "Standalone";
        helper.getItems(component, category, false);
                
        var category = "Package";
        helper.getItems(component, category, false);
        
        var category = "Vocation Description";
        helper.getItems(component, category, true);
        
        var category = "Pricing Types";
        helper.getItems(component, category, true);
        
        var category = "Group";
        helper.getItems(component, category, true);
        
        var category = "Publication Status";
        helper.getItems(component, category, true);
     
        
        component.set("v.ExtendedCoverage.Active__c", true);
        component.set("v.ExtendedCoverage.Publication_Status__c", "Published");
        component.set("v.ExtendedCoverage.Deductible__c", "0");
    },
    
    checkMandatory : function(component, event, helper)
    {
        var recordType = component.get("v.recordType");
        var dbCode = component.get("v.ExtendedCoverage.Name");
        var months = component.get("v.ExtendedCoverage.Months__c");
        var miles = component.get("v.ExtendedCoverage.Miles__c");
        var fmvDate = component.get("v.ExtendedCoverage.FMV_Date__c");
        var deduct = component.get("v.ExtendedCoverage.Deductible__c");
        var priceType = component.get("v.ExtendedCoverage.Pricing_Types__c");
        var publish = component.get("v.ExtendedCoverage.Publication_Status__c");
        var price = component.get("v.ExtendedCoverage.Price__c");
        
        var group = component.get("v.ExtendedCoverage.Group__c");
        var standalone = component.get("v.ExtendedCoverage.Standalone__c");
        var truckCVG = component.get("v.ExtendedCoverage.Package__c");
        
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
        if(group === undefined || group === "")
        {
            allValid = false;
            errorMessage = "Please select group";
            component.find("UID_Group").showHelpMessageIfInvalid();
            component.find("UID_Group").focus();
        }
        if((standalone === undefined || standalone === "") && (truckCVG === undefined || truckCVG === ""))
        {
            allValid = false;
            component.set("v.validFlag", true);
            errorMessage = "Please select standalone";
            component.find("UID_Standalone").showHelpMessageIfInvalid();
            component.find("UID_Standalone").focus();
        }    
        if(recordType === "Truck Chassis" && (truckCVG === undefined || truckCVG === "") && (standalone === undefined || standalone === ""))
        {
            allValid = false;
            component.set("v.validFlag", true);
            errorMessage = "Please select package";
            component.find("UID_Package").showHelpMessageIfInvalid();
            component.find("UID_Package").focus();
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
    
    groupChange : function(component, event, helper) 
    {
        var selectedValues = event.getParam("value");
        component.set("v.ExtendedCoverage.Group__c", selectedValues);
    },
    
    vocationChange : function(component, event, helper) 
    {
        var selectedValues = event.getParam("value");
        component.set("v.ExtendedCoverage.Level__c", selectedValues);
    },
    
    valueChange : function(component, event, helper) 
    {
        var name = event.getSource().get("v.name");
        //var value = event.getSource().get("v.value");
        
        if(name.toUpperCase() === "PACKAGE")
            component.set("v.ExtendedCoverage.Standalone__c", "");
        if(name.toUpperCase() === "STANDALONE")
            component.set("v.ExtendedCoverage.Package__c", "");
     
        component.set("v.validFlag", false);
        
        var stndlne = component.find("UID_Standalone");
        $A.util.removeClass(stndlne, "slds-has-error");
        $A.util.addClass(stndlne, "hide-error-message");
        
        var pkg = component.find("UID_Package");
        $A.util.removeClass(pkg, "slds-has-error");
        $A.util.addClass(pkg, "hide-error-message");
    }
})