({
	getDetailInformation: function(cmp){
        console.log('Inside getDetail');
        var action = cmp.get("c.fetchEWRDetail");
        action.setParams({"recordId": cmp.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                console.log("Successful");
                cmp.set("v.listOfDetails", storeResponse);
                var action = cmp.get("c.fetchWorkOrders");
                action.setParams({"Details": cmp.get("v.listOfDetails")});
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        console.log("Successful");
                        var storeResponse = response.getReturnValue();
                        
                        cmp.set("v.workOrders", storeResponse);
                        console.log(storeResponse);
                        console.log(cmp.get("v.workOrders"));
                    }
                });
                $A.enqueueAction(action);
            }
        });
        $A.enqueueAction(action);
    }
})