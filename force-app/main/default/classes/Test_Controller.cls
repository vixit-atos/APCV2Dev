public Without Sharing class Test_Controller {
    @AuraEnabled (cacheable=true)
    public static List<Contact> getContacts()
    {      
       /* List<Contact> contactList = new List<Contact>();
        contactList = [select id,FirstName,LastName,Email from contact limit 1000];
        system.debug('contactList->' + contactList);
        return contactList;      
    }*/
        
        List<Contact> contactList = new List<Contact>();
       // if(UserInfo.getUserId() == '005L0000005sTVPIA2' || UserInfo.getUserId() == '005L0000005sHECIA2' || UserInfo.getUserId() == '005L0000005s4KlIAI' || UserInfo.getUserId() == '0050W0000073mYBQAY'){
       if(UserInfo.getProfileId() == '00ed0000000viihAAA')
        {
            contactList = [select id,FirstName,LastName,Email from contact where accountid in (select id from account where dealer_code__c  ='KHMD')];
        }else{
            
            contactList = [select id,FirstName,LastName,Email from contact ];
        }
        system.debug('contactList->' + contactList);
        return contactList;       
    }
    
    @AuraEnabled (cacheable=true)
    public static Case getCase(string caseid)
    {      
    	Case objCase = [select id,Description,Multiple_Parts__c,Additional_Contacts__c from Case where id=:caseid];
        return objCase;
    }
    
    @AuraEnabled
    public static Case saveCaseDescriptionData(string caseid, string description)
    {
        System.debug(caseid);
        System.debug(description);
    	Case objCase = [select id,Description from Case where id=:caseid];
        objCase.Description = description;
        update objCase;
        return objCase;
    }

    @AuraEnabled
    public static Case saveCaseAdditionalContactsData(string caseid, string[] additionalContacts)
    {
        System.debug(caseid);
        System.debug(additionalContacts);
    	Case objCase = [select id,Additional_Contacts__c from Case where id=:caseid];
        objCase.Additional_Contacts__c = String.join(additionalContacts, ';');
        update objCase;
        return objCase;
    }
    
    @AuraEnabled
    public static boolean saveAdditionalRecipientsData(string caseid, string additionalrecipientlist)
    {
        System.debug(caseid);
        System.debug(additionalrecipientlist);
        list<string> recipients = new list<string>(); 
        recipientpill recipient = (recipientpill)JSON.deserialize(additionalrecipientlist, recipientpill.class);
        boolean isExists = false;
        list<Event> existingEvents = [select id from Event where Subject =: recipient.label and WhatId =:caseid];
        if(!existingEvents.isEmpty()){
            return true;
        }
        String userId = UserInfo.getUserId();
        Event event = new Event(
            OwnerId = userId,
            WhatId = caseid,                        
            Subject = recipient.label,
            startdatetime = system.now(),
            EndDateTime = system.now().addMinutes(10),
            type = 'Email'
        );
        
                try{
            insert event;
        }catch (exception ex){
            system.debug('Error message: ' + ex.getMessage());
     }
     return false;
 }
    
    @AuraEnabled
    public static boolean removeAdditionalRecipientsData(string caseid, string additionalrecipientlist)
    {
        System.debug(caseid);
        System.debug(additionalrecipientlist);
        list<string> recipients = new list<string>(); 
        recipientpill recipient = (recipientpill)JSON.deserialize(additionalrecipientlist, recipientpill.class);
        boolean isExists = false;
        list<Event> existingEvents = [select id from Event where Subject =: recipient.label and WhatId =:caseid];
        if(!existingEvents.isEmpty()){
           
            try{
            delete existingEvents;
            }catch (exception ex){
            system.debug('Error message: ' + ex.getMessage());
            return false;
          }
      }
        return true;
    }
    
     @AuraEnabled
    public static list<event> getadditionalrecipient(string caseid)
    {
        System.debug(caseid);
        return [select id, subject from event where whatid = :caseid];        
    }
 public class recipientpill {
         @AuraEnabled public String  label {get; set;}
         @AuraEnabled public String  name  {get; set;}
}
}