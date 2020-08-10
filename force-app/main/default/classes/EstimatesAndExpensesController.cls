public class EstimatesAndExpensesController {

    public EstimatesAndExpensesController(ApexPages.StandardController controller) {}
    
    @AuraEnabled
    static public void addEstimatesAndExpenses(id recordId, Integer cab, Integer chassis, Integer mechatronics, Integer eve, Integer otherEstimates, Decimal tooling, Decimal otherExpenses){
        
        List<Engineering_Work_Request__c> ewr = [SELECT ID FROM Engineering_Work_Request__c Where ID =: recordId];
        ewr[0].cab_estimate__c = cab;
        ewr[0].chassis_estimate__c = chassis;
        ewr[0].mechatronics_estimate__c = mechatronics;
        ewr[0].eve_estimate__c = eve;
        ewr[0].other_estimates__c = otherEstimates;
        ewr[0].tooling_expense__c = tooling;
        ewr[0].other_expenses__c = otherExpenses;
        update ewr;
        
    }
    
    @AuraEnabled
    static public List<Decimal> fetchEstimatesAndExpenses(id recordId){
        List<Engineering_Work_Request__c> ewr = [SELECT ID, Cab_Estimate__c, Chassis_Estimate__c, mechatronics_Estimate__c, eve_estimate__c, other_estimates__c, tooling_expense__c, other_expenses__c FROM Engineering_Work_Request__c Where ID =: recordId];
        List<Decimal>  iList = new List<Decimal>();
        if(ewr.size() > 0){
            iList.add(ewr[0].cab_estimate__c);
            iList.add(ewr[0].chassis_estimate__c);
            iList.add(ewr[0].mechatronics_estimate__c);
            iList.add(ewr[0].eve_estimate__c);
            iList.add(ewr[0].other_estimates__c);
            iList.add(ewr[0].tooling_expense__c);
            iList.add(ewr[0].other_expenses__c);
        }
        return iList;
    }
   
}