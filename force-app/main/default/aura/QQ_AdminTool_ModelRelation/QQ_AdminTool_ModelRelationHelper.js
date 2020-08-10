({
	getItems : function(component, category, isPicklist)
    {
        var action;
        if(isPicklist)
            action = component.get("c.getPicklistItem");
        else
            action = component.get("c.getItem");
        
        action.setParams({
            "category" : category
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var result = response.getReturnValue();
                
                if(category === "Chassis Model")
                    component.set("v.Models", result);
                if(category === "A85 Code")
                    component.set("v.A85Codes", result);
                if(category === "Group")
                    component.set("v.Groups", result);
            }
        });
        
        $A.enqueueAction(action);
    }
})