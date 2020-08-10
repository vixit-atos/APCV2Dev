@isTest(SeeAllData=true)
public class CI_AttachmentListController_Test {
	static testMethod void TestProcess(){
    	ProcessInstanceWorkitem Approval = [SELECT id from ProcessInstanceWorkitem limit 1];
    	Test.startTest();
        CI_AttachmentListController.getAttachmentList(Approval.id);
        Test.stopTest();
    }
}