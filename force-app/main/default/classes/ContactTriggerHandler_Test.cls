@isTest
private class ContactTriggerHandler_Test {
    
    @testSetup static void setup() {
        // Create common test data to test the SMR contact with related Roles
        Profile p = [SELECT Id,name FROM Profile WHERE Name = 'DTNA - SMR Specialist'];
        UserRole r = [SELECT Id,name FROM UserRole WHERE Name = 'SMR Specialist'];
        UserRole r1 = [SELECT Id,name FROM UserRole WHERE Name = 'SMR Manager'];
        User u1 = new User(Alias = 'smsr', Email = 'newsmruser@testorg.com',Title='PPAP Admin',
                           EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                           LocaleSidKey = 'en_US', ProfileId = p.Id,UserRoleId=r.Id,
                           TimeZoneSidKey = 'America/Los_Angeles', UserName = 'newuser@testorg.com.dtna.test2');
         System.runAs(u1) {
               RecordType smrRecType=[select Id from RecordType where sObjectType='Role__c' AND DeveloperName='SMR_Department_Title' LIMIT 1];
               RecordType smrContType=[select Id from RecordType where sObjectType='Contact' AND DeveloperName='Supplier_Contact' LIMIT 1];
              RecordType smrAccType=[select Id from RecordType where sObjectType='Account' AND DeveloperName='Supplier' LIMIT 1];
               Account ObjAcct = new Account(Name='test1234567890', RecordTypeId=smrAccType.id);
               insert ObjAcct;
                
               Contact ObjCont = new Contact(
                                FirstName = 'smr1',
                                LastName = 'cLN1',
                                phone ='1234567891', RecordTypeId=smrContType.id,
                    		    Email = 'smr1.cln1@smrtestail.com');
               
                insert ObjCont;
               
                Role__C ObjRole1 = new Role__c(Department__c='QUALITY ASSURANCE VENDOR CONTA',Job_Title__C='CEO',Account__c=ObjAcct.Id,Contact__C=ObjCont.Id,RecordTypeId=smrRecType.Id,Notes__c='Test2');
                insert ObjRole1;
             }
       User u2 = new User(Alias = 'smsr1', Email = 'new1smruser@testorg.com',Title='Admin',
                           EmailEncodingKey = 'UTF-8', LastName = 'Testing1', LanguageLocaleKey = 'en_US',
                           LocaleSidKey = 'en_US', ProfileId = p.Id,UserRoleId=r1.Id,
                           TimeZoneSidKey = 'America/Los_Angeles', UserName = 'new1smruser@testorg.com.dtna.test2');
        insert u2;
    }
    
    @isTest static void test_method_one() {
        
        List<Contact> lstcontact=new List<Contact>();
         List<Contact> lstcontact2=new List<Contact>();
         List<Contact> lstcontact3=new List<Contact>();
        List<Contact> lstcontact4=new List<Contact>();
        List<Contact> lstcontact5=new List<Contact>();
         List<Contact> lstcontact6=new List<Contact>();
        List<Contact> lstcontact7=new List<Contact>();
        Profile p1 = [SELECT Id,name FROM Profile WHERE Name = 'DTNA - STC Toronto'];
        User u1 = new User(Alias = 'newUser', Email = 'newuser@testorg.com',
                           EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                           LocaleSidKey = 'en_US', ProfileId = p1.Id,
                           TimeZoneSidKey = 'America/Los_Angeles', UserName = 'newuser@testorg.com.dtna.test12343554');
        System.runAs(u1) {
            Contact ca = new Contact();
            ca.FirstName = 'cFN1';
            ca.LastName = 'cLN1';
            ca.phone ='1234567891';
            ca.Email = 'test@gmtestail.com';
            lstcontact.add(ca);
            upsert lstcontact;
            
        }
        Profile p2 = [SELECT Id,name FROM Profile WHERE Name = 'DTNA - STC New England'];
        User u2 = new User(Alias = 'newUser1', Email = 'newuser1@testorg.com',
                           EmailEncodingKey = 'UTF-8', LastName = 'Testing1', LanguageLocaleKey = 'en_US',
                           LocaleSidKey = 'en_US', ProfileId = p2.Id,
                           TimeZoneSidKey = 'America/Los_Angeles', UserName = 'newuser@testorg.com.dtna.test21');
        System.runAs(u2) {
            Contact ca2 = new Contact();
            ca2.FirstName = 'cFN1';
            ca2.LastName = 'cLN1';
            ca2.phone ='1234567891';
            ca2.Email = 'test@gmtestail.com';
            lstcontact2.add(ca2);
            upsert lstcontact2;
            
        }
        Profile p3 = [SELECT Id,name FROM Profile WHERE Name = 'DTNA - STC Tampa'];
        User u3 = new User(Alias = 'newUser2', Email = 'newuser@testorg.com2',
                           EmailEncodingKey = 'UTF-8', LastName = 'Testing2', LanguageLocaleKey = 'en_US',
                           LocaleSidKey = 'en_US', ProfileId = p3.Id,
                           TimeZoneSidKey = 'America/Los_Angeles', UserName = 'newuser@testorg.com.dtna.test32');
        System.runAs(u3) {
            Contact ca3 = new Contact();
            ca3.FirstName = 'cFN1';
            ca3.LastName = 'cLN1';
            ca3.phone ='1234567891';
            ca3.Email = 'test@gmtestail.com';
            lstcontact3.add(ca3);
            upsert lstcontact3;
            
        }
         Profile p4 = [SELECT Id,name FROM Profile WHERE Name = 'DTNA - STC Louisville'];
        User u4 = new User(Alias = 'newUser3', Email = 'newuser@testorg.com3',
                           EmailEncodingKey = 'UTF-8', LastName = 'Testing3', LanguageLocaleKey = 'en_US',
                           LocaleSidKey = 'en_US', ProfileId = p4.Id,
                           TimeZoneSidKey = 'America/Los_Angeles', UserName = 'newuser@testorg.com.dtna.test43');
        System.runAs(u4) {
            Contact ca4 = new Contact();
            ca4.FirstName = 'cFN1';
            ca4.LastName = 'cLN1';
            ca4.phone ='1234567891';
            ca4.Email = 'test@gmtestail.com';
            lstcontact4.add(ca4);
            upsert lstcontact4;
            
        }
        Profile p5 = [SELECT Id,name FROM Profile WHERE Name = 'DTNA - STC Kansas City'];
        User u5 = new User(Alias = 'newUser4', Email = 'newuser@testorg.com4',
                           EmailEncodingKey = 'UTF-8', LastName = 'Testing4', LanguageLocaleKey = 'en_US',
                           LocaleSidKey = 'en_US', ProfileId = p5.Id,
                           TimeZoneSidKey = 'America/Los_Angeles', UserName = 'newuser@testorg.com.dtna.test54');
        System.runAs(u5) {
            Contact ca5 = new Contact();
            ca5.FirstName = 'cFN1';
            ca5.LastName = 'cLN1';
            ca5.phone ='1234567891';
            ca5.Email = 'test@gmtestail.com';
            lstcontact5.add(ca5);
            upsert lstcontact5;
            
        }
        Profile p6 = [SELECT Id,name FROM Profile WHERE Name = 'DTNA - STC Charlotte'];
        User u6 = new User(Alias = 'newUser5', Email = 'newuser@testorg.com5',
                           EmailEncodingKey = 'UTF-8', LastName = 'Testing5', LanguageLocaleKey = 'en_US',
                           LocaleSidKey = 'en_US', ProfileId = p6.Id,
                           TimeZoneSidKey = 'America/Los_Angeles', UserName = 'newuser@testorg.com.dtna.test65');
        System.runAs(u6) {
            Contact ca6 = new Contact();
            ca6.FirstName = 'cFN1';
            ca6.LastName = 'cLN1';
            ca6.phone ='1234567891';
            ca6.Email = 'test@gmtestail.com';
            lstcontact6.add(ca6);
            upsert lstcontact6;
            
        }
        Profile p7 = [SELECT Id,name FROM Profile WHERE Name = 'DTNA - STC Cleveland'];
        User u7 = new User(Alias = 'newUser6', Email = 'newuser@testorg.com6',
                           EmailEncodingKey = 'UTF-8', LastName = 'Testing6', LanguageLocaleKey = 'en_US',
                           LocaleSidKey = 'en_US', ProfileId = p7.Id,
                           TimeZoneSidKey = 'America/Los_Angeles', UserName = 'newuser@testorg.com.dtna.test76');
        System.runAs(u7) {
            Contact ca7 = new Contact();
            ca7.FirstName = 'cFN1';
            ca7.LastName = 'cLN1';
            ca7.phone ='1234567891';
            ca7.Email = 'test@gmtestail.com';
            lstcontact7.add(ca7);
            upsert lstcontact7;
            
        }
    }
    
    @isTest static void test_delete_Contact_method() 
    {
        User u2=[SELECT Id,alias,Email from User where Alias = 'smsr' and Email = 'newsmruser@testorg.com' LIMIT 1];//PPAP Admin User
        System.runAs(u2) {
             Contact ObjContact1=[SELECT Id from Contact where email='smr1.cln1@smrtestail.com' and FirstName='smr1' LIMIT 1];
             try{
                 System.debug('Contact1:' + ObjContact1.Id);
                 delete ObjContact1;
             }
             catch(Exception e)
                {
                    System.debug('ERROR:' + e);
                    Boolean expectedExceptionThrown =  e.getMessage().contains('This contact cannot be deleted until the roles assigned to it') ? true : false;
                    System.AssertEquals(expectedExceptionThrown, true);
                    System.debug('Done!');
                }
        }
        User u1=[SELECT Id,alias,Email from User where Alias = 'smsr1' and Email = 'new1smruser@testorg.com' LIMIT 1];//Non PPAP Admin User
        Contact ObjContact=[SELECT Id,Email,FirstName from Contact  LIMIT 1];
        System.debug('Contact2:' + ObjContact.Id);
        System.runAs(u1) {
            try{
                delete ObjContact;
            }
            catch(Exception e)
            {
                System.debug('ERROR:' + e);
                Boolean expectedExceptionThrown =  e.getMessage().contains('Cannot delete Contact associated with QA Department role. Please contact DTNA PPAP Administrator.')? true : false;
                System.AssertEquals(expectedExceptionThrown, true);
            }
        }
   }

}