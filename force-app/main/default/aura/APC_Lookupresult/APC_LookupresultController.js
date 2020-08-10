({
    selectAccount : function(component, event, helper){      
        // get the selected Account from list  
        var getSelectAccount = component.get("v.oAccount");
        var compEvent = component.getEvent("oSelectedAccountEvent");
        compEvent.setParams({"recordByEvent" : getSelectAccount });  
        compEvent.fire();
    }
})