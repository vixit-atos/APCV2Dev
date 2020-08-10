({
    submitAdminRecord : function(component, event, helper) 
    {
        var callback;
        var AdminTool;
        
        var params = event.getParam("arguments");
        if (params) {
            callback = params.callback;
            AdminTool = params.AdminTool;
            //alert(JSON.stringify(AdminTool));
        }
        
        var action = component.get("c.submitRecord");        
        action.setParams({
            "AdminTool" : AdminTool
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") 
            {
                if (callback) callback(response.getReturnValue());
            }
            else if (state === "ERROR") 
            {
                var errors = response.getError();
                if (errors)
                {
                    if (errors[0] && errors[0].message) 
                    {
                        console.log("Error message: " + errors[0].message);                        
                        if (callback) callback(errors[0].message);
                    }
                } 
                else
                {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    }
})