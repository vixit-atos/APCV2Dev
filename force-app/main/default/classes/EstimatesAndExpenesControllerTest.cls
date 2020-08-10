@isTest public class EstimatesAndExpenesControllerTest {
    
    @testSetup static void testSetup(){
        Engineering_Work_Request__c ewr = new Engineering_Work_Request__c();
        ewr.Job_No__c = '123546';
        insert ewr;
    }
    
    testMethod static void testController(){
        test.startTest();
        List<Engineering_Work_Request__c> ewr = [SELECT Id From Engineering_Work_Request__c LIMIT 1];
        EstimatesAndExpensesController.addEstimatesAndExpenses(ewr[0].id, 1, 1, 1, 1, 1, 1, 1);
        List<Engineering_work_request__c> ewr2 = [ Select ID, cab_estimate__c, chassis_estimate__c, mechatronics_estimate__c, eve_estimate__c, other_estimates__c, tooling_expense__c, other_expenses__c FROM Engineering_Work_Request__c];
        system.assertEquals(1, ewr2[0].cab_estimate__c);
        system.assertEquals(1, ewr2[0].chassis_estimate__c);
        system.assertEquals(1, ewr2[0].mechatronics_estimate__c);
        system.assertEquals(1, ewr2[0].eve_estimate__c);
        system.assertEquals(1, ewr2[0].other_estimates__c);
        system.assertEquals(1, ewr2[0].tooling_expense__c);
        system.assertEquals(1, ewr2[0].other_expenses__c);
        List<Decimal> ewr3 = EstimatesAndExpensesController.fetchEstimatesAndExpenses(ewr[0].id);
        system.assertEquals(1, ewr3[0]);
        system.assertEquals(1, ewr3[1]);
        system.assertEquals(1, ewr3[2]);
        system.assertEquals(1, ewr3[3]);
        system.assertEquals(1, ewr3[4]);
        system.assertEquals(1, ewr3[5]);
        system.assertEquals(1, ewr3[6]);
        test.StopTest();
        
    }

}