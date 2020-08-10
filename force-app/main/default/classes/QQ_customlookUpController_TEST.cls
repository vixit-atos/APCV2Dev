@isTest
public class QQ_customlookUpController_TEST 
{
    @isTest
    public static void runTest()
    {
        string searchKeyWord = ''; 
        string ObjectName = 'Account';
        QQ_customLookUpController.fetchLookUpValues(searchKeyWord, ObjectName);
    }
     @isTest
    public static void runcreateQQCustomertest()
    {
        QQ_customLookUpController.createQQCustomer('TestCustomer');
    }
}