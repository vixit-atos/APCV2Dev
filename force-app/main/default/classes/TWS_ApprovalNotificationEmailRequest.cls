public with sharing class TWS_ApprovalNotificationEmailRequest 
{
    public TCMeeting__c sObjTCM {get;set;}
    String idTCM {get;set;}
    public ApexPages.StandardController TCM_sc = null;

    public TWS_ApprovalNotificationEmailRequest(ApexPages.StandardController controller)
    {
        idTCM = ApexPages.currentPage().getParameters().get('id');
        sObjTCM = new TCMeeting__c();
        sObjTCM = [SELECT Name,TC_Meeting_Date__c, ID from TCMeeting__c where Id = :idTCM];
        TCM_sc = controller;
    }
    
    public void SendApprovalEmail()
    {
        try
        {
            Id templateId;
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            List <string> lstEmail = new list<string>();
            templateId =  [select id from EmailTemplate where developername = 'TWS_TC_Meeting_Approval_Notification'].id;

            lstEmail.add(UserInfo.getUserEmail());
            email.setToAddresses(lstEmail);
            email.setTargetObjectId(Id.valueOf(UserInfo.getUserId()));
            email.setTreatTargetObjectAsRecipient(false);
            email.setWhatId(sObjTCM.Id);
            email.setTemplateId(templateId);
            mails.add(email);
            Messaging.sendEmail(mails);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.CONFIRM, 'The Approval Notification email was sent to you. Please make any necessary changes and forward to the appropriate members');
            ApexPages.addMessage(myMsg);
            
        }
        catch(Exception e)
        {
            system.debug('Error:' + e.getMessage() + ' Stack trace:' + e.getStackTraceString());
            ApexPages.addMessages(e);
        }
    }
    
    public PageReference doCancel()
    {
        return TCM_sc.cancel();
    }
}