public class CI_AttachmentListController {   
	@AuraEnabled
    public static List<file> getAttachmentList(ID currendRecID){ 
        //Find related recordID
        ID relatedRecordID = findRelatedRecordID(currendRecID);
        //Find documents that related to the related record
        Map<id, ContentDocumentLink> fileList = new Map<id, ContentDocumentLink>();
        for (ContentDocumentLink ConDocLink : [SELECT ContentDocumentId FROM ContentDocumentLink where LinkedEntityId =: relatedRecordID]){
            fileList.put( ConDocLink.ContentDocumentId, ConDocLink);
        }
        List<ContentDocument> ContentDocumentList = new List<ContentDocument>();
        ContentDocumentList = [select id, Title, OwnerId, LastModifiedDate,  ContentSize from ContentDocument where id IN: fileList.keySet()];
        
		//Get all the user from database as a user library for searching use 	
        Map<id, User> ownerList = new Map<id, User>([SELECT Id, FirstName, LastName FROM User]);
        
        List<file> result = new List<file>();
        for (ContentDocument ContentDoc: ContentDocumentList){  
            result.add(new file(ContentDoc.id, ContentDoc.OwnerId, ContentDoc.title, 
                                ContentDoc.LastModifiedDate.format('MM/dd/yyyy HH:mm z', UserInfo.getTimeZone().getID()), 
                                ownerList.get(ContentDoc.OwnerId).FirstName + ' ' + ownerList.get(ContentDoc.OwnerId).LastName, 
                                sizeCalculation(ContentDoc.ContentSize)) );
        }
        return result;
    }
   
    //Find the related record of the current approval
    @AuraEnabled
    public static id findRelatedRecordID(ID approvalID){
    	ProcessInstanceWorkitem currentApproval = [SELECT ProcessInstanceId from ProcessInstanceWorkitem where id =: approvalID];  
		ProcessInstance relatedRecord = [Select TargetObjectId from ProcessInstance where id=: currentApproval.ProcessInstanceId];
        return  relatedRecord.TargetObjectId;
    }
        
    //Add unit on file size
    private static String sizeCalculation(Integer fileSize){
        Double fileSizeDouble = double.valueOf(fileSize);
        if (fileSizeDouble < 1024){
            return  String.valueOf(fileSize) + ' B'; 
        }
        else if ((fileSizeDouble/1024) < 1024){
            return  String.valueOf(Math.round(fileSizeDouble/1024)) + ' KB';
        }
        else{
            return  String.valueOf(Math.round(fileSizeDouble/(1024*1024)) ) + ' MB';
        }
    }
    
    //A wrapper class used in Lightning Component for convenience 
    public class file{
        public file(id id, id ownerID, string title, string lastModifiedDate, string owner, string size) {
            this.id = id;
            this.ownerID = ownerID;
            this.title = title;
            this.lastModifiedDate = lastModifiedDate;
            this.owner = owner;
            this.size = size;
        }
        @auraEnabled
        public id id { get; set; }
        @auraEnabled
        public id ownerId { get; set; }
        @auraEnabled
        public string title { get; set; }
        @auraEnabled
        public String lastModifiedDate { get; set; }
        @auraEnabled
        public string owner { get; set; }
        @auraEnabled
        public string size{ get; set; }
    }   
}