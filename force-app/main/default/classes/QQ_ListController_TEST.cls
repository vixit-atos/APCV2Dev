@isTest
private class QQ_ListController_TEST
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
        
        ASP_QQ__c quoteobj = new ASP_QQ__c();
        quoteobj.Stage__c = 'Pending';
        quoteobj.Status__c = 'Pending for Validation';
        quoteobj.Domain__c = 'Extended Warranty';
        quoteobj.Source__c = 'Internal';
        quoteobj.Expiration_Date__c = Date.today();
        quoteobj.From_Date__c = Date.today();
        quoteobj.Customer_Name__c = acc.ID;
        quoteobj.FMV_Date__c = Date.today();
        
        ASP_QQ__c quoteobj2 = new ASP_QQ__c();
        quoteobj2.Stage__c = 'Pending';
        quoteobj2.Status__c = 'Pending for Validation';
        quoteobj2.Domain__c = 'Extended Warranty';
        quoteobj2.Source__c = 'Internal';
        quoteobj2.Coverage__c = 'DETROIT COVERAGE';
        quoteobj2.Expiration_Date__c = Date.today();
        quoteobj2.From_Date__c = Date.today();
        quoteobj2.Customer_Name__c = acc.ID;
        quoteobj2.FMV_Date__c = Date.today();
        
        ASP_QQ__c quoteobj3 = new ASP_QQ__c();
        quoteobj3.Stage__c = 'Pending';
        quoteobj3.Status__c = 'Pending for Validation';
        quoteobj3.Domain__c = 'Extended Warranty';
        quoteobj3.Source__c = 'Internal';
        quoteobj3.Expiration_Date__c = Date.today();
        quoteobj3.From_Date__c = Date.today();
        quoteobj3.Customer_Name__c = acc.ID;
        quoteobj3.FMV_Date__c = Date.today();
        
        ASP_QQ_Line_Item__c QLI = new ASP_QQ_Line_Item__c();
        QLI.Engine_Component__c = 'DD16';
        QLI.Coverage_Type__c = 'EXT CLUTCH';
        QLI.Option__c = 'EW1'; 
        QLI.Custom__c = false;
        QLI.Deductible__c = '';
        QLI.Databook_Code__c = '';
        List<ASP_QQ_Line_Item__c> lstQLI = new  List<ASP_QQ_Line_Item__c>();
        lstQLI.add(QLI);
        
        ASP_QQ_Line_Item__c QLI2 = new ASP_QQ_Line_Item__c();
        QLI2.Engine_Component__c = 'DD16';
        QLI2.Coverage_Type__c = 'EXT CLUTCH';
        QLI2.Option__c = 'EW1'; 
        QLI2.Custom__c = false;
        QLI2.Deductible__c = '';
        QLI2.Databook_Code__c = '';
        List<ASP_QQ_Line_Item__c> lstQLI2 = new  List<ASP_QQ_Line_Item__c>();
        lstQLI2.add(QLI2);
        
        ASP_QQ_Line_Item__c QLI3 = new ASP_QQ_Line_Item__c();
        QLI3.Engine_Component__c = 'DD16';
        QLI3.Coverage_Type__c = 'EXT CLUTCH';
        QLI3.Option__c = 'EW1'; 
        QLI3.Custom__c = false;
        QLI3.Deductible__c = '';
        QLI3.Databook_Code__c = '';
        List<ASP_QQ_Line_Item__c> lstQLI3 = new  List<ASP_QQ_Line_Item__c>();
        lstQLI3.add(QLI3);
        
        ASP_QQ_Line_Item__c QLI4 = new ASP_QQ_Line_Item__c();
        QLI4.Engine_Component__c = 'DD16';
        QLI4.Coverage_Type__c = 'EXT CLUTCH';
        QLI4.Option__c = 'EW1'; 
        QLI4.Custom__c = false;
        QLI4.Deductible__c = '';
        QLI4.Databook_Code__c = '';
        List<ASP_QQ_Line_Item__c> lstQLI4 = new  List<ASP_QQ_Line_Item__c>();
        lstQLI4.add(QLI4);
        
        List<Note> lstNote = new List<Note>();
        note nt = new note();
        nt.body='inserting note from code';
        nt.title='New Note from code';
        nt.isPrivate=false;
        lstNote.add(nt);
        
        List<Note> lstNote2 = new List<Note>();
        note nt2 = new note();
        nt2.body='inserting note from code';
        nt2.title='New Note from code';
        nt2.isPrivate=false;
        lstNote2.add(nt2);
        
        List<Note> lstNote3 = new List<Note>();
        note nt3 = new note();
        nt3.body='inserting note from code';
        nt3.title='New Note from code';
        nt3.isPrivate=false;
        lstNote3.add(nt3);
        
        List<Note> lstNote4 = new List<Note>();
        note nt4 = new note();
        nt4.body='inserting note from code';
        nt4.title='New Note from code';
        nt4.isPrivate=false;
        lstNote4.add(nt4);
        
        List<Note> lstNote5 = new List<Note>();
        note nt5 = new note();
        nt5.body='inserting note from code';
        nt5.title='New Note from code';
        nt5.isPrivate=false;
        lstNote5.add(nt5);
        
        QQ_ListController.getUserName();
        
        ASP_QQ__c ASP_QQ1 = QQ_ListController.submitquote(quoteobj, lstQLI, lstNote, '', false);
        ASP_QQ__c ASP_QQ2 = QQ_ListController.submitquote(quoteobj2, lstQLI2, lstNote2, '', false);
                
        string stagefilter = 'Pending';
        string statusfilter = 'Pending for Validation';
        string domain = 'Extended Warranty';
        string source = 'Internal';
        List<QQ_ListController.wrapperQQ> lstWQQ = QQ_ListController.getQuoteRecords(stagefilter, statusfilter, domain, source);
        
        string stagefilter2 = 'Complete';
        string statusfilter2 = 'Pending for Validation';
        string domain2 = 'Extended Warranty';
        string source2 = 'Internal';
        List<QQ_ListController.wrapperQQ> lstWQQ2 = QQ_ListController.getQuoteRecords(stagefilter2, statusfilter2, domain2, source2);
        
        string stagefilter3 = 'Complete';
        string statusfilter3 = 'Pending for Validation';
        string domain3 = 'Extended Warranty';
        string source3 = 'External';
        List<QQ_ListController.wrapperQQ> lstWQQ3 = QQ_ListController.getQuoteRecords(stagefilter3, statusfilter3, domain3, source3);
        
        string QuoteNum = [SELECT Name FROM ASP_QQ__c WHERE ID = :ASP_QQ1.ID].Name;
        system.debug('QuoteNum: ' + QuoteNum);
        ASP_QQ__c ASP_QQ3 = QQ_ListController.submitquote(quoteobj, lstQLI, lstNote3, QuoteNum, true);
        
        string QuoteNum2 = [SELECT Name FROM ASP_QQ__c WHERE ID = :ASP_QQ1.ID].Name;
        system.debug('QuoteNum: ' + QuoteNum2);
        ASP_QQ__c ASP_QQ4 = QQ_ListController.submitquote(quoteobj2, lstQLI2, lstNote4, QuoteNum2, true);
        
        string QuoteNum3 = [SELECT Name FROM ASP_QQ__c WHERE ID = :QQ.ID].Name;
        system.debug('QuoteNum: ' + QuoteNum3);
        ASP_QQ__c ASP_QQ5 = QQ_ListController.submitquote(QQ, lstQLI3, lstNote5, QuoteNum3, true);
              
        List<ID> QQIdlist = new List<ID>();
        QQIdlist.add(ASP_QQ1.ID);
        QQ_ListController.archiveRecords(QQIdlist);
        
        ASP_QQ__c ASP_QQ6 = QQ_ListController.external_ew_submitquote(quoteobj3 ,lstQLI4);
        
        
        Id PM_recordTypeId = Schema.SObjectType.Administrative_Tool__c.getRecordTypeInfosByName().get('Add New Admin Panel Value').getRecordTypeId();
        Administrative_Tool__c adm = new Administrative_Tool__c();
        adm.Field_Name__c = 'Engine Component';
        adm.Value__c = 'DD-TEST';
        adm.RecordTypeId = PM_recordTypeId;
        INSERT adm;
        
        string category = 'Engine Component';
        QQ_ListController.getItem(category);
        
        Id MR_recordTypeId = Schema.SObjectType.Administrative_Tool__c.getRecordTypeInfosByName().get('Create New Model Relationship').getRecordTypeId();
        Administrative_Tool__c adm2 = new Administrative_Tool__c();
        adm2.Group__c = 'HD';
        adm2.Model__c = 'Econic';
        adm2.RecordTypeId = MR_recordTypeId;
        INSERT adm2;
        
        string engineModel = 'Econic';
        QQ_ListController.getGroup(engineModel);
        
        string A85_Code = '';
        QQ_ListController.getModel(A85_Code);
        
        Id EC_recordTypeId = Schema.SObjectType.QQ_Master__c.getRecordTypeInfosByName().get('Detroit Coverage').getRecordTypeId();
        QQ_Master__c QQM = new QQ_Master__c();
        QQM.Name = 'TEST';
        QQM.Cost__c = 0;
        QQM.Price__c = 0;
        QQM.Months__c = 0;
        QQM.Miles__c = 0;
        QQM.Active__c = true;
        QQM.Publication_Status__c = 'PUBLISHED';
        QQM.RecordTypeId = EC_recordTypeId;
        INSERT QQM;
        
        QQ_ListController.getDuration_Details(string.valueOf(QQM.Id));
        
        string coverage = 'Detroit Coverage';
        QQ_ListController.getMasterLineitems(coverage);
        
        string recType = '';
        string appDesc = '';
        string engComp = '';
        string cvgType = '';
        string option = '';
        decimal ddtValue = 0;
        string model = '';
        string groups = '';
        string packages = '';
        string standalone = '';
        
        QQ_ListController.getDuration(recType, appDesc, engComp, cvgType, option, ddtValue, model, groups, packages, standalone);
        
        
        Id FMVD_recordTypeId = Schema.SObjectType.Administrative_Tool__c.getRecordTypeInfosByName().get('FMV Date').getRecordTypeId();
        Id ECED_recordTypeId = Schema.SObjectType.Administrative_Tool__c.getRecordTypeInfosByName().get('EC Expiration Date').getRecordTypeId();
        
        
        Date dt = Date.today();
        Administrative_Tool__c adm1 = new Administrative_Tool__c();
        adm1.FMV_Date__c = dt;
        adm1.RecordTypeId = FMVD_recordTypeId;
        INSERT adm1;
        
        dt = dt.addDays(5);
        Administrative_Tool__c adm3 = new Administrative_Tool__c();
        adm3.Expiration_Date__c = dt;
        adm3.RecordTypeId = ECED_recordTypeId;
        INSERT adm3;
        
        QQ_ListController.getFMVDate();
        QQ_ListController.getExpDate();
        
        string recordType = 'DETROIT COVERAGE';
        string UI_Type = 'EXTERNAL';
        QQ_ListController.getQQ_Master(recordType, UI_Type);
        recordType = 'TRUCK CHASSIS';
        UI_Type = 'INTERNAL';
        QQ_ListController.getQQ_Master(recordType, UI_Type);
        
        QQ_ListController.updateQuote(QQ, QuoteNum, 'ORDER');
        QQ_ListController.updateQuote(QQ, QuoteNum, 'GENERAL');
        
    }
}