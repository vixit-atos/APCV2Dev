({
	calculateEstimateTotal : function(component) {
        var total=component.get("v.cab") + 
            component.get("v.chassis") + 
            component.get("v.mechatronics") + 
            component.get("v.eve") + 
            component.get("v.otherEstimates");
        
        component.find("totalEstimates").set("v.value", total);
    },
        
    calculateExpenseTotal : function(component) {
        var totalExpenses = component.get("v.tooling") +
            component.get("v.otherExpenses");
        
        component.find("totalExpenses").set("v.value", totalExpenses);
    }
})