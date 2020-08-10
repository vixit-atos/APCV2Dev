@isTest
public class DTNA_IntegrationLogging_Test 
{
    @isTest
    static void RequestInsertResponseUpdate_test()
	{
        test.startTest();
        DTNA_IntegrationLogging.IntegrationLoggingReqInsert('RCU','IMS-Mainframe','Approval','H1234567891','TestIntegrationLoggingRequestInsert','Requested');
        String soqlQuery = 'SELECT BusinessFunction__c, ExternalSystem__c, Method__c, Status__c, RequestMessage__c, Response_Message__c FROM IntegrationLog__c WHERE RelatedRecord__c=\'H1234567891\' Limit 1';
        IntegrationLog__c IntegrationLogToUpdate = database.query(soqlQuery);
        System.assertEquals('RCU', IntegrationLogToUpdate.BusinessFunction__c);
        System.assertEquals('IMS-Mainframe', IntegrationLogToUpdate.ExternalSystem__c);
        System.assertEquals('Approval', IntegrationLogToUpdate.Method__c);
        System.assertEquals('TestIntegrationLoggingRequestInsert',IntegrationLogToUpdate.RequestMessage__c);
        System.assertEquals('Requested', IntegrationLogToUpdate.Status__c);
        System.assertEquals(null, IntegrationLogToUpdate.Response_Message__c);
        DTNA_IntegrationLogging.IntegrationLoggingRespUpdate('H1234567891','TestIntegrationLoggingResponseUpdate','SOAP Request Failure');
        soqlQuery = 'SELECT BusinessFunction__c, ExternalSystem__c, Method__c, Status__c, RequestMessage__c, Response_Message__c FROM IntegrationLog__c WHERE RelatedRecord__c=\'H1234567891\' Limit 1';
        IntegrationLogToUpdate = database.query(soqlQuery);
        System.assertEquals('SOAP Request Failure', IntegrationLogToUpdate.Status__c);
        System.assertEquals('TestIntegrationLoggingResponseUpdate', IntegrationLogToUpdate.Response_Message__c);
        test.stopTest();
        
    }
    
    @isTest
    static void RequestInsertResponseUpdateException_test()
	{
     	test.startTest();
        DTNA_IntegrationLogging.IntegrationLoggingReqInsert('TestIntegrationLoggingwith More than 20 characters for length','IMS-Mainframe','Approval','','TestIntegrationLoggingRequestInsert','Requested');
        String soqlQuery = 'SELECT Response_Message__c FROM IntegrationLog__c WHERE RelatedRecord__c=\'H1234567890\' Limit 1';
        System.assertEquals(0,  database.query(soqlQuery).size());
        
        DTNA_IntegrationLogging.IntegrationLoggingReqInsert('RCU','IMS-Mainframe','Approval','H1234567890','TestIntegrationLoggingRequestInsert','Requested');
        soqlQuery = 'SELECT Response_Message__c FROM IntegrationLog__c WHERE RelatedRecord__c=\'H1234567890\' Limit 1';
        IntegrationLog__c IntegrationLogToUpdate = database.query(soqlQuery);
        
        DTNA_IntegrationLogging.IntegrationLoggingRespUpdate('H1234567890','Concessionnumbernotavialble','SOAP Request Failure_withmore than 20 characters');
        soqlQuery = 'SELECT Response_Message__c FROM IntegrationLog__c WHERE RelatedRecord__c=\'H1234567890\' Limit 1';
        IntegrationLogToUpdate = database.query(soqlQuery);
        System.assertEquals(null, IntegrationLogToUpdate.Response_Message__c);
        test.stopTest();
    }
}