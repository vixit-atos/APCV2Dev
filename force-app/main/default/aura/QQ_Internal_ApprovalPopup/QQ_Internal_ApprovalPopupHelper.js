({
    callApprovalservice : function(component) 
    {
        var self = this;
        var ApprovalSrvc = component.find("ApprovalService");
        var quoteitemlst = []; 
        var quoteitemobj = component.get("v.quoteitem");
        quoteitemlst.push(quoteitemobj);
        ApprovalSrvc.approvalmethod(component.get("v.quote"), quoteitemlst, component.get("v.noteslist"), function(result) {
            var submitEvent = $A.get("e.c:QQ_NQ_Submit_Save_event");        
            submitEvent.setParam("message", "event message here");
            submitEvent.fire();
            
            var quoteList = component.get("v.queuelist");
            var quoteStatus = component.get("v.quote.Status__c"); 
            if(quoteStatus == "Approved")
            {
                //----------- CREATE NEW MASTER RECORD ---------------------
                self.createMaster(component, quoteitemobj);                
            }
            
            var emailqueue = self.findqueue(quoteList, quoteStatus);
            var emailsrvc =  component.find("emailService");
            emailsrvc.sendEmail(component.get("v.quote.Name"), quoteStatus, emailqueue, function(result){});
        });
    }, 
    
    createMaster : function(component, lineItem)
    {
        var action = component.get("c.createMaster");
        action.setParams({"lineItem":lineItem});
        action.setCallback(this, function(response){
            var state = response.getState();            
            if(state === 'SUCCESS')
            {
                var result = response.getReturnValue();
                //alert(result);
                if(result.includes("SUCCESS"))
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "New master record created successfully",
                        "type" : "success"
                    });
                    toastEvent.fire();
                    component.set("v.openpopup", false);
                }
                if(result.includes("ERROR"))
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": result,
                        "type" : "error"
                    });
                    toastEvent.fire();
                    component.set("v.openpopup", false);
                }
                
            }else if (state === 'ERROR'){
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }else{
                console.log('Something went wrong, Please check with your admin');
            }
        });
        $A.enqueueAction(action);
    },
    
    getapprovalqueuedetails : function(component, recordstatus) 
    {
        var staticresourcereader = component.find("listservice");
        staticresourcereader.getListColumn("QQ_Static_Queue_mapper", function(result){
            component.set("v.queuelist", result);
        });
    }, 
    
    findqueue : function (queuelist, recordstatus)
    {
        var queueitem = queuelist.find(function(item){
            return item.status === recordstatus;
        });
        return queueitem.queue; 
    }
})