public class ContentDocumentTriggerHandler extends TriggerHandler{
    
    public ContentDocumentTriggerHandler(){
    } 
     
    protected override void afterdelete() {
         preventdeletingrecords();
    }
    

    private void preventdeletingrecords() {
        
        if ( trigger.isDelete ) {
        
        Set<ID> setContentDocument=Trigger.oldMap.keySet();
        List<ContentDocumentLink> lstContentDocumentLinksdelete=new List<ContentDocumentLink>();
       // for (ContentDocument objnewContentDocumentLink :(List<ContentDocument>) trigger.old) {
         //   setContentDocumentLinks.add(objnewContentDocumentLink.id);
        //}
        system.debug(setContentDocument);
        List<ContentDocumentLink> lstnewContentDocumentLinks=[select id,ContentDocumentId,LinkedEntityId,ShareType from ContentDocumentLink where ContentDocumentId in :setContentDocument ALL ROWS];

            for (ContentDocumentLink objnewContentDocumentLink :lstnewContentDocumentLinks) {
                system.debug('LinkedEntityId:::::::::::'+objnewContentDocumentLink.LinkedEntityId);
                system.debug('ShareType:::::::::::'+objnewContentDocumentLink.ShareType);
                string strLinkedEntityId;
                strLinkedEntityId =objnewContentDocumentLink.LinkedEntityId;
                
                if(strLinkedEntityId!=null){
                    // Opportunity and Tcmeeting objectids 
                    if(strLinkedEntityId.startsWith('006')){
                            if(Approval.isLocked(strLinkedEntityId)){
                              lstContentDocumentLinksdelete.add(objnewContentDocumentLink);
                              //objnewContentDocumentLink.adderror('insufficient privileges');
                        }
                    }
                }
            }
         for (ContentDocument objnewContentDocument :(List<ContentDocument>) trigger.old) {
            if(!lstContentDocumentLinksdelete.isempty()){
                            objnewContentDocument.adderror('File cannot be deleted as the deal is submitted for Approval');
                        }
        }
          

        }
        
   
    }   
    
}