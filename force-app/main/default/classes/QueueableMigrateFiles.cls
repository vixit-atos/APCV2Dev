/**
* ---------------------------------------------------------------------------------------------------
* @author         Christopher McDonald   
* @modifiedBy          
* @version        1.0
* @created        05-29-2018
* @modified       
* ---------------------------------------------------------------------------------------------------
*/
public class QueueableMigrateFiles implements Queueable {
    public ID folderID{get;set;}
    public QueueableMigrateFiles(ID folderID){
        this.folderID = folderID;
    }
    public void execute(QueueableContext context) {
        List<ID> documentIDs = new List<ID>();//Holds the contentDocumentIDs from the contentDocumentLinks
        Map<ID, Folder__c> folderInfo = new Map<ID, Folder__c>([SELECT ID, Type__c FROM Folder__c Where ID =: folderID]);//Gets the Folder's info
        Map<String, Folder_Settings__mdt> StartToFinishMap = new Map<String, Folder_Settings__mdt>();//Holds the folder's type and destination field from corresponding type
        List<Private_Note__c> insertPNList = new List<Private_Note__c>();//holds the private notes that were created for insert
        List<ContentDocumentLink> insertLinksList = new List<ContentDocumentLink>();//Holds the links that were created for insert
        List<FileManagementLog__c> fmlList = new List<FileManagementLog__c>();//Holds the FileManagementLogs to insert
        List<String> fileNamesForLogs = new List<String>();//Holds File Names, matches length of insert to retain iterability
        String destinationField;//Holds the field for the destination's field to check
        String pnName; //holds the private note's name for uses in logs
        Boolean linkCreation;//Boolean to determine if a second step is necessary due to private note
        String query;//holds the query that is used to get data.
        List<User> crmList = [SELECT ID FROM User WHERE Name = 'CRM Admin' LIMIT 1];//Gets the admin to set owner of AORA
        User crmAdmin = crmList[0]; //Gets specific user for ownerID of AORA
        String overrideName = '';
        
        for(Folder__c f : folderInfo.values()){
            if(f.Type__c == 'AORA'){
                overrideName = 'AORA';
            }
        }
        //currentProgress = 'Starting to migrate files from folder...';
        for(Folder_Settings__mdt fset : [SELECT MasterLabel, PrivateNoteName__c, StartingObject__c, StartingFieldDeterminant__c, StartingFieldFilter__c, DestinationObject__c, DestinationFieldDeterminant__c, Filter__c, QualifiedApiName FROM Folder_Settings__mdt ORDER BY QualifiedAPIName ASC]){               
            StartToFinishMap.put(fset.StartingFieldFilter__c, fset);
        }        
        Map<ID, ContentDocumentLink> contentLinksMap = new Map<ID, ContentDocumentLink>([Select ContentDocumentID, LinkedEntityID FROM ContentDocumentLink WHERE LinkedEntityID =: folderID]);
        for(ContentDocumentLink cdl : contentLinksMap.values()){
            documentIDs.add(cdl.ContentDocumentID);
        }
        
        Map<ID, ContentVersion> folderContentMap = new Map<ID, ContentVersion>([SELECT ID, Title, ContentDocumentID FROM ContentVersion WHERE ContentDocumentID =:documentIds]);//Holds the Files from the current folder
        if(folderContentMap.size() > 0){
            for(Folder__c f : folderInfo.values()){
                Folder_Settings__mdt dataForMigration = StartToFinishMap.get(f.Type__c);
                if(dataForMigration != null){
                    pnName = dataForMigration.PrivateNoteName__c;
                    destinationField = dataForMigration.DestinationFieldDeterminant__c;
                    query = 'SELECT ID, ' + dataForMigration.DestinationFieldDeterminant__c + ' FROM ' + dataForMigration.DestinationObject__c + ' WHERE ' + dataForMigration.DestinationFieldDeterminant__c + ' != NULL';
                }
            }            
            List<Sobject> queriedObject = Database.query(query);
            
            if(queriedObject.size() >0){
                for(SObject ob : queriedObject){
                    for(ContentVersion cv : folderContentMap.values()){
                        if(ob.get(destinationField) == cv.title){
                            if(ob instanceof Account || ob instanceof Contact){
                                insertPNList.add(createNoteForFile(pnName, cv.title, ob, overrideName, crmAdmin.id));
                                linkCreation = FALSE;
                            }else{
                                /*Reserved for Later File Metadata pairings. Only For Non-PrivateNote
                                linkCreation = TRUE;
                                ContentDocumentLink cdl = new ContentDocumentLink();
                                cdl.ContentDocumentID = cv.ContentDocumentID;
                                cdl.LinkedEntityID = (ID)ob.get('ID');
                                insertLinksList.add(cdl);
                                */
                            }
                        }
                    }
                }
                
                if(linkCreation == FALSE){
                    //currentProgress = 'Creating Private Notes for Files';
                    Database.SaveResult[] pnInsertList = Database.insert(insertPNList, false);//Holds Database results of the private note insert
                    for(Integer i = 0; i<pnInsertList.size(); i++){
                        for(ContentVersion cv : folderContentmap.values()){
                            if(cv.Title == insertPNList[i].Body__c){
                                insertLinksList.add(createLinkToFile(cv.ContentDocumentId, pnInsertList[i].getID()));
                                fileNamesForLogs.add(cv.Title);
                            } 
                        }
                    }
                }
                
                //currentProgress = 'Migrating files...';
                Database.SaveResult[] fileInsertList = Database.insert(insertLinksList, false);//Holds the database results for the contentDocumentLink creation
                for(Integer j = 0; j<fileInsertList.size(); j++){
                    fmlList.add(createFileManagementLog(folderID, fileNamesForLogs[j], NULL,''));
                }
                for(ContentVersion cv : folderContentMap.values()){
                    if(!fileNamesForLogs.contains(cv.title)){
                        fmlList.add(createFileManagementLog(folderID, cv.title, null, 'Could not find match for Object by File Name.'));
                    }
                }
                //currentProgress = 'Creating Logs...';
                insert fmlList;
                //currentProgress = 'Action Completed';
                
            }
            
        }else{
            //currentProgress = 'No files found in folder.';
        }
    }
     public static Private_Note__c createNoteForFile(String pnName, String titleOfFile, sObject ob, String overrideName, ID crmAdmin){
        ID idForObject = (ID)ob.get('ID');
        Private_Note__c pn = new Private_Note__c(
            Body__c = titleOfFile,
            Type__c = 'Attachment',
            OwnerID = crmAdmin
        );
        if(overrideName == 'AORA'){
            pn.Name = createAORAReportName(titleOfFile);
        }else{
            /*Reserved for Non-AORA Reports
            pn.Name = pnName;
            */
        }
        if(ob instanceof Account){
            pn.Account_RL__c = idForObject;
        }else{
            /*Reserved for Contact Private Note Files
            pn.Contact_RL__c = idForObject;
            */
        }
        return pn;
    }
    
    public static FileManagementLog__c createFileManagementLog(ID folderID, String titleOFFile, List<Database.Error> errorList, String singleError){
        String errors = '';
        if(errorList != null){
            /*Reserved for errors that may occur later
            for(Database.Error de : errorList){
                errors = errors + de;
            }
            */
        }
        if(singleError != ''){
            errors = singleError;
        }
        FileManagementLog__c fml = new FileManagementLog__c(
            ParentID__c = FolderID,
            errorReport__c = errors,
            Item__c = titleOfFile
        );
        if(errors == ''){
            fml.isSuccess__c = 'TRUE';
        }else{
            fml.isSuccess__c = 'FALSE';
        }
        return fml;
    }
    
    public static ContentDocumentLink createLinkToFile(ID documentID, ID entityToLink){
        ContentDocumentLink cdl = new ContentDocumentLink(
            ContentDocumentID = documentID,
            LinkedEntityID = entityToLink,
            ShareType = 'V'
        );
        return cdl;
    }
    public static String convertMonth(Integer month){//Converts month to one month behind for AORA reports
        if(month == 1){
            return 'Dec';
        }else if(month == 2){
            return 'Jan';
        }else if(month == 3){
            return 'Feb'; 
        }else if(month == 4){
            return 'Mar';
        }else if(month == 5){
            return 'Apr';
        }else if(month == 6){
            return 'May';
        }else if(month == 7){
            return 'Jun';
        }else if(month == 8){
            return 'Jul';
        }else if(month == 9){
            return 'Aug';
        }else if(month == 10){
            return 'Sep';
        }else if(month == 11){
            return 'Oct';
        }else{
            return 'Nov';
        }
    }
    public static String createAORAReportName(String dealerCode){
        String month = convertMonth(system.today().month()); //Gets month in XX form
        Integer year = system.today().year(); //year in YY form
        return 'AORA Report ' + month + year + '-' + dealerCode;
    }

}