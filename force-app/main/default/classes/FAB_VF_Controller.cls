public class FAB_VF_Controller {
    public ID oppId {get;set;} //Holds the opportunity to relate to
    public List<ID> imageFiles {get;set;}//Holds the Images associated with the Opportunity
    public List<ID> image{get;set;}//Holds the most recent image for the FAB.
    public String noteDataCodes {get;set;}//Holds the Data Codes for the Opportunity Note
    public String noteWhat {get;set;}//Holds the What Section for the Opportunity Note
    public String noteWhy {get;set;}//Holds the Why Section for the Opportunity Note
    public String noteCompatibility {get;set;}//Holds the High-Level Section for the Opportunity Note
    public String droppedSOP{get;set;}//Holds the SOP of the EWR
    public String pdfString{get;set;}//String for determining if the page should create a pdf
    public String pbFlag{get;set;}//Determines if the pb location will be set
    public List<String> ftlList{get;set;}//Holds the list of ftl models
    public List<String> wstList{get;set;}//Holds the list of ftl models
    public String M2112Flag{get;set;}//Holds the flag for the checkbox of the M2 112 Model
    public String M2108Flag{get;set;}//Holds the flag for the checkbox of the M2 108 Model
    public String X122SDFlag{get;set;}//Holds the flag for the checkboxd of the 122SD Model
    public String X108SDFlag{get;set;}//Holds the flag for the checkboxd of the 108SD Model
    public String X114SDFlag{get;set;}//Holds the flag for the checkboxd of the 114SD Model
    public String P4Flag{get;set;}//Holds the flag for the checkboxd of the P4 Model
    public String P3Flag{get;set;}//Holds the flag for the checkboxd of the P3 Model
    public List<String> modelImages{get;set;}//Holds the images for each model impacted
    public List<String> modelsList{get;set;}//Holds the model names list
    public String trueModelsList{get;set;}//Display models list
    
    public FAB_VF_Controller(ApexPages.StandardController controller) {
        M2112Flag = 'Empty';
        M2108Flag = 'Empty';
        X122SDFlag= 'Empty';
        X108SDFlag= 'Empty';
        X114SDFlag= 'Empty';
        P4Flag = 'Empty';
        P3Flag= 'Empty';
        noteWhat = '';
        noteWhy = '';
        noteCompatibility = '';
        image = New List<ID>();
        imageFiles = New List<ID>();
        oppId = controller.getRecord().id;//Gets the Opportunity ID
        pdfString = ApexPages.currentPage().getParameters().get('pdfString');
        if(oppId != null){
            ftlList = fetchFTLModels(oppId);
            wstList = fetchWSTModels(oppId);
            retrieveFilesandNote();
        }
    }
    /*Used in Content Note related stuff
    public static String escapeNote(String s){
        //replaces &, ", ', <, >
        String fixedString = s;
        
        fixedString = fixedString.replace('&quot;', '"');
        fixedString = fixedString.replace('&amp;', '\\&');
        fixedString = fixedString.replace('&#39;', '\'');
        fixedString = fixedString.replace('&It', '\\<');
        fixedString = fixedString.replace('&gt', '\\>');
        return fixedString;
    }
    */
    @AuraEnabled
    public static String createContentNote(Id recordId, String title, String noteBody){
        List<Note> nList = [SELECT ID, Title from Note where parentId=:recordId];//Holds the content notes list for the specified record
        Note overWriteNote = new Note();//The note that will be overwritten, if any
        Boolean overWriteFlag = false;//Boolean to determine if an overwrite will happen
        if(nList.size() > 0){
            for(Note nl : nList){
                if (nl.title == title){
                    overWriteNote = nl;
                    overWriteFlag = true;
                }
            }
        }
        if(overWriteFlag == true){
            overWriteNote.body = noteBody;
            update overWriteNote;
            return overWriteNote.Id;
        }else{
            Note note = new Note(//Note that is created for the record
                Title= title,
                parentId = recordId,
                body = noteBody,
                isPrivate = false
            );
            insert note;
            return note.id;
        }
        
        /*Content Note Version below
        String escapedNote;
        ContentNote cn = new ContentNote();//Holds the ContentNote, new or found
        List<ID> cdIds = new List<Id>();//Holds the list of contentdocumentIds associated with the recordId
        Boolean overwriteFlag = false;//Determines whether to create a new note or not
        
        Map<Id, ContentDocumentLink> cdlMap = new Map<Id, ContentDocumentLink>([Select id, contentdocumentid, linkedentityId from contentdocumentLink where linkedEntityId =: recordId]);//holds the Links from the RecordId
        for(ContentDocumentLink cdl : cdlMap.values()){
            cdIds.add(cdl.ContentDocumentId);
        }
        List<ContentNote> cnList = [Select ID, Title from ContentNote Where Title =: title and Id in :cdIds];//Holds the content Notes associated to the recordId
        for(ContentNote n : cnList){
            if(n.Title == title && noteBody != null){
                n.Content = Blob.valueOf(noteBody.escapeHTML4());
                cn = n;
                overWriteFlag = true;
            }
        }
        if(overWriteFlag == true){
            update cn;
        }else{
            if(recordId != null && noteBody != null){
                cn.Title= title;
                cn.Content = Blob.valueof(noteBody.escapeHTML4());
                insert cn;
                
                if(cn.Id != null){
                    ContentDocumentLink cdl = New ContentDocumentLink();//New Link to the recordId
                    cdl.LinkedEntityId = recordId;
                    cdl.ContentDocumentId = cn.Id;
                    cdl.sharetype = 'v';
                    insert cdl;
                }
            }
        }
        return cn.id;
        */
    }
    
    @AuraEnabled
    public static List<String> fetchFTLModels(Id recordId){
        List<String> finalString = new List<String>();//Final string to return to the VF Page
        String ftlModels = '';
        if(recordId != null){
            List<OpportunityLineItem> oppli = [SELECT ID, product2.name, product2.family from OpportunityLineItem where OpportunityID =: recordId AND product2.family = 'Freightliner'];//Gets all the freightliner models
            if(oppli.size() > 0){
                for(OpportunityLineItem oli : oppli){
                    if(!finalString.contains(oli.product2.Name)){
                    finalString.add(oli.product2.Name);
                    }
                }
            }
        }
        return finalString;
    }
    
    @AuraEnabled
    public static List<String> fetchWSTModels(Id recordId){
        List<String> finalString = new List<String>();//Final string to return to the VF Page
        if(recordId != null){
            List<OpportunityLineItem> oppli = [SELECT ID, product2.name, product2.family from OpportunityLineItem where OpportunityID =: recordId AND product2.family = 'Western Star'];//Gets all the western star models        
            if(oppli.size() > 0){
                for(OpportunityLineItem oli : oppli){
                    finalString.add(oli.product2.Name);
                }
            }
        }
        return finalString;
    }
    
    @AuraEnabled
    public static String fetchNote(Id recordId, String title){
        List<Note> n = [SELECT Body from Note where Title =: title and parentId =: recordId limit 1];//fetch the note associated to the record and title
        if(n.size() > 0){
            return n[0].Body;
        }
        return null;
        /*Content note 
        List<Id> cdIds = new List<Id>();
        Map<Id, ContentDocumentLink> cdlMap = new Map<Id, ContentDocumentLink>([Select id, contentdocumentId from contentdocumentlink where linkedEntityId =: recordId]);
        for(ContentDocumentLink cdl : cdlMap.values()){
            cdIds.add(cdl.Id);
        }
        List<ContentNote> cnList = [SELECT ID, Title, Content from ContentNote where Title =: title limit 1];
        Blob noteBody = cnList[0].Content;
        String noteInformation = escapeNote(noteBody.toString());
        return noteInformation;
        */
    }
    @AuraEnabled
    public static void tagImages(Id recordId){
        //For each image that was recently uploaded, tag it with "FAB" tag
        List<ContentDocumentLink> cdlList = [SELECT ContentDocumentID from ContentDocumentLink where LinkedEntityId =: recordId];
        List<ID> idList = new List<Id>();
        if(cdlList.size() > 0 ){
            for(ContentDocumentLink cdl : cdlList){
                idList.add(cdl.ContentDocumentId);
            }
        }
        List<ContentVersion> cvList = [SELECT ID, Description From ContentVersion Where ContentDocumentId in :idList AND ContentModifiedDate > :Datetime.now().addMinutes(-1)];
        for(ContentVersion cv: cvList){
            if(cv.Description == null){
                cv.Description = '#FAB';
            }else{
                cv.Description = cv.Description + '#FAB';
            }
        }
        
        update cvList;
    }
    
    static list<string> getImageIDs(Id recordId, boolean single){
        String imageId = '';//Used for the single image ID
        String tempId = '';//Used to hold the content version ID to prefix from
        List<String> imageTypes = new List<String>();//Holds the list of image types to query for
        List<String> imageIdsList = new List<String>();//Holds the returning IDs
        imageTypes.add('png');
        imageTypes.add('jpg');
        imageTypes.add('jpeg');
        imageTypes.add('gif');
        imageTypes.add('svg');
        
        if(recordId!=null){
            List<ID> cdlList = new List<Id>();//Holds the ContentdocumentLinks for all files on the Opportunity
            Map<ID, ContentDocumentLink> cdlMap = new Map<Id, ContentDocumentLink>([Select Id, ContentDocumentID from ContentDocumentLink where LinkedEntityId =: recordId]);//Holds the ContentDocumentLinks for the Opportunity
            if(cdlMap.size() > 0){
                for(ContentDocumentLink cdl: cdlMap.values()){
                    cdlList.add(cdl.ContentDocumentId);
                }
            }
            Map<ID, ContentVersion> cvMap = new Map<Id, ContentVersion>([SELECT ID, Description FROM ContentVersion WHERE ContentDocumentID in : cdlList AND isLatest = True AND FileType in :imageTypes ORDER BY CreatedDate DESC]);//Used to speed up the loop fron O(n) to O(1)
            if(cvMap.size() > 0){
                Map<ID, ID> cvIdMap = new Map<ID, ID>();//Used to filter through for 068's
                for(ContentVersion cv : cvMap.values()){
                    if(cv.Description != null){
                        if(cv.Description.contains('FAB')){
                            cvIDMap.put(cv.id, cv.id);
                        }
                    }
                }
                for(Id cv : cvIDMap.keyset()){
                    tempId = cv;
                    if(tempId.substring(0,3) == '068'){//Get only Prefix of 068 Before Adding.
                        if(imageId == ''){
                            imageId=cv;
                        }else{
                            imageIdsList.add(cv);
                        }
                    }
                }
            }
            if(single){
                imageIdsList.clear();
                imageIdsList.add(imageId);
                return imageIdsList;
            }else{
                return imageIdsList;
            }
        }
        return imageIdsList;
    }
    
    @AuraEnabled
    public static String fetchImage(Id recordId){
        List<String> images = getImageIDs(recordId, true);
        return images[0];
    }

    @AuraEnabled
    public static List<String> fetchImages(Id recordId){
        List<String> images = getImageIDs(recordId, false);
        return images;
    }
    
    @AuraEnabled
    static public List<String> fetchModelImages(Id recordId, Boolean returnImages){
        List<String> modelIds = new List<String>();//For returning the IDs for each model found on the Opportunity
        List<ID> cdIds = new List<ID>();//Used in finding the Content Documents for the Opportunity
        List<String> models = new List<String>();//Used in finding the Images for display
        String libraryName = 'Model Images';//Name of the Static library
        Boolean p3Flag = false;//If a p3 already went through, prevent copies of the image
        Boolean p4Flag = false;//if a p4 already went through, prevent copies of the image
        List<ContentWorkspace> cw = [SELECT ID FROM ContentWorkspace where Name =: libraryName Limit 1];//Gets the static Library's id
        
        if(cw.size() >0 ){
            List<ContentDocumentLink> cdlList = [SELECT ContentDocumentId FROM ContentDocumentLink where LinkedEntityId =: cw[0].id];//Gets the links to that library
            List<OpportunityLineItem> oliList = [SELECT ID, Product2.Name FROM opportunityLineItem where OpportunityId =: recordId];//Gets the model names for the library images
            if(oliList.size() > 0){
                List<ContentVersion> cvList = New List<ContentVersion>();//Holds the ContentVersions for the opportunity where the Titles are filtered by the Model names
                for(OpportunityLineItem oli : oliList){
                    if((oli.product2.Name.contains('Classic Cascadia'))){
                        if(p3Flag == false){
                            models.add('Classic Cascadia');
                            p3Flag = true;
                        }
                    }else if(oli.product2.Name.contains('New Cascadia')){
                        if(p4Flag == false){
                            models.add('New Cascadia');
                            p4Flag = true;
                        }
                    }else{
                        if(!models.contains(oli.product2.Name)){
                            models.add(oli.product2.Name);
                            
                        }
                    }
                }
                if(models.size() > 0){
                    models.sort();
                    if(returnImages == true){
                        if(cdlList.size() > 0){
                            for(ContentDocumentLink cdl : cdlList){
                                cdIds.add(cdl.ContentDocumentId);
                            }
                            cvlist = [Select ID From ContentVersion where Title in :models ORDER BY Title ASC NULLS LAST];
                            
                            if(cvList.size() > 0){
                                for(ContentVersion cv : cvList){
                                    modelIds.add(cv.Id);
                                }
                                return modelIds;
                            }
                        }
                    }else{
                        return models;
                    }
                }
            }
        }
        return null;
    }
    @AuraEnabled
    static public String fetchTheAuraSOP(Id recordId){
        String SOP = 'TBD';//Holds the SOP tentively 
        List<Milestone__c> m = new List<Milestone__c>();//Milestone to pull the changeover date from
        if(recordId != null){
            m = [Select ID, Deadline__c from Milestone__c where Opportunity__c =: recordId AND Name = 'Changeover' LIMIT 1];
            if(m.size() > 0 && m[0].Deadline__c != null){
                if(m[0].Deadline__c != null){
                    SOP = m[0].Deadline__c.format();
                }
            }
        }
        return SOP;
    }
    /*
    @AuraEnabled
    static public void publishFAB(Id recordId){
        List<Opportunity> opp = [SELECT ID, Name, Contact__c FROM Opportunity where ID =: recordId LIMIT 1];
        pageReference pdfPage = new PageReference('/apex/FAB_VF_Page?id=' + recordId + '&pdfString=true');
        blob pdfBody = pdfPage.getContentAsPDF();
        if(recordId != null){
            ContentVersion v = new ContentVersion();//Used to create a ContentVersion for the uploaded file blob
            v.versionData = pdfBody;
            v.title = 'FAB.pdf';
            v.pathOnClient = 'FAB.pdf';
            insert v;
            
            v = [select Id, ContentDocumentID from ContentVersion where id =: v.id limit 1];
            if(v.Id != null){
                ContentDocumentLink cdl = New ContentDocumentLink();//Used to link the ContentVersion(v) to the Opportunity
                cdl.LinkedEntityId = recordId;
                cdl.ContentDocumentId = v.ContentDocumentId;
                cdl.sharetype = 'v';
                insert cdl;
            }
            // Define the email
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
            
            // Create the email attachment    
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName('FAB.pdf');
            efa.setBody(pdfBody);
            
            // Set the paramaters to the email object
            email.setSubject(opp[0].Name + ' FAB');
            //List<Contact> Con= [select id, name from Contact where id =: opp[0].contact__c]; 
            //email.setTargetObjectId(Con[0].id); 
            email.setToAddresses( new String[] {UserInfo.getUserEmail()} );
            EmailTemplate et=[Select id from EmailTemplate where Name=:'Published FAB']; 
            email.setTemplateId(et.id); 
            
            // Attach file using setFileAttachments function
            email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
            
            // Sends the email
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});   
        }
        
    }
    */
    public void retrieveFilesandNote(){
        String tempId = '';//holds the content version to prefix
        if(oppId!=null){
            image = getImageIDs(oppId, true);
            imageFiles = getImageIDs(oppId, false);
            system.debug('@@@' + imageFiles + '@@@');
            if(imageFiles.size() > 0){
                pbFlag = 'True';
            }
            droppedSOP = fetchTheAuraSOP(oppId);
            noteDataCodes = fetchNote(oppId, 'Data Codes');
            noteWhat = fetchNote(oppId, 'What is it?');
            noteWhy = fetchNote(oppId, 'Why is it important?');
            noteCompatibility = fetchNote(oppId, 'High-Level Compatibility');
            modelImages = fetchModelImages(oppId, true);
            modelsList = fetchModelImages(oppId, false);
            trueModelsList = 'Models: ';
            if(modelsList != null && modelsList.size() > 0){
                for(String s : modelsList){
                    trueModelsList = trueModelsList + s + ', ';
                }
            }
            trueModelsList = trueModelsList.substring(0, trueModelsList.length()-2);
        }
    }
}