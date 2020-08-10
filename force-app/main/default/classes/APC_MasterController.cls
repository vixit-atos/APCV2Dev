/**
* @File Name          : APC_MasterController.apxc
* @Description        : Contains methods for all components in APC application
* @Author             : Sumit Datta, Akhila Putta.
* @Group              : 
* @Last Modified By   : Sumit Datta
* @Last Modified On   : 01/20/2020, 9:46:00 AM
* @Modification Log   : 
*==============================================================================
* Ver         Date                     Author                    Modification
*==============================================================================
* 1.0    10/21/2019, 9:46:00 AM       Sumit Datta             Initial Version
**/

public With Sharing class APC_MasterController {
    
    static final set<string> RECORDTYPENAMELIST = new set<string>{'APC Orders','APC Invoice','APC Credit','APC Core','APC Return','APC TBB'};
        
        @AuraEnabled
        public static List<Contact> getDealerContactsNew()
    {   // 01/16/2020 Modified by Dhruvil 
        //Removed Hardcoded ProfileID and Called it using customlabel 
        List<Contact> contactList = new List<Contact>();
        contactList = [select id,FirstName,LastName,Email from contact where email != '' and accountid  =:getloggeduseraccountid()];      
        system.debug('contactList->' + contactList);
        return contactList;      
    }
    @AuraEnabled
    public static List<Contact> getDealerContactsNew_Accountid(string accountid)
    {   // 01/16/2020 Modified by Dhruvil 
        //Removed Hardcoded ProfileID and Called it using customlabel 
        List<Contact> contactList = new List<Contact>();
        contactList = [select id,FirstName,LastName,Email from contact where email != '' and accountid  =:accountid];      
        system.debug('contactList->' + contactList);
        return contactList;      
    }
    @AuraEnabled
    public static List<String> getDealerCodes()
    {
        
        List<String> codesToReturn = new List<String>();
        codesToReturn.add('--select--');
        
        User theCurrentUser = [SELECT Contact.Account.Dealer_Code__C, ContactId FROM User WHERE Id =: UserInfo.getUserId() and Contact.Account.Dealer_Code__C!=null];
        system.debug(theCurrentUser.ContactId);
        codesToReturn.add(theCurrentUser.Contact.Account.Dealer_Code__C);
        system.debug('codesToReturn: ' + codesToReturn);
        /// 03/12/2020 Logic to include Visible Accounts
        list<accountinfowrapper> visibleaccountinfo = getuservisibleaccountdetails();        
        list<String> accountcodes = new list<String>();
        if(!visibleaccountinfo.isEmpty()){
            for(accountinfowrapper objAccount: visibleaccountinfo){
                accountcodes.add(objAccount.DealerCode);
            }
        }
        codesToReturn.addAll(accountcodes);      
        system.debug('codesToReturn: ' + codesToReturn);
        
        return codesToReturn;
        
    }
    @AuraEnabled
    public static List<accountinfowrapper> getDealerCodes_as_account()
    {// New logic after Stage 
        list<accountinfowrapper> dealercodeaccess = new list<accountinfowrapper>();
        accountinfowrapper defaultoption = new accountinfowrapper();
        defaultoption.Id = '';
        defaultoption.DealerCode='--select--';
        dealercodeaccess.add(defaultoption);
        User theCurrentUser = [SELECT Contact.Account.Dealer_Code__C, ContactId FROM User WHERE Id =: UserInfo.getUserId() and Contact.Account.Dealer_Code__C!=null];
        system.debug(theCurrentUser.ContactId);                
        
        dealercodeaccess.add(getloggeduserprimaryaccountinfo());
        dealercodeaccess.addAll(getuservisibleaccountdetails());     
        return dealercodeaccess;        
    }
    
    @AuraEnabled
    public static String getUserId() {
        return userInfo.getUserId();
    }
    @AuraEnabled
    Public static CaseAPIWrapper getpartvalidate(String partnumber) 
    {  
        
        CaseAPIWrapper objDT =  new CaseAPIWrapper();
        HttpRequest req = new HttpRequest();
        try {
            String paragonCredentails = System.label.Paragan_Credentials;
            APC_Paragon_Credentials__mdt paragonCredentials = [SELECT ID, User_Name__c,key__c,encrypted_password__c FROM APC_Paragon_Credentials__mdt WHERE MasterLabel =: paragonCredentails];
            system.debug('paragonCredentials       ' + paragonCredentials);
            String Password = decryptedpassword(paragonCredentials.encrypted_password__c,paragonCredentials.key__c);
            
            req.setEndpoint('callout:paragon_getpartvalidate');
            req.setMethod('POST');
            req.setTimeout(120000);
            req.setBody('{"Request": {"Login": { "UserId": "' + paragonCredentials.User_Name__c + '","UserPswd": "' + Password + '"},"Part":{"PartNum":  "' + partnumber + '", "ValidationMode": "1"}}}');                    
            //req.setBody('{"Request": {"Login": { "UserId": "' + paragonCredentials.User_Name__c + '","UserPswd": "' + paragonCredentials.Password__c + '"},"Part":{"PartNum":  "' + partnumber + '", "ValidationMode": "1"}}}');                    
            Http http = new Http();            
            HTTPResponse res;
            String jsonString='';   
            res = http.send(req); 
            system.debug(res.getBody());
            jsonString=res.getBody();
            
            System.debug('jsonString to Tokens-->'+jsonString);
            System.JSONParser jp=JSON.createParser(jsonString);
            System.debug('jp to parsing-->'+jp);
            
            String retcode,retMsg;
            while(jp.nextToken()!=null){
                if (jp.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String fieldName = jp.getText();
                    System.debug('fieldName: ' + fieldName);
                    jp.nextToken();            
                    if(fieldName=='RetCode'){                                     
                        retcode=jp.getText();
                        System.debug('Line Number 146'+retcode);  
                        //names.add(retcode);
                    }
                    if(fieldName=='RetMsg'){                                        
                        retMsg=jp.getText();
                        System.debug('Line Number 151'+retMsg);
                        objDT.message=retMsg;
                        //names.add(retMsg);
                    }
                    if(fieldName=='ValidationMode'){                                        
                        String mode=jp.getText();                    
                        //names.add(mode);
                    } 
                    if(fieldName=='PartNum'){                                       
                        String Partnum=jp.getText();                     
                        //names.add(Partnum);
                    }
                    if(fieldName=='ParagonPartNumber'){                                         
                        String Paragon=jp.getText();                     
                        //names.add(Paragon);
                    }
                    if(fieldName=='ParagonPartDescription'){                                        
                        String Paragondesc=jp.getText();
                        objDT.partdescription=Paragondesc;
                        //names.add(Paragondesc);
                    }
                    if(fieldName=='VMRSCode'){                                      
                        String vmr=jp.getText();
                        objDT.VMRSCode=vmr;
                        //names.add(vmr);
                    }
                    if(fieldName=='PartActive'){                                        
                        String active=jp.getText();
                        objDT.isActive=active;
                        //names.add(active);
                    }
                    if(fieldName=='Length'){                                        
                        String length=jp.getText(); 
                        objDT.Length=length;
                        //names.add(length);
                    }
                    if(fieldName=='Width'){                                         
                        String width=jp.getText();
                        objDT.Width=width;
                        //names.add(width);
                    }
                    if(fieldName=='height'){                                        
                        String height=jp.getText();
                        objDT.height=height;
                        //names.add(height);
                    }
                    if(fieldName=='UnitofMeasure'){                                         
                        String measure=jp.getText();
                        objDT.UnitofMeasure=measure;
                        //names.add(measure);
                    }
                    if(fieldName=='Volume'){                                        
                        String volume=jp.getText();
                        objDT.Volume=volume;
                        //names.add(volume);
                    }
                    if(fieldName=='Volumeunit'){                                        
                        String volumeunit=jp.getText();
                        objDT.volunit=volumeunit;
                        //names.add(volumeunit);
                    }
                    if(fieldName=='GrossWeight'){                                       
                        String gross=jp.getText();
                        objDT.GrossWeight=gross;
                        //names.add(gross);
                    }
                    if(fieldName=='WeightUnit'){                                        
                        String weightunit=jp.getText();
                        objDT.WeightUnit=weightunit;
                        //names.add(weightunit);
                    }
                    if(fieldName=='USPDCPackSize'){                                         
                        String packsize=jp.getText();
                        objDT.USPDCPackSize=packsize;
                        //names.add(packsize);
                    }
                    if(fieldName=='USDSPackSize'){                                      
                        String usdspack=jp.getText();
                        objDT.USDSPackSize=usdspack;
                        //names.add(usdspack);
                    }
                    if(fieldName=='CAPDCPackSize'){                                        
                        String cappack=jp.getText();
                        objDT.CAPDCPackSize=cappack;
                        //names.add(cappack);
                    }
                    if(fieldName=='CADSPackSize'){                                      
                        String cadpack=jp.getText();
                        objDT.CADSPackSize=cadpack;
                        //names.add(cadpack);
                    }
                    if(fieldName=='PlannerCode'){                                       
                        String plannercode=jp.getText();
                        objDT.plannercode=plannercode;
                        //names.add(plannercode);
                    }
                    if(fieldName=='Vendor'){                                        
                        String Vendor=jp.getText(); 
                        objDT.Vendor=Vendor;
                        //names.add(Vendor);
                    }
                    
                }
            }
        }catch (Exception e) {
            // "Convert" the exception into an AuraHandledException            
            System.debug('Error Message '+e.getMessage());            
            CustomAPIExceptionData data = new CustomAPIExceptionData('SAP API issue','SAP API is Currently unavailable:', 2);
            throw new AuraHandledException(JSON.serialize(data));
        }
        finally {
            // Something executed whether there was an error or not
        }
        System.debug('objDT'+objDT);
        
        return objDT;
    }
    
    
    @AuraEnabled
    public static String getloggedusercontactid(){ 
        list<User> u = new list<User>();               
        u  = [select contactid from user where id =:UserInfo.getUserId()];        
        return u[0].ContactId != null ? u[0].ContactId : '';
    }    
    @AuraEnabled
    public static String getloggeduseraccountid(){
        contact c = new contact();
        String accountid = '';
        list<contact> contacts = [select accountId from contact where id in (select contactid from user where id=:UserInfo.getUserId())];   
        if(!contacts.isEmpty()){
            accountid = contacts[0].accountId;
        }      
        return accountid;       
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
        // 01/17/2020 Try catch blocks added by Dhruvil
        try{
            insert cdLinks;
        }
        catch(DmlException e){
            System.debug('The following DML exception has occurred: ' + e.getMessage());
            CustomAPIExceptionData data = new CustomAPIExceptionData('DML issue','There Was an error at server while creating your case - please contact your Admin', 3);
            throw new AuraHandledException(JSON.serialize(data));
        }Catch(exception e)
        {
            System.debug(e.getMessage());
            CustomAPIExceptionData data = new CustomAPIExceptionData('Unknown issue','There was an unknown error while creating your case - please contact your Admin', 4);
            throw new AuraHandledException(JSON.serialize(data));
        }   
        return cdLinks;
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
        }catch(DmlException e){
            System.debug('The following DML exception has occurred: ' + e.getMessage());
            returnoutcome= false;
            CustomAPIExceptionData data = new CustomAPIExceptionData('DML issue','There Was an error at server while creating your case - please contact your Admin', 3);
            throw new AuraHandledException(JSON.serialize(data));
        }Catch(exception e)
        {
            System.debug(e.getMessage());
            returnoutcome= false;
            CustomAPIExceptionData data = new CustomAPIExceptionData('Unknown issue','There was an unknown error while creating your case - please contact your Admin', 4);
            throw new AuraHandledException(JSON.serialize(data));
        }   
        return returnoutcome;
    }    
    @AuraEnabled
    public static List<ContentDocumentLink> createDocumentLinksfrompills(Map<String, Object> params) {
        system.debug('pillsoffiles => '+params);
        List<Object> pills = (List<Object>)params.get('pillsoffiles');
        String recordId = (String)params.get('recordId');
        List<ContentDocumentLink> cdLinks = new List<ContentDocumentLink>();
        
        for(Object pill : pills) {
            Map<Object,Object> fileMap = (Map<Object,Object>)pill;
            Map<Object,Object> file = (Map<Object,Object>)fileMap.get('file');
            cdLinks.add(new ContentDocumentLink(
                LinkedEntityId=recordId, 
                ContentDocumentId=(String)file.get('Id'), 
                ShareType='V', 
                Visibility='AllUsers'
            ));
        }
        
        //01/17/2020 Try catch block added by Dhruvil
        try{ 
            insert cdLinks;
        }catch(DmlException e){
            System.debug('The following DML exception has occurred: ' + e.getMessage());
            CustomAPIExceptionData data = new CustomAPIExceptionData('DML issue','There Was an error at server while creating your case - please contact your Admin', 3);
            throw new AuraHandledException(JSON.serialize(data));
        }Catch(exception e)
        {
            System.debug(e.getMessage());
            CustomAPIExceptionData data = new CustomAPIExceptionData('Unknown issue','There was an unknown error while creating your case - please contact your Admin', 4);
            throw new AuraHandledException(JSON.serialize(data));
        }   
        return cdLinks;
    }    
    // 01/02/2020 Added by Sumit Datta 
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
    public static List<ContentDocumentLink> createDocumentLinksformultiplecases(list<case> cases, String orderlinenumberdocumentidsmapobj) {
        List<ContentDocumentLink> cdLinks = new List<ContentDocumentLink>();
        List<orderlinenumberdocumentidsmap> objorderlinenumberdocumentidsmap = (List<orderlinenumberdocumentidsmap>)JSON.deserialize(orderlinenumberdocumentidsmapobj,List<orderlinenumberdocumentidsmap>.class);
        system.debug('c.objorderlinenumberdocumentidsmap :' + objorderlinenumberdocumentidsmap);
        for(case c : cases)
        {         
            system.debug('c.APC_Line_Number__c :' + c.APC_Line_Number__c);
            
            for(orderlinenumberdocumentidsmap ob: objorderlinenumberdocumentidsmap)
            {
                if(ob.OrderLineNumber == c.APC_Line_Number__c && ob.documentids != null) 
                {
                    system.debug(' ob.documentids :' +  ob.documentids);
                    list<String> documentids = ob.documentids;
                    for(string docid: documentids)
                    {
                        system.debug(' docid :' +  docid);
                        cdLinks.add(new ContentDocumentLink(
                            LinkedEntityId=c.Id, 
                            ContentDocumentId=docid, 
                            ShareType='V', 
                            Visibility='AllUsers'
                        ));
                    }
                }  
            }
        }
        
        try{
            insert cdLinks;
        }catch(DmlException e){
            System.debug('The following DML exception has occurred: ' + e.getMessage());
            CustomAPIExceptionData data = new CustomAPIExceptionData('DML issue','There Was an error at server while creating your case - please contact your Admin', 3);
            throw new AuraHandledException(JSON.serialize(data));
        }Catch(exception e)
        {
            System.debug(e.getMessage());
            CustomAPIExceptionData data = new CustomAPIExceptionData('Unknown issue','There was an unknown error while creating your case - please contact your Admin', 4);
            throw new AuraHandledException(JSON.serialize(data));
        }   
        return cdLinks;
    }  
    
    // Additional Recipient logic 04/05/2020 By Sumit Datta 
    public static void createadditionalrecipientContentNote(list<case> caselist, String additionalrecipientlist) {
        String userId = UserInfo.getUserId();
        list<recipientpill> recipientpilllist = (list<recipientpill>)JSON.deserialize(additionalrecipientlist,list<recipientpill>.class);
        list<ContentNote> recipientlisttoadd = new list<ContentNote>();
        list<ContentDocumentLink> recipientlisttoaddlinks = new list<ContentDocumentLink>();
        system.debug('additionalrecipientlist: ' + additionalrecipientlist);
        if(!recipientpilllist.isEmpty()){
            for(recipientpill recipient: recipientpilllist){
                ContentNote objCntNote = new ContentNote();
                objCntNote.Title = recipient.label;                    
                recipientlisttoadd.add(objCntNote); 
            }   
            try{
                insert recipientlisttoadd;
                
                for(case objcase : caselist){
                    for(ContentNote recipient : recipientlisttoadd){
                        ContentDocumentLink objCntDocLink = new ContentDocumentLink();
                        objCntDocLink.LinkedEntityId = objcase.Id; // Specify your parent Id 
                        objCntDocLink.ContentDocumentId = recipient.Id;  //Content Note Id
                        objCntDocLink.shareType = 'V'; // Specify your sharing type 
                        objCntDocLink.Visibility='AllUsers';
                        recipientlisttoaddlinks.add(objCntDocLink);
                    }
                }
                insert recipientlisttoaddlinks;
                sendnotificationtoadditionalrecipientoncasecreationContentNote(caselist);
            } catch(DmlException e){
                System.debug('The following DML exception has occurred: ' + e.getMessage());
                CustomAPIExceptionData data = new CustomAPIExceptionData('DML issue','There Was an error at server while creating your case - please contact your Admin', 3);
                throw new AuraHandledException(JSON.serialize(data));
            }Catch(exception e)
            {
                System.debug(e.getMessage());
                CustomAPIExceptionData data = new CustomAPIExceptionData('Unknown issue','There was an unknown error while creating your case - please contact your Admin', 4);
                throw new AuraHandledException(JSON.serialize(data));
            } 
        }
    } 
    
    
    // Wrapper classes
    public class pillwrapper{
        String label;
        String name;
        string type;
        string iconname; 
        ContentDocument file;
    }
    public class recipientpill {
        @AuraEnabled public String  label {get; set;}
        @AuraEnabled public String  name  {get; set;}
    }    
    public class CustomExceptionData {
        public String name;
        public case caserecord;
        public Integer code;
        
        public CustomExceptionData(String name, case caserecord, Integer code) {
            this.name = name;
            this.caserecord = caserecord;
            this.code = code;
        }
    }  
    public class CustomAPIExceptionData {
        public String name;
        public String message;
        public Integer code;
        
        public CustomAPIExceptionData(String name, String message, Integer code) {
            this.name = name;
            this.message = message;
            this.code = code;
        }
    }  
    public class orderlinenumberdocumentidsmap{
        @AuraEnabled public String  OrderLineNumber {get; set;}
        @AuraEnabled public list<String> documentids {get; set;}
    }  
    public class CaseAPIWrapper{
        @AuraEnabled public String  message {get;set;}
        @AuraEnabled public String  isActive {get;set;}
        @AuraEnabled public String  partdescription {get;set;}
        @AuraEnabled public String  plannercode {get;set;}
        @AuraEnabled public String  vendor {get;set;}
        @AuraEnabled public String  VMRSCode  {get;set;}
        @AuraEnabled public String  Volume  {get;set;}
        @AuraEnabled public String  UnitofMeasure  {get;set;}
        @AuraEnabled public String  Length  {get;set;}
        @AuraEnabled public String  Width  {get;set;}
        @AuraEnabled public String  height  {get;set;}
        @AuraEnabled public String  volunit  {get;set;}
        @AuraEnabled public String  GrossWeight  {get;set;}
        @AuraEnabled public String  WeightUnit  {get;set;}
        @AuraEnabled public String  USPDCPackSize  {get;set;}
        @AuraEnabled public String  USDSPackSize  {get;set;}
        @AuraEnabled public String  CAPDCPackSize  {get;set;}
        @AuraEnabled public String  CADSPackSize  {get;set;}
    }       
    
    public static string decryptedpassword(string encryptedtext, string key){
        String encryptedString = EncodingUtil.urlDecode(encryptedtext, 'UTF-8');
        Blob keyblob = EncodingUtil.base64Decode(key);
        Blob dataToDecrypt = EncodingUtil.base64Decode(encryptedString);
        Blob decryptedData = Crypto.decryptWithManagedIV('AES256', keyblob, dataToDecrypt);
        String decryptedDataString = decryptedData.toString();
        system.debug('decrypted value: ' + decryptedDataString);
        return decryptedDataString;
    }       
    // New Notification logic using content note
    public static void sendnotificationtoadditionalrecipientoncasecreationContentNote(list<case> caselist){
        system.debug('caselist : ' + caselist);
        if(!caselist.isEmpty()){
            for(case objcase: caselist){
                Map<String, Object> inputs = new Map<String, Object>();
                inputs.put('caseId', objcase.Id);
                Flow.Interview.APC_Email_Notification_Case_Creation_Content_Note myflow = new  Flow.Interview.APC_Email_Notification_Case_Creation_Content_Note(inputs);
                try{
                    myflow.start();
                }catch(exception ex){
                    System.debug(ex.getMessage());
                    CustomAPIExceptionData data = new CustomAPIExceptionData('Email error','There was error while sending email to Additional Recipient- please contact your Admin', 5);
                    throw new AuraHandledException(JSON.serialize(data));
                }                
            }
        }        
    }   
    
    ///////////////////// New Case Creation Button Logic 02/25/2020
    
    @AuraEnabled
    public static string getRecordType(string recordTypeId)    {
        string RecordType;
        try
        {
            RecordType = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosById().get(recordTypeId).getName();        
        }
        catch(Exception e)
        {
            system.debug('Error! Line No: ' + e.getLineNumber() + ', Message:' + e.getMessage() + ', ' + e.getStackTraceString());
        }
        return RecordType;
    }    
    public class KeyValue     {
        @AuraEnabled 
        public string value {get; set;}
        @AuraEnabled 
        public string label {get; set;}
    }    
    @AuraEnabled        
    public static list<KeyValue> getDefaultRecordType()    {
        List<KeyValue> lstKV = new list<KeyValue>();
        KeyValue KV;
        try
        {
            for(RecordTypeInfo info: Case.SObjectType.getDescribe().getRecordTypeInfos()) {
                if(info.isAvailable() && info.getName() != 'Master') 
                {
                    KV = new KeyValue();
                    KV.value = info.getRecordTypeId();
                    KV.label = info.getName();
                    lstKV.add(KV);
                }
            }
        }
        catch(Exception e)
        {
            system.debug('Error! Line No: ' + e.getLineNumber() + ', Message:' + e.getMessage() + ', ' + e.getStackTraceString());
        }
        return lstKV;
    }    
    @AuraEnabled
    public static Id getAccountId(Id conId)    {
        string accId;
        try
        {
            Contact con = [SELECT Id, 
                           AccountId 
                           FROM Contact 
                           WHERE Id=:conId];
            accId = con.AccountId;
        }
        catch(Exception e)
        {
            system.debug('Error! Line No: ' + e.getLineNumber() + ', Message:' + e.getMessage() + ', ' + e.getStackTraceString());
        }
        return accId;
    }   
    
    ////////////////// Additional Dealer contacts email notification
    
    public static void sendnotificationtoadditionaldealercontacts(list<case> caselist){
        system.debug('caselist : ' + caselist);
        if(!caselist.isEmpty()){
            for(case objcase: caselist){
                Map<String, Object> inputs = new Map<String, Object>();
                List<String> additionaldealercontactlist = new List<String>();
                string contactsemail = objcase.Additional_Contacts__c;
                if(contactsemail != null){
                    if(contactsemail.contains(';')){
                        additionaldealercontactlist=contactsemail.split(';');
                    }else{
                        additionaldealercontactlist.add(contactsemail);
                    }
                    
                    inputs.put('caseId', objcase.Id);
                    inputs.put('additionaldealers_email_list', additionaldealercontactlist);
                    Flow.Interview.APC_Case_Email_Notification_Additional_Contacts myflow = new  Flow.Interview.APC_Case_Email_Notification_Additional_Contacts(inputs);
                    try{
                        myflow.start();
                    }catch(exception ex){
                        System.debug(ex.getMessage());
                        CustomAPIExceptionData data = new CustomAPIExceptionData('Email error','There was error while sending email to Additional Recipient- please contact your Admin', 5);
                        throw new AuraHandledException(JSON.serialize(data));
                    }       
                }                        
            }
        }        
    }    
    
    /// User Info for profile menu
    @AuraEnabled
    public static string getusernameinfo()    {
        return userInfo.getName();
    }
    /// Logic for visibility of all the Account code present in User's Visibility fields   
    
    public static list<String> getuservisibilityAccountcodes()    {
        User loggedinuser = [select id,visibilities__c from user where id=:userinfo.getUserId()];
        list<String> accountcodes = new list<String>();
        if(loggedinuser.visibilities__c != null && loggedinuser.visibilities__c !=''){
            String  visibilities = loggedinuser.visibilities__c;
            list<String> visibilitylist = new list<String>();
            visibilitylist = visibilities.split(',');  
            if(!visibilitylist.isEmpty()){
                for(string objvisible : visibilitylist){                   
                    if(objvisible.contains('cn=')){
                        integer visibilitycharacterlength = objvisible.length();                         
                        accountcodes.add(objvisible.substring(visibilitycharacterlength-4));
                    }                    
                }
                accountcodes.add('Z');
                system.debug('accountcodes: ' +accountcodes);
            }
        }          
        return accountcodes;
    }     
    @AuraEnabled
    public static list<accountinfowrapper> getuservisibleaccountdetails ()    {
        list<accountinfowrapper> visibleaccountlist = new list<accountinfowrapper>();       
        list<AccountContactRelation> VisibleAccountcontactrelation	 = new list<AccountContactRelation>();
        list<String> accountcodes = new list<String>();        
        contact c = [select Id, accountId from contact where id in (select contactid from user where id=:UserInfo.getUserId())];
        if(c != null){
            VisibleAccountcontactrelation = [select id, Accountid, Account.Dealer_code__c,account.Name from AccountContactRelation where contactid =: c.Id and isDirect=false];
            if(!VisibleAccountcontactrelation.isEmpty()){
                for(AccountContactRelation a: VisibleAccountcontactrelation){
                    accountinfowrapper objaccountinfowrapper = new accountinfowrapper();
                    objaccountinfowrapper.Id =a.Accountid;
                    objaccountinfowrapper.name=a.account.Name;
                    objaccountinfowrapper.DealerCode=a.Account.Dealer_code__c;
                    visibleaccountlist.add(objaccountinfowrapper);
                }
            }
        }
        
        return visibleaccountlist;        
    } 
    @AuraEnabled
    public static accountinfowrapper getloggeduserprimaryaccountinfo()    {
        accountinfowrapper objaccountinfowrapper = new accountinfowrapper();
        contact c = [select accountId,account.name, account.Dealer_code__c from contact where id in (select contactid from user where id=:UserInfo.getUserId())]; 
        objaccountinfowrapper.Id=c.accountId;
        objaccountinfowrapper.name=c.account.name;
        objaccountinfowrapper.DealerCode=c.account.Dealer_code__c;
        return objaccountinfowrapper;        
    }     
    public class accountinfowrapper {
        @AuraEnabled Public String Id;
        @AuraEnabled Public String name;
        @AuraEnabled Public String DealerCode;
    }
    public class contactinfowrapper {
        @AuraEnabled Public String Id;
        @AuraEnabled Public String firstname;
        @AuraEnabled Public String lastname;
        @AuraEnabled Public String email;
        @AuraEnabled Public String DealerCode;
        @AuraEnabled Public String accountname;
    }
    
    @AuraEnabled
    public static List<Contact> getDealerContactsSelectedAccount(String dealercode)    {   
        List<Contact> contactList = new List<Contact>();  
        contactList = [select id,FirstName,LastName,Email from contact where email != '' and accountid  =:dealercode and active__c = true];
        system.debug('contactList->' + contactList);
        return contactList;      
    }
    
    @AuraEnabled
    public static case createcaserecordexternal(case c, string additionalrecipientlist, string recordtypename, string dealercode, boolean isexternal){
        // Add security Check here
        case returncaserecord = new case();
        system.debug('Case Record: ' + c);
        if( isexternal != null && isexternal){
            if(!does_user_has_account_access_accountid(dealercode)){
                CustomAPIExceptionData data = new CustomAPIExceptionData('Security Breach','You do not have access to this Dealer' + dealercode, 6);
                throw new AuraHandledException(JSON.serialize(data));
            }
        }
        
        
        if (Test.isRunningTest()){
            // Multiple Mock Response Required for Testing multiple callouts in one method, which is not possible in Test Class 
        } 
        else{
            
            
            // Duplication check Server Side
            if (c.Request_Type__c == 'TBB'){
                findduplicatecaseforTBBserverside(c.Body_Number__c, '',dealercode);
            } 
            else if (c.Request_Type__c == 'Core Inquiry'){           } 
            else if (c.Request_Type__c == 'Credit/Debit Request'){
                findduplicateforcreditdebit(dealercode, c.Part_No__c, c.Request_Type__c, c.APC_Line_Number__c, c.Credit_Debit__c );
            }
            else if (
                c.Request_Type__c == 'PDC Return'                     ||
                c.Request_Type__c == 'Vendor Return'                  ||
                c.Request_Type__c == 'Excess/Special Approval Status' ||
                c.Request_Type__c == 'Excess/Special Credit'          ||
                c.Request_Type__c == 'Excess/Special Other'           ||
                c.Request_Type__c == 'Excess/Special Shipping'        ||
                c.Request_Type__c == 'Excess/Special Allowance' 
            ){
                findduplicateforReturnnumber(dealercode, c.Part_No__c, c.Request_Type__c, c.APC_Line_Number__c, c.Return_Number__c );
                
            }
            else if ( c.Request_Type__c == 'Price Request'){
                findduplicateforbucket1pricerequest(dealercode, c.Part_No__c, c.Request_Type__c, c.APC_Line_Number__c,c.SAP_Order_Number__c);
            }
            else {
                findduplicateforbucket1(dealercode, c.Part_No__c, c.Request_Type__c, c.APC_Line_Number__c,c.SAP_Order_Number__c);
            }
            
            // Find Sold to party and Order Mismatch
            if( 
                c.Request_Type__c == 'TBB' ||
                c.Request_Type__c == 'Core Inquiry' ||
                c.Request_Type__c == 'Lead Time' ||
                c.Request_Type__c == 'Material Load' ||
                c.Request_Type__c == 'Pack Size' ||
                c.Request_Type__c == 'Price Request' ||
                c.Request_Type__c == 'Reactivation' ||
                c.Request_Type__c == 'Weights & Dimensions' ||
                c.Request_Type__c == 'PDC Stock Check'
            ){
                
            }
            else {
                findordertosoldtopartyrelation(dealercode, c.SAP_Order_Number__c,c.APC_PO_Number__c, dealercode);
            }
            // 
        }
        
        if(c.Part_No__c != null && c.Part_No__c != '' && c.Request_Type__c != 'Material load' &&
           c.Request_Type__c != 'Core Inquiry' && c.Request_Type__c != 'TBB'){
               CaseAPIWrapper obj_CaseAPIWrapper = getpartvalidate(c.Part_No__c);
               system.debug('c.Part_No__c' + c.Part_No__c);
               system.debug('obj_CaseAPIWrapper.message:' + obj_CaseAPIWrapper.message);
               if(obj_CaseAPIWrapper.message ==  'Part is Valid'){    
                   
               }
               else{                   
                   CustomAPIExceptionData data = new CustomAPIExceptionData('Part is Invalid','Part is invalid', 6);
                   throw new AuraHandledException(JSON.serialize(data));
               }
           }       
        
        system.debug('case received from APC Commmunity ' + c);  
        //Fetching the assignment rules on case
        AssignmentRule AR = new AssignmentRule();
        AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
        
        //Creating the DMLOptions for "Assign using active assignment rules" checkbox
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
        c.setOptions(dmlOpts);
        c.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(recordtypename).getRecordTypeId() != null ? Schema.SObjectType.Case.getRecordTypeInfosByName().get(recordtypename).getRecordTypeId() : '';
        list<case> caselist = new list<case>();
        try
        {   
            c.AccountId = dealercode;
            caselist.add(c);
            insert caselist;            
            returncaserecord = [select Id, CaseNumber, Additional_Contacts__c from case where id = :caselist[0].Id];
            // Logic to send notification to additional recipient for Bucket 1 or Bucket 3 // 02/27/2020
            
            if(returncaserecord.Additional_Contacts__c != null){
                list<case> caselistforadditionalrecipient = new list<case>();
                caselistforadditionalrecipient.add(returncaserecord);
                sendnotificationtoadditionaldealercontacts(caselistforadditionalrecipient);
            }
            
            system.debug('Newly Created Cases: ' +caselist);
            if(String.isNotEmpty(additionalrecipientlist)){
                createadditionalrecipientContentNote(caselist,additionalrecipientlist);
            }            
        }
        catch(DmlException e){
            System.debug('The following DML exception has occurred: ' + e.getMessage());
            CustomAPIExceptionData data = new CustomAPIExceptionData('DML issue','There Was an error at server while creating your case - please contact your Admin', 3);
            throw new AuraHandledException(JSON.serialize(data));
            
        }
        catch(exception e ){
            system.debug(e.getMessage());
            CustomAPIExceptionData data = new CustomAPIExceptionData('Unknown issue','There was an unknown error while creating your case - please contact your Admin', 4);
            throw new AuraHandledException(JSON.serialize(data));
        }
        system.debug('caselist[0].Id '+caselist[0].Id);       
        system.debug('returncaserecord '+[select Id, CaseNumber from case where id = :caselist[0].Id]);         
        //system.debug('returncaserecord '+returncaserecord);
        return returncaserecord;
        // return c; 
    }    
    // Added by Sumit Datta 01/10/2020
    
    @AuraEnabled
    public static void findduplicatecaseforTBBserverside (string bodynumbertbb, string dealercode, string accountid)
    {
        system.debug('bodynumbertbb received from APC Commmunity ' + bodynumbertbb); 
        system.debug('dealercode received from APC Commmunity ' + dealercode);
        system.debug('accountid received from APC Commmunity ' + accountid);
        //String bodynumber = c.Body_Number__c;
        list<case> duplicatecase = new list<case>();
        
        if(String.isNotBlank(accountid)){
            duplicatecase = [select id,CaseNumber from case where Body_Number__c =:bodynumbertbb and AccountId =:accountid and status <> 'Closed'];
        }else if (String.isNotBlank(dealercode)){
            duplicatecase = [select id,CaseNumber from case where Body_Number__c =:bodynumbertbb and Account.Dealer_Code__c =:dealercode and status <> 'Closed'];
        }
        
        if(!duplicatecase.isEmpty())
        {
            CustomExceptionData data = new CustomExceptionData('Duplicate Case Record Found', duplicatecase[0], 1);
            throw new AuraHandledException(JSON.serialize(data));
        }   
    }  
     @AuraEnabled
    public static void findduplicateforbucket1pricerequest(string AccountId, string partnumber, string requesttype, string linenumber,string ordernumber)
    {        
        system.debug('AccountId received from APC Commmunity '  + AccountId);
        system.debug('partnumber received from APC Commmunity '  + partnumber); 
        system.debug('requesttype received from APC Commmunity ' + requesttype); 
        system.debug('linenumber received from APC Commmunity '  + linenumber); 
        system.debug('ordernumber received from APC Commmunity ' + ordernumber);
        
        list<case> duplicatecase = [select id,CaseNumber from case       where 
                                    status <> 'Closed'                   and 
                                    AccountId =:AccountId                and
                                    Request_Type__c =:requesttype        and
                                    Part_No__c =:partnumber              
                                   ];       
        if(!duplicatecase.isEmpty())
        {
            CustomExceptionData data = new CustomExceptionData('Duplicate Case Record Found', duplicatecase[0], 1);
            throw new AuraHandledException(JSON.serialize(data));
        }  
    } 
    @AuraEnabled
    public static void findduplicateforbucket1(string AccountId, string partnumber, string requesttype, string linenumber,string ordernumber)
    {        
        system.debug('AccountId received from APC Commmunity '  + AccountId);
        system.debug('partnumber received from APC Commmunity '  + partnumber); 
        system.debug('requesttype received from APC Commmunity ' + requesttype); 
        system.debug('linenumber received from APC Commmunity '  + linenumber); 
        system.debug('ordernumber received from APC Commmunity ' + ordernumber);
        
         list<case> duplicatecase = [select id,CaseNumber from case       where 
                                    status <> 'Closed'                   and 
                                    AccountId =:AccountId                and
                                    Request_Type__c =:requesttype        and
                                    Part_No__c =:partnumber              and
                                    APC_Line_Number__c=:linenumber       and
                                    SAP_Order_Number__c=:ordernumber
                                   ];
        if(!duplicatecase.isEmpty())
        {
            CustomExceptionData data = new CustomExceptionData('Duplicate Case Record Found', duplicatecase[0], 1);
            throw new AuraHandledException(JSON.serialize(data));
        }  
    } 
    @AuraEnabled
    public static void findduplicateforcreditdebit(string AccountId, string partnumber, string requesttype, string linenumber, string ordernumber)
    {        
        system.debug('AccountId received from APC Commmunity '  + AccountId);
        system.debug('partnumber received from APC Commmunity '  + partnumber); 
        system.debug('requesttype received from APC Commmunity ' + requesttype); 
        
        list<case> duplicatecase = [select id,CaseNumber from case       where 
                                    status <> 'Closed'                   and 
                                    AccountId =:AccountId                and
                                    Request_Type__c =:requesttype        and
                                    Part_No__c =:partnumber              and
                                    APC_Line_Number__c=:linenumber       and
                                    Credit_Debit__c =:ordernumber
                                   ];
        if(!duplicatecase.isEmpty())
        {
            CustomExceptionData data = new CustomExceptionData('Duplicate Case Record Found', duplicatecase[0], 1);
            throw new AuraHandledException(JSON.serialize(data));
        }  
    }  
    @AuraEnabled
    public static void findduplicateforReturnnumber(string AccountId, string partnumber, string requesttype, string linenumber, string ordernumber)
    {        
        system.debug('AccountId received from APC Commmunity '  + AccountId);
        system.debug('partnumber received from APC Commmunity '  + partnumber); 
        system.debug('requesttype received from APC Commmunity ' + requesttype); 
        
        list<case> duplicatecase = [select id,CaseNumber from case       where 
                                    status <> 'Closed'                   and 
                                    AccountId =:AccountId                and
                                    Request_Type__c =:requesttype        and
                                    Part_No__c =:partnumber              and
                                    APC_Line_Number__c=:linenumber       and
                                    Return_Number__c =:ordernumber
                                   ];
        if(!duplicatecase.isEmpty())
        {
            CustomExceptionData data = new CustomExceptionData('Duplicate Case Record Found', duplicatecase[0], 1);
            throw new AuraHandledException(JSON.serialize(data));
        }  
    }  
    @AuraEnabled
    public static void findordertosoldtopartyrelation(String AccountId, String orderNumber, String customerPoNo, string dealercode){
        String soldtopartycode ='';
       
        if (!String.isEmpty(AccountId) && AccountId != null && AccountId!= '') {
            soldtopartycode = getselecteddealercode(AccountId);
        }
        
        if(soldtopartycode.length() <5){
            soldtopartycode = 'F' + soldtopartycode;
        }
        customerPoNo = customerPoNo != null ? customerPoNo:'';
        String response = DealerCisApi.getSalesOrderFromParagon(orderNumber, customerPoNo, soldtopartycode);
        System.JSONParser jp=JSON.createParser(response);
        String retcode;
        String retmessage;
        while(jp.nextToken()!=null){
            if (jp.getCurrentToken() == JSONToken.FIELD_NAME) {
                String fieldName = jp.getText();
                System.debug('fieldName: ' + fieldName);
                jp.nextToken();            
                if(fieldName=='ReturnCode'){                                     
                    retcode=jp.getText();                        
                }
                if(fieldName=='ReturnMessage'){                                        
                    retmessage=jp.getText();                       
                }
            }
        }
        system.debug('response: '+ response);
        system.debug('retmessage: '+ retmessage);
        system.debug('retcode: '+ retcode);
        
        if(retcode == '00'){
            
        }
        else{
            CustomAPIExceptionData data = new CustomAPIExceptionData('Sold to party and order mismatch', retmessage, 1);
            throw new AuraHandledException(JSON.serialize(data));
        }
        
    }
    
    @AuraEnabled
    public static String getselecteddealercode(String AccountId)
    {   
        account objacc = new account();
        objacc = [select id,dealer_code__c from account where  id=:AccountId];        
        system.debug('objacc->' + objacc);
        return objacc.dealer_code__c;      
    }  
    
    
    @AuraEnabled
    public static list<case> createlistofcasesexternal_withoutorder(list<Case> caseobjlist, list<String> contactlist, String orderlinenumberdocumentidsmapobj, string additionalrecipientlist, string dealercode, boolean isexternal){
        // Add security Check here
        String Dealer_code = APC_ListController.getSoldtopartyfromaccountid(dealercode);
        if( isexternal != null && isexternal){
            if(!does_user_has_account_access_accountid(dealercode)){
                CustomAPIExceptionData data = new CustomAPIExceptionData('Security Breach','You do not have access to this Dealer' + Dealer_code, 6);
                throw new AuraHandledException(JSON.serialize(data));
            }
        }
        //Fetching the assignment rules on case
        AssignmentRule AR = new AssignmentRule();
        AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
        
        //Creating the DMLOptions for "Assign using active assignment rules" checkbox
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
        
        Case newCase = new Case(Status = 'New') ;        
        
        boolean success = false;       
        list<Case> casesfordocumentlinks = new list<case>();
        Profile currentuserprofile = [select Name from profile where id = :userinfo.getProfileId()];
        string contactid = '';
        string accountid = '';     
        if(!caseobjlist.isEmpty()){
            for(Case c:caseobjlist){   
                system.debug('c.AccountId: ' + c.AccountId);
                c.Request_Type__c='Order Status';
                c.RecordTypeId = Schema.SObjectType.case.getRecordTypeInfosByName().get('APC Order').getRecordTypeId();
                c.Origin = c.Origin != null ?  c.Origin :  'Web';                   
                c.Priority =c.Priority != null ? c.Priority :'Medium';                
                c.Status ='New';
                c.ContactId = c.ContactId != null ? c.ContactId: getloggedusercontactid();
                c.AccountId = c.AccountId != null ? c.AccountId : Dealercode;               
                c.APC_Source__c = 'Existing Order';
                c.Additional_Contacts__c = String.join(contactlist, ';');               
                c.setOptions(dmlOpts);   
                // Add Sold To Party and order mismatch logic
                findordertosoldtopartyrelation(c.AccountId, c.SAP_Order_Number__c,c.APC_PO_Number__c,Dealer_code);                
            }        
            try            {
                system.debug('caseobjlist = ' + caseobjlist);
                insert caseobjlist;
                Set<Id> caseids = (new Map<Id,case>(caseobjlist)).keySet();
                casesfordocumentlinks = [select id, APC_Line_Number__c, CaseNumber, Additional_Contacts__c from case where id in:caseids];
                sendnotificationtoadditionaldealercontacts(casesfordocumentlinks);
                system.debug('casesfordocumentlinks: ' +casesfordocumentlinks);
                system.debug('orderlinenumberdocumentidsmapobj: ' +orderlinenumberdocumentidsmapobj);
                
                createDocumentLinksformultiplecases(casesfordocumentlinks, orderlinenumberdocumentidsmapobj);
                createadditionalrecipientContentNote(caseobjlist,additionalrecipientlist);
                success= true;
                system.debug('caseobjlist = ' + casesfordocumentlinks);
            }
            catch(DmlException e)            {
                System.debug('The following DML exception has occurred: ' + e.getMessage());
                CustomAPIExceptionData data = new CustomAPIExceptionData('DML issue','There Was an error at server while creating your case - please contact your Admin', 3);
                throw new AuraHandledException(JSON.serialize(data));
            }
            Catch(exception e)            {
                System.debug(e.getMessage());
                CustomAPIExceptionData data = new CustomAPIExceptionData('Unknown issue','There was an unknown error while creating your case - please contact your Admin', 4);
                throw new AuraHandledException(JSON.serialize(data));
            }         
        }
        else 
        {
            success=false;
        }
        
        return casesfordocumentlinks;
    } 
    
    @AuraEnabled
    public static List<picklistwrapper1> getPicklistvalues(String objectName, String field_apiname){
        List<picklistwrapper1> optionlist = new List<picklistwrapper1>();       
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
        Map<String, Schema.SObjectField> field_map = gd.get(objectName.toLowerCase()).getDescribe().fields.getMap();        
        List<Schema.PicklistEntry> picklistValues = field_map.get(field_apiname).getDescribe().getPickListValues();  
        for (Schema.PicklistEntry pv : picklistValues) {
            picklistwrapper1 obj_picklistwrapper = new picklistwrapper1();
            obj_picklistwrapper.label = pv.getLabel();
            obj_picklistwrapper.value = pv.getValue();
            optionlist.add(obj_picklistwrapper); 
        }
        return optionlist;
    }
    
    @AuraEnabled
    public static List<picklistwrapper1> getdependentPicklistvalues(String objectName, string parentField, string parentFieldvalue,string childField){
        List<picklistwrapper1> optionlist = new List<picklistwrapper1>();       
        Map<String,List<String>> pickListMap = new Map<String,List<String>>();
        PicklistWrapper pw = new PicklistWrapper();
        pw.pickListMap = pickListMap;
        
        if (Schema.getGlobalDescribe().get(ObjectName) ==null || String.isBlank(parentField) || String.isBlank(ChildField)){
            return optionlist;
        }
        
        Schema.sObjectType objType = Schema.getGlobalDescribe().get(ObjectName).newSObject().getSObjectType();
        Map<String, Schema.SObjectField> objFieldMap = objType.getDescribe().fields.getMap();
        
        if (!objFieldMap.containsKey(parentField) || !objFieldMap.containsKey(childField)){
            return optionlist;     
        }
        
        List<PicklistEntryWrapper> depEntries = (List<PicklistEntryWrapper>)JSON.deserialize(JSON.serialize(objFieldMap.get(ChildField).getDescribe().getPicklistValues()), List<PicklistEntryWrapper>.class);
        List<String> controllingValues = new List<String>();
        
        for (Schema.PicklistEntry ple : objFieldMap.get(parentField).getDescribe().getPicklistValues()) {
            pickListMap.put(ple.getLabel(), new List<String>());
            controllingValues.add(ple.getLabel());
        }
        
        for (PicklistEntryWrapper plew : depEntries) {
            String validForBits = base64ToBits(plew.validFor);
            for (Integer i = 0; i < validForBits.length(); i++) {
                String bit = validForBits.mid(i, 1);
                if (bit == '1') {
                    pickListMap.get(controllingValues.get(i)).add(plew.label);
                }
            }
        }
        
        pw.pickListMap = pickListMap;
        list<string> optionslistvalue = pickListMap.get(parentFieldvalue);
        for(string option : optionslistvalue){
            picklistwrapper1 obj_picklistwrapper = new picklistwrapper1();
            obj_picklistwrapper.label = option;
            obj_picklistwrapper.value = option;
            optionlist.add(obj_picklistwrapper); 
        }
        
        return optionlist;
    }
    
    public class picklistwrapper1 {
        @AuraEnabled Public String value;
        @AuraEnabled Public String label;
    }    
    
    private static final String base64Chars = '' +
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
        'abcdefghijklmnopqrstuvwxyz' +
        '0123456789+/';
    
    
    public static String decimalToBinary(Integer val) {
        String bits = '';
        while (val > 0) {
            Integer remainder = Math.mod(val, 2);
            val = Integer.valueOf(Math.floor(val / 2));
            bits = String.valueOf(remainder) + bits;
        }
        return bits;
    }
    
    public static String base64ToBits(String validFor) {
        if (String.isEmpty(validFor)) return '';
        
        String validForBits = '';
        
        for (Integer i = 0; i < validFor.length(); i++) {
            String thisChar = validFor.mid(i, 1);
            Integer val = base64Chars.indexOf(thisChar);
            String bits = decimalToBinary(val).leftPad(6, '0');
            validForBits += bits;
        }
        
        return validForBits;
    }
    
    public class PicklistWrapper{
        @AuraEnabled
        public Map<String, List<String>> pickListMap;
        @AuraEnabled
        public String parentFieldLabel;
        @AuraEnabled
        public String childFieldLabel;      
    }
    
    public class PicklistEntryWrapper{
        public String active;
        public String defaultValue;
        public String label;
        public String value;
        public String validFor;
        
    }
    
    @AuraEnabled
    public static List<picklistwrapper1> getPriorityPicklistValue(){
        List<picklistwrapper1> optionlist = new List<picklistwrapper1>();  
        APC_Priority__mdt[] priorityValues = [select id, value__c, sequence_number__c from APC_Priority__mdt order by sequence_number__c asc];
        for(APC_Priority__mdt obj_mdt : priorityValues ){
            picklistwrapper1 obj_picklistwrapper = new picklistwrapper1();
            obj_picklistwrapper.label =obj_mdt.value__c;
            obj_picklistwrapper.value =obj_mdt.value__c;
            optionlist.add(obj_picklistwrapper); 
        }
        return optionlist;
    }
    
    @AuraEnabled
    public static List<picklistwrapper1> getOriginPicklistValue(){
        List<picklistwrapper1> optionlist = new List<picklistwrapper1>();  
        APC_origin__mdt[] priorityValues = [select id, value__c, sequence_number__c from APC_origin__mdt order by sequence_number__c asc];
        for(APC_origin__mdt obj_mdt : priorityValues ){
            picklistwrapper1 obj_picklistwrapper = new picklistwrapper1();
            obj_picklistwrapper.label =obj_mdt.value__c;
            obj_picklistwrapper.value =obj_mdt.value__c;
            optionlist.add(obj_picklistwrapper); 
        }
        return optionlist;
    }
    
    public static boolean does_user_has_account_access(string dealercode){
        if(String.isNotEmpty(dealercode) && String.isNotBlank(dealercode)){
            dealercode = dealercode.length() == 4 ? 'F' + dealercode : dealercode;
            list<AccountContactRelation> VisibleAccountcontactrelation	 = new list<AccountContactRelation>();
            list<String> accountcodes = new list<String>();    
            contact c = new contact();
            c = [select Id, accountId,Account.Dealer_code__c from contact where id in (select contactid from user where id=:UserInfo.getUserId())];
            if(c != null){
                if(c.Account.Dealer_code__c.length() == 4){
                    String contactAccountCode = 'F' + c.Account.Dealer_code__c;
                    system.debug('contactAccountCode : ' + contactAccountCode);
                    accountcodes.add(contactAccountCode);
                }else if (String.isNotEmpty(c.Account.Dealer_code__c) && String.isNotBlank(c.Account.Dealer_code__c)){
                    accountcodes.add(c.Account.Dealer_code__c);
                }
                
                VisibleAccountcontactrelation = [select id, Accountid, Account.Dealer_code__c,account.Name from AccountContactRelation where contactid =: c.Id and isDirect=false];
                if(!VisibleAccountcontactrelation.isEmpty()){
                    for(AccountContactRelation a: VisibleAccountcontactrelation){ 
                        if(a.Account.Dealer_code__c.length() == 4){
                            accountcodes.add('F' +a.Account.Dealer_code__c);
                            
                        }else if (String.isNotEmpty(c.Account.Dealer_code__c) && String.isNotBlank(c.Account.Dealer_code__c)){
                            accountcodes.add(a.Account.Dealer_code__c);
                        }
                    }
                }
            }
            system.debug('accountcodes: ' + accountcodes + '  Dealer code: ' + dealercode);
            return accountcodes.contains(dealercode); 
        }else {
            return false;
        }
        
    }
    public static boolean does_user_has_account_access_accountid(string dealercode){
        if(String.isNotEmpty(dealercode) && String.isNotBlank(dealercode)){
            //dealercode = dealercode.length() == 4 ? 'F' + dealercode : dealercode;
            list<AccountContactRelation> VisibleAccountcontactrelation	 = new list<AccountContactRelation>();
            list<String> accountcodes = new list<String>();    
            contact c = new contact();
            c = [select Id, accountId,Account.Dealer_code__c from contact where id in (select contactid from user where id=:UserInfo.getUserId())];
            if(c != null){
                if(c.accountId != null){                    
                    accountcodes.add(c.accountId);              
                }
                
                VisibleAccountcontactrelation = [select id, Accountid, Account.Dealer_code__c,account.Name from AccountContactRelation where contactid =: c.Id and isDirect=false];
                if(!VisibleAccountcontactrelation.isEmpty()){
                    for(AccountContactRelation a: VisibleAccountcontactrelation){                        
                        accountcodes.add(a.Accountid);                        
                    }
                }
            }
            system.debug('accountcodes: ' + accountcodes + '  Dealer code: ' + dealercode);
            return accountcodes.contains(dealercode); 
        }else {
            return false;
        }
        
    }
  
}