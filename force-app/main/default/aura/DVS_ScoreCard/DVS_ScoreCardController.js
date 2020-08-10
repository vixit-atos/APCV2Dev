({
	doInit : function(component, event, helper) {
        var recordID = component.get("v.recordId");
        var action = component.get("c.getScoreCard");
        action.setParams({ "currendRecID" : recordID });
        action.setCallback(this, function(response) {
     
        var state = response.getState();
        if (state === "SUCCESS") {
          component.set("v.scorecard", response.getReturnValue());
        } 
        else {
          console.log(state);
        }
        });
        
       /* var comments = component.find("comments");
        comments.set("v.value","asdasd");*/
        $A.enqueueAction(action);   
	},
    
    
    onCheck: function(cmp, evt) {
         var checkCmp = cmp.find("checkbox");
         resultCmp = cmp.find("checkResult");
         resultCmp.set("v.value", ""+checkCmp.get("v.value"));

    },
  
    save : function(component, event, helper) {
        var updated = component.get("v.scorecard");
        var action = component.get("c.saveScoreCard");
        action.setParams({ "updatedDVS" :  updated });
        action.setCallback(this, function(response) {
     
        var state = response.getState();
        if (state === "SUCCESS") {
         	
        } 
        else {
          console.log(state);
        }
        });
        $A.enqueueAction(action);   
        
        component.set("v.changed", "true");
      },
        
        
      savebtn : function(component, event, helper) {
        var updated = component.get("v.scorecard");
        var action = component.get("c.saveScoreCard");
        action.setParams({ "updatedDVS" :  updated });
        action.setCallback(this, function(response) {
     
        var state = response.getState();
        var toastEvent = $A.get("e.force:showToast");  
        if (state === "SUCCESS") {
          toastEvent.setParams({
                    "title": "Success!",
                    "message": " Your evalution score card has been saved successfully.",
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
        } 
       	toastEvent.fire();
        });
        $A.enqueueAction(action);   
        
        component.set("v.changed", "false");
      } 
  
})