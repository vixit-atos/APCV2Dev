trigger ContactTrigger  on Contact (before insert, before update, after insert, after update,before delete, after delete, after undelete)  {
  new ContactTriggerHandler().run();
}