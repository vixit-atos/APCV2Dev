@isTest public class EWRController_Test {
    @testSetup static void testSetup(){
        Case c = new Case();
        insert c;
        
        insert new Opportunity(Name='Test', StageName='New', CloseDate=Date.Today());
        
        Engineering_Work_Request__c ewr = new Engineering_Work_request__c();
        ewr.Job_No__c = '546372';
        insert ewr;
        
        EWR_Work_Order__c ewrWO = new EWR_Work_Order__c();
        ewrWO.PREPROD_VEH_NO__c = '123454';
        insert ewrWO;
        
        Engineering_Work_Request_Detail__c detail = new Engineering_Work_request_detail__c();
        detail.Engineering_Work_Request__c = ewr.Id;
        detail.EWR_Work_Order__c = ewrWO.Id;
        detail.recordTypeId = Schema.SObjectType.Engineering_Work_Request_Detail__c.getRecordTypeInfosByName().get('Serial').getRecordTypeId();
        insert detail;
    }
    @isTest
    static void EWRControllerTest(){
        test.startTest();
        List<Opportunity> caseList = [Select id from Opportunity];
        List<Engineering_Work_Request__c> ewrList = [SELECT Id, Job_No__c, Opportunity__c FROM Engineering_Work_Request__c];
        List<Engineering_Work_Request_Detail__c> detailList = [SELECT Id, EWR_Work_Order__c FROM Engineering_Work_Request_Detail__c];
        List<Engineering_Work_Request__c> emptyEWRList = new List<Engineering_Work_Request__c>();
        Engineering_Work_Request__c ewr = new Engineering_Work_Request__c();
        
        List<EWR_Work_Order__c> ewrWOList = [SELECT Id FROM EWR_Work_Order__c];
        	EWRController.attachEWRs(caseList[0].Id, emptyEWRList);
        	EWRController.attachEWRs(caseList[0].Id, ewrList);
        	EWRController.checkEWRError(ewrList, '0');
        	EWRController.checkEWRError(ewrList, ewrList[0].Job_No__c);
        	EWRController.checkEWRError(emptyEWRList, '0');
        	emptyEWRList.add(ewr);
        	EWRController.attachEWRs(caseList[0].Id, emptyEWRList);
        system.debug(caseList[0].id);
        	EWRController.fetchMilestoneEWR(caseList[0].Id);
        	EWRController.fetchEWRInformation(caseList[0].Id);
        	EWRController.fetchEWRDetails(ewrList);
        	EWRController.fetchEWRDetail(ewrList[0].Id);
        	EWRController.fetchWorkOrders(detailList);
        	EWRController.getEWRs(caseList[0].Id, ewrList[0].Job_No__c);
        	EWRController.getEWRs(caseList[0].Id, '0');
        test.stopTest();
    }
}