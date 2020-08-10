({
    /*
     * Generically calls the sObjectServerController using the controller method
     * Passing parameters into the controller, and returning the results to the parent component
     */ 
	callApexMethod: function (cmp, callerComponent, controllerMethod,
        actionParameters, functionCallBack) {        
        let action = cmp.get(controllerMethod);
        action.setParams(actionParameters);
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let returnedResponse = JSON.parse(JSON.stringify(response.getReturnValue()));
                functionCallBack(callerComponent, returnedResponse);
            } else if (state === "ERROR") {
                let errors = response.getError();
                if (errors) {
                    functionCallBack(callerComponent, errors);
                }
            } else {
                functionCallBack(callerComponent, 'Server Side Error Occurred');
            }
        });
        $A.enqueueAction(action);
    },
})