({
    mandatorycheck : function(component) 
    {
        var quote = component.get("v.quote");
        var mandatoryfield = ["Till_Date__c", "From_Date__c", "Total_Units__c", "Multi_Year_Deal__c"];
        var mandatoryfieldpopulated = true;        
        
        mandatoryfield.forEach(function(item) {
            if (quote[item] == "" || quote[item] == undefined) 
            {
                mandatoryfieldpopulated = false;
            }
        });
        component.set("v.qq_odr_completed", mandatoryfieldpopulated)
    },
    
    getFMVDate : function(component)
    {
        var action = component.get("c.getFMVDate");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS")
            {
                var result =  response.getReturnValue();
                component.set("v.quote.FMV_Date__c", result);
            }
        });
        
        $A.enqueueAction(action);
    },
    
    getExpDate : function(component)
    {
        var action = component.get("c.getExpDate");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS")
            {
                var result =  response.getReturnValue();
                component.set("v.quote.Expiration_Date__c", result);
            }
        });
        
        $A.enqueueAction(action);
    },
    
    updateQuote : function(component) 
    {
        var quoteObj = component.get("v.quote");
        var QuoteNum = component.get("v.quote.Name");
        var formType = "ORDER";
        
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