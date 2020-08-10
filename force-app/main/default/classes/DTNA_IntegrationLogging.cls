public class DTNA_IntegrationLogging 
{

    public static void IntegrationLoggingReqInsert(String BusinessFunction,String ExternalSystem,String Method,String ILId,String RequestMessage,String IntStatus)
    {
        try 
        {
            IntegrationLog__c obj_IntLog = new IntegrationLog__c(BusinessFunction__c=BusinessFunction,ExternalSystem__c=ExternalSystem,Method__c=Method,Status__C=IntStatus,RelatedRecord__c=ILId,RequestMessage__c = RequestMessage);
            insert obj_IntLog;
        } 
        catch(Exception e)
        {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }     
    }
   
    public static void IntegrationLoggingRespUpdate(String ILId,String ResponseMessage,String IntStatus)
    {
        try 
        {      
            String soql_Query = 'SELECT Response_Message__c,RelatedRecord__c,Status__C FROM IntegrationLog__c WHERE RelatedRecord__c=\''+ILId+'\' Limit 1';
            IntegrationLog__c IntegrationLogToUpdate = database.query(soql_Query);
            if(IntegrationLogToUpdate.RelatedRecord__c == ILId)
            {
                IntegrationLogToUpdate.Response_Message__c = ResponseMessage;
                IntegrationLogToUpdate.Status__C=IntStatus;
                update IntegrationLogToUpdate;
			}
        } 
        catch(Exception e)
        {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
		}
    }
}