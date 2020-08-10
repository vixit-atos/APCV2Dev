({
    insertcomment : function(component, event, helper) {
        
        var action = component.get("c.insertfeedcommentonfeeditem");
        var commentbody = component.get("v.commentbody");
        var FeedItemId = component.get('v.FeedItemId');  
        var caseId = component.get('v.caseId'); 
        action.setParams({            
            'FeedItemId': FeedItemId,
            'commentbody':commentbody,
            'recordId': caseId  
        });
        action.setCallback(this,function(response){            
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