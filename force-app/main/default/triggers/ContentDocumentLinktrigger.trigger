trigger ContentDocumentLinktrigger  on ContentDocumentLink (after insert,after delete,before delete,after update) {

String strTriggerToggle=Label.TriggerToggle;
if(strTriggerToggle=='True'){

new ContentDocumentLinktriggerHelper().run();
}

}