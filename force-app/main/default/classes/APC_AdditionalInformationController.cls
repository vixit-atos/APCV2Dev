/**
* @File Name          : APC_AdditionalInformationController.apxc
* @Description        : Displays Additional Information section in both Internal & External case detail pages.
* @Developer          : Akhila Putta
**/


public With Sharing class APC_AdditionalInformationController {
    @AuraEnabled
    public static List<Contact> getContacts(string caseid)
    {      
        Case objCase = new Case();        
        List<Contact> contactList = new List<Contact>(); 
        if(String.isNotBlank(caseid) && String.isNotEmpty(caseid)){
            objCase = [select id, AccountId, contactid  from Case where id=:caseid];          
            contactList = [select id,FirstName,LastName,Email from contact where accountid =:objCase.AccountId and id <>:objCase.ContactId and active__c = true];        
        }
        return contactList;       
    }
    
    @AuraEnabled 
    public static Case getCase(string caseid)
    {      
        Case objCase = new Case();
        if(String.isNotBlank(caseid) && String.isNotEmpty(caseid)){
            objCase = [select id,Description,Additional_Contacts__c from Case where id=:caseid];
        }
        return objCase;
    }
    
    @AuraEnabled
    public static Case saveCaseAdditionalContactsData(string caseid, string[] additionalContacts)
    {
        Case objCase = new case();
        if(String.isNotBlank(caseid) && String.isNotEmpty(caseid)){
            objCase = [select id,Additional_Contacts__c from Case where id=:caseid];
            objCase.Additional_Contacts__c = String.join(additionalContacts, ';');
            try{
                update objCase;
            }Catch(DmlException e){
                System.debug('The following DML exception has occurred: ' + e.getMessage());            
            }
            catch(Exception ex){
                System.debug('Error => '+ex.getStackTraceString());            
            }  
        }
        return objCase;
    }   
    
    // New Save  Additional Recipient using Content Note
    @AuraEnabled
    public static boolean saveAdditionalRecipientsDataContentNote(string caseid, string additionalrecipientlist)
    {
        list<string> recipients = new list<string>(); 
        recipientpill recipient = (recipientpill)JSON.deserialize(additionalrecipientlist, recipientpill.class);
        set<id> contentnoteids = new set<id>();
        list<contentdocumentlink> contentdocumentlinklist = new list<contentdocumentlink>([select contentdocumentId from contentdocumentlink where LinkedEntityId =:caseid]);
        if(!contentdocumentlinklist.isEmpty()){  
            for(contentdocumentlink obj_contentdocumentlink : contentdocumentlinklist){ 
                contentnoteids.add(obj_contentdocumentlink.contentdocumentId);
            }
        }
        list<contentnote> contentnoteexisting = [select id from contentnote where id in :contentnoteids and title =: recipient.label]; 
        if(!contentnoteexisting.isEmpty()){            return true;
                                          }
        
        try{
            ContentNote objCntNote = new ContentNote();
            objCntNote.Title = recipient.label;  
            insert objCntNote;    ContentDocumentLink objCntDocLink = new ContentDocumentLink();   objCntDocLink.LinkedEntityId = caseid;       objCntDocLink.ContentDocumentId = objCntNote.Id;         objCntDocLink.shareType = 'V';             objCntDocLink.Visibility='AllUsers';               
            insert objCntDocLink;
        }Catch(DmlException e){            System.debug('The following DML exception has occurred: ' + e.getMessage());             }catch (exception ex){
            system.debug('Error message: ' + ex.getMessage());
        }
        return false;
    }
    
    // New remove  Additional Recipient using Content Note
    @AuraEnabled
    public static boolean removeAdditionalRecipientsDataContentNote(string caseid, string additionalrecipientlist)
    {
        list<string> recipients = new list<string>(); 
        recipientpill recipient = (recipientpill)JSON.deserialize(additionalrecipientlist, recipientpill.class);
        set<id> contentnoteids = new set<id>();
        list<contentdocumentlink> contentdocumentlinklist = new list<contentdocumentlink>([select contentdocumentId from contentdocumentlink where LinkedEntityId =:caseid]);
        if(!contentdocumentlinklist.isEmpty()){
            for(contentdocumentlink obj_contentdocumentlink : contentdocumentlinklist){                contentnoteids.add(obj_contentdocumentlink.contentdocumentId);
                                                                                      }
        }
        list<contentnote> contentnotetodelete = [select id from contentnote where id in :contentnoteids and title =: recipient.label]; 
        if(!contentnotetodelete.isEmpty()){            
            try{                delete contentnotetodelete;            }Catch(DmlException e){            System.debug('The following DML exception has occurred: ' + e.getMessage());            
                                                                                             }catch (exception ex){               system.debug('Error message: ' + ex.getMessage());                return false;
                                                                                                                  }
        }
        return true;
    }    
    
    // New Get Additional Recipient using Content Note
    @AuraEnabled
    public static list<ContentNote> getadditionalrecipientContentNotes(string caseid)
    {
        return APC_WithoutSharingMasterController.getadditionalrecipientContentNotes(caseid);
    }
    public class recipientpill {
        @AuraEnabled public String  label {get; set;}
        @AuraEnabled public String  name  {get; set;}
    }
    
    @AuraEnabled
    public static String getUIThemeDescription() {
        String theme = UserInfo.getUiThemeDisplayed();
        return theme;
    }
    
    @AuraEnabled
    public static String getloggeduseraccountid(){        
        contact c = [select accountId from contact where id in (select contactid from user where id=:UserInfo.getUserId())];           
        return c.accountId;       
    } 
}