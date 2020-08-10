({
	getstandardprice : function(component, event, helper) {
		var params = event.getParam('arguments');
        var callback;
        var quoteid;
        
        if (params) {
            callback = params.callback;
            quoteid = params.quoteid; 
        }
        var action = component.get('c.getstandardPrice');
        action.setStorable();
        action.setParams({
            "quoteid" : quoteid           
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