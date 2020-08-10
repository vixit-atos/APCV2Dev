({
	fetchcasefeed : function(component, event, helper) {
		var action = component.get("c.fetchcasefeeditem");
        var caseRecordId = component.get('v.recordId');  
        action.setParams({            
                'recordId': caseRecordId           
        });
         action.setCallback(this,function(response){
            debugger;
            var state = response.getState();
            if(state=='SUCCESS' && response.getReturnValue()){
                debugger;               
                var feeds = response.getReturnValue();
                component.set("v.feeds", feeds);
            } else {
               
            }
        });
        $A.enqueueAction(action);
	}
})