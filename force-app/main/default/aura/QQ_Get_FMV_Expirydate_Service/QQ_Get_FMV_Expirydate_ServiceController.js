({
	getdates : function(component, event, helper) {
        var params = event.getParam('arguments');
        var callback;
       
        
        if (params) {
            callback = params.callback;  
        }
        var action = component.get('c.get_FMV_Expiration_Date'); 
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                //alert(JSON.stringify(response.getReturnValue()));
                if (callback) callback(response.getReturnValue()); 
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                let message = 'Unknown error'; // Default error message
                // Retrieve the error message sent by the server
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                // Display the message
                console.error(message);
            }

        });
        $A.enqueueAction(action);
	}
})