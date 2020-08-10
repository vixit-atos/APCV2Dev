({
    /*
     * Gathers the parameters and then calls the action associated
     * to the controller method. Passes the results back to the parent component
     */ 
	init: function (cmp, event, helper) {
        var params = event.getParams().arguments;
        var callerComponent = params.component;
        var controllerMethod = params.controllerMethod;
        var actionParameters = params.actionParameters;
        var functionCallBack = params.functionCallBack;
        helper.callApexMethod(cmp, callerComponent, controllerMethod, actionParameters,functionCallBack);
    },
    
    debugStatements : function(cmp){
    	console.log('Component: ' + callerComponent);
        console.log('Controller Method: ' + controllerMethod);
        console.log('Parameters: ' + JSON.stringify(actionParameters));
        console.log('Success Callback: ' + successCallBack);
    }
})