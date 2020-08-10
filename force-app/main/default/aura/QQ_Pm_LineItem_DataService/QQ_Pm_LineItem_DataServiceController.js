({
	getLineitemData : function(component, event, helper) {
		var params = event.getParam('arguments');
        var callback;
        var packagename;
        
        if (params) {
            callback = params.callback;
            packagename = params.packagename;            
        }
        var action = component.get('c.getMasterLineitems');
        action.setStorable();
        action.setParams({
            "packagename" : packagename           
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