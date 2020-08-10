@isTest
public class ASPOpportunityCreation_Emailservice_Test{
    static testMethod void testInboundEmail(){
       // create a new email and envelope object
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        User userToCreate = new User();
        String ProfileId=[SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
       userToCreate.FirstName = 'Satish';
       userToCreate.LastName  = 'Kumar';
       userToCreate.Email     = 'test@test.com';
       userToCreate.Username  = 'ABC@community.com';
       userToCreate.Alias     = 'ABC1';
       userToCreate.ProfileId = ProfileId;
       userToCreate.TimeZoneSidKey    = 'America/Denver';
       userToCreate.LocaleSidKey      = 'en_US';
       userToCreate.EmailEncodingKey  = 'UTF-8';
       userToCreate.LanguageLocaleKey = 'en_US';
       
       insert userToCreate;
  Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect/Customer').getRecordTypeId();
 Account actObj = new Account(Name='test_14feb',recordtypeid=RecordTypeIdAccount);
        insert actObj;
      contact conObj = new contact(lastName='test con ln', firstName='test', accountid=actObj.id);
        insert conObj;
        email.plainTextBody = 'Quote Number 1484669908757 <http://secure.freightliner.com/iwarranty/servlet/com.fourcs.c=lm.iwarranty.sc.dataview.servlets.QuoteDetailsServlet?ServiceContract_Id=3D=200165914&ActionType=3DRetrieve> Customer Code : A10994 Customer Name : MAYO MANUFACTURE CORPORATION Requested By test test con ln Requested Date 01/17/2017 Coverage Requested : CM BASE COVERAGE CM TIRES Terms In Months 72 Months Total Number of Units 1 Estimated fixed monthly charge : 601.50 Estimated variable charge/Mile : 0.0720 Estimated hourly reefer charge : 0.00 Comments';



        email.fromAddress = 'test@test.com';
        email.subject = 'Test Lead';

        ASPOpportunityCreation_Emailservice edr = new ASPOpportunityCreation_Emailservice();
        edr.handleInboundEmail(email,env); 

        Test.startTest();
        Messaging.InboundEmailResult result = edr.handleInboundEmail(email, env);
        System.assertEquals(result.success, true);
        Test.stopTest();
   }
}