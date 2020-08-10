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
                
                if(category === "Engine Component")
                    component.set("v.EngineComponents", result);
                if(category === "Coverage Type")
                    component.set("v.CoverageTypes", result);
                if(category === "Option")
                    component.set("v.Options", result);
                if(category === "Pricing Types")
                    component.set("v.PricingTypes", result);
                if(category === "Application Description")
                    component.set("v.AppDescriptions", result);
                if(category === "Publication Status")
                    component.set("v.Publications", result);
            }
        });
        
        $A.enqueueAction(action);
    }
})