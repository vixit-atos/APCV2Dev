trigger privateAttachmentUpload on Attachment (after insert) {
    
    List<Private_Note__c> pnList = new List<Private_Note__c>();
    String pn_prefix = Schema.SObjectType.Private_Note__c.getKeyPrefix();
    String aParentId;
    Private_Note__c pn;
    
    for (Attachment a: Trigger.new) {
    
        if(a.ParentId != null) {
            
            aParentId = a.ParentId;
            if(aParentId.startsWith(pn_prefix)){
                pn = [select Name, Account__c, Account_RL__c, Contact__c, Contact_RL__c from Private_Note__c where id=:a.ParentId];
                system.debug('***************'+pn);
                if(pn.Name=='From me button')
                    pn.Name = a.Name;
                if(pn.Account__c != null)
                 pn.Account_RL__c = pn.Account__c;
                else
                  pn.Account__c = pn.Account_RL__c;
                system.debug('***************'+pn.Account__c+pn.Account__c);
                if(pn.Contact__c!=null)
                    pn.Contact_RL__c = pn.Contact__c;
                else
                    pn.Contact__c = pn.Contact_RL__c;
                pn.AttachmentID__c = a.id;
                pnList.add(pn);
                
            }
        }
        
    }
    update pnList;
}