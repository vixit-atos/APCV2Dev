({
	submitquickquote : function(component, event, helper) {
		var params = event.getParam('arguments');
        var callback;
        var quoteobj;
        var quoteitemlst;
        var addonlst;
        if (params) {
            callback = params.callback;
            quoteobj = params.quote;
            quoteitemlst = params.quoteitemlst;
            addonlst = params.addonlst;
            
          //  alert(JSON.stringify(addonlst));
        }
        var action = component.get('c.submitPMquote');
        action.setParams({
            "quoteobj" : quoteobj,
            "quoteitemlst"  : quoteitemlst ,
            "addonlst" : addonlst
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