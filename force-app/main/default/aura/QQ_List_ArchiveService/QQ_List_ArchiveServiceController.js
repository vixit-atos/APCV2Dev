({
	archiveListData : function(component, event, helper) {
		var params = event.getParam('arguments');
        var callback;
        var qqlist;
        
        if (params) {
            callback = params.callback;
            qqlist = params.qqlst; 
        }
        
        var action = component.get('c.archiveRecords');
        action.setStorable();
        action.setParams({
            "QQIdlist" : qqlist
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