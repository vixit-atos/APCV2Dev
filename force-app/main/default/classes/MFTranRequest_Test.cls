@isTest(SeeAllData=True)
public class MFTranRequest_Test
{
    static testMethod void MFTranRequest_Test()
    {
        
        PageReference pageRef = Page.MFTranRequest;
        Test.setCurrentPage(pageRef);
        
        List<Concession__c> lstConc = new List<Concession__c>();
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(lstConc);
        MFTranRequest MFTranReq = new MFTranRequest();
        
       
        MFTranReq.MFTranSubmit();
    }
}