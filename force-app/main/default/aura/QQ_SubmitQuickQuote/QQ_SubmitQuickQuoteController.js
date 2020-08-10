({
	submitquickquote : function(component, event, helper) {
		var params = event.getParam('arguments');
        var callback;
        var quoteobj;
        var quoteitemlst;
        var noteslist;
        var QuoteNum;
        var editCoverage;
        
        if (params) {
            callback = params.callback;
            quoteobj = params.quote;
            quoteitemlst = params.quoteitemlst;
            noteslist = params.noteslist;
            QuoteNum = params.QuoteNum;
            editCoverage = params.editCoverage;
        }        
        
        var action = component.get('c.submitquote');
        action.setParams({
            "quoteobj" : quoteobj,
            "quoteitemlst"  : quoteitemlst ,
            "noteslist" : noteslist,
            "QuoteNum" : QuoteNum,
            "editCoverage" : editCoverage
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