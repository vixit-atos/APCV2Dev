@isTest()
public class QQ_Approval_Controller_TEST 
{
    @isTest
    public static void runTest()
    {
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect/Customer').getRecordTypeId();
        
        Account acc = new Account();
        acc.Name = 'Detroit Engine';
       // acc.Vendor_Code__c = 'Test';
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
        
        ASP_QQ__c QQ2 = new ASP_QQ__c();
        QQ2.Stage__c = 'Pending';
        QQ2.Status__c = 'Pending for Validation';
        QQ2.Domain__c = 'Extended Warranty';
        QQ2.Source__c = 'Internal';
        QQ2.Expiration_Date__c = Date.today();
        QQ2.From_Date__c = Date.today();
        QQ2.Customer_Name__c = acc.ID;
        QQ2.FMV_Date__c = Date.today();
        INSERT QQ2;
        
        ASP_QQ__c QQ3 = new ASP_QQ__c();
        QQ3.Stage__c = 'Complete';
        QQ3.Status__c = 'Approved';
        QQ3.Quote_Type__c = 'Custom';
        QQ3.Domain__c = 'Extended Warranty';
        QQ3.Source__c = 'Internal';
        QQ3.Coverage__c = 'DETROIT COVERAGE';
        QQ3.Expiration_Date__c = Date.today();
        QQ3.From_Date__c = Date.today();
        QQ3.Customer_Name__c = acc.ID;
        QQ3.FMV_Date__c = Date.today();
        INSERT QQ3;
        
        ASP_QQ__c QQ4 = new ASP_QQ__c();
        QQ4.Stage__c = 'Complete';
        QQ4.Status__c = 'Approved';
        QQ4.Quote_Type__c = 'Custom';
        QQ4.Domain__c = 'Extended Warranty';
        QQ4.Source__c = 'Internal';
        QQ4.Coverage__c = 'TRUCK CHASSIS';
        QQ4.Expiration_Date__c = Date.today();
        QQ4.From_Date__c = Date.today();
        QQ4.Customer_Name__c = acc.ID;
        QQ4.FMV_Date__c = Date.today();
        INSERT QQ4;
          
        List<ASP_QQ_Line_Item__c> quoteitemlst = new  List<ASP_QQ_Line_Item__c>();
        ASP_QQ_Line_Item__c QQL = new ASP_QQ_Line_Item__c();
        QQL.ASP_QQ__c = QQ.ID;
        QQL.A85_Code__c = 'A85 001 Refuse Service';
        QQL.Coverage__c = 'DETROIT COVERAGE';
        QQL.Engine_Component__c = 'DD16';
        QQL.Coverage_Type__c = 'EXT CLUTCH';
        QQL.Option__c = 'EW1'; 
        //QQL.Usage__c = 'Vocational';               
        QQL.Custom__c = false;
        QQL.Months__c = 18;
        QQL.Miles__c = 1233;
        //QQL.Duration__c = dur.ID;
        //QQL.Custom_Duration__c = '8 yr / 1500k mi / 2414k km';
        QQL.Deductible__c = '';
        //QQL.Quote_Price__c = 0;
        QQL.Databook_Code__c = '';
        INSERT QQL;
        quoteitemlst.add(QQL);
        
        List<ASP_QQ_Line_Item__c> quoteitemlst2 = new  List<ASP_QQ_Line_Item__c>();
        ASP_QQ_Line_Item__c QQL2 = new ASP_QQ_Line_Item__c();
        QQL2.ASP_QQ__c = QQ2.ID;
        QQL2.A85_Code__c = 'A85 001 Refuse Service';
        QQL2.Coverage__c = 'TRUCK CHASSIS';
        QQL2.Engine_Component__c = 'DD16';
        QQL2.Coverage_Type__c = 'EXT CLUTCH';
        QQL2.Option__c = 'EW1'; 
        //QQL2.Usage__c = 'Vocational';               
        QQL2.Custom__c = false;
        QQL2.Months__c = 18;
        QQL2.Miles__c = 1233;
        //QQL2.Duration__c = dur.ID;
        //QQL2.Custom_Duration__c = '8 yr / 1500k mi / 2414k km';
        QQL2.Deductible__c = '';
        //QQL2.Quote_Price__c = 0;
        QQL2.Databook_Code__c = '';
        INSERT QQL2;
        quoteitemlst2.add(QQL2);
        
        
        ASP_QQ_Line_Item__c QQL3 = new ASP_QQ_Line_Item__c();
        QQL3.ASP_QQ__c = QQ3.ID;
        QQL3.A85_Code__c = 'A85 001 Refuse Service';
        QQL3.Coverage__c = 'TRUCK CHASSIS';
        QQL3.Engine_Component__c = 'DD16';
        QQL3.Coverage_Type__c = 'EXT CLUTCH';
        QQL3.Option__c = 'EW1'; 
        QQL3.Custom__c = false;
        QQL3.Months__c = 18;
        QQL3.Miles__c = 1233;
        QQL3.Deductible__c = '';
        QQL3.Databook_Code__c = '';
        INSERT QQL3;
        
        ASP_QQ_Line_Item__c QQL4 = new ASP_QQ_Line_Item__c();
        QQL4.ASP_QQ__c = QQ4.ID;
        QQL4.A85_Code__c = 'A85 001 Refuse Service';
        QQL4.Coverage__c = 'TRUCK CHASSIS';
        QQL4.Engine_Component__c = 'DD16';
        QQL4.Coverage_Type__c = 'EXT CLUTCH';
        QQL4.Option__c = 'EW1'; 
        QQL4.Custom__c = false;
        QQL4.Months__c = 18;
        QQL4.Miles__c = 1233;
        QQL4.Deductible__c = '';
        QQL4.Databook_Code__c = '';
        INSERT QQL4;
        
        
        Opportunity opp = new Opportunity();
        opp.StageName = 'Sourcing Demand';
        opp.CloseDate = Date.today();
        opp.AccountId = acc.ID;
        opp.Name = 'Test Opportunity Triggers';
        INSERT opp;
        
        List<Note> noteslist = new List<Note>();
        note n = new note();
        n.parentId= opp.ID;
        n.body='inserting note from code';
        n.title='New Note from code';
        n.isPrivate=false;
        INSERT n;
        noteslist.add(n);
        
        
        QQ_Master__c QQM = new QQ_Master__c();
        QQM.Name = 'TEST';
        QQM.Cost__c = 0;
        QQM.Price__c = 0;
        QQM.Months__c = 0;
        QQM.Miles__c = 0;
        //QQM.Duration__c = 0;
        INSERT QQM;
        
        
        ID masterid = QQM.ID;
        Decimal price = 0.0;
        string databook = QQM.Name;
        QQ_Approval_Controller.updateMaster(masterid, price, databook);
        QQ_Approval_Controller.createMaster(QQL3);
        QQ_Approval_Controller.createMaster(QQL4);
		        
        ASP_QQ__c quoteobj = QQ;
        ID quoteid = QQ.ID;
        ID quoteid2 = QQ2.ID;
        QQ_Approval_Controller.getstandardPrice(quoteid);
        QQ_Approval_Controller.getstandardPrice(quoteid2);
        QQ_Approval_Controller.customApproval(quoteobj, quoteitemlst, noteslist);
        QQ_Approval_Controller.getPillar(quoteid);
        QQ_Approval_Controller.getPillar(quoteid2);
        QQ_Approval_Controller.getQQPricehistory(quoteid);
        QQ_Approval_Controller.getQQPricehistory(quoteid2);
        QQ_Approval_Controller.getQuotedata(quoteid);        
        
        QQ_Approval_Controller.wrapperQQ WQQ = new QQ_Approval_Controller.wrapperQQ();
    }
}