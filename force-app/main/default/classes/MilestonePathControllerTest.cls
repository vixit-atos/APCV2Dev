@isTest public class MilestonePathControllerTest {
    
 @isTest static void getDashboardDataTest(){
        List<Milestone__c> milestones = new List<Milestone__c>();
        Opportunity opp = new Opportunity(Name='Test', StageName='New', CloseDate=Date.Today());
        insert opp;
        
     	List<Engineering_Work_Request__c> EWRList = new List<Engineering_Work_Request__c>();
        EWRList.add(new Engineering_Work_Request__c(Name='Test1',job_no__C = 'A123', Opportunity__c=opp.id));
      insert EWRList;
     
        milestones.add(new Milestone__c(Name='Design Release', Completed__c = true, Opportunity__c=opp.id));
        milestones.add(new Milestone__c(Name='Final Packet', Completed__c = true, Opportunity__c=opp.id));
        milestones.add(new Milestone__c(Name='Pact Approval', Completed__c = true, Opportunity__c=opp.id));
        insert milestones;
     
    
     	
     	test.startTest();
     
        MileStonePathController.Result r = MileStonePathController.getDashboardData(opp.id);
        list<Milestone__c> t = MileStonePathController.fetchMilestones(Opp.id);
        system.assertNotEquals(null, r);
        test.stopTest(); 
    }
    
}