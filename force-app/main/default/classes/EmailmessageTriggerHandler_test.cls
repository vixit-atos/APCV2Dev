@isTest
public class EmailmessageTriggerHandler_test {
static testMethod void testEmailMessage()
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

            
       EmailMessage[] newEmail = new EmailMessage[0];
 
newEmail.add(new EmailMessage(FromAddress = 'test@abc.org', Incoming = True, ToAddress= 'test@gmtestail.com', Subject = 'Test email', TextBody = '23456 ', RelatedToId = a.id)); 

insert newEmail;

Delete newEmail;
        
    }
}