({
	geturlcommunity : function(component, event, helper) {
		var params = event.getParam('arguments');
        var callback;
        var communityname;
        
        if (params) {
            callback = params.callback;
            communityname = params.communityname;            
        }
        var action = component.get('c.fetchURL');
        
        action.setStorable();
        action.setParams({
            "communityname" : communityname          
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