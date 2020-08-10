@isTest
private class RoleTriggerHandler_Test 
{  
    @testSetup static void setup() {
        // Create common test data
        Profile p = [SELECT Id,name FROM Profile WHERE Name = 'DTNA - SMR Specialist'];
        UserRole r = [SELECT Id,name FROM UserRole WHERE Name = 'SMR Specialist'];
         UserRole r1 = [SELECT Id,name FROM UserRole WHERE Name = 'SMR Manager'];
       
        User u1 = new User(Alias = 'smsr', Email = 'newsmruser@testorg.com',Title='PPAP Admin',
                           EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                           LocaleSidKey = 'en_US', ProfileId = p.Id,UserRoleId=r.Id,
                           TimeZoneSidKey = 'America/Los_Angeles', UserName = 'newuser@testorg.com.dtna.test2');
         System.runAs(u1) {
               RecordType smrRecType=[select Id from RecordType where sObjectType='Role__c' AND DeveloperName='SMR_Department_Title' LIMIT 1];
              
                Account ObjAcct = new Account(Name='SMtest1234567890');
                insert ObjAcct;
                
                Contact ObjCont = new Contact(
                                 FirstName = 'cFN1',
                                LastName = 'cLN1',
                                phone ='1234567891',
                                Email = 'test@gmtestail.com');
                insert ObjCont;
             
                Role__C ObjRole = new Role__c(Department__c='MARKETING',Job_Title__C='CEO',Account__c=ObjAcct.Id,Contact__C=ObjCont.Id,RecordTypeId=smrRecType.Id,Notes__c='Test1');
                insert ObjRole;
               
                Role__C ObjRole1 = new Role__c(Department__c='QUALITY ASSURANCE VENDOR CONTA',Job_Title__C='CEO',Account__c=ObjAcct.Id,Contact__C=ObjCont.Id,RecordTypeId=smrRecType.Id,Notes__c='Test2');
                insert ObjRole1;
             }
      User u2 = new User(Alias = 'smsr1', Email = 'new1smruser@testorg.com',Title='Admin',
                           EmailEncodingKey = 'UTF-8', LastName = 'Testing1', LanguageLocaleKey = 'en_US',
                           LocaleSidKey = 'en_US', ProfileId = p.Id,UserRoleId=r1.Id,
                           TimeZoneSidKey = 'America/Los_Angeles', UserName = 'new1smruser@testorg.com.dtna.test2');
        insert u2;
    }
    @isTest static void test_method_one() 
    {
        Account ObjAcct = new Account(Name='test1234567890');
        insert ObjAcct;
        
        Contact ObjCont = new Contact(LastName='test1234567890',AccountId=ObjAcct.Id);
        insert ObjCont;
        
        Role__C ObjRole = new Role__c(ExternalID__c='test1234567890',Account__c=ObjAcct.Id,Contact__C=ObjCont.Id);
        insert ObjRole;
    }
    
    @isTest static void test_method_two() 
    {
        
        // Implement test code
        Account ObjAcct = new Account(Name='test1234567890');
        insert ObjAcct;
        
        Contact ObjCont = new Contact(LastName='test1234567890');
        insert ObjCont;
        
        Role__C ObjRole = new Role__c(ExternalID__c='test1234567890',Account__c=ObjAcct.Id,Contact__C=ObjCont.Id);
        insert ObjRole;
    }
    
     @isTest static void test_delete_method_one() 
    {
        User u1=[SELECT Id,alias,Email from User where Alias = 'smsr1' and Email = 'new1smruser@testorg.com' LIMIT 1];
        System.runAs(u1) {

             Role__C ObjRole1=[SELECT Id from Role__C where Notes__c='Test1' LIMIT 1];
             delete ObjRole1;
            
             Role__C ObjRole2=[SELECT Id from Role__C where Notes__c='Test2' LIMIT 1];
            try{
                delete ObjRole2;
            }
            catch(Exception e)
            {
                System.debug('ERROR:' + e);
            }
        }
		User u2=[SELECT Id,alias,Email from User where Alias = 'smsr' and Email = 'newsmruser@testorg.com' LIMIT 1];
        System.runAs(u2) {
             Role__C ObjRole3=[SELECT Id from Role__C where Notes__c='Test2' LIMIT 1];
             try{
                delete ObjRole3;
            }
            catch(Exception e)
            {
                System.debug('ERROR:' + e);
            }
            system.debug('Complete delete Role Test.');
        }
    }
}