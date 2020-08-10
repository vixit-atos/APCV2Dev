({
	editcost : function(component, event, helper) {
		component.set("v.editcostmode" , true);
        component.set("v.saved" , false);
        var cost = component.get("v.quoteitem.Cost__c");
        if (typeof cost != 'undefined'){
        component.set("v.oldcost" , component.get("v.quoteitem.Cost__c"));
        }
	},
    savecost : function(component, event, helper) {
        var cost = component.get("v.quoteitem.Cost__c");
        if(cost != undefined && cost != "" && cost != null)
        {
            component.set("v.editcostmode" , false);
            component.set("v.saved" , true); 
        }
        else
        {
            component.find("Cost").showHelpMessageIfInvalid();
            component.find("Cost").focus();
        }
	},
    cancelcost : function(component, event, helper) {
		component.set("v.editcostmode" , false);
        component.set("v.saved" , true);
        component.set("v.quoteitem.Cost__c" , component.get("v.oldcost"));
	}
})