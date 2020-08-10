({
	doInit : function(component, event, helper) {
        var recordID = component.get("v.recordId"); 
        var action = component.get("c.getAttachmentList");
        action.setParams({ "currendRecID" : recordID });
        action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === "SUCCESS") {
          component.set("v.data", response.getReturnValue());
        } 
        else {
          console.log(state);
        }
        });
        $A.enqueueAction(action);
        
      	var setRelatedRecordId = component.get("c.findRelatedRecordID");
        setRelatedRecordId.setParams({ "approvalID" : recordID });
        setRelatedRecordId.setCallback(this, function(response) {
        var state = response.getState();
        if (state === "SUCCESS") {
          component.set("v.relatedRecordID", response.getReturnValue());
        } 
        else {
          console.log(state);
        }
        });
        $A.enqueueAction(setRelatedRecordId);             
	}
})