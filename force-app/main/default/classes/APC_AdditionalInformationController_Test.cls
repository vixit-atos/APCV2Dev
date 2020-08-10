@Istest
public class APC_AdditionalInformationController_Test {
    @testSetup static void setup() {
        Account ac = new Account(name ='CDCD Account', Dealer_Code__c = 'CDCD') ;
        insert ac; 
        Account ac1 = new Account(name ='YFFD Account', Dealer_Code__c = 'YFFD') ;
        insert ac1;
        
        Contact con = new Contact(LastName ='CDCD User1',AccountId = ac.Id);
        insert con;  
        
        Contact con1 = new Contact(LastName ='YFFD User1',AccountId = ac1.Id);
        insert con1;  
        
        case objcase = new case(status='new', accountid=ac.id, Body_Number__c='11221',Additional_Contacts__c='CDCD User1',Additional_Recipients__c='dhruviltest@gmail.com');
        insert objcase;
        Event e = new Event();
        e.WhatId=objcase.id;
        e.Subject = 'adsa@sada.com';
        e.StartDateTime=system.today();
        e.EndDateTime=system.today()+5;        
        insert  e;
        
        String uniqueUserName = 'standarddealeruser' + DateTime.now().getTime() + '@testorg.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='DEALER-PARTNER-COMMUNITY'];
        User u = new User(Alias = 'stduser',
                          Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', 
                          LastName='Testing', 
                          LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', 
                          ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName=uniqueUserName,
                          isActive=true,
                          contactId = con.Id,
                          visibilities__c='cn=YKFD,ou=dealers,ou=organizations,o=freightliner,o=dcx.com^cn=YFFD,ou=dealers,ou=organizations,o=freightliner,o=dcx.com^cn=YBFD');
        insert u;
        
        
    }
    
    @isTest static void getDealerContactsNewTest(){  
        user u = [select id from user where contact.Account.Dealer_code__c = 'CDCD' limit 1];
        Case caseid=[select id,Additional_Recipients__c from case];   
        String Caseid1=caseid.Id;
        String acaselist=caseid.Additional_Recipients__c;
        String [] AdditionalContacts = new List<String>();
        system.runAs(u) {            
            APC_AdditionalInformationController.getContacts(Caseid1);
        }
    }
    @isTest static void getContactsinternaltest(){  
        user u = [select id from user where contact.Account.Dealer_code__c = 'CDCD' limit 1];
        Case caseid=[select id,Additional_Recipients__c from case];   
        String Caseid1=caseid.Id;
        String acaselist=caseid.Additional_Recipients__c;
        String [] AdditionalContacts = new List<String>();
        system.runAs(u) {
            APC_AdditionalInformationController.getContactsinternal(Caseid1);
        }
    }
    @isTest static void getCaseTest(){  
        user u = [select id from user where contact.Account.Dealer_code__c = 'CDCD' limit 1];
        Case caseid=[select id,Additional_Recipients__c from case];   
        String Caseid1=caseid.Id;
        String acaselist=caseid.Additional_Recipients__c;
        String [] AdditionalContacts = new List<String>();
        system.runAs(u) {
            APC_AdditionalInformationController.getCase(Caseid1);
        }
    }
    @isTest static void getadditionalrecipientTest(){  
        user u = [select id from user where contact.Account.Dealer_code__c = 'CDCD' limit 1];
        Case caseid=[select id,Additional_Recipients__c from case];   
        String Caseid1=caseid.Id;
        String acaselist=caseid.Additional_Recipients__c;
        String [] AdditionalContacts = new List<String>();
        system.runAs(u) {
            APC_AdditionalInformationController.getadditionalrecipient(Caseid1);
        }
    }
    ///
    @isTest static void removeAdditionalRecipientsDataTest(){  
        user u = [select id from user where contact.Account.Dealer_code__c = 'CDCD' limit 1];
        Case caseid=[select id,Additional_Recipients__c from case];
        Event e = new Event();
        e.WhatId=caseid.id;
        e.StartDateTime=system.today();
        e.EndDateTime=system.today()+5;        
        insert  e;
        String Caseid1=caseid.Id;
        String acaselist=caseid.Additional_Recipients__c;
        String [] arrayOfProducts = new List<String>();
        arrayOfProducts.add(acaselist);
        String [] AdditionalContacts = new List<String>();
        system.runAs(u) {
            Event e1 = new Event();
            e1.WhatId=caseid.Id;
            e1.Subject = 'adsa@sada.com';
            e1.StartDateTime=system.today();
            e1.EndDateTime=system.today()+5;        
            insert  e1;
            APC_AdditionalInformationController.recipientpill WrapCl=new  APC_AdditionalInformationController.recipientpill();
            APC_AdditionalInformationController.removeAdditionalRecipientsData(Caseid1,'{"label":"adsa@sada.com","name":"adsa@sada.com"}');
        }
    }
    
    @isTest static void getUIThemeDescriptiontest(){  
        user u = [select id from user where contact.Account.Dealer_code__c = 'CDCD' limit 1];
        Case caseid=[select id,Additional_Recipients__c from case];
        String Caseid1=caseid.Id;
        String acaselist=caseid.Additional_Recipients__c;
        String [] AdditionalContacts = new List<String>(); 
        system.runAs(u) {
            APC_AdditionalInformationController.getUIThemeDescription();
            APC_AdditionalInformationController.getloggeduseraccountid();
        }
    }
    
    @isTest static void saveCaseAdditionalContactsDatatest(){  
        user u = [select id from user where contact.Account.Dealer_code__c = 'CDCD' limit 1];
        Case caseid=[select id,Additional_Contacts__c from case];   
        String Caseid1=caseid.Id;
        String acaselist=caseid.Additional_Contacts__c;
        String [] AdditionalContacts = new List<String>();
        AdditionalContacts.add(acaselist);
        system.runAs(u) {
            try{ 
                APC_AdditionalInformationController.saveCaseAdditionalContactsData(Caseid1,AdditionalContacts);
            }catch(DMLException e){
                system.assertEquals(e.getMessage(), e.getMessage()); 
            }
            
        }
    }
    @isTest static void saveCaseAdditionalContactsDatatestNegative(){  
        user u = [select id from user where contact.Account.Dealer_code__c = 'CDCD' limit 1];
        Case caseid=[select id,Additional_Contacts__c from case];   
        String Caseid1=caseid.Id;
        String acaselist=caseid.Additional_Contacts__c;
        String [] AdditionalContacts = new List<String>();
        AdditionalContacts.add(acaselist);
        system.runAs(u) {
            Event e1 = new Event();
            e1.WhatId=caseid.Id;
            e1.Subject = 'adsa@sada.com';
            e1.StartDateTime=system.today();
            e1.EndDateTime=system.today()+5;        
            insert  e1;
            try{ 
                APC_AdditionalInformationController.saveCaseAdditionalContactsData(Caseid1,AdditionalContacts);
            }catch(DMLException e){
                system.assertEquals(e.getMessage(), e.getMessage()); 
            }
            
        }
    }
    @isTest static void saveAdditionalRecipientsDataTest(){  
        user u = [select id from user where contact.Account.Dealer_code__c = 'CDCD' limit 1];
        Case caseid=[select id,Additional_Recipients__c from case];
        String Caseid1=caseid.Id;
        String acaselist=caseid.Additional_Recipients__c;
        String [] AdditionalContacts = new List<String>();
        AdditionalContacts.add(acaselist);
        
        
        
        system.runAs(u) {
            APC_AdditionalInformationController.recipientpill WrapCl=new  APC_AdditionalInformationController.recipientpill();
            WrapCl.label='teadsa@sada.comst';
            WrapCl.name='testNameadsa@sada.com';
            try{ 
                APC_AdditionalInformationController.saveAdditionalRecipientsData(Caseid1,'{"label":"adsa@sada.com","name":"adsa@sada.com"}');
            }catch(DMLException e){
                system.assertEquals(e.getMessage(), e.getMessage()); 
            }
            
        }
    }
}