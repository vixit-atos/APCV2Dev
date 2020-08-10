trigger SalesContractApproverTrigger on Sales_Contract_Approver__c (before insert, before update, after insert, after update, after delete, after undelete) {
system.debug('i am inside SalesxContractApproverTrigger');
  new TWSSalesContractApproverTriggerHandler().run();
}