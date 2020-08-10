({
    updatemaster : function(component, event, helper) 
    {
        var params = event.getParam('arguments');
        var callback;
        var masterid;
        var price;
        var databook;
        
        if (params)
        {
            callback = params.callback;
            masterid = params.masterid;
            price = params.price;
            databook = params.databook;
        }
        
        var action = component.get('c.updateMaster');
        action.setParams({
            "masterid" : masterid,
            "price" : price,
            "databook" : databook
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