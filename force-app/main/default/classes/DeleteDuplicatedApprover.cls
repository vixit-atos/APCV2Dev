public without sharing class DeleteDuplicatedApprover {
	@InvocableMethod
	public static void ApproverDelete(List<Opportunity> Opportunities){
        List<TWS_Approver__c> oppApproverDelList  = new List<TWS_Approver__c>();
        for (Opportunity opp : Opportunities){
    		oppApproverDelList.addAll([select id, TWS_Deal__c from TWS_Approver__c where TWS_Deal__c =: opp.id and TWS_Approver__c =: opp.Preliminary_Approver__c ]);
        }
        delete oppApproverDelList;
   	}
}