@isTest
public class APC_Fileuploadcontroller_Test {
    
    @testSetup
    static void setup() {
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion;    
    }
    
    @isTest
    static void test1(){
        Map<String, Object> params = new Map<String, Object>();
        Account acct = new Account(Name='TEST_ACCT');
        insert acct;
        
        String myUserId = APC_Fileuploadcontroller.getUserId();
    
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        List<ContentDocumentLink> cdls = APC_Fileuploadcontroller.createDocumentLinks(
            new Map<String, Object>{
                'files' => new List<Object>{ new Map<Object,Object>{ 'Id'=>documents[0].Id } },
                    'recordId' => acct.Id
            }
        );
            
   
         List<ContentDocument> documentsInfo = APC_Fileuploadcontroller.getDocuments(
            new Map<String, Object>{
                'docIds' => new List<Object>{ documents[0].Id }
            }
        );
        
        APC_FileuploadController.getExistingFilesInfo();
        
        Account ac = new Account(name ='CDCD Account', Dealer_Code__c = 'CDCD') ;
        insert ac; 
        Account ac1 = new Account(name ='YFFD Account', Dealer_Code__c = 'YFFD') ;
        insert ac1;
        
        Contact con = new Contact(LastName ='CDCD User1',AccountId = ac.Id);
        insert con;  
        
        Contact con1 = new Contact(LastName ='YFFD User1',AccountId = ac1.Id);
        insert con1;  
        
        case objcase = new case(status='new', accountid=ac.id, Body_Number__c='11221',Request_Type__c='Core Inquiry',Part_No__c='11111111');
        insert objcase;
        
		APC_FileuploadController.getExistingFilesInfo1(objcase.Id);
        try{
        	APC_FileuploadController.createDocumentLinks1(null);
        }catch(Exception ex){}
        APC_FileuploadController.createDocumentLinks1(new Map<String, Object>{
                'files' => new List<Object>{ new Map<Object,Object>{ 'documentId'=>documents[0].Id } },
                    'recordId' => acct.Id
                    }
        );
          
        Boolean deleteInfo = APC_Fileuploadcontroller.deleteFiles(
            new Map<String, Object>{
                'fileIds' => new List<Object>{ documents[0].Id }
            }
        );
        
        Boolean deleteInfoError = APC_Fileuploadcontroller.deleteFiles(
            new Map<String, Object>{
                'fileId' => new List<Object>{ documents[0].Id }
            }
        );
    }
    
}