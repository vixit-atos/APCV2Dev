trigger AttachmentTrigger on Attachment (before insert,before update,before delete,after insert,after update,after delete, 
  after undelete) {
  system.debug('i am inside AttachmentTrigger');
    new AttachmentTriggerHandler().run();

}