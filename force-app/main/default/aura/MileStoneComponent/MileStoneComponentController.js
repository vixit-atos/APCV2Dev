({
	doInit : function(component, event, helper) {
		let action = component.get("c.getData");
        action.setParams({
            "OppId":component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            component.set("v.result",response.getReturnValue());
        });
        $A.enqueueAction(action);
	}
})