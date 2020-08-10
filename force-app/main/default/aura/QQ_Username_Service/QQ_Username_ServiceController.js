({
	getusername : function(component, event, helper) {
		var params = event.getParam('arguments');
        var callback;
        if (params) {
            callback = params.callback;              
        }
        var action = component.get('c.getUserName');
        action.setStorable();        
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                
                if (callback) callback(response.getReturnValue()); 
                
            }
        });
        $A.enqueueAction(action);
	}
})