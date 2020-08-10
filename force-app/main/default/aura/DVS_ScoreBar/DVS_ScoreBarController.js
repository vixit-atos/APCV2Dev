({
	doInit : function(component, event, helper) {
        var recordID = component.get("v.recordId");
        var action = component.get("c.getScoreCard");
        action.setParams({ "currendRecID" : recordID });
        action.setCallback(this, function(response) {
     
        var state = response.getState();
        if (state === "SUCCESS") {
          component.set("v.scorebar", response.getReturnValue());
        } 
        else {
          console.log(state);
        }
        });
        $A.enqueueAction(action);   
	}
})