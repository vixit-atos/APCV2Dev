@isTest
public class privateAttachmentUploadtrigger_Test {
static testMethod void testAttachments()
    {    
         Account a = new Account (Name = 'a1');
            
            insert a;
            Contact ca = new Contact(
                
                
                FirstName = 'cFN1',
                LastName = 'cLN1',
                AccountId = a.Id,
                Email = 'test@gmtestail.com'
            );
            
            insert ca;
        Private_Note__c pn= new Private_Note__c(Name='testnote',Account__c=a.id,Contact__c=ca.id);
        insert pn;
 
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=pn.id;
        insert attach;
        
       
        
        //List<Attachment> attachments=[select id, name from Attachment where parent.id=:cse.id];
        
    }
}