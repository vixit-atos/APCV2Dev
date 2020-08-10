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
                
                if(category === "Standalone")
                    component.set("v.Standalones", result);
                if(category === "Package")
                    component.set("v.Packages", result);
                if(category === "Vocation Description")
                    component.set("v.Vocations", result);
                if(category === "Pricing Types")
                    component.set("v.PricingTypes", result);
                if(category === "Publication Status")
                    component.set("v.Publications", result);
                if(category === "Group")
                    component.set("v.Groups", result);
            }
        });
        
        $A.enqueueAction(action);
    }
})