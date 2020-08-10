({
    doInit: function(component, helper){
        
        var action = component.get("c.fetchEstimatesAndExpenses");
        action.setParams({"recordId": component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                const list = ['v.cab', 'v.chassis', 'v.mechatronics', 'v.eve', 'v.otherEstimates', 'v.tooling', 'v.otherExpenses'];
                var result = [];
                for (var i=0;i<storeResponse.length;i++){
                    component.set(list[i], storeResponse[i]);
                }
            }
            //Wont use the helper class. Not sure why
            var total=component.get("v.cab") + 
                component.get("v.chassis") + 
                component.get("v.mechatronics") + 
                component.get("v.eve") + 
                component.get("v.otherEstimates");
            
            component.find("totalEstimates").set("v.value", total);
            var totalExpenses = component.get("v.tooling") +
                component.get("v.otherExpenses");
            
            component.find("totalExpenses").set("v.value", totalExpenses);
        });
        $A.enqueueAction(action); 
        
    },
    
    calculate:function(component, helper){
        //Wont use the helper class. Not sure why
        var total=component.get("v.cab") + 
            component.get("v.chassis") + 
            component.get("v.mechatronics") + 
            component.get("v.eve") + 
            component.get("v.otherEstimates");
        
        component.find("totalEstimates").set("v.value", total);
        var totalExpenses = component.get("v.tooling") +
            component.get("v.otherExpenses");
        console.log(totalExpenses);
        component.find("totalExpenses").set("v.value", totalExpenses);
    },
    
    save:function(cmp){
        var action = cmp.get("c.addEstimatesAndExpenses");
        action.setParams({"recordId": cmp.get("v.recordId"),
                          "cab" : cmp.get("v.cab"),
                          "chassis" : cmp.get("v.chassis"),
                          "mechatronics" : cmp.get("v.mechatronics"),
                          "eve" : cmp.get("v.eve"),
                          "otherEstimates" : cmp.get("v.otherEstimates"),
                          "tooling" : cmp.get("v.tooling"),
                          "otherExpenses" : cmp.get("v.otherExpenses")
                         });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "The Estimates saved successfully"
                });
                toastEvent.fire();
            }else{
                console.log('Issue occured with: ' + state);
            }
        });
        $A.enqueueAction(action); 
        
    }
})