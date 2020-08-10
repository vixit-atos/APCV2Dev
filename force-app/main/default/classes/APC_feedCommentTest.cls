@isTest
private class APC_feedCommentTest {
    
    static testMethod void testTrigger() {
        Test.StartTest(); 
        Account ac = new Account(name ='CDCD Account', Dealer_Code__c = 'CDCD') ;
        insert ac; 
        Account ac1 = new Account(name ='YFFD Account', Dealer_Code__c = 'YFFD') ;
        insert ac1;
        
        Contact con = new Contact(LastName ='CDCD User1',AccountId = ac.Id);
        insert con;  
        
        Contact con1 = new Contact(LastName ='YFFD User1',AccountId = ac1.Id);
        insert con1;  
        
        case objcase = new case(status='new', accountid=ac.id, Body_Number__c='11221',Additional_Contacts__c='CDCD User1',Additional_Recipients__c='dhruviltest@gmail.com,dhruviltest@gmail.com');
        insert objcase;
        
        Event e = new Event();
        e.WhatId=objcase.id;
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
        user Portalusr = [select id from user where contact.Account.Dealer_code__c = 'CDCD' limit 1];
        
        System.runAs ( Portalusr ) { 
            recordtype rt = [select id from recordtype where sobjecttype = 'case' and name like'APC%' limit 1];
            Case case1 = new Case(status='Resolved',Body_Number__c='11221',recordtypeId = rt.id,Type_Of_Request__c = 'Credit Inquiry');          
            insert case1;
            FeedItem ff = new FeedItem();
            ff.ParentId = case1.id;
            ff.body = 'test';
            insert ff;
            FeedComment fc = new FeedComment();
            fc.CommentBody = 'legal test';
            // fc.RelatedRecordId =c.Id;
            fc.FeedItemId = ff.Id;  
            //  fc.ParentId =c.id;
            insert fc;
            Test.StopTest();       
        }        
    }     
}