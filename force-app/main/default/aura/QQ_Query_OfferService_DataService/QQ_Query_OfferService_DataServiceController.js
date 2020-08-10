({
	getofferservicedata : function(component, event, helper) {
		var params = event.getParam('arguments');
        var callback;
        var offermasterid;
        
        if (params) {
            callback = params.callback;
            offermasterid = params.offermasterid;            
        }
        var action = component.get('c.getofferservice');
        
        action.setStorable();
        action.setParams({
            "offermasterid" : offermasterid           
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