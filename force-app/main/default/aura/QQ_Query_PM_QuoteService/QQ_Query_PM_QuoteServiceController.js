({
	getquoteData : function(component, event, helper) {
		var params = event.getParam('arguments');
        var callback;
        var qqid;
        
        if (params) {
            callback = params.callback;
            qqid = params.qqid; 
        }
        
        var action = component.get('c.getPMQuotedata');
        
        action.setParams({
            "QQId" : qqid            
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