/*
05/07/2015 Created by Anto Nirmal for Testing Lead Concession Update
*/

@isTest
public class DTNA_Concession_Update_test 
{    /*
    @isTest
    static void test_Concession_Insert_LeadRecord() 
    {
        test.startTest();
        Opportunity Concession = TestDataFactory_Opportunity.createOpportunitys(1,'12345','12345')[0];
        System.assertEquals(Concession.LeadConcession__c, null); 
        test.stopTest();
    }
    
    @isTest
    static void test_Concession_Insert_NoValue() 
    {
        test.startTest();
        Opportunity Concession = TestDataFactory_Opportunity.createOpportunitys(1,'12347','')[0];
        System.assertEquals(Concession.LEAD_CONC_NO__c, ''); 
        test.stopTest();
    }
    
    @isTest
    static void test_Concession_Insert_childRecord() 
    {
        test.startTest();
        Opportunity ConcessionLead = TestDataFactory_Opportunity.createOpportunitys(1,'54321','543211')[0];
        Opportunity ConcessionGo = TestDataFactory_Opportunity.createOpportunitys(1,'54322','543211')[0];
        List<Opportunity> ConcessionCheck = [Select  LEAD_CONC_NO__c, LeadConcession__r.name, LeadConcession__C from Opportunity where Name='543221' limit 1];
        
        System.debug('Check ConcessionCheck:' + ConcessionCheck);
        System.debug('Check Value:' + ConcessionCheck[0].LeadConcession__r.name);
        System.debug('Check Value:' + ConcessionCheck[0].LeadConcession__c);

        System.assertEquals(ConcessionCheck[0].LEAD_CONC_NO__c, ConcessionCheck[0].LeadConcession__r.name);  
        test.stopTest();
    }
    
    @isTest 
    static void test_Concession_Update_childRecord() 
    {
        test.startTest();
        Opportunity LeadConcession = TestDataFactory_Opportunity.createOpportunitys(1,'99991','999911')[0];
        Opportunity ChildConcession = TestDataFactory_Opportunity.createOpportunitys(1,'99992','999921')[0];
        System.debug('Check Concession Insert:' + ChildConcession);
        ChildConcession.LEAD_CONC_NO__c = '999911';
        update ChildConcession;
        System.debug('Check Concession Update:' + ChildConcession);
        List<Opportunity> ConcessionCheck = [Select  LEAD_CONC_NO__c, LeadConcession__r.name from Opportunity where Name='999921' limit 1];
        
        System.debug('Check ConcessionCheck:' + ConcessionCheck);
        System.assertEquals(ConcessionCheck[0].LEAD_CONC_NO__c, ConcessionCheck[0].LeadConcession__r.name); 
        test.stopTest();
    }
    
    @isTest
    static void test_Concession_MultiInsert_childRecord() 
    {
        test.startTest();
        Opportunity ConcessionLead = TestDataFactory_Opportunity.createOpportunitys(1,'54321','543211')[0];
        List<Opportunity> ConcessionGo = TestDataFactory_Opportunity.createOpportunitys(151,'999','543211');
        List<Opportunity> lst_ConcessionCheck = [Select  LEAD_CONC_NO__c, LeadConcession__r.name, LeadConcession__C from Opportunity where Name like '999%'];
        
        for(Opportunity ConcessionCheck: lst_ConcessionCheck)
        {
            System.debug('Check ConcessionCheck:' + ConcessionCheck);
            System.debug('Check Value:' + ConcessionCheck.LeadConcession__r.name);
            System.debug('Check Value:' + ConcessionCheck.LeadConcession__c);
            System.assertEquals(ConcessionCheck.LEAD_CONC_NO__c, ConcessionCheck.LeadConcession__r.name);  
        }
        test.stopTest();
    }
    
    @isTest
    static void test_Concession_MultiUpdate_childRecord() 
    {
        test.startTest();
        Opportunity ConcessionLead = TestDataFactory_Opportunity.createOpportunitys(1,'54321','543211')[0];
        List<Opportunity> list_ConcessionGo = TestDataFactory_Opportunity.createOpportunitys(151,'999','');
        for(Opportunity ConcessionGo: list_ConcessionGo)
        {
            ConcessionGo.LEAD_CONC_NO__c = '543211';
        }
        update list_ConcessionGo;

        List<Opportunity> lst_ConcessionCheck = [Select  LEAD_CONC_NO__c, LeadConcession__r.name, LeadConcession__C from Opportunity where Name like '999%'];
        
        for(Opportunity ConcessionCheck: lst_ConcessionCheck)
        {
            System.debug('Check ConcessionCheck:' + ConcessionCheck);
            System.debug('Check Value:' + ConcessionCheck.LeadConcession__r.name);
            System.debug('Check Value:' + ConcessionCheck.LeadConcession__c);
            System.assertEquals(ConcessionCheck.LEAD_CONC_NO__c, ConcessionCheck.LeadConcession__r.name);  
        }
        test.stopTest();
    }
    
    @isTest
    static void test_Concession_MultiInsert_parentchildRecord() 
    {
        test.startTest();
        List<Opportunity> list_OpportunityObj = new List<Opportunity>();
        
        Opportunity obj_Opportunity = new Opportunity (Name='9991',
                                                           StageName = 'New', 
                                                           LEAD_CONC_NO__c = '9991', 
                                                           CloseDate = Date.today() +1);

        list_OpportunityObj.add(obj_Opportunity);
        Opportunity obj_Opportunity2 = new Opportunity (Name='9992',
                                                           StageName = 'New', 
                                                           LEAD_CONC_NO__c = '9991', 
                                                           CloseDate = Date.today() +1);
       
        
        list_OpportunityObj.add(obj_Opportunity2);
        insert list_OpportunityObj;
        List<Opportunity> lst_ConcessionCheck = [Select  LEAD_CONC_NO__c, LeadConcession__r.name, LeadConcession__C from Opportunity where Name like '9992%'];
        
        for(Opportunity ConcessionCheck: lst_ConcessionCheck)
        {
            System.debug('Check ConcessionCheck:' + ConcessionCheck);
            System.debug('Check Value:' + ConcessionCheck.LeadConcession__r.name);
            System.debug('Check Value:' + ConcessionCheck.LeadConcession__c);
            System.assertEquals(ConcessionCheck.LEAD_CONC_NO__c, ConcessionCheck.LeadConcession__r.name);  
        }
        test.stopTest();
    }
    */
}