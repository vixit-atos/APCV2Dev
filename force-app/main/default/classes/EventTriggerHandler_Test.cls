@isTest
private class EventTriggerHandler_Test {
    
 	    @isTest static void test_method_ChorletUser() {
        List<Contact> lstcontact=new List<Contact>();
        Account a = new Account(Name='S1');
        
        insert a;
        
        Contact ca = new Contact();
        ca.FirstName = 'cFN1';
        ca.LastName = 'cLN1';
        ca.phone ='1234567891';
        ca.Email = 'test@gmtestail.com';
        lstcontact.add(ca);
        upsert lstcontact;
        
        
        Profile p1 = [SELECT Id FROM Profile WHERE Name = 'DTNA - STC Charlotte'];
        // UserRole r = [select id from UserRole where DeveloperName = 'Sales_Person'];
        
        User u3 = new User(Alias = 'newUser', Email = 'newuser1@testorg.com',
                           EmailEncodingKey = 'UTF-8', LastName = 'Testing1', LanguageLocaleKey = 'en_US',
                           LocaleSidKey = 'en_US', ProfileId = p1.Id,
                           TimeZoneSidKey = 'America/Los_Angeles',UserName = 'newuser1@testorg.com.dtna.test12343554');
        
        
        Insert u3;
        System.runAs(u3) {
            
            
            Event e = new Event(
                
                Subject = 'Sample Task',
                StartDateTime = Datetime.now(),
                EndDateTime = Datetime.now(),
                Contact__c=ca.Id,
                OwnerId = UserInfo.getUserId());
                
            
            
            insert e;
            
            
        }
    }    
    @isTest static void test_method_one() {

        Account a = new Account(Name = 'a1');

        insert a;

        Contact ca = new Contact(

            FirstName = 'cFN1',
            LastName = 'cLN1',
            AccountId = a.Id,
            Email = 'test@gmtestail.com'
        );

        insert ca;
        Contact cna = new Contact(

            FirstName = 'cFN2',
            LastName = 'cLN2',
            Email = 'test@gmtestail.com'
        );

        insert cna;

        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        User u2 = new User(Alias = 'newUser', Email = 'newuser@testorg.com',
                           EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                           LocaleSidKey = 'en_US', ProfileId = p.Id,
                           TimeZoneSidKey = 'America/Los_Angeles', UserName = 'newuser@testorg.com.dtna.test12343554');

        System.runAs(u2) {
            
            
            Event e;
            Event e1;
           
            
            e = new Event(
                    StartDateTime = Datetime.now(),
                    EndDateTime = Datetime.now(),
                    Subject = 'Test Event',
                    Contact__c = ca.Id,
                    WhatId = a.Id);
            
          
            Event [] eList;
            e1 = new Event(
                    StartDateTime = Datetime.now(),
                    EndDateTime = Datetime.now(),
                    Subject = 'Test Event1',
                    Contact__c = ca.Id,
                    WhatId = a.Id);

            insert e1;

            //edit event

            e1.Subject = 'Suck it trebeck';
            update e1;

            //event associated with a contact quickaction

            e = new Event(
                    StartDateTime = Datetime.now(),
                    EndDateTime = Datetime.now(),
                    Subject = 'Test Event',
                    Contact__c = cna.Id);


            insert e;
			 Event e4 = new Event(
                    StartDateTime = Datetime.now(),
                    EndDateTime = Datetime.now(),
                    Subject = 'Test Event',
                    Contact__c = ca.Id);


            insert e4;
            
            User NAEuser =[select id,name,email from  User where  SalesUserRole__c='NAE' Limit 1];
            Id domesticRecordTypeId = TWSConstants.getOpportunityRecordTypeMap().get('TWS_TC_Deal');
            
            Opportunity o = new Opportunity(Name = 'o1',DTR_Requested_to_Quote_Residual__c = true, VEH_MAKE__c = 'FTL', Account = a,RecordTypeId = domesticRecordTypeId, StageName = 'Initial Notification', CloseDate = Date.Today(),Owner=NAEuser);
            insert o;
            
              Event e2 = new Event(
                StartDateTime = Datetime.now(),
                EndDateTime = Datetime.now(),
                Subject = 'Sample Task',
                WhatId = o.Id,
                OwnerId = UserInfo.getUserId());
            
            insert e2;
            Event objtask=[select id,Subject from Event where id=:e2.id]; 
            system.debug('objtask11111111111'+objtask);
            //edit a task
            objtask.Subject = 'Edited Sample Task';
            
            
            update objtask;
            
            
            Id ConcRecordTypeId =  [Select Id From RecordType Where SobjectType = 'Concession__c' and Name = 'FTL Mainframe Concession'].Id;
            Concession__c conc = new Concession__c(Name='12345',RecordTypeId=ConcRecordTypeId,Account__c=a.id);
            Insert conc;
            Event e3 = new Event(
                StartDateTime = Datetime.now(),
                EndDateTime = Datetime.now(),
                Subject = 'Sample Task10',
                
                WhatId = conc.id,
                OwnerId = UserInfo.getUserId());
                
            insert e3;
            Event objevent1=[select id,Subject from Event where id=:e3.id];
            objevent1.Subject = 'Edited Sample Task';
            
            update objevent1;
            Event objevent2=[select id,Subject from Event where id=:e3.id];
            
            
            Delete objevent2;

        Private_Activity_Redirector parAccountA = new Private_Activity_Redirector(new ApexPages.StandardController(a));

        
        }
    }
    
}