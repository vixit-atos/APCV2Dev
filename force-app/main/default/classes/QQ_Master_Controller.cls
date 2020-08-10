public with sharing class QQ_Master_Controller
{
    public class KeyValue 
    {
        @AuraEnabled 
        public string value {get; set;}
        @AuraEnabled 
        public string label {get; set;}
    }
    
    @AuraEnabled
    public static QQ_Master__c getQQMaster(string recordID)
    {
        QQ_Master__c QQMaster = [SELECT Active__c,
                                 Usage__c,
                                 Cost__c,
                                 Coverage_Type__c,
                                 Name,
                                 Deductible__c,
                                 Duration__c,
                                 Engine_Component__c,
                                 FMV_Date__c,
                                 Group__c,
                                 Kms__c,
                                 Miles__c,
                                 Months__c,
                                 Option__c,
                                 Price__c,
                                 Price_Per_Mile__c,
                                 Price_Per_Month__c,
                                 Pricing_Types__c,
                                 Publication_Status__c,
                                 RecordTypeId,
                                 RecordType.Name,
                                 Standalone__c,
                                 Package__c,
                                 Level__c
                                 FROM QQ_Master__c
                                 WHERE ID = :recordID];
        return QQMaster;
    }
    
    @AuraEnabled
    public static string getRecordType(string recordTypeId)
    {
        string RecordType = Schema.getGlobalDescribe().get('QQ_Master__c').getDescribe().getRecordTypeInfosById().get(recordTypeId).getName();
        return RecordType;
    }
    
    @AuraEnabled
    public static list<KeyValue> getItem(string category)
    {
        //system.debug('Category: ' + category);
        list<Administrative_Tool__c> lstItems = [SELECT ID,
                                                 Name,
                                                 Value__c,
                                                 Sort_Order__c
                                                 FROM Administrative_Tool__c
                                                 WHERE Field_Name__c = :category AND
                                                 RecordType.Name = 'Add New Admin Panel Value' AND
                                                 Active__c = true
                                                 ORDER BY Value__c ASC];
        
        list<KeyValue> lstKV = new list<KeyValue>();
        KeyValue KV;
        for(Administrative_Tool__c AT : lstItems)
        {
            KV = new KeyValue();
            KV.value = AT.Value__c;
            KV.label = AT.Value__c;
            lstKV.add(KV);
        }
        return lstKV;
    }
    
    @AuraEnabled
    public static list<KeyValue> getPicklistItem(string category)
    {
        Schema.DescribeFieldResult fieldResult;
        if(category == 'Pricing Types')
            fieldResult = QQ_Master__c.Pricing_Types__c.getDescribe();
        if(category == 'Publication Status')
            fieldResult = QQ_Master__c.Publication_Status__c.getDescribe();
        if(category == 'Application Description')
            fieldResult = QQ_Master__c.Usage__c.getDescribe();
        if(category == 'Group')
            fieldResult = QQ_Master__c.Group__c.getDescribe();
        if(category == 'Vocation Description')
            fieldResult = QQ_Master__c.Level__c.getDescribe();
                
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        list<KeyValue> lstKV = new list<KeyValue>();
        KeyValue KV;
        for( Schema.PicklistEntry pickListVal : ple)
        {
            //system.debug(pickListVal.getLabel());
            KV = new KeyValue();
            KV.value = pickListVal.getValue();
            KV.label = pickListVal.getLabel();
            lstKV.add(KV);
        }
        return lstKV;  
    }
    
    @AuraEnabled
    public static boolean verifyDuplicate(string QQMasterID, string dbCode, date fmvDate)
    {
        system.debug('QQMasterID: ' + QQMasterID);
        boolean duplicateExist = false;
        
        List<QQ_Master__c> lstQQMaster = new List<QQ_Master__c>();
        if(QQMasterID == null)
        {
            lstQQMaster = [SELECT ID,
                           Name,
                           FMV_Date__c
                           FROM QQ_Master__c];
        }
        else
        {   
            lstQQMaster = [SELECT ID,
                           Name,
                           FMV_Date__c
                           FROM QQ_Master__c 
                           WHERE ID != :QQMasterID];
        }
        
        for(QQ_Master__c QQMaster : lstQQMaster)
        {
            if(QQMaster.Name == dbCode && QQMaster.FMV_Date__c == fmvDate)
            {
                duplicateExist = true;
                break;
            }
        }
        
        return duplicateExist;
    }
    
    @AuraEnabled
    public static Id submitRecord(QQ_Master__c QQMaster)
    {
        string stsMessage = '';
        try
        {
            UPSERT QQMaster;
            stsMessage = 'Record submitted successfully';
        }
        catch(Exception exp)
        {
            stsMessage = 'Sorry! Transaction failed.';
            system.debug('Line: ' + exp.getLineNumber() + ', Error: ' + exp.getMessage());
        }
        return QQMaster.Id;
    }
}