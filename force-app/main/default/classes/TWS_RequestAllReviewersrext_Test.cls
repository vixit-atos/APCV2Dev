@isTest
//Modification to formatting so I can read it @Chris
public class TWS_RequestAllReviewersrext_Test{
        @testSetup static void testSetup(){
        User adminUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        System.runAs(adminUser){
            Contact mandatoryContact = new Contact();
            mandatoryContact.FirstName = 'Test';
            mandatoryContact.LastName = 'Test';
            String email = 'test@gmtestail.com';
            mandatoryContact.Email = email.replaceAll( '\\s+', '');
            mandatoryContact.Phone = '0000000000';
            insert mandatoryContact;
            
            List<Task_Group_Closure_Types_List__c> customSettings = new List<Task_Group_Closure_Types_List__c>();
            
            Task_Group_Closure_Types_List__c ispSettings = new Task_Group_Closure_Types_List__c();
            ispSettings.Name = 'Controlling Group Review - ISP';
            ispSettings.StageUpdate__c = 'Controlling Review';
            customSettings.add(ispSettings);
            
            Task_Group_Closure_Types_List__c ASPReviewSettings = new Task_Group_Closure_Types_List__c();
            ASPReviewSettings.Name = 'ASP Group Review - TWS';
            ASPReviewSettings.StageUpdate__c = 'Controlling Review';
            customSettings.add(ASPReviewSettings);
            
            Task_Group_Closure_Types_List__c ASPQuoteSettings = new Task_Group_Closure_Types_List__c();
            ASPQuoteSettings.Name = 'ASP Group Quote - TWS';
            ASPQuoteSettings.StageUpdate__c = 'Controlling Review';
            customSettings.add(ASPQuoteSettings);
            
            Task_Group_Closure_Types_List__c DTRSettings = new Task_Group_Closure_Types_List__c();
            DTRSettings.Name = 'DTR Group Review - TWS';
            DTRSettings.StageUpdate__c = 'Controlling Review';
            customSettings.add(DTRSettings);
            
            insert customSettings;
        }
    }
        @isTest static void test_method_one() {
            Profile p = [SELECT Id FROM Profile WHERE Name = 'TWS/TC - Read Only'];
            User u2 = new User(Alias = 'newUser', Email = 'newuser@testorg.com',
                           EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                           LocaleSidKey = 'en_US', ProfileId = p.Id,
                           TimeZoneSidKey = 'America/Los_Angeles', UserName = 'newuser@testorg.com.dtna.test12343554');
            System.runAs(u2) {
                Task_Closure_Email_Template__c tskEmailCustSetng = new Task_Closure_Email_Template__c(name='TWS_TC_Deal', Object_Type__c='Opportunity', Email_Template__c='TWS_TC_Task_CompletedVFTemplate');
                insert tskEmailCustSetng;
                Task_Group_Closure_Types_List__c tskgrpcls = new Task_Group_Closure_Types_List__c(name='Controlling Group Review - TWS', StageUpdate__c='Controlling Review');
                insert tskgrpcls;
                User NAEuser =[select id,name,email from  User where  SalesUserRole__c='NAE' Limit 1];

                Account a = new Account (Name = 'a1');
                insert a;
                
                Contact ca = new Contact(
                    FirstName = 'cFN1',
                    LastName = 'cLN1',
                    AccountId = a.Id,
                    Email = 'test@gmtestail.com'
                );
                insert ca;
        
                Id domesticRecordTypeId = TWSConstants.getOpportunityRecordTypeMap().get('TWS_TC_Deal');
                Opportunity o = new Opportunity(Name = 'o1',DTR_Requested_to_Quote_Residual__c = true, VEH_MAKE__c = 'FTL', Account = a,RecordTypeId = domesticRecordTypeId, StageName = 'Initial Notification', CloseDate = Date.Today(),Owner=NAEuser);
                insert o;
                system.debug('---Current Queries: ' + Limits.getQueries());

                Task  t = new Task(
                    ActivityDate = Date.today().addDays(7),
                    Subject = 'Sample Task',
                    WhatId = o.Id,
                    OwnerId = UserInfo.getUserId(),
                    Status = 'Pending Controlling review',
                    Type = 'ASP Group Review - TWS'
                );
                List<Task> lst=new List<Task>();
                lst.add(t);
                insert lst;
                system.debug('---Current Queries: ' + Limits.getQueries());

                TWSTaskRequestAllReviews__c objtaskcs1=new TWSTaskRequestAllReviews__c();
                objtaskcs1.Name='ControlingTask';
                objtaskcs1.Status__c='Pending ASP review';
                objtaskcs1.Priority__c='Normal';
                objtaskcs1.Type__c='ASP Group Review - TWS';
                objtaskcs1.Subject__c='ASP review';
                insert objtaskcs1;

                TWSTaskRequestAllReviews__c objtaskcs2=new TWSTaskRequestAllReviews__c();
                objtaskcs2.Name='AspTask';
                objtaskcs2.Status__c='Pending ASP review';
                objtaskcs2.Priority__c='Normal';
                objtaskcs2.Type__c='ASP Group Review - TWS';
                objtaskcs2.Subject__c='ASP review';
                insert objtaskcs2;
                
                TWSTaskRequestAllReviews__c objtaskcs3=new TWSTaskRequestAllReviews__c();
                objtaskcs3.Name='DTRTask';
                objtaskcs3.Status__c='Pending ASP review';
                objtaskcs3.Priority__c='Normal';
                objtaskcs3.Type__c='ASP Group Review - TWS';
                objtaskcs3.Subject__c='ASP review';
                insert objtaskcs3; 
                
                Attachment attach=new Attachment();     
                attach.Name='Unit Test Attachment';
                Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
                attach.body=bodyBlob;
                attach.parentId=t.id;
                insert attach;

                //system.debug('1111111'+attach);
                Attachment attach1=new Attachment();    
                attach1.Name='Unit Test Attachment';
                Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body');
                attach1.body=bodyBlob1;
                attach1.parentId=t.id;
                insert attach1;

                List <Attachment> attachments1 = [select id, name, body from Attachment  where parentid=:lst[0].id ];
                List <Attachment> attachments=new   List <Attachment>();
                attachments=attachments1;
                test.startTest();
                TWS_RequestAllReviewerscontrollerext ext =new TWS_RequestAllReviewerscontrollerext();
                ext.blnASP=true;
                ext.blnContolling=true;
                ext.blnDTR=true;
                ext.blndisplayASP=true;
                ext.blndisplayContolling=true;
                ext.blndisplayDTR=true;
                Try{
                    ext.SaveNewTask();
                }Catch(Exception e){
                  system.debug('exp'+e.getMessage());
                }
                ext.updateBooleanvaalues();
                ext.FileCount='2';
                ext.ChangeCount();
                ext.Cancel();
                test.StopTest();
            }//End runAs
        }
}