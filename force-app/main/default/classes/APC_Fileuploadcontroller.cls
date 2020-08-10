/**
* @File Name          : APC_Fileuploadcontroller.apxc
* @Description        : Displays attachments in Additional Information section on the case detail page.
* @Developer          :	Akhila Putta
**/


public with sharing class APC_Fileuploadcontroller {
    
    @AuraEnabled
    public static String getUserId() {
        return userInfo.getUserId();
    }
    
    @AuraEnabled
    public static Boolean deleteFiles(Map<String, Object> params) {
        boolean returnoutcome = false;
        // Null checks added 04/05/2020
        try{
            system.debug('params => '+params);
            List<Object> fileIds = (List<Object>)params.get('fileIds');
            if(!fileIds.isEmpty()){
                List<String> documentIds = new List<String>();
                for(Object ob : fileIds){
                    documentIds.add((String)ob);
                }
                list<ContentDocument> listofcontentdocumenttodelete = new list<ContentDocument>();
                listofcontentdocumenttodelete = [SELECT Id FROM ContentDocument WHERE Id=:documentIds];
                if(!listofcontentdocumenttodelete.isEmpty()){
                    delete listofcontentdocumenttodelete;
                    returnoutcome= true;
                }
                
            }
            
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
 
    /// Added to Merge APC_ExternalFileupload 04/05/2020
    @AuraEnabled
    public static List<ContentDocument> getFilesInfoExternal(Map<String, Object> params) {
        system.debug('params => '+params);
        List<Object> files = (List<Object>)params.get('files');
        List<String> documentIds = new List<String>();
        List<ContentDocument> documents = new  List<ContentDocument>();
        
        for(Object file : files) {
            Map<Object,Object> fileMap = (Map<Object,Object>)file;
            documentIds.add((String)fileMap.get('documentId'));
        }
        
        if(!documentIds.isEmpty()){   
            documents = [ SELECT Id, Title, ContentSize, FileType FROM ContentDocument WHERE Id=:documentIds and FileType <> 'SNOTE'];
        }
        return documents;
    }
    
    @AuraEnabled
    public static List<ContentDocument> getExistingFilesInfo() {
        set<string> documentIds = new set<string>();
        List<ContentDocument> documents = new  List<ContentDocument>();
        for(ContentDocumentLink obj: [select id,ContentDocumentId from ContentDocumentLink where LinkedEntityId=:Userinfo.getUserId()  order by SystemModstamp desc limit 20]){
            documentIds.add(obj.ContentDocumentId);
        }
        if(!documentIds.isEmpty()){
            documents = [SELECT Id, Title, ContentSize, FileType FROM ContentDocument WHERE Id=:documentIds];
        }
        return documents;
    }
    
    @AuraEnabled
    public static List<ContentDocument> getExistingFilesInfo1(string caseid) {
        List<ContentDocument> documents = new  List<ContentDocument>(); 
        set<string> documentIds = new set<string>();
        for(ContentDocumentLink obj: [select id,ContentDocumentId from ContentDocumentLink where LinkedEntityId=:caseid]){
            documentIds.add(obj.ContentDocumentId);
        }
        if(!documentIds.isEmpty()){
            documents = [SELECT Id, Title, ContentSize, FileType FROM ContentDocument WHERE Id=:documentIds and filetype <> 'SNOTE'];
        }
        return documents;
    }
    
    @AuraEnabled
    public static List<ContentDocumentLink> createDocumentLinks(Map<String, Object> params) {
        system.debug('createDocumentLinks');
        List<Object> files = (List<Object>)params.get('files');
        String recordId = (String)params.get('recordId');
        List<ContentDocumentLink> cdLinks = new List<ContentDocumentLink>();
        
        set<string> setFileNames = new set<string>();
        set<string> documentIds = new set<string>();
        for(Object file : files) {
            Map<Object,Object> fileMap = (Map<Object,Object>)file;
            setFileNames.add((String)fileMap.get('Title'));
        }
        for(ContentDocumentLink obj: [select id,ContentDocumentId from ContentDocumentLink where LinkedEntityId=:recordId and ContentDocument.Title in : setFileNames]){
            documentIds.add(obj.ContentDocumentId);
        }
        if(!documentIds.isEmpty()){
            return null;
        }
        
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
    
    @AuraEnabled
    public static List<ContentDocumentLink> createDocumentLinks1(Map<String, Object> params) {
        List<Object> files = (List<Object>)params.get('files');
        String recordId = (String)params.get('recordId');
        List<ContentDocumentLink> cdLinks = new List<ContentDocumentLink>();
        set<Id> storecontentdocumentids = new set<Id> ();
        for(Object file : files){
            Map<Object,Object> fileMap = (Map<Object,Object>)file;
            storecontentdocumentids.add((String)fileMap.get('documentId'));
        }    
        
        List<ContentDocumentLink> cdLinkstoupdate = new List<ContentDocumentLink> ();   
        if(!storecontentdocumentids.isEmpty()){
            cdLinkstoupdate = [select id,LinkedEntityId  from ContentDocumentLink where ContentDocumentId in:storecontentdocumentids];
        }
        if(!cdLinkstoupdate.isEmpty()){
            for(ContentDocumentLink cdl: cdLinkstoupdate){
                String LinkedEntityId= cdl.LinkedEntityId;
                String objectcode = LinkedEntityId.substring(0, 3);
                if(objectcode == '500'){
                    cdl.Visibility = 'AllUsers';
                }
            }                    
        }
        for(Object file : files) {
            Map<Object,Object> fileMap = (Map<Object,Object>)file;
            cdLinks.add(new ContentDocumentLink(
                LinkedEntityId=recordId, 
                ContentDocumentId=(String)fileMap.get('documentId'), 
                ShareType='V', 
                Visibility='AllUsers'
            ));
        }
        
        try{
            if(!cdLinkstoupdate.isEmpty()){
                update cdLinkstoupdate;
                system.debug('cdLinkstoupdate: ' + cdLinkstoupdate);
            }else{
                insert cdLinks;
                system.debug('cdLinks: ' + cdLinks);
            }
            
            
        }Catch(DmlException e){
            System.debug('The following DML exception has occurred: ' + e.getMessage());            
        }
        catch(Exception ex){
            System.debug('Error => '+ex.getStackTraceString());            
        }
        
        return cdLinks;
    }
    /// Added to Merge APC_ExternalFileupload 04/05/2020
    @AuraEnabled
    public static List<ContentDocumentLink> createDocumentLinksExternal(Map<String, Object> params) {
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