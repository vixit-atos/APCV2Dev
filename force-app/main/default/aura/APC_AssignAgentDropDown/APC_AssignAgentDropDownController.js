({
    doInit : function(component, event, helper) {
        var Cid = component.get("v.recordId");
        component.set("v.CaseId",Cid);
        console.log(Cid);
        var action = component.get("c.fetchLookUpValues");  
        action.setParams({
            ObjectName : 'GroupMember',
            caseId: component.get("v.CaseId")
        });  
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();               
            }
            console.log('storeResponse@@'+storeResponse);
            component.set("v.listOfSearchRecords", storeResponse);
            Console.log('Values rec'+listOfSearchRecords);
        }); 
        $A.enqueueAction(action);
    },
    SaveCaseAgent : function (component, event, helper) {
        var Cid = component.get("v.recordId");
        var selectedcompVal = component.get("v.SelectedVal");
        console.log('test@@@@'+selectedcompVal);
        if(selectedcompVal != '--None--'){
            var action = component.get("c.saveAgent");
            
            action.setParams({
                'caseid': Cid,
                'AgentId': selectedcompVal
            });
            action.setCallback(this, function(response) {
                var state = response.getState();  
                if (state === "SUCCESS") {
                    $A.get('e.force:refreshView').fire();
                   // var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    //dismissActionPanel.fire();
                }
                else if (state === "INCOMPLETE") {
                    alert('Dhruvil');
                }
                    else if (state === "ERROR") {
                         alert('Dhruvil');
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
        }
        //var AgentId = (component.get("v.selectedLookUpRecord").Id).substring(0,15);
        
    }
})