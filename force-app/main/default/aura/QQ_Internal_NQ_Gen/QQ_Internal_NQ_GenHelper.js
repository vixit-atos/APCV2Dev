({
    mandatorycheck: function(component) {
        var quote = component.get("v.quote");
        var mandatoryfield = ['Customer_Name__c', 'Sales_Outlet__c', 'Request_Type__c'];
        var mandatoryfieldpopulated = true;
        
        if (component.get("v.concession_TWS") == 'CONCESSION') {
            mandatoryfield.push('Concession__c');
            component.set("v.quote.TWS_Deal_No__c", '');
        } else {
            mandatoryfield.push('TWS_Deal_No__c');
            component.set("v.quote.Concession__c", '');
        }

        if (quote["Request_Type__c"] == "TC") {
            mandatoryfield.push('Revision_Status__c');

        }

        if (quote["Revision_Status__c"] == "Revised") {
            mandatoryfield.push('TC_Date__c');

        }
        
        mandatoryfield.forEach(function(item) {
            if (quote[item] == '' || quote[item] == undefined) {
                mandatoryfieldpopulated = false;
            }
        });
        component.set("v.qq_gen_completed", mandatoryfieldpopulated)
    },
    
    updateQuote : function(component) 
    {
        var quoteObj = component.get("v.quote");
        var QuoteNum = component.get("v.quote.Name");
        var formType = "GENERAL";
        
        //alert(JSON.stringify(quoteObj));
        //alert("Quote Number: " + QuoteNum);
        
        var action = component.get("c.updateQuote");
        action.setParams({
            "quoteObj" : quoteObj,
            "QuoteNum" : QuoteNum,
            "formType" : formType
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") 
            {
                var result = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Record updated successfully",
                    "type" : "success"
                });
                toastEvent.fire();
                
                component.set("v.editmode", false);
            }
        });
        $A.enqueueAction(action);
    }
})