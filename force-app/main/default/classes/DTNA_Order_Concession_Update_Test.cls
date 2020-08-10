/* 07/23/2015 Created by Anto Nirmal for Testing Concession Order Update */

@isTest
public class DTNA_Order_Concession_Update_Test 
{
/*
    @isTest
    static void test_Order_Insert_withConcession() 
    {
        test.startTest();
        Opportunity Obj_ConcessionGo = TestDataFactory_Opportunity.createOpportunitys(1,'54321','543211')[0];
        Order Obj_OrderTest =  TestDataFactory_Order.createOrders(1,'Tst00','543211')[0];
        
        List<Order> OrderCheck = [Select ConcessionNumber__c, ConcessionNumber__r.name, CONC_NO__c from Order where name = 'Tst001' limit 1];
        
        System.debug('Check OrderCheck:' + OrderCheck);
        System.debug('Check Value:' + OrderCheck[0].ConcessionNumber__r.name);
        System.debug('Check Value:' + OrderCheck[0].ConcessionNumber__c);

        System.assertEquals(OrderCheck[0].CONC_NO__c, OrderCheck[0].ConcessionNumber__r.name);  
        test.stopTest();
    }
    
    
    @isTest
    static void test_Order_Insert_withoutConcession() 
    {
        test.startTest();
        Order Obj_OrderTest =  TestDataFactory_Order.createOrders(1,'Tst01','')[0];
        
        List<Order> OrderCheck = [Select ConcessionNumber__c, ConcessionNumber__r.name, CONC_NO__c from Order where name = 'Tst011' limit 1];
        
        System.debug('Check OrderCheck:' + OrderCheck);
        System.debug('Check Value:' + OrderCheck[0].ConcessionNumber__r.name);
        System.debug('Check Value:' + OrderCheck[0].ConcessionNumber__c);

        System.assertEquals(OrderCheck[0].CONC_NO__c, OrderCheck[0].ConcessionNumber__r.name);  
        test.stopTest();
    }
    
    @isTest
    static void test_Order_Update_withConcession() 
    {
        test.startTest();
        Opportunity Obj_ConcessionGo = TestDataFactory_Opportunity.createOpportunitys(1,'54321','543211')[0];
        Order Obj_OrderTest =  TestDataFactory_Order.createOrders(1,'Tst02','')[0];
        Obj_OrderTest.CONC_NO__c = '543211';
        update Obj_OrderTest;
        
        List<Order> OrderCheck = [Select ConcessionNumber__c, ConcessionNumber__r.name, CONC_NO__c from Order where name = 'Tst021' limit 1];
        
        System.debug('Check OrderCheck:' + OrderCheck);
        System.debug('Check Value:' + OrderCheck[0].ConcessionNumber__r.name);
        System.debug('Check Value:' + OrderCheck[0].ConcessionNumber__c);

        System.assertEquals(OrderCheck[0].CONC_NO__c, OrderCheck[0].ConcessionNumber__r.name);  
        test.stopTest();
    }
    
    @isTest
    static void test_Order_Update_withoutConcession() 
    {
        test.startTest();
        Opportunity Obj_ConcessionGo = TestDataFactory_Opportunity.createOpportunitys(1,'54321','543211')[0];
        Order Obj_OrderTest =  TestDataFactory_Order.createOrders(1,'Tst03','543211')[0];
        Obj_OrderTest.CONC_NO__c = '';
        update Obj_OrderTest;
        
        List<Order> OrderCheck = [Select ConcessionNumber__c, ConcessionNumber__r.name, CONC_NO__c from Order where name = 'Tst031' limit 1];
        
        System.debug('Check OrderCheck:' + OrderCheck);
        System.debug('Check Value:' + OrderCheck[0].ConcessionNumber__r.name);
        System.debug('Check Value:' + OrderCheck[0].ConcessionNumber__c);

        System.assertEquals(OrderCheck[0].CONC_NO__c, OrderCheck[0].ConcessionNumber__r.name);  
        test.stopTest();
    }
    
    @isTest
    static void test_Order_MultiUpdate_withConcession() 
    {
        test.startTest();
        Opportunity Obj_ConcessionGo = TestDataFactory_Opportunity.createOpportunitys(1,'54321','543211')[0];
        List<Order> lst_OrderTest =  TestDataFactory_Order.createOrders(151,'T04','');
        
        for (Order Obj_Ord: lst_OrderTest)
        {
            Obj_Ord.CONC_NO__c = '543211';
        }
        update lst_OrderTest;
        
        List<Order> lst_OrderCheck = [Select ConcessionNumber__c, ConcessionNumber__r.name, CONC_NO__c from Order where name like 'T04%'];
        for (Order OrderCheck: lst_OrderCheck)
        {
            System.debug('Check OrderCheck:' + OrderCheck);
            System.debug('Check Value:' + OrderCheck.ConcessionNumber__r.name);
            System.debug('Check Value:' + OrderCheck.ConcessionNumber__c);
    
            System.assertEquals(OrderCheck.CONC_NO__c, OrderCheck.ConcessionNumber__r.name);
        }
        test.stopTest();
    }
    
    @isTest
    static void test_Order_MultiInsert_withConcession() 
    {
        test.startTest();
        Opportunity Obj_ConcessionGo = TestDataFactory_Opportunity.createOpportunitys(1,'54321','543211')[0];
        List<Order> lst_OrderTest =  TestDataFactory_Order.createOrders(151,'T04','543211');
        
        List<Order> lst_OrderCheck = [Select ConcessionNumber__c, ConcessionNumber__r.name, CONC_NO__c from Order where name like 'T04%'];
        for (Order OrderCheck: lst_OrderCheck)
        {
            System.debug('Check OrderCheck:' + OrderCheck);
            System.debug('Check Value:' + OrderCheck.ConcessionNumber__r.name);
            System.debug('Check Value:' + OrderCheck.ConcessionNumber__c);
    
            System.assertEquals(OrderCheck.CONC_NO__c, OrderCheck.ConcessionNumber__r.name);
        }
        test.stopTest();
    }*/
}