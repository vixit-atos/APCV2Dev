/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Purpose:
* This class for testing the DTNA_Quote_Activity_List  
* 
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Anto  
* @modifiedBy          
* @version        1.0
* @created        08-06-2017
* @modified       04-20-2018
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes 1.3
* modifiedBy      Anto      
* 04-20-2018      Supported the new functions
* 
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/

@isTest (SeeAllData=True)
public class DTNA_Quote_Activity_List_Test
{
    static testMethod void DTNA_Quote_Activity_List_Test()
    {
        Filter objFilter = new Filter(1,'Name',' = ','T12345');
        Filter objFilter1 = new Filter(2);
        Filter objFilter7 = new Filter(7,'Q1__C',' = ','50');
   //  	Filter objFilter8 = new Filter(8,'CloseDate__c',' = ','10-02-2018');
        
        List<Concession__c> lstConcs = new List<Concession__c>();
        
        Concession__c sobjConc1 = new Concession__c(Name='test',Q1__C = 20,Q2__c = 100,Q3__C = 40);
        Concession__c sobjConc2 = new Concession__c(Name='test5',Q1__C = 20,Q2__c = 100,Q3__C = 40);
        Concession__c sobjConc3 = new Concession__c(Name='test6',Q1__C = 30,Q2__c = 100,Q3__C = 40,Conc_Status_CD__C = 'RPC',SLS_DIST_CD__C = '7F');
        lstConcs.add(sobjConc1);
        lstConcs.add(sobjConc2);
        lstConcs.add(sobjConc3);
        insert lstconcs;
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(lstConcs);
        DTNA_Quote_Activity_List testQAController = new DTNA_Quote_Activity_List();
        testQAController.lstFilters.add(objFilter);
        testQAController.lstFilters.add(objFilter7);
 //       testQAController.lstFilters.add(objFilter8);
        testQAController.getConcessions();
        testQAController.Filter();
        testQAController.FilterClear();
        testQAController.Query();
        
        for (Concession__c sObjConc : (List<Concession__c>)sc.getRecords())
        {
            sObjConc.Miscellaneous_Comments__c=null;
            sObjConc.DOA_Comment_1__c=null;
            sObjConc.DOA_Comment_2__c=null;
            sobjConc.Q1__C = 15;
            sobjConc.Q2__C = 20;
          }

        testQAController.Save();

        for (Concession__c sObjConc : (List<Concession__c>)sc.getRecords())
        {
            sObjConc.Miscellaneous_Comments__c='test01';
            sObjConc.DOA_Comment_1__c='test02';
            sObjConc.DOA_Comment_2__c='test03';
            sobjConc.Q1__C = 15;
            sobjConc.Q2__C = 20;
        }
          testQAController.Save();
    PageReference pgref = Page.QuoteActivityConc_Excel;
    pgref.getParameters().put('Name','CONC NO');
    Test.setCurrentPage(pgref);
   
      testQAController.SelectedValues  = new list<String>{'Name'};
          List<Apexpages.Message> pageMessages = ApexPages.getMessages();
        testQAController.GenerateColSelectedExcel();
        testQAController.ExcelSelectionListDisplay();
        testQAController.ColSelectedExcel();
       // testQAController.Export();
        testQAController.ExcelCancel();
        testQAController.Save();
        testQAController.NewFilter();
        testQAController.intDelFilter = testQAController.intFilterAutoNumber;
        testQAController.FilterRemove();
        testQAController.lstFilters.add(objFilter1);
        testQAController.doCancel();
        testQAController.changeStageName();
        System.debug(testQAController.getConcessions());
        System.debug(testQAController.hasNext);
        System.debug(testQAController.hasPrevious);
        System.debug(testQAController.pageNumber);
        testQAController.first();
        testQAController.last();
        System.debug(testQAController.getQALastPageNumber());
        testQAController.previous();
        testQAController.next();
        testQAController.QApageNumber = 1;
        testQAController.GotoPage();
        testQAController.cancel();
        testQAController.openPage();
        testQAController.openPageMobile();
 //       DTNA_Quote_Activity_List.concwrapper asdf = DTNA_Quote_Activity_List.concwrapper(sobjConc1);
        testQAController.getItems();
        testQAController.RCUInquiryRequest();
        testQAController.getStrDTNow();
        testQAController.FilterClear();
        testQAController.lstFilters.add(objFilter);
        testQAController.SetDefaultFilter();
        testQAController.QueryAll();
        
        Filter objFilter2 = new Filter(1,'Name',' like ','12345');
        testQAController.FilterClear();
        testQAController.lstFilters.add(objFilter2);
        testQAController.QueryAll();
        
        Filter objFilter5 = new Filter(1,'In_Approval_Process__c',' = ','true');
        testQAController.FilterClear();
        testQAController.lstFilters.add(objFilter5);
        testQAController.Query();
        
        Filter objFilter3 = new Filter(1,'RQST_MIN_UNITS__c',' > ','1000');
        testQAController.FilterClear();
        testQAController.lstFilters.add(objFilter2);
        testQAController.lstFilters.add(objFilter3);
        testQAController.Query();
        
        Filter objFilter4 = new Filter(1,'Name',' = ','12345,12346,12347');
        testQAController.FilterClear();
        testQAController.lstFilters.add(objFilter4);
        testQAController.Query();
        
        Filter objFilter6 = new Filter(1,'RQST_MIN_UNITS__c',' < ','1000');
        testQAController.FilterClear();
        testQAController.lstFilters.add(objFilter2);
        testQAController.lstFilters.add(objFilter3);
        testQAController.Query();
        
         Filter objFilter9 = new Filter(1,'RQST_MIN_UNITS__c',' < ','0');
        testQAController.FilterClear();
        testQAController.lstFilters.add(objFilter9);
        testQAController.Query();
        
         Filter objFilter10 = new Filter(1,'In_Approval_Process__c',' = ','false');
        testQAController.FilterClear();
        testQAController.lstFilters.add(objFilter10);
        testQAController.Query();
        
        Filter objFilter8 = new Filter(1,'CloseDate__c',' = ','01-12-2018');
        testQAController.FilterClear();
        testQAController.lstFilters.add(objFilter8);
        testQAController.Query();
    }
}