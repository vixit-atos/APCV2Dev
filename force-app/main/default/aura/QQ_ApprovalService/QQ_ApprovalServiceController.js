({
	approvalmethod : function(component, event, helper) {
		var params = event.getParam('arguments');
        var callback;
        var quoteobj;
        var quoteitemlst;
        var noteslist;
        
        
        
        if (params) {
            callback = params.callback;
            quoteobj = params.quote;
            quoteitemlst = params.quoteitemlst;
            noteslist = params.noteslist;
        }
        
       
        var action = component.get('c.customApproval');
        action.setParams({
            "quoteobj" : quoteobj,
            "quoteitemlst"  : quoteitemlst ,
            "noteslist" : noteslist
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