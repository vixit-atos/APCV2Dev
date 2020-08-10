@isTest(SeeAllData=True)
public class DTNA_INQ_Inquiry_List_Test
{
    static testMethod void DTNA_INQ_Inquiry_List_Test()
    {
   //     Concession__c testConcession = new Concession__c(name = 'T12345');
      //  insert testConcession;
     //   testConcession = [select Id from concession__C where name ='T12345' limit 1];
     //   testConcession = [select Id from concession__C where name ='2H7795' limit 1];
        
        PageReference pageRef = Page.DTNAConcessionInquiryMobile;
        //pageRef.getParameters().put('id', String.valueOf(Concession__c.Id));
        //pageRef.getParameters().put('id', String.valueOf(testConcession.Id));
        Test.setCurrentPage(pageRef);
        
        List<Concession__c> lstConc = new List<Concession__c>();
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(lstConc);
        DTNA_INQ_Inquiry_List testINQController = new DTNA_INQ_Inquiry_List(sc);
        testINQController.obj_Conc.CONC_STATUS_CD__c = 'ALL';
        
// This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new DTNA_RCU_WebServiceMockImpl());
        
        testINQController.RCUInquiryRequest();
        testINQController.getConcStatus();
        testINQController.RCUInquiryQueryRequest();
        testINQController.datetoString(System.Today());
        testINQController.dateConverion('12122015');
        testINQController.getOutput();
     //   testINQController.datetoStringformat();
     //   testRCUController.CalcTranChanges();
    //    testRCUController.CalcOnChangedConcAmt(); 
    //    testRCUController.returnPage();
        
        // Call the method that invokes a callout
    /*    List<String> listInput = new List<String>();
        listInput.add('12345');
        listInput.add(' ');
        listInput.add('');
        DTNA_IMS_RCU_Concession_Request.IMS_RCU_Concession_Request(listInput);
       // System.debug('#' + output.split('\n')[4] + '#');
        // Verify that a fake result is returned
       // System.assertEquals(' INVALID ACTION, CONC IS EXPIRED. ', output.split('\n')[4]);
        listInput = new List<String>();
        listInput.add('12345');
        listInput.add('R');
        listInput.add('Hello');
        DTNA_IMS_RCU_Concession_Request.IMS_RCU_Concession_Request(listInput);*/
    }
}