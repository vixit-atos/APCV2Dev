@isTest
public class FMVCloneHandler_TEST 
{
    @isTest
    public static void runTest()
    {
        Date dt = Date.today();
        
        ASP_QQ_Switch__c SW = new ASP_QQ_Switch__c();
        SW.Active__c = true;
        SW.Date__c = dt;
        SW.Expiration_Date__c = Date.today();
        SW.FMV_Date__c = dt;
        INSERT SW;
           
        ASP_QQ_Switch__c SW1 = new ASP_QQ_Switch__c();
        SW1.Active__c = false;        
        SW1.Date__c = dt.addDays(3);
        SW1.Expiration_Date__c = dt.addDays(15);
        SW1.FMV_Date__c = dt.addDays(5);
        INSERT SW1;
        
        ASP_QQ_Switch__c SW2 = new ASP_QQ_Switch__c();
        SW2.Active__c = false;
        SW2.Date__c = dt.addDays(4);
        SW2.Expiration_Date__c = dt.addDays(16);
        SW2.FMV_Date__c = dt.addDays(6);
        INSERT SW2;
        
        ASP_QQ_Duration_Master__c DR = new ASP_QQ_Duration_Master__c();
        DR.Name = '3.1 yr / 351k mi / 564k km';
        DR.Active__c = true;
        DR.Usage__c = '';
        DR.Cost__c = 0;
        DR.Coverage__c = 'TRUCK CHASSIS';
        DR.Coverage_Type__c = '';
        DR.Databook_Code__c = 'WBB-174';
        DR.Deductible__c = '0';
        DR.Engine_Component__c = '';
        DR.FMV_Date__c = dt.addDays(2);
        DR.Group__c = 'HD';
        DR.Miles__c = 350001;
        DR.Months__c = 21;
        DR.Option__c = '';
        DR.Price__c = 2301;
        DR.Pricing_Types__c = 'Standard';
        DR.Publication_Status__c = 'PUBLISHED';
        DR.Standalone_Package__c = '';
        DR.Truck_Coverage_Package__c = 'TC3';
        DR.Level__c = 'Standard';
        INSERT DR;
        
        List<ASP_QQ_Switch__c> newSwitch = new List<ASP_QQ_Switch__c>();
        newSwitch.add(SW);
        List<ASP_QQ_Switch__c> oldSwitch = new List<ASP_QQ_Switch__c>();
        oldSwitch.add(SW);
        
        Map<ID, ASP_QQ_Switch__c> newSwitchMap = new Map<ID, ASP_QQ_Switch__c>();
        newSwitchMap.put(SW.ID, SW1);
        Map<ID, ASP_QQ_Switch__c> oldSwitchMap = new Map<ID, ASP_QQ_Switch__c>();
        oldSwitchMap.put(SW.ID, SW2);
        
        FMVCloneHandler obj = new FMVCloneHandler();
        obj.OnBeforeInsert(newSwitch);
        obj.OnAfterInsert(newSwitch);
        obj.OnBeforeUpdate(newSwitch, oldSwitch, newSwitchMap, oldSwitchMap);
        obj.OnAfterUpdate(newSwitch, oldSwitch, newSwitchMap, oldSwitchMap);
        
        ASP_QQ_Switch__c SW3 = new ASP_QQ_Switch__c();
        SW3.ID = SW.ID;
        SW3.Active__c = true;
        SW3.Date__c = dt.addDays(21);
        SW3.Expiration_Date__c = dt.addDays(25);
        SW3.FMV_Date__c = dt.addDays(23);
        UPDATE SW3;
        DELETE SW3;
        
    }    
}