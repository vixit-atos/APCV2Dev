@isTest
public class AttachmentTriggerHandler_Test {
static testMethod void testAttachments()
    {
		Contact mandatoryContact = new Contact();
        mandatoryContact.FirstName = 'Test';
        mandatoryContact.LastName = 'Test';
        String email = 'test@gmtestail.com';
        mandatoryContact.Email = email.replaceAll( '\\s+', '');
        mandatoryContact.Phone = '0000000000';
        insert mandatoryContact;
        
        Task objtask=new Task();
        insert objtask;
 
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        insert attach;
        Blob bodyBlobupdate=Blob.valueOf('Unit Test Attachment Body update');
        update attach;
        Blob bodyBlobdelete=Blob.valueOf('Unit Test Attachment Body update');
        delete attach;
        
        //List<Attachment> attachments=[select id, name from Attachment where parent.id=:cse.id];
        
    }
}