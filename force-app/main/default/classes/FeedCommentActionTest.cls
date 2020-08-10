/**
* @File Name          : FeedCommentActionTest.cls
* @Description        :
* @Author             : VIXIT BHARDWAJ - ATOS SYNTEL INC
* @Group              :
* @Last Modified By   : VIXIT BHARDWAJ - ATOS SYNTEL INC
* @Last Modified On   : 5/13/2020, 5:42:12 AM
* @Modification Log   :
* Ver       Date            Author                  Modification
* 1.0    5/12/2020   VIXIT BHARDWAJ - ATOS SYNTEL INC     Initial Version
**/
@isTest
public with sharing class FeedCommentActionTest{
    
    @testSetup
    static void setup(){
        // APC Specific Record Types only
        final Id ACCOUNT_DEALERSHIP_recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealership').getRecordTypeId();
        final Id CONTACT_DEALERSHIP_CONTACT_recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Dealership Contact').getRecordTypeId();
        final Id CASE_APC_CORE_recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('APC Core').getRecordTypeId();
        final Id CASE_APC_CREDIT_recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('APC Credit').getRecordTypeId();
        final Id CASE_APC_INVOICE_recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('APC Invoice').getRecordTypeId();
        final Id CASE_APC_ORDER_recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('APC Order').getRecordTypeId();
        final Id CASE_APC_RETURN_recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('APC Return').getRecordTypeId();
        final Id CASE_APC_TBB_recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('APC TBB').getRecordTypeId();
        // APC Specific Account Creation
        List<Account> accts = new List<Account>();
        Account acc1 = new Account(name = 'CDCD Account', Dealer_Code__c = 'CDCD', recordtypeid = ACCOUNT_DEALERSHIP_recordTypeId);
        accts.add(acc1);
        Account acc2 = new Account(name = 'KHMD Account', Dealer_Code__c = 'KHMD', recordtypeid = ACCOUNT_DEALERSHIP_recordTypeId);
        accts.add(acc2);
        Account acc3 = new Account(name = 'YFFD Account', Dealer_Code__c = 'YFFD', recordtypeid = ACCOUNT_DEALERSHIP_recordTypeId);
        accts.add(acc3);
        insert accts;
        // APC Specific Contact Creation
        List<Contact> conts = new List<Contact>();
        Contact con1 = new Contact(LastName = 'CDCDUsr1', AccountId = acc1.Id, recordtypeid = CONTACT_DEALERSHIP_CONTACT_recordTypeId);
        conts.add(con1);
        Contact con2 = new Contact(LastName = 'KHMDUsr1', AccountId = acc2.Id, recordtypeid = CONTACT_DEALERSHIP_CONTACT_recordTypeId);
        conts.add(con2);
        Contact con3 = new Contact(LastName = 'YFFDUsr1', AccountId = acc3.Id, recordtypeid = CONTACT_DEALERSHIP_CONTACT_recordTypeId);
        conts.add(con3);
        insert conts;
        // APC Specific Case Creaion
        List<Case> cases = new List<Case>();
        case cas1=new case(accountid = acc1.id, priority = 'Medium', origin = 'Web', status = 'New', Body_Number__c = '22222', Request_Type__c = 'Reactivation', Part_No__c = '11111111', recordtypeid = CASE_APC_ORDER_recordTypeId, Reason__c = 'Customer Quote');
        cases.add(cas1);
        case cas2=new case(accountid = acc1.id, priority = 'Medium', origin = 'Web', status = 'In Progress', Body_Number__c = '44444', Request_Type__c = 'Reactivation', Part_No__c = '33333333', recordtypeid = CASE_APC_ORDER_recordTypeId, Reason__c = 'Customer Quote');
        cases.add(cas2);
        case cas3=new case(accountid = acc1.id, priority = 'Medium', origin = 'Web', status = 'Assigned', Body_Number__c = '66666', Request_Type__c = 'Reactivation', Part_No__c = '55555555', recordtypeid = CASE_APC_ORDER_recordTypeId, Reason__c = 'Customer Quote');
        cases.add(cas3);
        case cas4=new case(accountid = acc1.id, priority = 'Medium', origin = 'Web', status = 'Resolved', Body_Number__c = '88888', Request_Type__c = 'Reactivation', Part_No__c = '77777777', recordtypeid = CASE_APC_ORDER_recordTypeId, Reason__c = 'Customer Quote');
        case cas5=new case(accountid = acc1.id, priority = 'Medium', origin = 'Web', status = 'Resolved', Body_Number__c = '88888', Request_Type__c = 'Reactivation', Part_No__c = '22222222', recordtypeid = CASE_APC_ORDER_recordTypeId, Reason__c = 'Customer Quote');
        case cas6=new case(accountid = acc1.id, priority = 'Medium', origin = 'Web', status = 'Resolved', Body_Number__c = '88888', Request_Type__c = 'Reactivation', Part_No__c = '44444444', recordtypeid = CASE_APC_ORDER_recordTypeId, Reason__c = 'Customer Quote');
        case cas7=new case(accountid = acc1.id, priority = 'Medium', origin = 'Web', status = 'Resolved', Body_Number__c = '88888', Request_Type__c = 'Reactivation', Part_No__c = '66666666', recordtypeid = CASE_APC_ORDER_recordTypeId, Reason__c = 'Customer Quote');
        case cas8=new case(accountid = acc1.id, priority = 'Medium', origin = 'Web', status = 'Resolved', Body_Number__c = '88888', Request_Type__c = 'Reactivation', Part_No__c = '88888888', recordtypeid = CASE_APC_ORDER_recordTypeId, Reason__c = 'Customer Quote');
        case cas9=new case(accountid = acc1.id, priority = 'Medium', origin = 'Web', status = 'Resolved', Body_Number__c = '88888', Request_Type__c = 'Reactivation', Part_No__c = '00000000', recordtypeid = CASE_APC_ORDER_recordTypeId, Reason__c = 'Customer Quote');
        cases.add(cas4);
        cases.add(cas5);
        cases.add(cas6);
        cases.add(cas7);
        cases.add(cas8);
        cases.add(cas9);
        
        insert cases;
        // Create APC Specific Dealer User
        Id pidD = [SELECT 
                   id
                   FROM profile
                   WHERE name = 'DEALER-PARTNER-COMMUNITY'].id;
        User dlruser1 = new User(alias = con1.LastName, email = con1.LastName + '.dealer@apcorg.com', emailencodingkey = 'UTF-8', lastname = con1.LastName, languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = pidD, country = 'United States', IsActive = true, ContactId = con1.Id, timezonesidkey = 'America/Los_Angeles', username = con1.LastName + DateTime.now().getTime() + '.dealer@apcorg.com', visibilities__c = 'cn=YKFD,ou=dealers,ou=organizations,o=freightliner,o=dcx.com^cn=YFFD,ou=dealers,ou=organizations,o=freightliner,o=dcx.com^cn=YBFD');
        insert dlruser1;
        User dlruser2 = new User(alias = con2.LastName, email = con2.LastName + '.dealer@apcorg.com', emailencodingkey = 'UTF-8', lastname = con2.LastName, languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = pidD, country = 'United States', IsActive = true, ContactId = con2.Id, timezonesidkey = 'America/Los_Angeles', username = con2.LastName + DateTime.now().getTime() + '.dealer@apcorg.com', visibilities__c = 'cn=YKFD,ou=dealers,ou=organizations,o=freightliner,o=dcx.com^cn=YFFD,ou=dealers,ou=organizations,o=freightliner,o=dcx.com^cn=YBFD');
        insert dlruser2;
        User dlruser3 = new User(alias = con3.LastName, email = con3.LastName + '.dealer@apcorg.com', emailencodingkey = 'UTF-8', lastname = con3.LastName, languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = pidD, country = 'United States', IsActive = true, ContactId = con3.Id, timezonesidkey = 'America/Los_Angeles', username = con3.LastName + DateTime.now().getTime() + '.dealer@apcorg.com', visibilities__c = 'cn=YKFD,ou=dealers,ou=organizations,o=freightliner,o=dcx.com^cn=YFFD,ou=dealers,ou=organizations,o=freightliner,o=dcx.com^cn=YBFD');
        insert dlruser3;
        // Create APC Specific Agent User
        Id pidA = [SELECT 
                   id
                   FROM profile
                   WHERE name = 'System Administrator'].id;
        User aguser1 = new User(alias = con1.LastName, email = con1.LastName + '.agent@apcorg.com', emailencodingkey = 'UTF-8', lastname = con1.LastName, languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = pidA, country = 'United States', IsActive = true, timezonesidkey = 'America/Los_Angeles', username = con1.LastName + DateTime.now().getTime() + '.agent@apcorg.com', visibilities__c = 'cn=YKFD,ou=dealers,ou=organizations,o=freightliner,o=dcx.com^cn=YFFD,ou=dealers,ou=organizations,o=freightliner,o=dcx.com^cn=YBFD');
        insert aguser1;
        User aguser2 = new User(alias = con2.LastName, email = con2.LastName + '.agent@apcorg.com', emailencodingkey = 'UTF-8', lastname = con2.LastName, languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = pidA, country = 'United States', IsActive = true, timezonesidkey = 'America/Los_Angeles', username = con2.LastName + DateTime.now().getTime() + '.agent@apcorg.com', visibilities__c = 'cn=YKFD,ou=dealers,ou=organizations,o=freightliner,o=dcx.com^cn=YFFD,ou=dealers,ou=organizations,o=freightliner,o=dcx.com^cn=YBFD');
        insert aguser2;
        User aguser3 = new User(alias = con3.LastName, email = con3.LastName + '.agent@apcorg.com', emailencodingkey = 'UTF-8', lastname = con3.LastName, languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = pidA, country = 'United States', IsActive = true, timezonesidkey = 'America/Los_Angeles', username = con3.LastName + DateTime.now().getTime() + '.agent@apcorg.com', visibilities__c = 'cn=YKFD,ou=dealers,ou=organizations,o=freightliner,o=dcx.com^cn=YFFD,ou=dealers,ou=organizations,o=freightliner,o=dcx.com^cn=YBFD');
        insert aguser3;
    }
    
    
    static testMethod void validateSuccessUpdateStatus1(){
        User dlrUserTest1 = [SELECT 
                             Id
                             FROM User
                             WHERE Contact.Account.Dealer_Code__c = 'CDCD' and UserType = 'PowerPartner'
                             limit 1];
        
        
        Case testCase1 = [SELECT 
                          Id, 
                          Body_Number__c, 
                          Part_No__c
                          FROM Case
                          WHERE Body_Number__c = '22222' and Part_No__c = '11111111'
                          LIMIT 1];
        Test.startTest();
        System.runAs(dlrUserTest1){
            FeedItem fedItm = new FeedItem();
            fedItm.ParentId = testCase1.id;
            fedItm.body = 'Feed Item Body';
            fedItm.Visibility = 'AllUsers';
            insert fedItm;
            FeedComment fedCmt = new FeedComment();
            fedCmt.CommentBody = 'Feed Comment Here';
            fedCmt.FeedItemId = fedItm.Id;
            insert fedCmt;
        }
        Case updatedCase = [SELECT 
                            Id, 
                            Body_Number__c, 
                            Part_No__c, 
                            status
                            FROM Case
                            WHERE Body_Number__c = '22222' and Part_No__c = '11111111'
                            LIMIT 1];
        System.assertEquals('Dealer Response', updatedCase.status);
        
        System.assertNotEquals(null, dlrUserTest1);
        System.assertNotEquals(null, testCase1);
        
        Test.stopTest();
    }
    
    static testMethod void validateSuccessUpdateStatus2(){
        
        User dlrUserTest2 = [SELECT 
                             Id
                             FROM User
                             WHERE Contact.Account.Dealer_Code__c = 'CDCD' and UserType = 'PowerPartner'
                             limit 1];
        
        
        Case testCase2 = [SELECT 
                          Id, 
                          Body_Number__c, 
                          Part_No__c
                          FROM Case
                          WHERE Body_Number__c = '44444' and Part_No__c = '33333333'
                          LIMIT 1];
        System.assertNotEquals(null, dlrUserTest2);
        System.assertNotEquals(null, testCase2);
        Test.startTest();
        System.runAs(dlrUserTest2){
            FeedItem fedItm = new FeedItem();
            fedItm.ParentId = testCase2.id;
            fedItm.body = 'Feed Item Body';
            fedItm.Visibility = 'AllUsers';
            insert fedItm;
            FeedComment fedCmt = new FeedComment();
            fedCmt.CommentBody = 'Feed Comment Here';
            fedCmt.FeedItemId = fedItm.Id;
            insert fedCmt;
        }
        Case updatedCase = [SELECT 
                            Id, 
                            Body_Number__c, 
                            Part_No__c, 
                            status
                            FROM Case
                            WHERE Body_Number__c = '44444' and Part_No__c = '33333333'
                            LIMIT 1];
        System.assertEquals('Dealer Response', updatedCase.status);
        Test.stopTest();
    }
    
    static testMethod void validateSuccessUpdateStatus3(){
        User dlrUserTest3 = [SELECT 
                             Id
                             FROM User
                             WHERE Contact.Account.Dealer_Code__c = 'CDCD' and UserType = 'PowerPartner'
                             limit 1];
        
        
        Case testCase3 = [SELECT 
                          Id, 
                          Body_Number__c, 
                          Part_No__c
                          FROM Case
                          WHERE Body_Number__c = '66666' and Part_No__c = '55555555'
                          LIMIT 1];
        System.assertNotEquals(null, dlrUserTest3);
        System.assertNotEquals(null, testCase3);
        Test.startTest();
        System.runAs(dlrUserTest3){
            FeedItem fedItm = new FeedItem();
            fedItm.ParentId = testCase3.id;
            fedItm.body = 'Feed Item Body';
            fedItm.Visibility = 'AllUsers';
            insert fedItm;
            FeedComment fedCmt = new FeedComment();
            fedCmt.CommentBody = 'Feed Comment Here';
            fedCmt.FeedItemId = fedItm.Id;
            insert fedCmt;
        }
        Case updatedCase = [SELECT 
                            Id, 
                            Body_Number__c, 
                            Part_No__c, 
                            status
                            FROM Case
                            WHERE Body_Number__c = '66666' and Part_No__c = '55555555'
                            LIMIT 1];
        System.assertEquals('Dealer Response', updatedCase.status);
        Test.stopTest();
    }
    
    static testMethod void validateSuccessUpdateStatus4(){
        User dlrUserTest4 = [SELECT 
                             Id
                             FROM User
                             WHERE Contact.Account.Dealer_Code__c = 'CDCD' and UserType = 'PowerPartner'
                             limit 1];
        
        Case testCase4 = [SELECT 
                          Id, 
                          Body_Number__c, 
                          Part_No__c
                          FROM Case
                          WHERE Body_Number__c = '88888' and Part_No__c = '77777777'
                          LIMIT 1];
        System.assertNotEquals(null, dlrUserTest4);
        System.assertNotEquals(null, testCase4);
        
        Test.startTest();
        System.runAs(dlrUserTest4){
            FeedItem fedItm = new FeedItem();
            fedItm.ParentId = testCase4.id;
            fedItm.body = 'Feed Item Body';
            fedItm.Visibility = 'AllUsers';
            insert fedItm;
            FeedComment fedCmt = new FeedComment();
            fedCmt.CommentBody = 'Feed Comment Here';
            fedCmt.FeedItemId = fedItm.Id;
            insert fedCmt;
        }
        Case updatedCase = [SELECT 
                            Id, 
                            Body_Number__c, 
                            Part_No__c, 
                            status
                            FROM Case
                            WHERE Body_Number__c = '88888' and Part_No__c = '77777777'
                            LIMIT 1];
        System.assertEquals('Reopened', updatedCase.status);
        Test.stopTest();
    }
    
    static testMethod void validateFailureUpdateStatus1(){
        User agtUserTest1 = [SELECT 
                             Id
                             FROM User
                             WHERE email = 'KHMDUsr1.agent@apcorg.com' and UserType = 'Standard'
                             limit 1];
        Case testCase1 = [SELECT 
                          Id, 
                          Body_Number__c, 
                          Part_No__c
                          FROM Case
                          WHERE Body_Number__c = '22222' and Part_No__c = '11111111'
                          LIMIT 1];
        Test.startTest();
        System.runAs(agtUserTest1){
            FeedItem fedItm = new FeedItem();
            fedItm.ParentId = testCase1.id;
            fedItm.body = 'Feed Item Body';
            fedItm.Visibility = 'AllUsers';
            insert fedItm;
            FeedComment fedCmt = new FeedComment();
            fedCmt.CommentBody = 'Feed Comment Here';
            fedCmt.FeedItemId = fedItm.Id;
            insert fedCmt;
        }
        Case updatedCase = [SELECT 
                            Id, 
                            Body_Number__c, 
                            Part_No__c, 
                            status
                            FROM Case
                            WHERE Body_Number__c = '22222' and Part_No__c = '11111111'
                            LIMIT 1];
        System.assertEquals('New', updatedCase.status);
        
        System.assertNotEquals(null, agtUserTest1);
        System.assertNotEquals(null, testCase1);
        
        Test.stopTest();
    }
    
    static testMethod void validateFailureUpdateStatus2(){
        User agtUserTest2 = [SELECT 
                             Id
                             FROM User
                             WHERE email = 'KHMDUsr1.agent@apcorg.com' and UserType = 'Standard'
                             limit 1];
        Case testCase2 = [SELECT 
                          Id, 
                          Body_Number__c, 
                          Part_No__c
                          FROM Case
                          WHERE Body_Number__c = '44444' and Part_No__c = '33333333'
                          LIMIT 1];
        System.assertNotEquals(null, agtUserTest2);
        System.assertNotEquals(null, testCase2);
        Test.startTest();
        System.runAs(agtUserTest2){
            FeedItem fedItm = new FeedItem();
            fedItm.ParentId = testCase2.id;
            fedItm.body = 'Feed Item Body';
            fedItm.Visibility = 'AllUsers';
            insert fedItm;
            FeedComment fedCmt = new FeedComment();
            fedCmt.CommentBody = 'Feed Comment Here';
            fedCmt.FeedItemId = fedItm.Id;
            insert fedCmt;
        }
        Case updatedCase = [SELECT 
                            Id, 
                            Body_Number__c, 
                            Part_No__c, 
                            status
                            FROM Case
                            WHERE Body_Number__c = '44444' and Part_No__c = '33333333'
                            LIMIT 1];
        System.assertEquals('In Progress', updatedCase.status);
        Test.stopTest();
    }
    
    static testMethod void validateFailureUpdateStatus3(){
        User agtUserTest3 = [SELECT 
                             Id
                             FROM User
                             WHERE email = 'KHMDUsr1.agent@apcorg.com' and UserType = 'Standard'
                             limit 1];
        Case testCase3 = [SELECT 
                          Id, 
                          Body_Number__c, 
                          Part_No__c
                          FROM Case
                          WHERE Body_Number__c = '66666' and Part_No__c = '55555555'
                          LIMIT 1];
        System.assertNotEquals(null, agtUserTest3);
        System.assertNotEquals(null, testCase3);
        Test.startTest();
        System.runAs(agtUserTest3){
            FeedItem fedItm = new FeedItem();
            fedItm.ParentId = testCase3.id;
            fedItm.body = 'Feed Item Body';
            fedItm.Visibility = 'AllUsers';
            insert fedItm;
            FeedComment fedCmt = new FeedComment();
            fedCmt.CommentBody = 'Feed Comment Here';
            fedCmt.FeedItemId = fedItm.Id;
            insert fedCmt;
        }
        Case updatedCase = [SELECT 
                            Id, 
                            Body_Number__c, 
                            Part_No__c, 
                            status
                            FROM Case
                            WHERE Body_Number__c = '66666' and Part_No__c = '55555555'
                            LIMIT 1];
        System.assertEquals('Assigned', updatedCase.status);
        Test.stopTest();
    }
    
    static testMethod void validateFailureUpdateStatus4(){
        User agtUserTest4 = [SELECT 
                             Id
                             FROM User
                             WHERE email = 'KHMDUsr1.agent@apcorg.com' and UserType = 'Standard'
                             limit 1];
        Case testCase4 = [SELECT 
                          Id, 
                          Body_Number__c, 
                          Part_No__c
                          FROM Case
                          WHERE Body_Number__c = '88888' and Part_No__c = '77777777'
                          LIMIT 1];
        System.assertNotEquals(null, agtUserTest4);
        System.assertNotEquals(null, testCase4);
        
        Test.startTest();
        System.runAs(agtUserTest4){
            FeedItem fedItm = new FeedItem();
            fedItm.ParentId = testCase4.id;
            fedItm.body = 'Feed Item Body';
            fedItm.Visibility = 'AllUsers';
            insert fedItm;
            FeedComment fedCmt = new FeedComment();
            fedCmt.CommentBody = 'Feed Comment Here';
            fedCmt.FeedItemId = fedItm.Id;
            insert fedCmt;
        }
        Case updatedCase = [SELECT 
                            Id, 
                            Body_Number__c, 
                            Part_No__c, 
                            status
                            FROM Case
                            WHERE Body_Number__c = '88888' and Part_No__c = '77777777'
                            LIMIT 1];
        System.assertEquals('Resolved', updatedCase.status);
        Test.stopTest();
    }
    
    static testMethod void validatebulkcomments(){
        Case testCase1 = [SELECT Id, Body_Number__c, Part_No__c FROM Case WHERE Body_Number__c = '22222' and Part_No__c = '11111111' LIMIT 1];
        
        Case testCase2 = [SELECT Id, Body_Number__c, Part_No__c FROM Case WHERE Part_No__c = '33333333' LIMIT 1];
        Case testCase3 = [SELECT Id, Body_Number__c, Part_No__c FROM Case WHERE Part_No__c = '55555555' LIMIT 1];        
        Case testCase4 = [SELECT Id, Body_Number__c, Part_No__c FROM Case WHERE Part_No__c = '77777777' LIMIT 1];
        Case testCase5 = [SELECT Id, Body_Number__c, Part_No__c FROM Case WHERE Part_No__c = '22222222' LIMIT 1];
        Case testCase6 = [SELECT Id, Body_Number__c, Part_No__c FROM Case WHERE Part_No__c = '44444444' LIMIT 1];
        Case testCase7 = [SELECT Id, Body_Number__c, Part_No__c FROM Case WHERE Part_No__c = '66666666' LIMIT 1];
        Case testCase8 = [SELECT Id, Body_Number__c, Part_No__c FROM Case WHERE Part_No__c = '88888888' LIMIT 1];
        Case testCase9 = [SELECT Id, Body_Number__c, Part_No__c FROM Case WHERE Part_No__c = '00000000' LIMIT 1];
        
        FeedItem fedItm = new FeedItem();
        fedItm.ParentId = testCase1.id;
        fedItm.body = 'Feed Item Body';
        fedItm.Visibility = 'AllUsers';
        insert fedItm;
        list<FeedComment> listfeedcomment = new list<FeedComment>();
        for(integer i=0; i<100;i++){
            FeedComment fedCmt = new FeedComment();
            fedCmt.CommentBody = 'Feed Comment Here '+ i;
            fedCmt.FeedItemId = fedItm.Id;
            listfeedcomment.add(fedCmt);
        } // 100 Comments on one case
        
        // chatter on 2nd case 
        FeedItem fedItm2 = new FeedItem();
        fedItm2.ParentId = testCase2.id;
        fedItm2.body = 'Feed Item Body';
        fedItm2.Visibility = 'AllUsers';
        insert fedItm2;
        // Comment on  2nd case
        FeedComment fedCmt2 = new FeedComment();
        fedCmt2.CommentBody = 'Feed Comment Here 2';
        fedCmt2.FeedItemId = fedItm2.Id;
        listfeedcomment.add(fedCmt2);
        
        // chatter on 3rd case 
        FeedItem fedItm3 = new FeedItem();
        fedItm3.ParentId = testCase3.id;
        fedItm3.body = 'Feed Item Body';
        fedItm3.Visibility = 'AllUsers';
        insert fedItm3;
        // Comment on  3rd case
        FeedComment fedCmt3 = new FeedComment();
        fedCmt3.CommentBody = 'Feed Comment Here 3';
        fedCmt3.FeedItemId = fedItm3.Id;
        listfeedcomment.add(fedCmt3);
        
        // chatter on 4th case 
        FeedItem fedItm4 = new FeedItem();
        fedItm4.ParentId = testCase4.id;
        fedItm4.body = 'Feed Item Body';
        fedItm4.Visibility = 'AllUsers';
        insert fedItm4;
        // Comment on  4th case
        FeedComment fedCmt4 = new FeedComment();
        fedCmt4.CommentBody = 'Feed Comment Here 4';
        fedCmt4.FeedItemId = fedItm4.Id;
        
        //comment added to one list
        listfeedcomment.add(fedCmt4);
        
        // chatter on 5th case 
        FeedItem fedItm5 = new FeedItem();
        fedItm5.ParentId = testCase5.id;
        fedItm5.body = 'Feed Item Body';
        fedItm5.Visibility = 'AllUsers';
        insert fedItm5;
        // Comment on  4th case
        FeedComment fedCmt5 = new FeedComment();
        fedCmt5.CommentBody = 'Feed Comment Here 5';
        fedCmt5.FeedItemId = fedItm5.Id;
        
        //comment added to one list
        listfeedcomment.add(fedCmt5);
        
        // chatter on 6th case 
        FeedItem fedItm6 = new FeedItem();
        fedItm6.ParentId = testCase6.id;
        fedItm6.body = 'Feed Item Body';
        fedItm6.Visibility = 'AllUsers';
        insert fedItm6;
        // Comment on  6th case
        FeedComment fedCmt6 = new FeedComment();
        fedCmt6.CommentBody = 'Feed Comment Here 6';
        fedCmt6.FeedItemId = fedItm6.Id;
        
        //comment added to one list
        listfeedcomment.add(fedCmt6);
        
        // chatter on 7th case 
        FeedItem fedItm7 = new FeedItem();
        fedItm7.ParentId = testCase7.id;
        fedItm7.body = 'Feed Item Body';
        fedItm7.Visibility = 'AllUsers';
        insert fedItm7;
        // Comment on  7th case
        FeedComment fedCmt7 = new FeedComment();
        fedCmt7.CommentBody = 'Feed Comment Here 7';
        fedCmt7.FeedItemId = fedItm7.Id;
        
        //comment added to one list
        listfeedcomment.add(fedCmt7);
        
        // chatter on 8th case 
        FeedItem fedItm8 = new FeedItem();
        fedItm8.ParentId = testCase8.id;
        fedItm8.body = 'Feed Item Body';
        fedItm8.Visibility = 'AllUsers';
        insert fedItm8;
        // Comment on  8th case
        FeedComment fedCmt8 = new FeedComment();
        fedCmt8.CommentBody = 'Feed Comment Here 8';
        fedCmt8.FeedItemId = fedItm8.Id;
        
        //comment added to one list
        listfeedcomment.add(fedCmt8);
        
        // chatter on 9th case 
        FeedItem fedItm9 = new FeedItem();
        fedItm9.ParentId = testCase9.id;
        fedItm9.body = 'Feed Item Body';
        fedItm9.Visibility = 'AllUsers';
        insert fedItm9;
        // Comment on  9th case
        FeedComment fedCmt9 = new FeedComment();
        fedCmt9.CommentBody = 'Feed Comment Here 9';
        fedCmt9.FeedItemId = fedItm9.Id;
        
        //comment added to one list
        listfeedcomment.add(fedCmt9);
        
        Test.startTest();
        insert listfeedcomment;
        
        list<FeedComment> afterinsertfeedcomment = new list<FeedComment>();
        
        //case assertcase1 = [select id from case where id=: testCase1.id];
        
        list<FeedComment> assertcomment2 = [select id,CommentBody from FeedComment  where FeedItemId in (select id from feeditem where ParentId =: testCase2.id) ];
        system.assertEquals(1, assertcomment2.size()); // one comment on testcase 2        
        system.assertEquals('Feed Comment Here 2', assertcomment2[0].CommentBody);        
        list<FeedComment> assertcomment3 = [select id,CommentBody from FeedComment  where FeedItemId in (select id from feeditem where ParentId =: testCase3.id)];
        system.assertEquals(1, assertcomment3.size()); // one comment on testcase 3  
        system.assertEquals('Feed Comment Here 3', assertcomment3[0].CommentBody);
        list<FeedComment> assertcomment4 = [select id,CommentBody from FeedComment  where FeedItemId in (select id from feeditem where ParentId =: testCase4.id) ];
        system.assertEquals(1, assertcomment4.size()); // one comment on testcase 4  
        system.assertEquals('Feed Comment Here 4', assertcomment4[0].CommentBody);
        list<FeedComment> assertcomment5 = [select id,CommentBody from FeedComment  where FeedItemId in (select id from feeditem where ParentId =: testCase5.id) ];
        system.assertEquals(1, assertcomment5.size()); // one comment on testcase 5    
        system.assertEquals('Feed Comment Here 5', assertcomment5[0].CommentBody);
        list<FeedComment> assertcomment6 = [select id,CommentBody from FeedComment  where FeedItemId in (select id from feeditem where ParentId =: testCase6.id)];
        system.assertEquals(1, assertcomment6.size()); // one comment on testcase 6
        system.assertEquals('Feed Comment Here 6', assertcomment6[0].CommentBody);
        list<FeedComment> assertcomment7 = [select id,CommentBody from FeedComment  where FeedItemId in (select id from feeditem where ParentId =: testCase7.id) ];
        system.assertEquals(1, assertcomment7.size()); // one comment on testcase 7
        system.assertEquals('Feed Comment Here 7', assertcomment7[0].CommentBody);
        list<FeedComment> assertcomment8 = [select id,CommentBody from FeedComment  where FeedItemId in (select id from feeditem where ParentId =: testCase8.id)];
        system.assertEquals(1, assertcomment8.size()); // one comment on testcase 8
        system.assertEquals('Feed Comment Here 8', assertcomment8[0].CommentBody);
        list<FeedComment> assertcomment9 = [select id,CommentBody from FeedComment  where FeedItemId in (select id from feeditem where ParentId =: testCase9.id)];
        system.assertEquals(1, assertcomment9.size()); // one comment on testcase 9
        system.assertEquals('Feed Comment Here 9', assertcomment9[0].CommentBody);
        
        afterinsertfeedcomment = [select id from FeedComment  where FeedItemId =:fedItm.Id];
        system.debug('afterinsertfeedcomment.size(): ' + afterinsertfeedcomment.size());
        System.assertEquals(100, afterinsertfeedcomment.size()); // Expect 100 Comments on test case 1
        
        
        Test.stopTest();
    }
    
}