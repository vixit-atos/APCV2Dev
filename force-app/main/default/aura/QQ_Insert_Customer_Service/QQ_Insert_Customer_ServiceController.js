({
	createQQcustomer : function(component, event, helper) {
		var params = event.getParam('arguments');
        var callback;
        var customername;
        
        if (params) {
            callback = params.callback;
            customername = params.customername; 
        }
        var action = component.get('c.createQQCustomer');
        action.setParams({
            "customername" : customername           
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                
                if (callback) callback(response.getReturnValue()); 
                
            }
        });
        $A.enqueueAction(action);
	}
})