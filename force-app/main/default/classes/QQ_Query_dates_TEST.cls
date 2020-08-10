@isTest
public class QQ_Query_dates_TEST 
{
    @isTest
    public static void runTest()
    {
       
        ASP_QQ_Switch__c testdate= new ASP_QQ_Switch__c ();
      
        insert testdate;
  QQ_Query_dates.get_FMV_Expiration_Date();
       
    }
}