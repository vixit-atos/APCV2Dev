@isTest
public class QQ_Internal_EditQuote_TEST 
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
        
        //If Detroit Engine Coverage is selected, please enter values for engine component, application description, coverage type, and option.  Truck and Standalone data should not be entered.
        /*ASP_QQ_Duration_Master__c dur = new ASP_QQ_Duration_Master__c();
        dur.Name = 'ENE-013';
        dur.Coverage__c = 'DETROIT COVERAGE';
        dur.Engine_Component_1__c = 'DD16';
        //dur.Usage__c = 'On-Highway';
        dur.Option_1__c = 'EXT-NEXT EW4'; 
        dur.Coverage_Type_1__c = 'Extended Next';
        dur.Deductible__c = '0';
        dur.Active__c = true;
        dur.Publication_Status__c = 'Published';
        dur.FMV_Date__c = Date.today();
        dur.Months__c = 18;
        dur.Miles__c = 1233;
        dur.Price__c = 375;
        INSERT dur;            
		*/
        
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
        
        
        string QuoteNum = QQName.Name;
        
        QQ_Internal_EditQuote.getQuickQuote(QuoteNum);
        QQ_Internal_EditQuote.getLineItem(QuoteNum);        
        QQ_Internal_EditQuote.getAccount(QuoteNum);
        
    }
}