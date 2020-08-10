({
    updateOrder : function(component, event, helper) {
        var SubmitQuoteSrvc = component.find("SubmitQuickQuote");
        component.set("v.quote.Stage__c" , "Pending");
        component.set("v.quote.Status__c" , "Pending for Validation");
        component.set("v.quote.Source__c" , "Internal");
        
        var Duration = component.get("v.quoteitem.Duration_Final__c");
        var Months = component.get("v.quoteitem.Months__c");
        var Miles = component.get("v.quoteitem.Miles__c");
        
        //alert("Duration: " + Duration + ", Months: " + Months + ", Miles: " + Miles);
        if(Months != undefined && Miles != undefined)
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
            alert("Duration cannot be left blank, if duration is not available please enter months and miles.");
        }
    },
    
    CancelQuote : function(component, event, helper) {
        component.set("v.closeform" , true);    
    }
    
})