@isTest(SeeAllData=false)
public class schedulBatchApprovalMailTest {
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    
    static testMethod void scheduleApproveMethod(){               
        String jobId = System.schedule('ScheduleApexClassTest', CRON_EXP, new schedulBatchApprovalMail());
        String approverEmailId = System.Label.BatchApproverEmailId; 
         List<User> userList = new List<User>();
         userList = [SELECT Id FROM USER WHERE Email =: approverEmailId];
         if(userList.isEmpty())
         {
            Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
            User userObj = new User(Alias = 'standt', Email=approverEmailId, 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg1.com');
            insert userObj;
            userList.add(userObj);
         
         }
         List<RecordType> recordTypeList = [SELECT Id FROM RecordType WHERE SobjectType = 'Opportunity' AND DeveloperName = 'International_Sales_Proposal' LIMIT 1];
         Opportunity opp=New opportunity();
         opp.Name = 'Test678';
         opp.StageName = 'Ready for Submission';
         opp.CloseDate = system.today();
         opp.Approver_1__c = userList[0].Id;
         opp.Approver_2__c = userList[0].Id;
         opp.Approver_3__c = userList[0].Id;
         opp.Approver_4__c = userList[0].Id;
         opp.Approver_5__c = userList[0].Id;
         opp.Approver_6__c = userList[0].Id;
        if(!recordTypeList.isEmpty())
        opp.RecordTypeId=recordTypeList[0].Id;
       
       // opp.RecordTypeId='012d0000001UOqY';
         insert opp;
         
       Test.startTest();  
         
       System.runAs(userList[0]) {
             
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Submitting request for approval.');
            req.setNextApproverIds(new Id[] {userList[0].id});
            req.setObjectId(opp.Id);
            req.setProcessDefinitionNameOrId('TWS_ISP_Approval');
            Approval.ProcessResult resu = Approval.process(req,false);   
            //EmailTemplate e = new EmailTemplate (developerName = 'test', FolderId = '00ld0000002BC0W', TemplateType= 'Text', Name = 'Multiple Sales Proposal Submission');
            //insert e;
            schedulBatchApprovalMail sc = new schedulBatchApprovalMail();
            sc.sendmail();
            
              
          }
            
            
        Test.stopTest();
            
        
        
        
    }

}