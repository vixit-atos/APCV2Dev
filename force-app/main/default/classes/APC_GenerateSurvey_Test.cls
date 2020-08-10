@isTest
public class APC_GenerateSurvey_Test {
 @isTest(SeeAllData=true) 
    static void APC_GenerateSurvey_Test(){ 
        
        Account ac = [select Id, name, Dealer_Code__c from account where Dealer_Code__c = 'YFFD' limit 1];
        
        Contact con = new Contact(LastName ='CDCD User1',AccountId = ac.Id, email = 'test@asd.com');
        insert con;  
        
        String recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('APC TBB').getRecordTypeId();        
        String uniqueUserName = 'standarddealeruser' + DateTime.now().getTime() + '@testorg.com';
        

        case objcase = new case(status='new', accountid=ac.id, Body_Number__c='11221',Request_Type__c='TBB',
                                Part_No__c='11111111', recordtypeid=recordtypeid,
                               contactId= con.Id);
        insert objcase;   
        
        list<Id> testlist = new list<Id>();
        testlist.add(objcase.Id);
        Test.startTest();        
        APC_GenerateSurvey.CreateSurveyInv(testlist);
        Test.stopTest();
    }
}