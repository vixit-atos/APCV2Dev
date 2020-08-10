trigger TWSApproverTrigger on TWS_Approver__c (before insert, before update, after insert, after update, after delete, after undelete) {
system.debug('i am inside TWSApproverTrigger ');
  new TWSApproverTriggerHandler().run();
}