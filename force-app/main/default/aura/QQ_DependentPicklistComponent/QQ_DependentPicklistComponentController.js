({
    getdeplist : function(component, event, helper) {
        var params = event.getParam('arguments');
        var callback;
        var sObjectName;
        var controlfieldApiName;
        var controlfieldValue;
        var depfieldApiName;
        if (params) {
            callback = params.callback;
            sObjectName = params.sObjectName;
            controlfieldApiName = params.controlfieldApiName;
            controlfieldValue = params.controlfieldValue;
            depfieldApiName = params.depfieldApiName;
        }
        var action = component.get('c.getDependentlist');
        
        action.setParams({
            objName:  sObjectName,            
            contrfieldApiName : controlfieldApiName,
            contrfieldvalue : controlfieldValue,
            depfieldApiName : depfieldApiName            
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var dependentlist = response.getReturnValue();
                var dependentoptions = [];
                dependentlist.forEach(function(item) {
                    var dependentobj = {};
                    dependentobj.label=item;
                    dependentobj.value=item;
                    dependentoptions.push(dependentobj);
                });
                if (callback) callback(dependentoptions);    
            }
        });
        $A.enqueueAction(action);
    }
})