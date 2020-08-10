@isTest
public class ContentDocumentLinktriggerHelper_Test {
    @testSetup static void setup(){
        Insert new Contact(LastName = 'T3ST', Email = 'test@gmtestail.com');
        List<UserRole> roles = [SELECT ID FROM UserRole WHERE DeveloperName = 'CRM_Admin'];
		List<User> userList = [Select ID, Name FROM User WHERE IsActive = TRUE AND UserRoleId = :roles[0].Id];
        List<CollaborationGroupMember> cgmList = new List<CollaborationGroupMember>();
        List<CollaborationGroup> gpList = new List<CollaborationGroup>();
        CollaborationGroup gp = new CollaborationGroup(Name = 'Sys Group', CollaborationType= 'Private');
        CollaborationGroup gp2 = new CollaborationGroup(Name = 'No Group', CollaborationType= 'Private');
        gpList.add(gp);
        gpList.add(gp2);
        Insert(gpList);
        for(User u : userList){
            CollaborationGroupMember cgm = new CollaborationGroupMember();
            cgm.CollaborationGroupId = gp.id;
            cgm.CollaborationRole = 'Standard';
            cgm.MemberId = u.id;
            cgmList.add(cgm);
        }
        Database.insert(cgmList, false);
    }
    @isTest static void testPrivatizingFile(){
        List<Contact> c = [SELECT ID FROM Contact LIMIT 1];
        Blob b = Blob.valueOf('Unit Test Attachment Body');
        ContentVersion cv = new ContentVersion(
            Title = 'Test Content Trigger',     
            PathOnClient = 'Test',         
            VersionData = b
        );
        List<UserRole> roles = [SELECT ID FROM UserRole WHERE DeveloperName = 'CRM_Admin'];
		List<User> userList = [Select ID, Name FROM User WHERE IsActive = TRUE AND UserRoleId = :roles[0].Id];
        system.runas(userList[0]){
            List<CollaborationGroupMember> userGroupID = [SELECT CollaborationGroupID FROM CollaborationGroupMember WHERE MemberID =: UserInfo.getUserId()];
            Test.StartTest();
                Database.Insert(cv, false);
                ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];
                ContentDocumentLink contentlink = new ContentDocumentLink(
                	LinkedEntityId = c[0].id,
                	ShareType = 'I',
                	ContentDocumentId = testcontent.ContentDocumentId
                );
                insert contentlink;
    			
                Map<Id, ContentVersion> cvMap = new Map<Id, ContentVersion>([SELECT ID, Title, SharingPrivacy, SharingOption, ContentDocumentID from ContentVersion]);
                List<Id> cdList = new List<ID>();
                if(cvMap.size() > 0){
                    for(ContentVersion cvTest : cvMap.values()){
                        cdList.add(cvtest.ContentDocumentID);
                        Map<id, contentdocumentlink> cdlMap = new Map<Id, contentdocumentlink>([select contentdocumentID, linkedentityId from contentdocumentlink where contentdocumentID in :cdList]);
                    }
                }else{
                    system.assertEquals(2, cvMap.size());//Tests if any notes exist
                }
            
            Test.stopTest();
        }
    }
    @isTest static void testPublicFile(){
        Blob b = Blob.valueOf('Unit Test Attachment Body');
        ContentVersion cv = new ContentVersion(
            Title = 'Test Content Trigger',     
            PathOnClient = 'Test',         
            VersionData = b
        );
        List<UserRole> roles = [SELECT ID FROM UserRole WHERE DeveloperName = 'CRM_Admin'];
		List<User> userList = [Select ID, Name FROM User WHERE IsActive = TRUE AND UserRoleId = :roles[0].Id];
        system.runas(userList[0]){
            List<CollaborationGroupMember> userGroupID = [SELECT CollaborationGroupID FROM CollaborationGroupMember WHERE MemberID =: UserInfo.getUserId()];
            Test.StartTest();
                Database.Insert(cv, false);
                ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];
    			
                Map<Id, ContentVersion> cvMap = new Map<Id, ContentVersion>([SELECT ID, Title, SharingPrivacy, SharingOption, ContentDocumentID from ContentVersion WHERE SharingPrivacy != 'P']);
                List<Id> cdList = new List<ID>();
                if(cvMap.size() == 0){
                    system.assertEquals(1, cvMap.size());//Tests if any notes exist
                }
            
            Test.stopTest();
        }
    }
    
    @isTest static void updateContentDocumentLink() {
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
        update contentlink;
        delete contentlink;
    }
}