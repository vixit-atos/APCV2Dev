global class schedulBatchApprovalMail implements Schedulable {

   
    global void execute(SchedulableContext sc)
    {
                sendmail();
    }

    public void sendmail()
    {
    
       
        if([SELECT Count() FROM ProcessInstance WHERE ProcessDefinition.DeveloperName='TWS_ISP_Approval' AND Status='Pending']>0  )
        {
            String approverEmailId = System.Label.BatchApproverEmailId; 
            system.debug('approverEmailId ::::'+approverEmailId );
            String sentEmail = System.Label.sentEmail; 
            List<User> approverUser = [SELECT id,Email FROM User WHERE email =:approverEmailId];
             system.debug('approverUser ::::'+approverUser ); 
            List<EmailTemplate> emailTemplateList = [SELECT Id FROM EmailTemplate WHERE Name = 'Multiple Sales Proposal Submission'];
            if(!emailTemplateList.isEmpty() && !approverUser.isEmpty() && approverUser[0].email != null)
            {
                //list<Messaging.SingleEmailMessage> mails = new  list<Messaging.SingleEmailMessage>(); 
                OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =: sentEmail ];
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setTargetObjectId(approverUser[0].id);
                email.setTemplateId(emailTemplateList[0].id);
                email.setOrgWideEmailAddressId(owea[0].Id);
                email.saveAsActivity = false;
                //email.setinReplyTo('batchapprovalemailservice@6to2mj0ptz1p7ubx4ls3x8bzhhf8j265qtjb8ts8gqbsqcr8x.1d-8fkwuaa.cs68.apex.sandbox.salesforce.com');
                Messaging.sendEmail(new list<Messaging.SingleEmailMessage>{email});   
                    
              }  
            
        }
    
    } 
}