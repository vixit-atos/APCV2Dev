@isTest(SeeAllData=True)
public class DTNA_CUA_AddNewConcession_Test{
    static testMethod void DTNA_RCU_Inquiry_Request_Test()
    {
        Concession__c testConcession = new Concession__c(name = 'T12345');
        insert testConcession;
        //testConcession = [select Id from concession__C where name ='T12345' limit 1];
        //   testConcession = [select Id from concession__C where name ='2H7795' limit 1];
        
        PageReference pageRef = Page.DTNAAddNewConcession;
        //pageRef.getParameters().put('id', String.valueOf(Concession__c.Id));
        pageRef.getParameters().put('id', String.valueOf(testConcession.Id));
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(testConcession);
        DTNA_CUA_AddNewConcession testRCUController = new DTNA_CUA_AddNewConcession(sc);
        
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new DTNA_RCU_WebServiceMockImpl());
        
        testRCUController.obj_Conc.LEAD_CONC_NO__c = '5K9079';
        testRCUController.obj_Conc.EST_DLR_PROF__c = 100000;
        testRCUController.obj_Conc.Dealer_Code__c = 'BCFD';
        testRCUController.obj_Conc.CONT_PRSN_NAME_42__c = 'James KM';
        testRCUController.obj_Conc.CUST_NAME_50__c = 'Test Name';
        testRCUController.obj_Conc.VEH_MDL_NO__c = 'PT126SLP';
        testRCUController.obj_Conc.VEH_BASE_MDL_NO__c = 'PT126064S T';
        testRCUController.obj_Conc.CMPTR_CD__c = 'PET';
        testRCUController.obj_Conc.RQST_MIN_UNITS__c = 1;
        testRCUController.obj_Conc.RQST_MAX_UNITS__c = 2;
        testRCUController.obj_Conc.CURR_FREIGHT__c = 300000;
        testRCUController.obj_Conc.DLR_NET_PRC__c = 500000;
        testRCUController.obj_Conc.TOT_MIN__c = 1;
        testRCUController.obj_Conc.TOT_MAX__c = 2;
        testRCUController.obj_Conc.RQST_CONC_PCT__c = 10.00;
        testRCUController.obj_Conc.DATE_DELV_RQST__c = Date.Today();
        testRCUController.obj_Conc.DATE_LATEST_ACCEPT__c = Date.Today();
        testRCUController.obj_Conc.REQ_PRICELVL__c = '18k';
        testRCUController.obj_Conc.CURR_DN_COST__c = 600000;
        testRCUController.obj_Conc.CURR_SELL_PRC__c = 700000;
        testRCUController.obj_Conc.CURR_TOT_SELL_PRC__c = 100000;
        testRCUController.obj_Conc.APPR_NET_CNTRB__c = 2655500;
        testRCUController.obj_Conc.APPR_CONC_PCT__c = 10.00;
        testRCUController.CalcOnChangedConcPct();
        testRCUController.CalcOnChangedConcAmt();
        testRCUController.CalcOnChangedAprConcPct();
        testRCUController.CalcOnChangedAprConcAmt();
        testRCUController.CalcTranChanges();
        try
        {
        testRCUController.save();
        }
        Catch(Exception e)
        {
            system.debug(e);
        }
        
    }
    
    
}