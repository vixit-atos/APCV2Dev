global class DTNA_Send_Outbound_Email
{
      @InvocableMethod
      webservice static void SendEmail(List<Outbound_Email__c> LstOutEmail)
      {
            for(Outbound_Email__c OutEmail:LstOutEmail)
            {
                try
                {
                    Id templateId;
                    List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    List <string> lstEmail = new list<string>();
                    
                    if(OutEmail.Type__c == 'Expired Concessions')
                    {
                        templateId =  [select id from EmailTemplate where developername = 'Expired_Concessions_Feedback_Request'].id;
                    }
                    else
                    {
                        templateId =  [select id from EmailTemplate where developername = 'Concessions_For_Expiry_Feedback_Request'].id;
                    }
                    
                    List<Role__c> lstRole = [select Contact__r.Email,Account__c,Role__c from Role__c where Role__c = 'Sales Manager' and Account__c = :OutEmail.Account__c];
                    
                    for(Role__c RoleCont:lstRole)
                    {
                        if(RoleCont.Contact__r.Email != null)
                              lstEmail.add(RoleCont.Contact__r.Email);
                    }
                    system.debug('lstEmail'+lstEmail);
                    email.setToAddresses(lstEmail);
                    email.setTargetObjectId(OutEmail.Contact__c);
                    email.setTreatTargetObjectAsRecipient(false);
                    email.setWhatId(OutEmail.Id);
                    email.setTemplateId(templateId);
                    mails.add(email);
                    Messaging.sendEmail(mails);
                   // OutEmail.Status__c= 'Submitted';
               }
               catch(Exception e)
               {
                  // OutEmail.Log__c = 'Error:' + e.getMessage() + ' Stack trace:' + e.getStackTraceString();
                   system.debug('Error:' + e.getMessage() + ' Stack trace:' + e.getStackTraceString());
               }
           }
         //  update LstOutEmail;
      }
}