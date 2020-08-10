@isTest

public  Class TCMeetingController_Test{
    static testMethod void TCMeeting_method_one() {
        
        Test.startTest(); //switch to testing context
        PageReference pageRef = Page.TWC_ThisWeekTCMeeting;
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User umgr = new User(Alias = 'mstandt', Email='manafer@testorg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='manafer@testorg.com');
        insert umgr ;
        system.debug('user manager'+umgr );
        
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduseffr@testorg.com', managerid=umgr.id );
        insert u;
        system.debug('user iiiiiiiiii'+u);
        
        
        TCMeeting__c tcMeeting = new TCMeeting__c();
        tcMeeting.Name='Test TC Meeting';
        tcMeeting.TC_Meeting_Status__c='Agenda Finalized';
        tcMeeting.TC_Meeting_Date__c=system.today();
        insert  tcMeeting;         
        // List<TCMeeting__c> lstTcmeetings = new List<TCMeeting__c>();
        //   lstTcmeetings.add(tcMeeting);
        // insert lsttcmeetings;
        System.runAs(u) {
            
            
            Opportunity obj_Opportunity = new Opportunity ();
            RecordType Rd = [select id,name from recordtype where sobjecttype='Opportunity' AND name = 'TWS-Direct TC'];
            obj_Opportunity.Name='testoopname';
            obj_Opportunity .StageName = 'Ready for TCM';
            obj_Opportunity.LEAD_CONC_NO__c = 'H64118'; 
            obj_Opportunity.CloseDate = Date.today() +1;
            obj_Opportunity.RecordtypeId = Rd.id;
            obj_Opportunity.owner =u;
            insert obj_Opportunity;
            /*  Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
req1.setComments('Submitting request for approval.');
req1.setObjectId(obj_Opportunity.id);

// Submit on behalf of a specific submitter
req1.setSubmitterId(userInfo.getUserId()); 

// Submit the record to specific process and skip the criteria evaluation
req1.setProcessDefinitionNameOrId('PTO_Request_Process');
req1.setSkipEntryCriteria(true);

// Submit the approval request for the account
Approval.ProcessResult result = Approval.process(req1);

// Verify the result
System.assert(result.isSuccess());

System.assertEquals(
'Pending', result.getInstanceStatus(), 
'Instance Status'+result.getInstanceStatus()); 

if([select count() from ProcessInstance where targetobjectid=:obj_Opportunity.id] < 1)
{       
Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
req.setComments('Approve.');
system.debug('666666666666'+new Id[] {UserInfo.getUserId()});
system.debug('3333333333'+u);

req.setNextApproverIds(new Id[] {u.id});
req.setObjectId(obj_Opportunity.Id);

//Submit the approval request
Approval.ProcessResult result = Approval.process(req);

} */
            
            Deal_Meeting_Association__c   DealMeetingAssociation = new Deal_Meeting_Association__c();
            DealMeetingAssociation.TC_Meeting__c=tcMeeting.id;
            DealMeetingAssociation.TWS_TC_Deal__c=obj_Opportunity.id;
            
            List<Deal_Meeting_Association__c> DealMeetingAssociations = new List<Deal_Meeting_Association__c>();
            DealMeetingAssociations.add(DealMeetingAssociation);
            insert DealMeetingAssociations;
            Test.setCurrentPage(pageRef);
            
            pageRef.getParameters().put('id',obj_Opportunity.id);
            ApexPages.StandardController sc = new ApexPages.StandardController(tcMeeting);
            
            TCMeetingController objTCMeetingcon =new TCMeetingController(sc );
            objTCMeetingcon.RejectNavigate();
            objTCMeetingcon.ApproveNavigate();
            objTCMeetingcon.getOpportunityID();
            
            try{
              objTCMeetingcon.Approve();    
            }catch(exception ex){}
            try{
              objTCMeetingcon.Reject();    
            }catch(exception ex){}
            objTCMeetingcon.processApprove();
            objTCMeetingcon.doCancel();
            try{
              objTCMeetingcon.processApproval(true);    
            }catch(exception ex){
                system.debug('wwwwwwww'+ex.getMessage());
            }
            //objTCMeetingcon.Reject();
            // objTCMeetingcon.processApproval(true);
            
            // TCMeetingController.item_wrapper  wraper=new TCMeetingController.item_wrapper(obj_Opportunity.id,'opportunity','opportunity','pending',obj_Opportunity.TC_Meeting_Notes__c,obj_Opportunity.id,'TWS-Direct SP',true,obj_Opportunity);
            
            Test.stopTest(); //switch to testing context
        }
        
    }
    
    static testMethod void TCMeeting_method_Cancel(){
        TCMeetingController testCancel = new TCMeetingController(null); 
        testCancel.Cancel();
    }
}