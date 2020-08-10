trigger PrivateActivityTrigger  on Private_Activity__c (before insert, before update, after insert, after update, after delete, after undelete)  {
  new PrivateActivityTriggerHandler().run();
}