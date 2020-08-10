@isTest
public class QQ_MasterCoverage_TEST 
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
        
        List<ASP_QQ_Line_Item__c> quoteitemlst = new  List<ASP_QQ_Line_Item__c>();
        ASP_QQ_Line_Item__c QQL = new ASP_QQ_Line_Item__c();
        QQL.ASP_QQ__c = QQ.ID;
        QQL.A85_Code__c = 'A85 001 Refuse Service';
        QQL.Coverage__c = 'Detroit Engine';
        QQL.Engine_Component__c = 'DD16';
        QQL.Coverage_Type__c = 'EXT CLUTCH';
        QQL.Option__c = 'EW1'; 
        QQL.Usage__c = 'Vocational';  
        QQL.Custom__c = true;
        QQL.Deductible__c = '';
        QQL.Databook_Code__c = '';
        INSERT QQL;
        quoteitemlst.add(QQL);
        
        QQ_MasterCoverage MC = new QQ_MasterCoverage();
        MC.createRecord(quoteitemlst);
    }
}