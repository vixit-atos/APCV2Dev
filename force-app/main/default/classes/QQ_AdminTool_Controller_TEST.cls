@isTest
public class QQ_AdminTool_Controller_TEST 
{
    @isTest
    public static void runTest()
    {
        Id MR_recordTypeId = Schema.SObjectType.Administrative_Tool__c.getRecordTypeInfosByName().get('Create New Model Relationship').getRecordTypeId();
        Administrative_Tool__c adminTool = new Administrative_Tool__c();
        adminTool.Field_Name__c = 'Engine Component';
        adminTool.Value__c = 'TEST-DATA';
        adminTool.Quote_Type__c = 'Extended Coverage';
        adminTool.RecordTypeId = MR_recordTypeId;
        INSERT adminTool;
        
        Administrative_Tool__c adminTool2 = new Administrative_Tool__c();
        adminTool2.Field_Name__c = 'Engine Component';
        adminTool2.Value__c = 'TEST-DATA';
        adminTool2.Quote_Type__c = 'Extended Coverage';
        adminTool2.RecordTypeId = MR_recordTypeId;
        
        QQ_AdminTool_Controller.submitRecord(adminTool2);
        
        string category = 'Engine Component';
        QQ_AdminTool_Controller.getItem(category);
        
        category = 'Group';
        QQ_AdminTool_Controller.getPicklistItem(category);
        category = 'A85 Code';
        QQ_AdminTool_Controller.getPicklistItem(category);
        category = 'Quote Type';
        QQ_AdminTool_Controller.getPicklistItem(category);
        
        string QuoteType = 'Extended Coverage';
        QQ_AdminTool_Controller.getParentID(QuoteType);
        
        Id FMVD_recordTypeId = Schema.SObjectType.Administrative_Tool__c.getRecordTypeInfosByName().get('FMV Date').getRecordTypeId();
        QQ_AdminTool_Controller.getRecordType(FMVD_recordTypeId);
        
        QQ_AdminTool_Controller.verifyDuplicate(adminTool2);
        
        DateTime dt = DateTime.now();
        Id DIS_recordTypeId = Schema.SObjectType.Administrative_Tool__c.getRecordTypeInfosByName().get('PDF Disclaimer Management').getRecordTypeId();
        Administrative_Tool__c adminTool3 = new Administrative_Tool__c();
        adminTool3.Quote_Type__c = 'Extended Coverage';
        adminTool3.Disclaimers__c = 'Daimler test disclaimer';
        adminTool3.Disclaimer_From_Date__c = dt;
        adminTool3.Disclaimer_To_Date__c = dt.addDays(-3);
        adminTool3.RecordTypeId = DIS_recordTypeId;
        INSERT adminTool3;
        
        Administrative_Tool__c adminTool4 = new Administrative_Tool__c();
        adminTool4.Quote_Type__c = 'Extended Coverage';
        adminTool4.Disclaimers__c = 'Daimler test disclaimer';
        adminTool4.Disclaimer_From_Date__c = dt;
        adminTool4.Disclaimer_To_Date__c = dt.addDays(3);
        adminTool4.RecordTypeId = DIS_recordTypeId;
        INSERT adminTool4;
        
        Administrative_Tool__c adminTool5 = new Administrative_Tool__c();
        adminTool5.Quote_Type__c = 'Extended Coverage';
        adminTool5.Disclaimers__c = 'Daimler test disclaimer';
        adminTool5.Disclaimer_From_Date__c = dt.addDays(-30);
        adminTool5.RecordTypeId = DIS_recordTypeId;
        INSERT adminTool5;
        
        QQ_AdminTool_Controller.validateDisclaimer(adminTool3);
        QQ_AdminTool_Controller.validateDisclaimer(adminTool4);
        QQ_AdminTool_Controller.validateDisclaimer(adminTool5);
        
        string before = 'Testing base 64 encode';
        Blob beforeblob = Blob.valueOf(before);
        string base64Data = EncodingUtil.base64Encode(beforeblob);
        
        string policyDesc = '97-Extended Coverage';
        string fileName = 'My File.jpg';
        string contentType = 'JPG';
        QQ_AdminTool_Controller.saveFile(fileName, base64Data, contentType, policyDesc);
    }
}