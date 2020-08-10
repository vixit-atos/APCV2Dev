@isTest
public class QQ_Master_Controller_TEST 
{
    @isTest
    public static void runTest()
    {
        Id recordTypeId = Schema.SObjectType.QQ_Master__c.getRecordTypeInfosByName().get('Detroit Coverage').getRecordTypeId();
        
        QQ_Master__c QQMaster = new QQ_Master__c();
        QQMaster.Active__c = true;
        QQMaster.Usage__c  = 'Vocational';
        QQMaster.Cost__c = 0;
        QQMaster.Coverage_Type__c = 'Detroit Engines';
        QQMaster.Name = 'TEST-000';
        QQMaster.Deductible__c = 3;
        QQMaster.Duration__c = '';
        QQMaster.Engine_Component__c = 'DD15';
        Date dt = Date.today();
        QQMaster.FMV_Date__c = dt;
        //QQMaster.Group__c = 'MD';
        //QQMaster.Kms__c = 0;
        QQMaster.Miles__c = 1500;
        QQMaster.Months__c = 30;
        QQMaster.Option__c = 'EW3';
        QQMaster.Price__c = 0;
        //QQMaster.Price_Per_Mile__c = 0;
        //QQMaster.Price_Per_Month__c = 0;
        QQMaster.Pricing_Types__c = 'Standard';
        QQMaster.Publication_Status__c = 'Published';
        QQMaster.RecordTypeId = recordTypeId;
        //QQMaster.Standalone__c = 'Ext Towing/Roadside Service $550 Cap';
        //QQMaster.Truck_Coverage_Package__c = 'TC2';
        //QQMaster.Level__c = 'Standard';
                
        ID recordID = QQ_Master_Controller.submitRecord(QQMaster);
        system.debug('Record ID: ' + recordID);
        QQ_Master_Controller.getQQMaster(recordID);
        string dbCode = QQMaster.Name;
        date fmvDate = QQMaster.FMV_Date__c;
        QQ_Master_Controller.verifyDuplicate(null, dbCode, fmvDate);
        
        string category = 'Publication Status';
        QQ_Master_Controller.getPicklistItem(category);
        category = 'Pricing Types';
        QQ_Master_Controller.getPicklistItem(category);
        category = 'Application Description';
        QQ_Master_Controller.getPicklistItem(category);
        category = 'Group';
        QQ_Master_Controller.getPicklistItem(category);
        category = 'Vocation Description';
        QQ_Master_Controller.getPicklistItem(category);
        
        Id recordTypeId2 = Schema.SObjectType.Administrative_Tool__c.getRecordTypeInfosByName().get('Add New Admin Panel Value').getRecordTypeId();
        Administrative_Tool__c AdminTool = new Administrative_Tool__c();
        AdminTool.Value__c = 'TEST Engine Comp';
        AdminTool.Field_Name__c = 'Engine Component';
        AdminTool.RecordTypeId = recordTypeId2;
        //AdminTool.Active__c = true;
        INSERT AdminTool;
                
        category = 'Engine Component';
        QQ_Master_Controller.getItem(category);
        
        QQ_Master_Controller.getRecordType(recordTypeId);
    }
}