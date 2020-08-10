@isTest
public class QQdependentPicklist_UpdateCtrl_TEST 
{
    @isTest
    public static void runTest()
    {
        string objName = 'ASP_QQ__c';
        string contrfieldApiName = 'a85_code__c';
        string contrfieldvalue = 'A85 001 Refuse Service';
        string depfieldApiName = 'A85_Code__c';
        QQdependentPicklist_UpdateCtrl.getDependentlist(objName, contrfieldApiName, contrfieldvalue, depfieldApiName);
                
        List<Schema.PicklistEntry> PLEs = new List<Schema.PicklistEntry>();
        QQdependentPicklist_UpdateCtrl.wrapPicklistEntries(PLEs);        
        
        QQdependentPicklist_UpdateCtrl.decimalToBinary(5);
        QQdependentPicklist_UpdateCtrl.base64ToBits('TEST');
        QQdependentPicklist_UpdateCtrl.PicklistEntryWrapper obj = new QQdependentPicklist_UpdateCtrl.PicklistEntryWrapper();
        obj.active = '';
        obj.defaultValue = '';
        obj.label = '';
        obj.validFor = '';
        obj.value = '';
    }
    
}