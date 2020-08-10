trigger ContentDocumentTrigger on ContentDocument (before insert, before update, after insert, after update, after delete, after undelete) {
new ContentDocumentTriggerHandler().run();
}