({
    callApprovalservice : function(component) {
        var ApprovalSrvc = component.find("ApprovalService");
        var quoteitemlst = []; 
        var quoteobj = component.get("v.quote");
        var quoteitemobj = component.get("v.quoteitem");
        quoteitemlst.push(quoteitemobj);
        var emailsrvc =  component.find("emailService") ;
        emailsrvc.sendEmail(quoteobj.Name, quoteobj.Status__c, quoteobj.CreatedById , function(result){ });

        ApprovalSrvc.approvalmethod(component.get("v.quote"), quoteitemlst, component.get("v.noteslist") , function(result) {
            component.set("v.openpopup" , false);
            var submitEvent = $A.get("e.c:QQ_NQ_Submit_Save_event");        
            submitEvent.setParam("message", "event message here");
            submitEvent.fire();
        });
        
    }
})