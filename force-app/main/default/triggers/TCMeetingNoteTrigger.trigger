trigger TCMeetingNoteTrigger on TC_Meeting_Note__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
  system.debug('i am inside TCMeetingNoteTrigger');
    new TCMeetingNotesTriggerHandler().run();
     
}