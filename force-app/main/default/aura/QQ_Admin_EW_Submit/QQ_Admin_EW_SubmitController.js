({
    submitQQMaster : function(component, event, helper) 
    {
        var callback;
        var QQMaster;
        
        var params = event.getParam("arguments");
        if (params)
        {
            callback = params.callback;
            QQMaster = params.QQMaster;
        }
        
        var action = component.get("c.submitRecord");        
        action.setParams({
            "QQMaster" : QQMaster
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") 
            {
                if (callback) callback(response.getReturnValue());
            }
        });
        
        $A.enqueueAction(action);
    }
})