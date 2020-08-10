({
    sendEmail : function(component, event, helper) {
        var params = event.getParam('arguments');
        var callback;
        var recordnum;
        var recordstatus;
        var queuename;
        
        
        if (params) {
            callback = params.callback;
            recordnum = params.recordnum; 
            recordstatus = params.recordstatus; 
            queuename = params.queue_or_owner;
            
        }
        var action = component.get('c.qqsendEmail');
      
        action.setParams({
            "recordID" : recordnum,
            "queueName" : queuename,
            "recordStatus" : recordstatus
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                if (callback) callback(response.getReturnValue()); 
                
            }
        });
        $A.enqueueAction(action);
        
        
    }
})