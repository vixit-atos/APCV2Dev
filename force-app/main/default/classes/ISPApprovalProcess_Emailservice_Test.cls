/**
 * @Description: Test class for  ProcessContactApplicantEmail
 */
@isTest
private class ISPApprovalProcess_Emailservice_Test {

    static testMethod void handleInboundEmailTest() {
      
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
      insert opp;
      
      Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
      req.setComments('Submitting request for approval.');
      req.setNextApproverIds(new Id[] {userList[0].id});
      req.setObjectId(opp.Id);
      req.setProcessDefinitionNameOrId('TWS_ISP_Approval');
      Approval.ProcessResult resu = Approval.process(req,false);
      List<ProcessInstanceWorkitem> workitemList = [SELECT Id FROM ProcessInstanceWorkitem WHERE ProcessInstance.Status = 'Pending' AND ActorId =:userList[0].id];
      system.debug('workitemList   : '+workitemList);
      // create a new email and envelope object
      Messaging.InboundEmail email = new Messaging.InboundEmail() ;
      Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
     system.debug('approverEmailId :   '+approverEmailId);
      // setup the data for the email
      email.subject = 'Test Contact Applicant';
      email.fromname = 'FirstName LastName';
      email.plainTextBody = 'yes';
      email.fromAddress = approverEmailId;
      env.fromAddress = approverEmailId;
      Test.startTest();
      // call the email service class and test it with the data in the testMethod
      ISPApprovalProcess_Emailservice emailProcess = new ISPApprovalProcess_Emailservice();
      emailProcess.handleInboundEmail(email, env);
      //Opportunity oppResult = [SELECT Id, StageName FROM Opportunity WHERE Id=:opp.Id];
      //system.assertEquals('ISP Approved',oppResult.StageName);
      Test.stopTest();

    }
}