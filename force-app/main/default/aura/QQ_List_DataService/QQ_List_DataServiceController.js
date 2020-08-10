({
	getListData : function(component, event, helper) {
		var params = event.getParam('arguments');
        var callback;
        var stagefilter;
        var statusfilter;
        var domain;
        var source;
        if (params) {
            callback = params.callback;
            stagefilter = params.Stagefilter;
            statusfilter = params.Statusfilter;
            domain = params.domain;
            source = params.source;
        }
        var action = component.get('c.getQuoteRecords');
        //action.setStorable();
        action.setParams({
            "stagefilter" : stagefilter,
            "statusfilter" : statusfilter,
            "domain" : domain,
            "source" : source
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