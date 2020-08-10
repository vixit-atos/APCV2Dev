({
	submitquickquote : function(component, event, helper) {
		var params = event.getParam('arguments');
        var callback;
        var quoteobj;
        var quoteitemlst;
        
        if (params) {
            callback = params.callback;
            quoteobj = params.quote;
            quoteitemlst = params.quoteitemlst;
           
        }
        var action = component.get('c.external_ew_submitquote');
        action.setParams({
            "quoteobj" : quoteobj,
            "quoteitemlst"  : quoteitemlst
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