({
	getLineitemData : function(component, event, helper) {
		var params = event.getParam('arguments');
        var callback;
        var coverage;
        
        if (params) {
            callback = params.callback;
            coverage = params.coverage;            
        }
        var action = component.get('c.getMasterLineitems');
        
        action.setStorable();
        action.setParams({
            "coverage" : coverage           
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