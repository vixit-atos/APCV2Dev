public Without Sharing class APC_WithoutSharingMasterController {
   
    //New Additional Recipient logic using Content Notes
     @AuraEnabled
    public static list<ContentNote> getadditionalrecipientContentNotes(string caseid)
    {
        list<ContentNote> listofrecipient = new list<ContentNote>();
        set<id> contentnoteids = new set<id>();
        list<contentdocumentlink> contentdocumentlinklist = new list<contentdocumentlink>([select contentdocumentId from contentdocumentlink where LinkedEntityId =:caseid and ContentDocument.FileType = 'SNOTE']);
        if(!contentdocumentlinklist.isEmpty()){            for(contentdocumentlink obj_contentdocumentlink : contentdocumentlinklist){                contentnoteids.add(obj_contentdocumentlink.contentdocumentId);
            }
        }
        listofrecipient = [select id, title from ContentNote where id in :contentnoteids];
        return listofrecipient;      
    }
    
    @AuraEnabled
    public static List<ContentDocument> getExistingFilesInfo1(string caseid) {
        List<ContentDocument> documents = new  List<ContentDocument>(); 
        set<string> documentIds = new set<string>();
        for(ContentDocumentLink obj: [select id,ContentDocumentId from ContentDocumentLink where LinkedEntityId=:caseid]){            documentIds.add(obj.ContentDocumentId);
        }
        if(!documentIds.isEmpty()){             documents = [SELECT Id, Title, ContentSize, FileType FROM ContentDocument WHERE Id=:documentIds];
        }
        return documents;
    }    
   
}