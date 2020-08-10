@isTest
public class DeleteDuplicatedApprover_Test {
	static testMethod void TestProcess(){
		Test.startTest();
        User preapprover =[select id,name from user where name='John O\'leary' Limit 1];
        List<Opportunity> oppList = new List<Opportunity>();
        Opportunity opp = new Opportunity(Name = 'o1sss', Related_TC_Deal__c=null,DTR_Requested_to_Quote_Residual__c = true, 
       	DTR_Requested_to_Quote_Trades__c = true, VEH_MAKE__c = 'FTL', 
        StageName = 'Initial Notification', CloseDate = Date.Today(), Preliminary_Approver__c = preapprover.Id);
        oppList.add(opp);
        DeleteDuplicatedApprover.ApproverDelete(oppList);            
    	Test.StopTest();
	}
}