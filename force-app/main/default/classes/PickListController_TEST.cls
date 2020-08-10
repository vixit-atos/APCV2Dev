@isTest
public class PickListController_TEST 
{
    @isTest
    public static void runTest()
    {
        string objectType = 'account';
        string selectedField = 'name';
        PickListController.getPickListValuesIntoList(objectType, selectedField);
        
    }
}