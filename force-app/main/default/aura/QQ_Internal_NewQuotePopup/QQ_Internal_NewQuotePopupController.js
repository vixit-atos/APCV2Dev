({
    handleEvent : function(component, event, helper)
    {
        var saveFlag = event.getParam("saveFlag");
        component.set("v.saveFlag", saveFlag);
    }, 
    
    SubmitQuote : function(component, event, helper) 
    {        
        var gencmp = component.find("genform");
        var odrcmp = component.find("odrform");
        
        //alert(JSON.stringify(component.get("v.quote")));
        
        var validcustomer = false;
        var qqcustomer = gencmp.find("quotecustomer");
        var qqcustomer_help = gencmp.find("quotecustomerhelptext");
        if(component.get("v.quote.Customer_Name__c"))
        { 
            validcustomer = true;
            $A.util.removeClass(qqcustomer, "slds-has-error");
            $A.util.addClass(qqcustomer_help, "slds-hide");            
        }
        else
        {
            $A.util.addClass(qqcustomer, "slds-has-error");
            $A.util.removeClass(qqcustomer_help, "slds-hide");
            validcustomer = false;            
        }
        
        var validgen = gencmp.find("quoteform").reduce(function (validSoFar, inputCmp) {  
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get("v.validity").valid;
        }, true);
        
        var validodr = odrcmp.find("quoteform").reduce(function (validSoFar, inputCmp) { 
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get("v.validity").valid;            
        }, true);
        
        if(validcustomer && validgen && validodr)
        {
            var SubmitQuoteSrvc = component.find("SubmitQuickQuote");
            component.set("v.quote.Stage__c", "Pending");
            component.set("v.quote.Status__c", "Pending for Validation");
            component.set("v.quote.Source__c", "Internal");
            
            var Duration = component.get("v.quoteitem.Duration_Final__c");
            var Months = component.get("v.quoteitem.Months__c");
            var Miles = component.get("v.quoteitem.Miles__c");
            
            var cvrgcmp = component.find("cvgform");
            var coverage = component.get("v.quoteitem.Coverage__c");
            let cvrg_section;
            switch(coverage) 
            {
                case "DETROIT COVERAGE":
                    cvrg_section = cvrgcmp.find("detroitform");
                    break;
                case "TRUCK CHASSIS":
                    cvrg_section = cvrgcmp.find("truckform");
                    break;
                default:
                    // code block
            } 
            
            let validcvgsection = cvrg_section.find("quoteform").reduce(function (validSoFar, inputCmp) { 
                inputCmp.showHelpMessageIfInvalid();
                return validSoFar && inputCmp.get("v.validity").valid; 
            }, true);
            
            //alert("Duration: " + Duration + ", Months: " + Months + ", Miles: " + Miles);
            if((Months != undefined && Miles != undefined) && (Number(Months) != 0 && Number(Miles) != 0) && validcvgsection)
            {                
                var quoteitemlst = []; 
                var quoteitemobj = component.get("v.quoteitem");
                quoteitemlst.push(quoteitemobj);
                var QuoteNum = component.get("v.QuoteNum");
                var editCoverage = component.get("v.editCoverage");                
                // alert(JSON.stringify(quoteitemlst));
                
                SubmitQuoteSrvc.submitquickquote(component.get("v.quote"), quoteitemlst, component.get("v.noteslist"), QuoteNum, editCoverage, function(result) {
                    component.set("v.openpopup", false);
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
        }
    }, 
    
    SaveforlaterQuote : function(component, event, helper) 
    {
        var gencmp = component.find("genform");
        var validcustomer = false;
        var qqcustomer = gencmp.find("quotecustomer");
        var qqcustomer_help = gencmp.find("quotecustomerhelptext");
        if(component.get("v.quote.Customer_Name__c"))
        { 
            validcustomer = true;
            $A.util.removeClass(qqcustomer, "slds-has-error");
            $A.util.addClass(qqcustomer_help, "slds-hide");
            
        }
        else
        {
            $A.util.addClass(qqcustomer, "slds-has-error");
            $A.util.removeClass(qqcustomer_help, "slds-hide");
            validcustomer = false;            
        }
        
        var validgen = gencmp.find("quoteform").reduce(function (validSoFar, inputCmp) {  
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get("v.validity").valid;
        }, true);
        
        if(validcustomer && validgen)
        {
            var SubmitQuoteSrvc = component.find("SubmitQuickQuote");
            component.set("v.quote.Stage__c", "Draft");
            component.set("v.quote.Status__c", "Draft");
            component.set("v.quote.Source__c", "Internal");
            component.set("v.openpopup", false);
            var quoteitemlst = []; 
            var quoteitemobj = component.get("v.quoteitem");
            quoteitemlst.push(quoteitemobj);
            var QuoteNum = component.get("v.QuoteNum");
            var editCoverage = component.get("v.editCoverage");
            
            //SubmitQuoteSrvc.submitquickquote(component.get("v.quote"), component.get("v.quoteitem"), function(result) {
            SubmitQuoteSrvc.submitquickquote(component.get("v.quote"), quoteitemlst, component.get("v.noteslist"), QuoteNum, editCoverage, function(result) {
                var saveEvent = $A.get("e.c:QQ_NQ_Submit_Save_event");
                saveEvent.fire();    
            });
        }
    }, 
    
    CancelQuote : function(component, event, helper)
    {
        component.set("v.closeform", true);    
    }    
})