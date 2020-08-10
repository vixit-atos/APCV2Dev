/*------------------------------------------------------------------------------------------------
 * Class is test class of extension controller - TWS_OptyApprovalextensioncontroller. 
 * ----------------------------------------------------------------------------------------------
 * @author         Rahul Aggarwal   
 * @modifiedBy          
 * @version        1.0
 * @created        06-25-2018
 * @modified       MM-DD-YYYY
 * ---------------------------------------------------------------------------------------------*/
@isTest
public class TWS_OptyApprovalextensioncontroller_Test {

    public class wrapperClass {
        Id TestOptyid;
        Id TestItemId;
        Opportunity TestOppty;
    }


    static wrapperClass createOpportunityApproval() {
        Opportunity opty = new Opportunity(Name = 'TWSOptyApprovalextension');
        opty.StageName = 'Controlling Review';
        opty.CloseDate = system.today() + 1;
        opty.Amount = 100;
        opty.Probability = 10;
        opty.RecordtypeId = [Select Id from recordtype where SobjectType = 'Opportunity'
            and name = 'TWS-Dealer SP'
        ].Id;
        insert opty;
        TWS_Approver__c apprvr = new TWS_Approver__c(TWS_Approver__c = UserInfo.getUserId(), TWS_Deal__c = opty.id);
        insert apprvr;
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(opty.id);
        req1.setSubmitterId(UserInfo.getUserId());
        req1.setProcessDefinitionNameOrId('TWS_DSP_Approval');
        req1.setSkipEntryCriteria(true);
        Approval.ProcessResult result = Approval.process(req1);
        wrapperClass wrapObj = new wrapperClass();
        wrapObj.TestOptyid = opty.Id;
        wrapObj.TestItemId = result.getNewWorkitemIds()[0];
        wrapObj.TestOppty = opty;        
        return wrapObj;
    }

    public static testMethod void testApprove() {
        Test.startTest();
        wrapperClass testwrapObj = createOpportunityApproval();
        ApexPages.StandardController sc = new ApexPages.StandardController(testwrapObj.TestOppty);
        TWS_OptyApprovalextensioncontroller dtnaopty = new TWS_OptyApprovalextensioncontroller(sc);
        dtnaopty.OptyId = testwrapObj.TestOptyid;
        dtnaopty.itemid = testwrapObj.TestItemId;
        String nextPage = dtnaopty.Approve().getUrl();
        System.assertEquals('/home/home.jsp', nextPage);
        Test.stopTest();
    }

    public static testMethod void testReject() {
        Test.startTest();
        wrapperClass testwrapObj = createOpportunityApproval();
        ApexPages.StandardController sc = new ApexPages.StandardController(testwrapObj.TestOppty);
        TWS_OptyApprovalextensioncontroller dtnaopty = new TWS_OptyApprovalextensioncontroller(sc);
        dtnaopty.OptyId = testwrapObj.TestOptyid;
        dtnaopty.itemid = testwrapObj.TestItemId;
        String nextPage = dtnaopty.Reject().getUrl();
        System.assertEquals('/home/home.jsp', nextPage);
        Test.stopTest();
    }
    public static testMethod void testCancel() {
        Test.startTest();
        wrapperClass testwrapObj = createOpportunityApproval();
        ApexPages.StandardController sc = new ApexPages.StandardController(testwrapObj.TestOppty);
        TWS_OptyApprovalextensioncontroller dtnaopty = new TWS_OptyApprovalextensioncontroller(sc);
        dtnaopty.OptyId = testwrapObj.TestOptyid;
        dtnaopty.itemid = testwrapObj.TestItemId;
        String nextPage = dtnaopty.Cancel().getUrl();
        System.assertEquals('/home/home.jsp', nextPage);
        Test.stopTest();
    }

}