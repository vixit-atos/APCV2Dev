trigger NotificationRecipientTrigger on Notification_Recipient__c (before insert, before update, after insert, after update, after delete, after undelete)  {
new NotificationRecipienttriggerHandler().run();
}