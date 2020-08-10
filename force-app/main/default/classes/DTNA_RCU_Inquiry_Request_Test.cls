@isTest(SeeAllData=True)
public class DTNA_RCU_Inquiry_Request_Test
{
    static testMethod void DTNA_RCU_Inquiry_Request_Test()
    {
      	Concession__c testConcession = new Concession__c(name = 'T12345');
        insert testConcession;
        testConcession = [select Id from concession__C where name ='T12345' limit 1];

        //   testConcession = [select Id from concession__C where name ='2H7795' limit 1];
        
        PageReference pageRef = Page.DTNAConcessionLive;
        //pageRef.getParameters().put('id', String.valueOf(Concession__c.Id));
        pageRef.getParameters().put('id', String.valueOf(testConcession.Id));
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(testConcession);
        DTNA_RCU_Inquiry_Request testRCUController = new DTNA_RCU_Inquiry_Request(sc);
        
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new DTNA_RCU_WebServiceMockImpl());
        
        testRCUController.RCUInquiryRequest();
        testRCUController.RCUApprovalRequest();
        testRCUController.RCURejectionRequest();
        testRCUController.datetoString(System.Today());
        testRCUController.CalcOnChangedConcPct();
        testRCUController.CalcOnChangedAprConcPct();
        testRCUController.CalcOnChangedConcAmt();
        testRCUController.CalcTranChanges();
        testRCUController.CalcOnChangedConcAmt(); 
        testRCUController.SaveComment();
        testRCUController.NewComment();
        testRCUController.SaveComment();
        testRCUController.DeleteComment();
        testRCUController.saveRecord();
        testRCUController.Submitforapproval();
        testRCUController.Recallapprovalrequest();
        system.debug(testRCUController.getFields());
        
        testRCUController.returnPage();
        testRCUController.CalcOnChangedAprConcAmt();
        testRCUController.RCUUpdateRequest();
        testRCUController.RCUVoidRequest();
        testRCUController.CUACopyRequest();
        testRCUController.RCUCancelRequest();
        
        testRCUController.CUADealEditRequest();
        testRCUController.RCUReplaceRequest();
        testRCUController.ReloadRCUPage();
        testRCUController.ReloadMobileRCUPage();
        testRCUController.ReloadConcLivePage();
        testRCUController.getOutput();
         
        
        // Call the method that invokes a callout
        /*     List<String> listInput = new List<String>();
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
    
    static testMethod void DTNA_RCU_Inquiry_Request_FCC_Test()
    {
               
        Concession__c testConcession = new Concession__c(name = 'T12345');
        insert testConcession;
        testConcession = [select Id from concession__C where name ='T12345' limit 1];
        //   testConcession = [select Id from concession__C where name ='2H7795' limit 1];
        
        PageReference pageRef = Page.DTNAConcessionLive;
        //pageRef.getParameters().put('id', String.valueOf(Concession__c.Id));
        pageRef.getParameters().put('id', String.valueOf(testConcession.Id));
        Test.setCurrentPage(pageRef);
               
        ApexPages.StandardController sc = new ApexPages.StandardController(testConcession);
        DTNA_RCU_Inquiry_Request testRCUController = new DTNA_RCU_Inquiry_Request(sc);
        testRCUController.isCUA = false;
               
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new DTNA_RCU_WebServiceMockImpl());
        
        testRCUController.RCUInquiryRequest();
        testRCUController.RCUApprovalRequest();
        testRCUController.RCURejectionRequest();
        testRCUController.datetoString(System.Today());
        testRCUController.CalcOnChangedConcPct();
        testRCUController.CalcOnChangedAprConcPct();
        testRCUController.CalcOnChangedConcAmt();
        testRCUController.CalcTranChanges();
        testRCUController.CalcOnChangedConcAmt(); 
        testRCUController.SaveComment();
        testRCUController.NewComment();
        testRCUController.SaveComment();
        testRCUController.DeleteComment();
        testRCUController.saveRecord();
        testRCUController.Submitforapproval();
        testRCUController.Recallapprovalrequest();
        system.debug(testRCUController.getFields());
		
        testRCUController.isCUA = true;
        testRCUController.returnPage();
        testRCUController.CalcOnChangedAprConcAmt();
        testRCUController.RCUUpdateRequest();
        testRCUController.RCUVoidRequest();
        testRCUController.CUACopyRequest();
        testRCUController.RCUCancelRequest();
        
        testRCUController.CUADealEditRequest();
        testRCUController.RCUReplaceRequest();
        testRCUController.ReloadRCUPage();
        testRCUController.ReloadMobileRCUPage();
        testRCUController.ReloadConcLivePage();
        testRCUController.getOutput();
            
        
        
    }
     static testMethod void DTNA_CUA_Inquiry_Request_Test()
    {
    
        Concession__c testConcession = new Concession__c(name = 'T12345');
        insert testConcession;
        testConcession = [select Id from concession__C where name ='T12345' limit 1];
        //   testConcession = [select Id from concession__C where name ='2H7795' limit 1];
        
        PageReference pageRef = Page.DTNAConcessionLive;
        //pageRef.getParameters().put('id', String.valueOf(Concession__c.Id));
        pageRef.getParameters().put('id', String.valueOf(testConcession.Id));
        Test.setCurrentPage(pageRef);
               
        ApexPages.StandardController sc = new ApexPages.StandardController(testConcession);
        DTNA_RCU_Inquiry_Request testRCUController = new DTNA_RCU_Inquiry_Request(sc);
      //  testRCUController.isCUA = false;
     
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new DTNA_RCU_WebServiceMockImpl());
        
        testRCUController.RCUInquiryRequest();
        testRCUController.RCUApprovalRequest();
        testRCUController.RCURejectionRequest();
        testRCUController.datetoString(System.Today());
        testRCUController.CalcOnChangedConcPct();
        testRCUController.CalcOnChangedAprConcPct();
        testRCUController.CalcOnChangedConcAmt();
        testRCUController.CalcTranChanges();
        testRCUController.CalcOnChangedConcAmt(); 
        testRCUController.SaveComment();
        testRCUController.NewComment();
        testRCUController.SaveComment();
        testRCUController.DeleteComment();
        testRCUController.saveRecord();
        testRCUController.Submitforapproval();
        testRCUController.Recallapprovalrequest();
        system.debug(testRCUController.getFields());
        testRCUController.returnPage();
        testRCUController.CalcOnChangedAprConcAmt();
        testRCUController.RCUUpdateRequest();
        testRCUController.RCUVoidRequest();
        testRCUController.CUACopyRequest();
        testRCUController.RCUCancelRequest();
        testRCUController.CUADealEditRequest();
        testRCUController.RCUReplaceRequest();
        testRCUController.ReloadRCUPage();
        testRCUController.ReloadMobileRCUPage();
        testRCUController.groupcode = 'CN';
        testRCUController.screen = 'CSCNCUA';
        testRCUController.isRCUandCUA = true;       
        testRCUController.ReloadConcLivePage();
        testRCUController.getOutput(); 
        
        
    }
}