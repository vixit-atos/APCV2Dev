/**
* ---------------------------------------------------------------------------------------------------
* @author         Christopher McDonald   
* @modifiedBy          
* @version        3.0
* @created        03-19-2018
* @modified       
* ---------------------------------------------------------------------------------------------------
* @changes
* modifiedBy            
* MM-DD-YYYY      5/4/2018 - Changes from ContentDocument to ContentVersion
* @changes
* modifiedBy            
* MM-DD-YYYY      5/29/2018 - Uses Queueable Apex to prevent CPU bottleneck
* ---------------------------------------------------------------------------------------------------
*/
public class FileManagementController{
    public static Database.SaveResult[] aoraAttachList{get;set;} //For printing out the populate aora reports into the vf page
    public static Database.DeleteResult[] deleteResultList{get;set;} //Prints out purged objects into the vf page
    public ID folderID{get;set;}//Folder that was clicked on for distributing AORA
    public ID latestJobID{get;set;}//Latest run job for displaying to user
    public AsyncApexJob jobInfo{get;set;}//Latest job object used for testing
    public String currentProgress{get;set;}

    public FileManagementcontroller(ApexPages.StandardController controller) {
        folderID = controller.getRecord().id;
        currentProgress = 'No current Job';
    }
    
    public void purgeAORA(){
        aoraAttachList = null;//Holds onto the AORA reports that attached to Private Notes
        Map<String, ContentVersion> cvMap = new Map<String, ContentVersion>{}; //Map of Contentdocument Title:ID
        Map<ID, String> accountMap = new Map<ID, String>{}; //Map AccountID:Dealer Code
        List<String> cvTitles = new List<String>{}; //List of Content Document Titles(Names)
        List<ID> deleteCVList = new List<ID>{};//List for deleting content documents that are AORA
        List<ID> pnDeleteList = new List<ID>{};//List of Private Notes related to AORA to delete
        List<ID> aoraFolderIDList = new List<ID>();//Used currently for getting the ID of the folder populated with AORA
            
        for(ContentVersion cv : [SELECT ID, ContentDocumentID, Title FROM ContentVersion WHERE FileType ='PDF' AND Title LIKE '____']){
            cvMap.put(cv.Title,cv);
        }
        for(Account acct : [SELECT ID, Dealer_Code__C FROM Account WHERE Dealer_Code__C != NULL AND Dealer_Code__C LIKE '____']){
            accountMap.put(acct.ID, acct.Dealer_Code__c);
        }
        for(String title : cvMap.keySet()){
            if(accountMap.values().contains(title)){
                cvTitles.add(title);
                deleteCVList.add(cvMap.get(title).id);
            }
        }
            
        Map<ID, String> pnMap = new Map<ID, String>();//Map of Private Notes to search for AORA reports inside
        for(Private_Note__c pn : [SELECT ID, Body__C FROM Private_Note__c WHERE Name LIKE '%AORA%']){
            if(cvTitles.contains(pn.Body__C)){
                pnDeleteList.add(pn.id); //Adds any Content that isn't in the folder
            }
        }
        List<Folder__c> aoraFolderList = [Select Id FROM Folder__c Where Name like '%AORA%'];
        for(Folder__c f : aoraFolderList){
            aoraFolderIDList.add(f.id);
        }
        List<Contentdocumentlink> cdlFolderList = [SELECT ContentDocumentID, LinkedEntityID FROM ContentDocumentLink WHERE LinkedEntityID =: aoraFolderIDList]; //Gets current ContentDocumentLinks for the Aora Reports
        for(ContentDocumentLink cdl : cdlFolderList){
            if(!pnDeleteList.contains(cdl.ContentDocumentID)){
                pnDeleteLIst.add(cdl.ContentDocumentID); //Adds content that remains in the folder
            }
        }
        currentProgress = 'Purging AORA records';
        deleteResultList = Database.delete(pnDeleteList);
        currentProgress = 'Private Notes have been deleted';
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Old AORA Reports and Private Notes have been purged. Please upload the new AORA Reports for Distribution'));
    }
    
    public PageReference getProgress(){
        if(latestJobID!= null){
            jobInformation();
        }
        return null;
    }
    public void jobInformation(){
        List<AsyncApexJob> Lst_apxjb = new List<AsyncApexJob>();
        if(latestJobID != null)
            Lst_apxjb = [SELECT Status,NumberOfErrors, TotalJobItems FROM AsyncApexJob WHERE Id=:latestJobID];
        if(Lst_apxjb.size() > 0)
            jobInfo = Lst_apxjb[0];
            
        if(jobInfo != null){
            if(jobInfo.Status == 'Completed'){
                currentProgress = 'Job Completed. Number of Errors: ' + jobInfo.NumberOfErrors + '. For items that errored, check the Logs in the Folder';
            }else{
                currentProgress = 'Job: ' + jobInfo.ID + ' has started. Status: ' + jobInfo.Status + ' Number of Errors: ' + jobInfo.NumberOfErrors;
            }
        }
    }
    public void migrate(){
        latestJobID = System.enqueueJob(new QueueableMigrateFiles(folderID));
        jobInformation();
    }
    
}