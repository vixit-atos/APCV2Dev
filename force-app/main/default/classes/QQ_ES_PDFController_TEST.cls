@isTest
public class QQ_ES_PDFController_TEST
{
    @isTest
    public static void runTest()
    {
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect/Customer').getRecordTypeId();
        
        Account acc = new Account();
        acc.Name = 'Daimler';
        acc.RecordTypeId = RecordTypeId;
        INSERT acc;
        
        string before = 'Testing base 64 encode';
        Blob beforeblob = Blob.valueOf(before);
        string base64Data = EncodingUtil.base64Encode(beforeblob);
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        Attachment attach1 = new Attachment();
        attach1.parentId = acc.Id;
        attach1.Body = EncodingUtil.base64Decode(base64Data);
        attach1.Name = 'Policy Manual-1.jpg';
        attach1.ContentType = 'image/jpeg';
        attach1.Description = '95-Extended Coverage';
        INSERT attach1;
        
        Attachment attach2 = new Attachment();
        attach2.parentId = acc.Id;
        attach2.Body = EncodingUtil.base64Decode(base64Data);
        attach2.Name = 'Policy Manual-2.jpg';
        attach2.ContentType = 'image/jpeg';
        attach2.Description = '95-Extended Coverage';
        INSERT attach2;
        
        Attachment attach3 = new Attachment();
        attach3.parentId = acc.Id;
        attach3.Body = EncodingUtil.base64Decode(base64Data);
        attach3.Name = 'Policy Manual-3.jpg';
        attach3.ContentType = 'image/jpeg';
        attach3.Description = '95-Extended Coverage';
        INSERT attach3;
        
        ASP_QQ__c QQ = new ASP_QQ__c();
        QQ.Stage__c = 'Pending';
        QQ.Status__c = 'Pending for Validation';
        QQ.Domain__c = 'Extended Warranty';
        QQ.Source__c = 'Internal';
        QQ.Expiration_Date__c = Date.today();
        QQ.From_Date__c = Date.today();
        QQ.Customer_Name__c = acc.ID;
        QQ.FMV_Date__c = Date.today();
        INSERT QQ;
        
        ASP_QQ__c QQName = [SELECT Id, Name FROM ASP_QQ__c WHERE Id = : QQ.Id];
        System.debug('TEST-Record Name: ' + QQName.Name);
                
        ASP_QQ_Line_Item__c QQL = new ASP_QQ_Line_Item__c();
        QQL.ASP_QQ__c = QQ.ID;
        QQL.A85_Code__c = 'A85 001 Refuse Service';
        QQL.Coverage__c = 'DETROIT COVERAGE';
        QQL.Engine_Component__c = 'DD16';
        QQL.Coverage_Type__c = 'EXT CLUTCH';
        QQL.Option__c = 'EW1'; 
        QQL.Usage__c = 'Vocational';               
        QQL.Custom__c = false;
        QQL.Master_Coverage__c = '';
        //QQL.Custom_Duration__c = '8 yr / 1500k mi / 2414k km';
        QQL.Deductible__c = '';
        //QQL.Quote_Price__c = 0;
        QQL.Databook_Code__c = '';
        INSERT QQL;
        
        QQL = new ASP_QQ_Line_Item__c();
        QQL.ASP_QQ__c = QQ.ID;
        QQL.A85_Code__c = 'A85 001 Refuse Service';
        QQL.Coverage__c = 'Truck Chassis';
        QQL.Engine_Component__c = 'DD16';
        QQL.Coverage_Type__c = 'EXT CLUTCH';
        QQL.Option__c = 'EW1'; 
        QQL.Usage__c = 'Vocational';               
        QQL.Custom__c = false;
        QQL.Master_Coverage__c = '';
        //QQL.Custom_Duration__c = '8 yr / 1500k mi / 2414k km';
        QQL.Deductible__c = '';
        //QQL.Quote_Price__c = 0;
        QQL.Databook_Code__c = '';
        INSERT QQL;
        
        QQL = new ASP_QQ_Line_Item__c();
        QQL.ASP_QQ__c = QQ.ID;
        QQL.A85_Code__c = 'A85 032 Shuttle Bus';
        QQL.Coverage__c = 'Truck Chassis';
        QQL.Engine_Component__c = 'DD16';
        QQL.Coverage_Type__c = 'EXT CLUTCH';
        QQL.Option__c = 'EW1'; 
        QQL.Usage__c = 'Vocational';               
        QQL.Custom__c = false;
        QQL.Master_Coverage__c = '';
        //QQL.Custom_Duration__c = '8 yr / 1500k mi / 2414k km';
        QQL.Deductible__c = '';
        //QQL.Quote_Price__c = 0;
        QQL.Databook_Code__c = '';
        INSERT QQL;
        
        QQ_ES_PDFController.recordID = QQName.Name;
        QQ_ES_PDFController obj = new QQ_ES_PDFController();
        QQ_ES_PDFController.recordID = QQName.Name;
        obj = new QQ_ES_PDFController();
        QQ_ES_PDFController.recordID = QQName.Name;
        obj = new QQ_ES_PDFController();
        
        
        Date dt = Date.today();
        
        ASP_QQ__c QQAdmin = new ASP_QQ__c();
        QQAdmin.Stage__c = 'Pending';
        QQAdmin.Status__c = 'Pending for Validation';
        QQAdmin.Domain__c = 'Extended Warranty';
        QQAdmin.Source__c = 'Internal';
        QQAdmin.Expiration_Date__c = dt.addDays(4);
        QQAdmin.From_Date__c = Date.today();
        QQAdmin.Customer_Name__c = acc.ID;
        QQAdmin.FMV_Date__c = dt.addDays(1);
        QQAdmin.Mgmt_Approved_On__c = dt.addDays(3);
        INSERT QQAdmin;
        
        DateTime dt2 = DateTime.now();
        Id DIS_recordTypeId = Schema.SObjectType.Administrative_Tool__c.getRecordTypeInfosByName().get('PDF Disclaimer Management').getRecordTypeId();
        Administrative_Tool__c admin = new Administrative_Tool__c();
        admin.Disclaimers__c = 'Test-Disclaimer';
        admin.Disclaimer_From_Date__c = dt2.addDays(-2);
        admin.Disclaimer_To_Date__c = dt2.addDays(5);
        admin.Quote_Type__c = 'Extended Coverage';
        admin.RecordTypeId = DIS_recordTypeId;
        INSERT admin;
        
        obj.getDisclaimer('EXTERNAL', QQAdmin);
        obj.getDisclaimer('INTERNAL', QQAdmin);
    }
}