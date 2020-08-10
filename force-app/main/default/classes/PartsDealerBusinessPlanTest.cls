@istest
public class PartsDealerBusinessPlanTest{
    @testSetup static void testSetup(){
        Account Acc = new Account(Name = 'Test');
        Insert acc;
        
        Business_Plan__c BussPlan = new Business_Plan__c(Account__C = acc.id);
        Insert BussPlan;
        
        RecordType RT = [Select id from RecordType where RecordType.DeveloperName = 'Earnback_Opportunities'];
        Business_Plan_Detail__c BusPlandetail = new Business_Plan_Detail__c(RecordTypeId = RT.id,Business_Plan__c=BussPlan.id,delete__c = true);
        Insert BusPlandetail;
        
        RT = [Select id from RecordType where RecordType.DeveloperName = 'Regional_Fleet_Conquests'];
        BusPlandetail = new Business_Plan_Detail__c(RecordTypeId = RT.id,Business_Plan__c=BussPlan.id);
        Insert BusPlandetail;

        Dealer_Performance_Category__c DelPer = new Dealer_Performance_Category__c(name = 'Test', Target_Growth__c = .10);
        Insert DelPer;
        
        Contact mandatoryContact = new Contact();
        mandatoryContact.FirstName = 'Test';
        mandatoryContact.LastName = 'Test';
        String email = 'test@gmtestail.com';
        mandatoryContact.Email = email.replaceAll( '\\s+', '');
        mandatoryContact.Phone = '0000000000';
        Database.insert(mandatoryContact,false);

    }
    public static testmethod void DTNA_Parts_Business(){
        Business_Plan__c BussPlan = [SELECT Name, Account__c from Business_Plan__c LIMIT 1];
        RecordType RT = [Select id from RecordType where RecordType.DeveloperName = 'Earnback_Opportunities' LIMIT 1];
        //RT = [Select id from RecordType where DeveloperName = 'Parts_Task'];
        //Task T = new Task(Subject = 'TestTask', type='Top Objectives',whatId=BussPlan.id,RecordTypeId = RT.id);
        //Insert T;
        //T = new Task(Subject = 'TestTask', type='Top DTNA Improvement Items',whatId=BussPlan.id,RecordTypeId = RT.id);
        //Insert T;
        //
        
        Test.setCurrentPageReference(new PageReference('Page.PartsDealerBusinessPlan')); 
        System.currentPageReference().getParameters().put('id',BussPlan.Id);
		ApexPages.StandardController sc = new ApexPages.StandardController(BussPlan);
		DTNA_Parts_Business_Plan obj = new DTNA_Parts_Business_Plan(sc);
        
        obj.NewDealerPerformanceCategory();
        obj.NewTopObjective();
        obj.NewImpItems();
        obj.NewEarnbackOppt();
        obj.NewRegFleetConq();
        obj.CalcReRender();
        obj.Lst_TOP_Objectives.add(new Task(Subject='Test', Delete__c = true));
        obj.Lst_TOP_ImpPlan.add(new Task(Subject='Test', Delete__c = true));
        obj.Lst_BPD_EarnbackOpportunities.add(new Business_Plan_Detail__c(RecordTypeId = RT.id,Business_Plan__c=BussPlan.id, delete__c = true));
        obj.SavePage();
        obj.ReloadPage();
        obj.goBack();
    }
    public static testmethod void DTNA_Parts_Business_NullID(){
        Business_Plan__c BussPlan = new Business_Plan__c();
        RecordType RT = [Select id from RecordType where RecordType.DeveloperName = 'Earnback_Opportunities' LIMIT 1];
        //RT = [Select id from RecordType where DeveloperName = 'Parts_Task'];
        //Task T = new Task(Subject = 'TestTask', type='Top Objectives',whatId=BussPlan.id,RecordTypeId = RT.id);
        //Insert T;
        //T = new Task(Subject = 'TestTask', type='Top DTNA Improvement Items',whatId=BussPlan.id,RecordTypeId = RT.id);
        //Insert T;
        Test.setCurrentPageReference(new PageReference('Page.PartsDealerBusinessPlan')); 
		ApexPages.StandardController sc = new ApexPages.StandardController(BussPlan);
		DTNA_Parts_Business_Plan obj = new DTNA_Parts_Business_Plan(sc);
        test.startTest();
            obj.NewDealerPerformanceCategory();
            obj.NewTopObjective();
            obj.NewImpItems();
            obj.NewEarnbackOppt();
            obj.NewRegFleetConq();
            obj.CalcReRender();
        	obj.Lst_TOP_Objectives.add(new Task(Subject='Test', Delete__c = true));
        	obj.Lst_TOP_ImpPlan.add(new Task(Subject='Test', Delete__c = true));
            obj.Lst_BPD_EarnbackOpportunities.add(new Business_Plan_Detail__c(RecordTypeId = RT.id,Business_Plan__c=BussPlan.id, delete__c = true));
        	obj.SavePage();
            obj.ReloadPage();
            obj.goBack();
        test.stopTest();
    }
}