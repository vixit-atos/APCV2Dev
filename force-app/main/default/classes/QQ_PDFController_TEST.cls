@isTest
public class QQ_PDFController_TEST 
{
    @isTest
    public static void runTest()
    {
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect/Customer').getRecordTypeId();
        
        Account acc = new Account();
        acc.Name = 'Daimler';
        acc.RecordTypeId = RecordTypeId;
        INSERT acc;
        
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
        
        ASP_QQ_Duration_Master__c dur = new ASP_QQ_Duration_Master__c();
        dur.Name = '';
        dur.Coverage__c = 'DETROIT ENGINE';
        dur.Deductible__c = '300';
        dur.Active__c = true;
        dur.Publication_Status__c = 'Published';
        dur.FMV_Date__c = Date.today();
        dur.Engine_Component__c = 'DD16';
        dur.Option__c = 'EW1';
        dur.Coverage_Type__c = 'EXT CLUTCH';
        dur.Usage__c = 'TBB';
        dur.Miles__c = 500;
        INSERT dur;            
        
        ASP_QQ_Line_Item__c QQL = new ASP_QQ_Line_Item__c();
        QQL.ASP_QQ__c = QQ.ID;
        QQL.A85_Code__c = 'A85 001 Refuse Service';
        QQL.Coverage__c = 'DETROIT ENGINE';
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
        QQL.Coverage__c = 'FCCC';
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
        
        QQ_PDFController.recordID = QQName.Name;
        QQ_PDFController obj = new QQ_PDFController();
        QQ_PDFController.recordID = QQName.Name;
        obj = new QQ_PDFController();
        QQ_PDFController.recordID = QQName.Name;
        obj = new QQ_PDFController();
        /*
        Date dt = Date.today();
        Date dt1 = dt.addMonths(1);
        Date dt2 = dt.addMonths(2);
        Date dt3 = dt.addMonths(3);
        Date dt4 = dt.addMonths(4);
        Date dt5 = dt.addMonths(5);
        Date dt6 = dt.addMonths(6);
        Date dt7 = dt.addMonths(7);
        Date dt8 = dt.addMonths(8);
        Date dt9 = dt.addMonths(9);
        Date dt10 = dt.addMonths(10);
        Date dt11 = dt.addMonths(11);
        Date dt12 = dt.addMonths(12);
        obj.getMonth(dt1);
        obj.getMonth(dt2);
        obj.getMonth(dt3);
        obj.getMonth(dt4);
        obj.getMonth(dt5);
        obj.getMonth(dt6);
        obj.getMonth(dt7);
        obj.getMonth(dt8);
        obj.getMonth(dt9);
        obj.getMonth(dt10);
        obj.getMonth(dt11);
        obj.getMonth(dt12);
*/
    }
}