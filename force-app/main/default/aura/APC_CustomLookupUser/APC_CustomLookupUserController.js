({
	doInit : function(component, event, helper) {
        //console.log('testttt');
		var Cid = component.get("v.recordId");
        
        //console.log('@@@@@'+Cid);
        //console.log('@@@@@'+Cid);
        component.set("v.CaseId",Cid);
	},

  	 SaveCaseAgent : function (component, event, helper) {
        //console.log("Testing this function"+component.get("v.recordId"));
         var Cid = component.get("v.recordId");
         //Cid.Agent__c = null;
         //console.log('Cid@@@'+Cid);
         var AgentId = (component.get("v.selectedLookUpRecord").Id).substring(0,15);
         /*console.log('enter@@@@'+AgentId);
          if(AgentId != null){
          console.log('enter1111'+Cid.Agent__c);    
          Cid.Agent__c = AgentId;
          console.log('@@@@@'+Cid.Agent__c);    
        } */
         //alert('the agent id is:'+AgentId);
        var action = component.get("c.saveAgent");
        //console.log('action@@@'+action);
         
        action.setParams({
            'caseid': Cid,
            'AgentId': AgentId
        });
        action.setCallback(this, function(response) {
       // alert('enter');    
        //store state of response
       // alert('the returned value is'+response.getReturnValue());
        var state = response.getState();
            //conlose.log(state);
         //alert('enter1111'+state);   
        if (state === "SUCCESS") {
                // Alert the user with the value returned 
                // from the server
                 $A.get('e.force:refreshView').fire();
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
               dismissActionPanel.fire();
               // alert("From server: " + response.getReturnValue());

                // You would typically fire a event here to trigger 
                // client-side notification that the server-side 
                // action is complete
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
      });
      $A.enqueueAction(action);
    }, 
    Cancel: function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});           
        })
        .catch(function(error) {
            console.log(error);
        });
    }
})