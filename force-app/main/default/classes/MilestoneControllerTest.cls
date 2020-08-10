@isTest public class MilestoneControllerTest {
    @isTest static void getDataTest(){
        List<Milestone__c> milestones = new List<Milestone__c>();
        Opportunity opp = new Opportunity(Name='Test', StageName='New', CloseDate=Date.Today());
        insert opp;
        
        milestones.add(new Milestone__c(Name='Design Release', Completed__c = true, Opportunity__c=opp.id));
        milestones.add(new Milestone__c(Name='Final Packet', Completed__c = true, Opportunity__c=opp.id));
        milestones.add(new Milestone__c(Name='Changeover', Completed__c = true, Opportunity__c=opp.id));
        insert milestones;
        
        test.startTest();
        MileStoneController.Result r = MileStoneController.getData(opp.id);
        system.assertNotEquals(null, r);
        test.stopTest();
    } 
}