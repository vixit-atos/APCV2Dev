({
    doInit : function(component, event, helper) 
    {
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set("v.today", today);
        
        helper.getFMVDate(component);
        helper.getExpDate(component);
    }, 
    
    handlechange: function(component, event, helper)
    {
        helper.mandatorycheck(component);  
    }, 
    
    editOrder : function(component, event, helper)
    {
        component.set("v.openpopup", true);
    }, 
    
    editform: function(component, event, helper) 
    {
        component.set("v.editmode", true)  ;
    }, 
    
    saveform :function(component, event, helper) 
    {
        var validodr = component.find("quoteform").reduce(function (validSoFar, inputCmp) { 
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get("v.validity").valid;            
        }, true);
        
        if(validodr)
        {
            helper.updateQuote(component);
        }
        else
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "All (*)required field cannot be left blank and invalid value is not allowed.",
                "type" : "error"
            });
            toastEvent.fire();
        }
    }
})