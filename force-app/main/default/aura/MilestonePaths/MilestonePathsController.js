({
	doInit : function(component, event, helper) {
		let action = component.get("c.getDashboardData");
        action.setParams({
            "OppId":component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            component.set("v.result",response.getReturnValue());
        });
        $A.enqueueAction(action);
	}
})