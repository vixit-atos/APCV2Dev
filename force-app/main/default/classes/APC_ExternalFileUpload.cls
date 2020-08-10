public class APC_ExternalFileUpload {
    @AuraEnabled
    public static String getUserId() {
        return userInfo.getUserId();
    }
    
    @AuraEnabled
    public static Boolean deleteFiles(Map<String, Object> params) {
        boolean returnoutcome = false;
        try{
            system.debug('params => '+params);
            List<Object> fileIds = (List<Object>)params.get('fileIds');
            List<String> documentIds = new List<String>();
            for(Object ob : fileIds){
                documentIds.add((String)ob);
            }
            delete [SELECT Id FROM ContentDocument WHERE Id=:documentIds];
            returnoutcome= true;
        }Catch(DmlException e){
            System.debug('The following DML exception has occurred: ' + e.getMessage());
            returnoutcome = false;
        }
        catch(Exception ex){
            System.debug('Error => '+ex.getStackTraceString());
            returnoutcome = false;
        }
        return returnoutcome;
    }
    
    @AuraEnabled
    public static List<ContentDocument> getDocuments(Map<String, Object> params) {
        system.debug('params => '+params);
        List<ContentDocument> listcontentdocument= new List<ContentDocument>();
        List<Object> docIds = (List<Object>)params.get('docIds');
        List<String> documentIds = new List<String>();
        for(Object ob : docIds){
            documentIds.add((String)ob);
        }
        if(!documentIds.isEmpty()){
            listcontentdocument = [SELECT Id, Title, ContentSize, FileType FROM ContentDocument WHERE Id=:documentIds];
        }
        return listcontentdocument;
    }
    
    @AuraEnabled
    public static List<ContentDocument> getFilesInfo(Map<String, Object> params) {
        system.debug('params => '+params);
        List<Object> files = (List<Object>)params.get('files');
        List<String> documentIds = new List<String>();
        List<ContentDocument> documents = new  List<ContentDocument>();
        
        for(Object file : files) {
            Map<Object,Object> fileMap = (Map<Object,Object>)file;
            documentIds.add((String)fileMap.get('documentId'));
        }
        
        if(!documentIds.isEmpty()){   
            documents = [ SELECT Id, Title, ContentSize, FileType FROM ContentDocument WHERE Id=:documentIds];
        }
        return documents;
    }
    
    @AuraEnabled
    public static List<ContentDocumentLink> createDocumentLinks(Map<String, Object> params) {
        system.debug('params => '+params);
        List<Object> files = (List<Object>)params.get('files');
        String recordId = (String)params.get('recordId');
        List<ContentDocumentLink> cdLinks = new List<ContentDocumentLink>();
        
        for(Object file : files) {
            Map<Object,Object> fileMap = (Map<Object,Object>)file;
            cdLinks.add(new ContentDocumentLink(
                LinkedEntityId=recordId, 
                ContentDocumentId=(String)fileMap.get('Id'), 
                ShareType='V', 
                Visibility='AllUsers'
            ));
        }
        try{
            insert cdLinks;
        }Catch(DmlException e){
            System.debug('The following DML exception has occurred: ' + e.getMessage());            
        }
        catch(Exception ex){
            System.debug('Error => '+ex.getStackTraceString());            
        }        
        return cdLinks;
    }
}