@isTest
public class ContentDocumentTriggerHandler_Test {
    @isTest static void deleteContentDocumentLink() {
         Account a = new Account (Name = 'a1qqq');
        Opportunity opp = new Opportunity(Name = 'o1',DTR_Requested_to_Quote_Residual__c = true, VEH_MAKE__c = 'FTL',  StageName = 'Initial Notification', CloseDate = Date.Today());
        insert opp;
          
        Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');

        ContentVersion cv = new ContentVersion();
        cv.title = 'test content trigger';      
        cv.PathOnClient ='test';           
        cv.VersionData =beforeblob;          
        insert cv;         

        ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];

        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=opp.id;
        contentlink.ShareType= 'V';
        contentlink.ContentDocumentId=testcontent.ContentDocumentId;

        insert contentlink;
        contentlink.ShareType= 'V';
        
        ContentDocument testContentdoc = [SELECT id FROM ContentDocument where Id = :testcontent.ContentDocumentId];

        delete testContentdoc;
    }

}