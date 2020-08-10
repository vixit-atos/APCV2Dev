trigger EmailmessageTrigger on EmailMessage (before insert, before update, after insert, after update, after delete, after undelete) {
     new EmailmessageTriggerHandler().run();
}