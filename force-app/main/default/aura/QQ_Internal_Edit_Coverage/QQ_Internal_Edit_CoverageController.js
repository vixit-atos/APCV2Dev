({
    handleEvent : function(component, event, helper)
    {
        var saveFlag = event.getParam("saveFlag");
        component.set("v.saveFlag", saveFlag);
    },
    
    updateCoverage : function(component, event, helper) 
    {
        var cvrgcmp = component.find("cvgform");
        var coverage = component.get("v.quoteitem.Coverage__c");
        let cvrg_section;
        switch(coverage) 
        {
            case 'DETROIT COVERAGE':
                cvrg_section = cvrgcmp.find("detroitform");
                break;
            case 'TRUCK CHASSIS':
                cvrg_section = cvrgcmp.find("truckform");
                break;
            default:
                // code block
        }
        
        let validcvgsection = cvrg_section.find("quoteform").reduce(function (validSoFar, inputCmp) { 
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid; 
        }, true);
        
        var SubmitQuoteSrvc = component.find("SubmitQuickQuote");
        component.set("v.quote.Stage__c" , "Pending");
        component.set("v.quote.Status__c" , "Pending for Validation");
        component.set("v.quote.Source__c" , "Internal");
        
        var Duration = component.get("v.quoteitem.Duration_Final__c");
        var Months = component.get("v.quoteitem.Months__c");
        var Miles = component.get("v.quoteitem.Miles__c");
        
        //alert("Duration: " + Duration + ", Months: " + Months + ", Miles: " + Miles);
        if((Months != undefined && Miles != undefined) && (Number(Months) != 0 && Number(Miles) != 0) && validcvgsection)
        {  
            var quoteitemlst = []; 
            var quoteitemobj = component.get("v.quoteitem");
            quoteitemlst.push(quoteitemobj);
            SubmitQuoteSrvc.submitquickquote(component.get("v.quote"), quoteitemlst, component.get("v.noteslist"), component.get("v.quotenum"), true, function(result) {
                component.set("v.openpopup" , false);
                var submitEvent = $A.get("e.c:QQ_NQ_Submit_Save_event");        
                submitEvent.setParam("message", "event message here");
                submitEvent.fire();
            });
        }
        else
        {
            component.set("v.requiredFlag", "true");
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Duration cannot be left blank, if duration is not available please enter both months and miles.",
                "type" : "error"
            });
            toastEvent.fire();
        }
    },
    
    CancelQuote : function(component, event, helper)
    {
        component.set("v.closeform" , true);    
    }
    
})