@isTest
public class singleSelectLookUpController_Test 
{
    @isTest
    public static void runTest()
    {
        Try
         {
            string objectType = 'user';
            string selectedField = 'shaik';
            singleSelectLookUpController.fetchLookUpValues(selectedField, objectType);
         }
		Catch(Exception e){
        	system.debug('exception '+e.getMessage());
        }
    }
}