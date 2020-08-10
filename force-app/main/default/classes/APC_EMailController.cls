public with sharing class APC_EMailController {
    @InvocableMethod(label='Send email notificaiton to additional recipient' description='Send Email to Additional Recipient on case update')
    public static void sendemailadditionalrecipientscaseupdates(list<case> caselist){
        
        // Fetch Email template Id 
        List<EmailTemplate> lstEmailTemplates = [SELECT Id, Body, Subject from EmailTemplate where DeveloperName = 'APC_Email_Notification_Additional_Recipient'];
        
        //Create Map of Case and Event Object
        Map<Id, list<string>> caseadditionalrecipientmap = new Map<Id, list<string>>();
        
        list<event> eventlist = [select whatId, subject from event where whatId in: (new Map<Id,case>(caselist)).keySet()];
        
        //list<event> eventlist = [select subject from event where whatId =: caselist[0].Id];
        list<string> additionalrecipient = new list<string>();
        if(!eventlist.isEmpty()){// Null check event list 
            for(event objevent: eventlist){
                additionalrecipient.add(objevent.subject);
                if(String.isNotBlank(objevent.WhatId)){
                    if(!caseadditionalrecipientmap.containsKey(objevent.WhatId)){
                        caseadditionalrecipientmap.put(objevent.WhatId, new list<string>());
                    }
                    caseadditionalrecipientmap.get(objevent.WhatId).add(objevent.subject);
                }                
            }
        }  
        
/*        for(){
            
        }*/
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTemplateId(lstEmailTemplates[0].Id);
        mail.setSaveAsActivity(false);
        mail.setTargetObjectId(caselist[0].ContactId);// Any contact or User id of your record
        mail.setToAddresses(additionalrecipient);
        
        mail.setWhatId(caselist[0].Id); // Enter your record Id whose merge field you want to add in template
        Messaging.SendEmailResult[] resultMail = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        //Please replace "Your Email Template Unique Name" with your template name
    }
}