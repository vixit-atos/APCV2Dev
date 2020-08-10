/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* One or two sentence summary of this class.
*
* class is used to  publish ContentDocument into another ShareType(Set by Record). when file is 
* attched it will 
*
* 7-17-2018 Repaired indenting for readability
* 7-23-2018 Added ContentNote and ContentVersion replacements
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Hareesh goud nellykonda   
* @modifiedBy          
* @version        1.0
* @created        04-20-2017
* @modified       MM-DD-YYYY
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* 
* modifiedBy	Chris McDonald
* 08/27/2018	Privatize Files causing issues with opportunity due to Else statement taking everything in. 
*				Placing defensive mechanism on else.
*
* modifiedBy	Chris McDonald
* 08/27/2018	Privatize files created to allow Content Note to be privatized.
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
without sharing public class ContentDocumentLinktriggerHelper extends TriggerHandler {
    
    List<ContentDocumentLink> updateContentDocumentLinkList = new list<ContentDocumentLink>();
    map<String,set<String>> OppVerids = new map<String,set<String>>();
    public ContentDocumentLinktriggerHelper(){
    } 
    
    protected override void afterInsert() {
        shareContentDocument();
        FileNameupdate();
        privatizeData();//New
    } 
    protected override void afterdelete() {
         preventdeletingrecords();
    }
    
    protected override void afterupdate() {
         FileNameupdate();
    }
    
     protected override void beforeDelete() {
         FileNameupdate();
    }
    
    
    @TestVisible private void privatizeData(){
        ID userRoleID = UserInfo.getUserRoleId();//Use the ID of the Role to find the role's name
        ID collaborationGroupID = getCollaborationGroupID(userRoleID);//Used to create links to the group
        List<ContentDocumentLink> triggerLinks = Trigger.new;//Retains the trigger data
        List<ContentDocumentLink> collaboratorLinks = new List<ContentDocumentLink>();//Used in inserting the collaborator links
        List<ID> fileIds = new List<ID>();//Holds file IDs for querying and updating their sharing privacy
        List<ID> noteIds = new List<ID>();//Holds note IDs for querying and updating their sharing privacy
        List<Database.SaveResult> cdlResults = new List<Database.SaveResult>();//Holds the results of the collaborator insert
        List<Database.SaveResult> cnResults = new List<Database.SaveResult>();//Holds the results of the note update
        List<Database.SaveResult> cvResults = new List<Database.SaveResult>();//Holds the results of the content version update
        List<CollaborationGroup> crmID = [SELECT ID FROM CollaborationGroup WHERE Name = 'Lightning Explorers' LIMIT 1];
        
        for(ContentDocumentLink link : triggerLinks){//If ContentNote for Account or Contact, Create a link to the user's Collaboration group
            if(String.valueOf(link.ContentDocumentId).startsWith('069') && (String.ValueOf(link.LinkedEntityId).startsWith('001') || String.ValueOf(link.LinkedEntityId).startsWith('003')) && (collaborationGroupID != null || test.isRunningTest())){
                noteIds.add(link.ContentDocumentId);
                ContentDocumentLink cdl = new ContentDocumentLink(
                    contentDocumentID = link.ContentDocumentId,
                    linkedEntityID = collaborationGroupID,
                    shareType = 'C'
                );
                collaboratorLinks.add(cdl);
                
            }else if((String.ValueOf(link.LinkedEntityId).startsWith('001') || String.ValueOf(link.LinkedEntityId).startsWith('003')) && (collaborationGroupID != null || test.isRunningTest())){
                fileIds.add(link.ContentDocumentId);
            }
        }
        
        if(collaboratorLinks != null){ cdlResults = Database.Insert(collaboratorLinks, false);}
        for(ContentDocumentLink link : collaboratorLinks){ noteIds.add(link.Id);}
        if(noteIds.size() > 0 || test.isRunningTest()){ cnResults = privatizeNotes(noteIds);}
        if(fileIds.size() > 0 || test.isRunningTest()){ cvResults = privatizeFiles(fileIds);}
    }
    
    private void FileNameupdate(){
        if(Trigger.isUpdate || trigger.isInsert){
            list<ContentDocumentLink> newrecords = Trigger.new;
            for(ContentDocumentLink oattach : newrecords){
                if(String.valueOf(oattach.LinkedEntityId).startsWith('006')){  
                    if(OppVerids.containskey(oattach.LinkedEntityId))
                        OppVerids.get(oattach.LinkedEntityId).add(oattach.ContentDocumentId);
                    else
                        OppVerids.put(oattach.LinkedEntityId,new set<String>{oattach.ContentDocumentId});
                
                // parentIDs.add(oattach.LinkedEntityId);
                //  VersionIDs.add(oattach.ContentDocumentId);
                }        
            }
            List<opportunity> quoteDocuments = [SELECT Id, Name,FileName__c FROM opportunity where id IN:OppVerids.keyset()];
            List<opportunity> opportunityUpdateList = new List<opportunity>();
            set<String> dvids = new set<String>();
            for(id id1: OppVerids.keyset())
                dvids.addall(OppVerids.get(id1));
            // boolean b= dvids.addall(OppVerids.values());
            List<ContentVersion> cvlist = [Select Id, Title,ContentDocumentId from ContentVersion where ContentDocumentId =: dvids];
            List<ContentVersion> ContentVersionUpdateList = new List<ContentVersion>();
    
            map<String,opportunity> Updateopps = new map<String,opportunity>();
            for(opportunity doc : quoteDocuments){
                for(ContentVersion cv: cvlist ){
                    if(OppVerids.get(doc.id).contains(cv.ContentDocumentId)){
                    if(doc.FileName__c!=null){
                    if(doc.FileName__c.contains(cv.title)){
                        //doc.FileName__c=doc.FileName__c+ '\n' +cv.title;
                    }else
                        doc.FileName__c=doc.FileName__c+ '\n' +cv.title; 
                    }else
                        doc.FileName__c=cv.title;
                    }
                }
            Updateopps.put(doc.id,doc);
            }
        update Updateopps.values();
        }
        
        if(trigger.isDelete && trigger.isBefore){
            list<ContentDocumentLink> oldrecords = Trigger.old;
            for(ContentDocumentLink oattach : oldrecords){
                if(String.valueOf(oattach.LinkedEntityId).startsWith('006')){  
                    if(OppVerids.containskey(oattach.LinkedEntityId))
                        OppVerids.get(oattach.LinkedEntityId).add(oattach.ContentDocumentId);
                    else
                        OppVerids.put(oattach.LinkedEntityId,new set<String>{oattach.ContentDocumentId});
                // parentIDs.add(oattach.LinkedEntityId);
                //  VersionIDs.add(oattach.ContentDocumentId);
                }        
            }
            List<opportunity> quoteDocuments = [SELECT Id, Name,FileName__c FROM opportunity where id IN:OppVerids.keyset()];
            List<opportunity> opportunityUpdateList = new List<opportunity>();
            set<String> dvids = new set<String>();
            for(id id1: OppVerids.keyset())
                dvids.addall(OppVerids.get(id1));
                // boolean b= dvids.addall(OppVerids.values());
            List<ContentVersion> cvlist = [Select Id, Title,ContentDocumentId from ContentVersion where ContentDocumentId =: dvids];
            List<ContentVersion> ContentVersionUpdateList = new List<ContentVersion>();
    
            map<String,opportunity> Updateopps = new map<String,opportunity>();
            for(opportunity doc : quoteDocuments){
                for(ContentVersion cv: cvlist ){
                    if(OppVerids.get(doc.id).contains(cv.ContentDocumentId))
                        if(doc.FileName__c!=null)
                            if(doc.FileName__c.contains(cv.title))
                                doc.FileName__c=doc.FileName__c.remove(cv.title);  
                }  
                Updateopps.put(doc.id,doc);  
            }
            update Updateopps.values(); 
        }
    }
    
    private void shareContentDocument(){
        Set<ID> setContentDocumentLinks=new Set<ID>();
        
        List<ContentDocumentLink> lstContentDocumentLinkstoupdate=new List<ContentDocumentLink>();
        for (ContentDocumentLink objnewContentDocumentLink :(List<ContentDocumentLink>) trigger.new) {
            setContentDocumentLinks.add(objnewContentDocumentLink.id);
        }
        List<ContentDocumentLink> lstnewContentDocumentLinks=[select id,ContentDocumentId,LinkedEntityId,ShareType from ContentDocumentLink where id in:setContentDocumentLinks];  
        
        for (ContentDocumentLink objnewContentDocumentLink :lstnewContentDocumentLinks) {
            system.debug('LinkedEntityId:::::::::::'+objnewContentDocumentLink.LinkedEntityId);
            system.debug('ShareType:::::::::::'+objnewContentDocumentLink.ShareType);
            String strLinkedEntityId;
            strLinkedEntityId =objnewContentDocumentLink.LinkedEntityId;
            
            if(strLinkedEntityId!=null){
                // Opportunity and Tcmeeting objectids 
                if(strLinkedEntityId.startsWith('006') || strLinkedEntityId.startsWith('a13')  ){
                    ContentDocumentLink cdl = new ContentDocumentLink();            
                    cdl.id=objnewContentDocumentLink.id;
                    cdl.ShareType = 'I';
                    lstContentDocumentLinkstoupdate.add(cdl);
                    
                    try{
                        if(!lstContentDocumentLinkstoupdate.isempty()){
                            update (lstContentDocumentLinkstoupdate);
                        }
                    }catch(DmlException e){
                        System.debug('Exception occurred on insert: ' + e.getMessage());  
                    }
                }
            } 
        }
    }
    private void preventdeletingrecords() {
        
        if ( trigger.isDelete ) {
            for (ContentDocumentLink objnewContentDocumentLink :(List<ContentDocumentLink>) trigger.old) {
                system.debug('LinkedEntityId:::::::::::'+objnewContentDocumentLink.LinkedEntityId);
                system.debug('ShareType:::::::::::'+objnewContentDocumentLink.ShareType);
                string strLinkedEntityId;
                strLinkedEntityId =objnewContentDocumentLink.LinkedEntityId;
                
                if(strLinkedEntityId!=null){
                    // Opportunity and Tcmeeting objectids 
                    if(strLinkedEntityId.startsWith('006')){
                            if(Approval.isLocked(strLinkedEntityId)){
                                objnewContentDocumentLink.adderror('File cannot be deleted as the deal is submitted for Approval');
                            }
                    }
                }
            }          
        }
    }
    
    private ID getCollaborationGroupID(ID userRoleID){
        List<UserRole> userRole = [SELECT Name from UserRole where ID =: userRoleID LIMIT 1];//Gets the Name of the User Role for the Metadata Map
        if(userRole.size() > 0){
            String userRoleName = userRole[0].Name;//Used to filter the Metadata to the specific group
            List<CoreCollaborationGroup__mdt> ccgList = [SELECT Role__c, CoreGroup__c FROM CoreCollaborationGroup__mdt WHERE Role__c =: userRoleName];//Gets the Group Name for getting the id
            if(ccgList.size() > 0){
                List<CollaborationGroup> cgList = [SELECT ID FROM CollaborationGroup WHERE Name =: ccgList[0].CoreGroup__c];//Gets the Id for the collaboration Group
                if(cgList.size() > 0){
                    return cgList[0].Id;
                }
            }
        }
        return null;
    }
    
    private List<Database.SaveResult> privatizeNotes(List<ID> noteIds){
        Map<ID, ContentNote> cnMap = new Map<ID, ContentNote>([SELECT ID, Title, TextPreview, SharingPrivacy FROM ContentNote WHERE ID in :noteIds]);//Gets Notes to privatize
        List<ContentNote> updateNoteList = new List<ContentNote>();//Used in updating the privacy of notes
        if(cnMap.size() > 0){
            for(ContentNote cn : cnMap.values()){
                cn.SharingPrivacy = 'P';
                updateNoteList.add(cn);
            }
            return Database.Update(updateNoteList, false);
        }
        return null;
    }
    
    private List<Database.SaveResult> privatizeFiles(List<ID> fileIds){
        List<ContentVersion> updateFileList = new List<ContentVersion>();//Used in updating the privacy of notes
        Map<ID, ContentVersion> cvMap = new Map<ID, ContentVersion>([SELECT ID, SharingPrivacy FROM ContentVersion WHERE ContentDocumentId in :fileIds]);//Gets Files to privatize
        if(cvMap.size() >0){
            for(ContentVersion cv : cvMap.values()){
                cv.SharingPrivacy = 'P';
                updateFileList.add(cv);
            }
            return Database.Update(updateFileList, false);
        }
        return null;
    }
}