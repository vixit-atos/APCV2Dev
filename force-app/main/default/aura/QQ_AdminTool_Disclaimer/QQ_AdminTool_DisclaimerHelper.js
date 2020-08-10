({
	validateDisclaimer : function(component) 
    {
        var self = this;
        var AdminTool = component.get("v.AdminTool");
		var action = component.get("c.validateDisclaimer");        
        action.setParams({
            "AdminTool" : AdminTool
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") 
            {
                var result = response.getReturnValue();
                //alert("Validation Message: " + result);
                
                if(result === "SUCCESS")
                {
                    self.saveDisclaimer(component);
                }
                else
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": result,
                        "type" : "error"
                    });
                    toastEvent.fire();
                }
            }
        });
        $A.enqueueAction(action);
	},
    
    saveDisclaimer : function(component)
    {
        var AdminTool = component.get("v.AdminTool");
        var adminMethod = component.find("SubmitAdminTool");
        adminMethod.submitAdminData(AdminTool, function(result){        
            //alert(result);
            if(result != null)
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Disclaimer saved successfully",
                    "type" : "success"
                });
                toastEvent.fire();
            }
            else
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Sorry! DML Operation is not successful",
                    "type" : "error"
                });
                toastEvent.fire();
            }
        });
    }    
})