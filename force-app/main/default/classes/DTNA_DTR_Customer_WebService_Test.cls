@isTest
public class DTNA_DTR_Customer_WebService_Test
{
static testMethod void DTNA_DTR_CustomertestAccount_WithPrivateOwnerShip1()
 {
     Account accobj=new Account();     
     accobj.Name='Insight4002';
     accobj.Mainframe_ID__c='4002';
     accobj.Private_Ownership_List1__C='005d0000005fMWK,';
     accobj.Private_Ownership_List2__C='';
     accobj.Private_Ownership_List3__C='';
     accobj.Private_Ownership_List4__C='';
     accobj.Private_Ownership_List5__C='';
     upsert accobj;   
     
    // system.debug('AccountId:' + accobj.Mainframe_ID__c);
     String jsonstring = '{' +
                              '\"Account\":[{' +
                              '\"CompanyName\":\"Insight4002\",\"InsightCompanyID\":\"4002\",\"Phone1\":\"(910) 334 - 0000\",\"Address1\":\"NW 360 \",' +
                              '\"Address2\":\"Apt A04\",\"City\":\"bEAVERTON\",\"State\":\"OR\",\"Country\":\"USA\",\"ZIP\":\"97006\",\"County\":\"SUMMIT\",' +
                              '\"FleetSize\":\"Small Fleet 2 - 9\",\"Description\":\"Test111\",\"URL\":\"www.ww\",\"Fax\":\"(567) 667 - 0000\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"Contacts\":[{' +
                              '\"FirstName\":\"Robert\",\"LastName\":\"Shields\",\"InsightContactID\":\"3001\",\"Title\":\"Spouse\",' +
                                '\"ContactPhone1\":\"000-000-0000\",\"ContactPhone2\":\"111-111-1111\",\"ContactFax\":\"666-666-6666\",\"ContactEmail\":\"Test@ss.com\",' +
                                '\"ContactRole\":\"Other\",\"Department\":\"Sales\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"PrivateActivity\":[{' +
                              '\"DTNAConnectId\":\"JF21338\",\"Act_Stage\":\"Not Started\",\"Act_DueDate\":\"2012-04-23\",\"Act_Priority\":\"High\",\"Act_Description\":\"TESTSSE\"' +
                              '}]' +
                              '}';

    // This causes a fake response to be generated
       // Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        
        // Call the method that invokes a callout
        
        string output = DTNA_DTR_Customer_Creation_WebService.DTNA_DTR_Customer_Creation(jsonstring);
       // system.debug('Output:' + jsonstring);
	    System.assert(output.contains('Success')); 
 }
    
  static testMethod void DTNA_DTR_CustomertestAccount_WithoutPrivateOwnerShip()
 {
     Account accobj=new Account();     
     accobj.Name='Insight4002';
     accobj.Mainframe_ID__c='4002';
     accobj.Private_Ownership_List1__C='';
     accobj.Private_Ownership_List2__C='';
     accobj.Private_Ownership_List3__C='';
     accobj.Private_Ownership_List4__C='';
     accobj.Private_Ownership_List5__C='';
     upsert accobj;   
     
    // system.debug('AccountId:' + accobj.Mainframe_ID__c);
     String jsonstring = '{' +
                              '\"Account\":[{' +
                              '\"CompanyName\":\"Insight4002\",\"InsightCompanyID\":\"4002\",\"Phone1\":\"(910) 334 - 0000\",\"Address1\":\"NW 360 \",' +
                              '\"Address2\":\"Apt A04\",\"City\":\"bEAVERTON\",\"State\":\"OR\",\"Country\":\"USA\",\"ZIP\":\"97006\",\"County\":\"SUMMIT\",' +
                              '\"FleetSize\":\"Small Fleet 2 - 9\",\"Description\":\"Test111\",\"URL\":\"www.ww\",\"Fax\":\"(567) 667 - 0000\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"Contacts\":[{' +
                              '\"FirstName\":\"Robert\",\"LastName\":\"Shields\",\"InsightContactID\":\"4002\",\"Title\":\"Spouse\",' +
                                '\"ContactPhone1\":\"000-000-0000\",\"ContactPhone2\":\"111-111-1111\",\"ContactFax\":\"666-666-6666\",\"ContactEmail\":\"Test@ss.com\",' +
                                '\"ContactRole\":\"Other\",\"Department\":\"Sales\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"PrivateActivity\":[{' +
                              '\"DTNAConnectId\":\"D70ROS35\",\"Act_Stage\":\"Not Started\",\"Act_DueDate\":\"2012-04-23\",\"Act_Priority\":\"High\",\"Act_Description\":\"TESTSSE\"' +
                              '}]' +
                              '}';

    // This causes a fake response to be generated
       // Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        
        // Call the method that invokes a callout
        
        string output = DTNA_DTR_Customer_Creation_WebService.DTNA_DTR_Customer_Creation(jsonstring);
       // system.debug('Output:' + jsonstring);
	    System.assert(output.contains('Success')); 
 }
 static testMethod void DTNA_DTR_CustomertestAccount_WithAllPrivateOwnerShip()
 {
     Account accobj=new Account();     
     accobj.Name='Insight4002';
     accobj.Mainframe_ID__c='4002';
     accobj.Private_Ownership_List1__C='005d0000005fMWK,';
     accobj.Private_Ownership_List2__C='005d0000005fMWL,';
     accobj.Private_Ownership_List3__C='005d0000005fMWM,';
     accobj.Private_Ownership_List4__C='005d0000005fMWN,';
     accobj.Private_Ownership_List5__C='005d0000005fMWP,';
     upsert accobj;   
     
    // system.debug('AccountId:' + accobj.Mainframe_ID__c);
     String jsonstring = '{' +
                              '\"Account\":[{' +
                              '\"CompanyName\":\"Insight4002\",\"InsightCompanyID\":\"4002\",\"Phone1\":\"(910) 334 - 0000\",\"Address1\":\"NW 360 \",' +
                              '\"Address2\":\"Apt A04\",\"City\":\"bEAVERTON\",\"State\":\"OR\",\"Country\":\"USA\",\"ZIP\":\"97006\",\"County\":\"SUMMIT\",' +
                              '\"FleetSize\":\"Small Fleet 2 - 9\",\"Description\":\"Test111\",\"URL\":\"www.ww\",\"Fax\":\"(567) 667 - 0000\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"Contacts\":[{' +
                              '\"FirstName\":\"Robert\",\"LastName\":\"Shields\",\"InsightContactID\":\"4002\",\"Title\":\"Spouse\",' +
                                '\"ContactPhone1\":\"000-000-0000\",\"ContactPhone2\":\"111-111-1111\",\"ContactFax\":\"666-666-6666\",\"ContactEmail\":\"Test@ss.com\",' +
                                '\"ContactRole\":\"Other\",\"Department\":\"Sales\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"PrivateActivity\":[{' +
                              '\"DTNAConnectId\":\"D70ROS35\",\"Act_Stage\":\"Not Started\",\"Act_DueDate\":\"2012-04-23\",\"Act_Priority\":\"High\",\"Act_Description\":\"TESTSSE\"' +
                              '}]' +
                              '}';

    // This causes a fake response to be generated
       // Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        
        // Call the method that invokes a callout
        
        string output = DTNA_DTR_Customer_Creation_WebService.DTNA_DTR_Customer_Creation(jsonstring);
       // system.debug('Output:' + jsonstring);
	    System.assert(output.contains('Success')); 
 }
 static testMethod void DTNA_DTR_CustomertestAccount_WithPrivateOwnerShip_01()
 {
     Account accobj=new Account();     
     accobj.Name='Insight4002';
     accobj.Mainframe_ID__c='4002';
     accobj.Private_Ownership_List1__C='005d0000005fKb3,005d0000005fMVK,005d0000005fMLK,005d0000005fMJK,005d0000005fMCK,005d0000005fMWL,005d0000005fMVK,005d0000005fMLK,005d0000005fMJK,005d0000005fMCK,005d0000005fMWL,005d0000005fMVK,005d0000005fMLK,';
     accobj.Private_Ownership_List2__C='005d0000005fMWL,005d0000005fMVK,005d0000005fMLK,005d0000005fMJK,005d0000005fMCK,005d0000005fMWL,005d0000005fMVK,005d0000005fMLK,005d0000005fMJK,005d0000005fMCK,005d0000005fMWL,005d0000005fMVK,005d0000005fMLK,005d0000005fMJK,';
     accobj.Private_Ownership_List3__C='005d0000005fMWL,005d0000005fMVK,005d0000005fMLK,005d0000005fMJK,005d0000005fMCK,005d0000005fMWL,005d0000005fMVK,005d0000005fMLK,005d0000005fMJK,005d0000005fMCK,005d0000005fMWL,005d0000005fMVK,005d0000005fMLK,005d0000005fMJK,';
     accobj.Private_Ownership_List4__C='005d0000005fMWL,005d0000005fMVK,005d0000005fMLK,005d0000005fMJK,005d0000005fMCK,005d0000005fMWL,005d0000005fMVK,005d0000005fMLK,005d0000005fMJK,005d0000005fMCK,005d0000005fMWL,005d0000005fMVK,005d0000005fMLK,005d0000005fMJK,';
     accobj.Private_Ownership_List5__C='005d0000005fMWL,005d0000005fMVK,005d0000005fMLK,005d0000005fMJK,005d0000005fMCK,005d0000005fMWL,005d0000005fMVK,005d0000005fMLK,005d0000005fMJK,005d0000005fMCK,005d0000005fMWL,005d0000005fMVK,005d0000005fMLK,005d0000005fMJK,';
     upsert accobj;   
     
    // system.debug('AccountId:' + accobj.Mainframe_ID__c);
     String jsonstring = '{' +
                              '\"Account\":[{' +
                              '\"CompanyName\":\"Insight4002\",\"InsightCompanyID\":\"4002\",\"Phone1\":\"(910) 334 - 0000\",\"Address1\":\"NW 360 \",' +
                              '\"Address2\":\"Apt A04\",\"City\":\"bEAVERTON\",\"State\":\"OR\",\"Country\":\"USA\",\"ZIP\":\"97006\",\"County\":\"SUMMIT\",' +
                              '\"FleetSize\":\"Small Fleet 2 - 9\",\"Description\":\"Test111\",\"URL\":\"www.ww\",\"Fax\":\"(567) 667 - 0000\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"Contacts\":[{' +
                              '\"FirstName\":\"Robert\",\"LastName\":\"Shields\",\"InsightContactID\":\"4002\",\"Title\":\"Spouse\",' +
                                '\"ContactPhone1\":\"000-000-0000\",\"ContactPhone2\":\"111-111-1111\",\"ContactFax\":\"666-666-6666\",\"ContactEmail\":\"Test@ss.com\",' +
                                '\"ContactRole\":\"Other\",\"Department\":\"Sales\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"PrivateActivity\":[{' +
                              '\"DTNAConnectId\":\"D70ROS35\",\"Act_Stage\":\"Not Started\",\"Act_DueDate\":\"2012-04-23\",\"Act_Priority\":\"High\",\"Act_Description\":\"TESTSSE\"' +
                              '}]' +
                              '}';

    // This causes a fake response to be generated
       // Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        
        // Call the method that invokes a callout
        
        string output = DTNA_DTR_Customer_Creation_WebService.DTNA_DTR_Customer_Creation(jsonstring);
       // system.debug('Output:' + jsonstring);
	    System.assert(output.contains('Success')); 
 }   
  
static testMethod void DTNA_DTR_CustomertestAccount_WithWrongFleetData()
 {
     Account accobj=new Account();     
     accobj.Name='Insight4002';
     accobj.Mainframe_ID__c='4002';
     accobj.Private_Ownership_List1__C='005d0000005fKb3,005d0000005fMVK,005d0000005fMLK,005d0000005fMJK,005d0000005fMCK,005d0000005fMWL,005d0000005fMVK,005d0000005fMLK,005d0000005fMJK,005d0000005fMCK,005d0000005fMWL,005d0000005fMVK,005d0000005fMLK,';
     accobj.Private_Ownership_List2__C='005d0000005fMWL,005d0000005fMVK,005d0000005fMLK,005d0000005fMJK,005d0000005fMCK,005d0000005fMWL,005d0000005fMVK,005d0000005fMLK,005d0000005fMJK,005d0000005fMCK,005d0000005fMWL,005d0000005fMVK,005d0000005fMLK,005d0000005fMJK,';
     accobj.Private_Ownership_List3__C='005d0000005fMWL,005d0000005fMVK,005d0000005fMLK,005d0000005fMJK,005d0000005fMCK,005d0000005fMWL,005d0000005fMVK,005d0000005fMLK,005d0000005fMJK,005d0000005fMCK,005d0000005fMWL,005d0000005fMVK,005d0000005fMLK,005d0000005fMJK,';
     accobj.Private_Ownership_List4__C='005d0000005fMWL,005d0000005fMVK,005d0000005fMLK,005d0000005fMJK,005d0000005fMCK,005d0000005fMWL,005d0000005fMVK,005d0000005fMLK,005d0000005fMJK,005d0000005fMCK,005d0000005fMWL,005d0000005fMVK,005d0000005fMLK,005d0000005fMJK,';
     accobj.Private_Ownership_List5__C='005d0000005fMWL,005d0000005fMVK,005d0000005fMLK,005d0000005fMJK,005d0000005fMCK,005d0000005fMWL,005d0000005fMVK,005d0000005fMLK,005d0000005fMJK,005d0000005fMCK,005d0000005fMWL,005d0000005fMVK,005d0000005fMLK,005d0000005fMJK,';
     upsert accobj;   
     
    // system.debug('AccountId:' + accobj.Mainframe_ID__c);
     String jsonstring = '{' +
                              '\"Account\":[{' +
                              '\"CompanyName\":\"Insight4002\",\"InsightCompanyID\":\"4002\",\"Phone1\":\"(910) 334 - 0000\",\"Address1\":\"NW 360 \",' +
                              '\"Address2\":\"Apt A04\",\"City\":\"bEAVERTON\",\"State\":\"OR\",\"Country\":\"USA\",\"ZIP\":\"97006\",\"County\":\"SUMMIT\",' +
                              '\"FleetSize\":\"Small Fleet 2-9\",\"Description\":\"Test111\",\"URL\":\"www.ww\",\"Fax\":\"(567) 667 - 0000\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"Contacts\":[{' +
                              '\"FirstName\":\"Robert\",\"LastName\":\"Shields\",\"InsightContactID\":\"4002\",\"Title\":\"Spouse\",' +
                                '\"ContactPhone1\":\"000-000-0000\",\"ContactPhone2\":\"111-111-1111\",\"ContactFax\":\"666-666-6666\",\"ContactEmail\":\"Test@ss.com\",' +
                                '\"ContactRole\":\"Other\",\"Department\":\"Sales\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"PrivateActivity\":[{' +
                              '\"DTNAConnectId\":\"D70ROS35\",\"Act_Stage\":\"Not Started\",\"Act_DueDate\":\"2012-04-23\",\"Act_Priority\":\"High\",\"Act_Description\":\"TESTSSE\"' +
                              '}]' +
                              '}';

    // This causes a fake response to be generated
       // Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        
        // Call the method that invokes a callout
        
        string output = DTNA_DTR_Customer_Creation_WebService.DTNA_DTR_Customer_Creation(jsonstring);
       // system.debug('Output:' + jsonstring);
	  //  System.assert(output.contains('Success')); 
 } 
    
    static testMethod void DTNA_DTR_CustomertestContact_WithPrivateOwnerShip1()
 {
     Account accobj=new Account();     
     accobj.Name='Insight4002';
     accobj.Mainframe_ID__c='4002';
     accobj.Private_Ownership_List1__C='005d0000005fMWK,';
     accobj.Private_Ownership_List2__C='';
     accobj.Private_Ownership_List3__C='';
     accobj.Private_Ownership_List4__C='';
     accobj.Private_Ownership_List5__C='';
     upsert accobj;  
     
     Contact contobj=new Contact();
     contobj.AccountId=accobj.id;
     contobj.Mainframe_ID__c='4002';
     contobj.LastName='PPP';
     contobj.FirstName='FFF';
     contobj.Private_Ownership_List1__C='005d0000005fMWK,';
     contobj.Private_Ownership_List2__C='';
     contobj.Private_Ownership_List3__C='';
     contobj.Private_Ownership_List4__C='';
     contobj.Private_Ownership_List5__C='';
     upsert contobj;
    // system.debug('ContactAccountId:' + contobj.Id);
     String jsonstring = '{' +
                              '\"Account\":[{' +
                              '\"CompanyName\":\"Insight4002\",\"InsightCompanyID\":\"4002\",\"Phone1\":\"(910) 334 - 0000\",\"Address1\":\"NW 360 \",' +
                              '\"Address2\":\"Apt A04\",\"City\":\"bEAVERTON\",\"State\":\"OR\",\"Country\":\"USA\",\"ZIP\":\"97006\",\"County\":\"SUMMIT\",' +
                              '\"FleetSize\":\"Small Fleet 2 - 9\",\"Description\":\"Test111\",\"URL\":\"www.ww\",\"Fax\":\"(567) 667 - 0000\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"Contacts\":[{' +
                              '\"FirstName\":\"Robert\",\"LastName\":\"Shields\",\"InsightContactID\":\"4002\",\"Title\":\"Spouse\",' +
                                '\"ContactPhone1\":\"000-000-0000\",\"ContactPhone2\":\"111-111-1111\",\"ContactFax\":\"666-666-6666\",\"ContactEmail\":\"Test@ss.com\",' +
                                '\"ContactRole\":\"Other\",\"Department\":\"Sales\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"PrivateActivity\":[{' +
                              '\"DTNAConnectId\":\"D70ROS35\",\"Act_Stage\":\"Not Started\",\"Act_DueDate\":\"2012-04-23\",\"Act_Priority\":\"High\",\"Act_Description\":\"TESTSSE\"' +
                              '}]' +
                              '}';

    // This causes a fake response to be generated
       // Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        
        // Call the method that invokes a callout
        
        string output = DTNA_DTR_Customer_Creation_WebService.DTNA_DTR_Customer_Creation(jsonstring);
       // system.debug('Output:' + jsonstring);
	    System.assert(output.contains('Success')); 
 }
 static testMethod void DTNA_DTR_CustomertestContact_WithoutPrivateOwnerShip()
 {
     Account accobj=new Account();     
     accobj.Name='Insight4002';
     accobj.Mainframe_ID__c='4002';
     accobj.Private_Ownership_List1__C='005d0000005fMWK,';
     accobj.Private_Ownership_List2__C='';
     accobj.Private_Ownership_List3__C='';
     accobj.Private_Ownership_List4__C='';
     accobj.Private_Ownership_List5__C='';
     upsert accobj;  
     
     Contact contobj=new Contact();
     contobj.AccountId=accobj.id;
     contobj.Mainframe_ID__c='4002';
     contobj.LastName='PPP';
     contobj.FirstName='FFF';
     contobj.Private_Ownership_List1__C='';
     contobj.Private_Ownership_List2__C='';
     contobj.Private_Ownership_List3__C='';
     contobj.Private_Ownership_List4__C='';
     contobj.Private_Ownership_List5__C='';
     upsert contobj;
    // system.debug('ContactAccountId:' + contobj.Id);
     String jsonstring = '{' +
                              '\"Account\":[{' +
                              '\"CompanyName\":\"Insight4002\",\"InsightCompanyID\":\"4002\",\"Phone1\":\"(910) 334 - 0000\",\"Address1\":\"NW 360 \",' +
                              '\"Address2\":\"Apt A04\",\"City\":\"bEAVERTON\",\"State\":\"OR\",\"Country\":\"USA\",\"ZIP\":\"97006\",\"County\":\"SUMMIT\",' +
                              '\"FleetSize\":\"Small Fleet 2 - 9\",\"Description\":\"Test111\",\"URL\":\"www.ww\",\"Fax\":\"(567) 667 - 0000\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"Contacts\":[{' +
                              '\"FirstName\":\"Robert\",\"LastName\":\"Shields\",\"InsightContactID\":\"4002\",\"Title\":\"Spouse\",' +
                                '\"ContactPhone1\":\"000-000-0000\",\"ContactPhone2\":\"111-111-1111\",\"ContactFax\":\"666-666-6666\",\"ContactEmail\":\"Test@ss.com\",' +
                                '\"ContactRole\":\"Other\",\"Department\":\"Sales\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"PrivateActivity\":[{' +
                              '\"DTNAConnectId\":\"D70ROS35\",\"Act_Stage\":\"Not Started\",\"Act_DueDate\":\"2012-04-23\",\"Act_Priority\":\"High\",\"Act_Description\":\"TESTSSE\"' +
                              '}]' +
                              '}';

    // This causes a fake response to be generated
       // Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        
        // Call the method that invokes a callout
        
        string output = DTNA_DTR_Customer_Creation_WebService.DTNA_DTR_Customer_Creation(jsonstring);
        System.assert(output.contains('Success')); 

 }
    
 static testMethod void DTNA_DTR_CustomertestContact_WithAllPrivateOwnerShip()
 {
     Account accobj=new Account();     
     accobj.Name='Insight4002';
     accobj.Mainframe_ID__c='4002';
     accobj.Private_Ownership_List1__C='005d0000005fMWK,';
     accobj.Private_Ownership_List2__C='';
     accobj.Private_Ownership_List3__C='';
     accobj.Private_Ownership_List4__C='';
     accobj.Private_Ownership_List5__C='';
     upsert accobj;  
     
     Contact contobj=new Contact();
     contobj.AccountId=accobj.id;
     contobj.Mainframe_ID__c='4002';
     contobj.LastName='PPP';
     contobj.FirstName='FFF';
     contobj.Private_Ownership_List1__C='005d0000005fMWK,';
     contobj.Private_Ownership_List2__C='005d0000005fMWM,';
     contobj.Private_Ownership_List3__C='005d0000005fMWN,';
     contobj.Private_Ownership_List4__C='005d0000005fMWO,';
     contobj.Private_Ownership_List5__C='005d0000005fMWP,';
     upsert contobj;
    // system.debug('ContactAccountId:' + contobj.Id);
     String jsonstring = '{' +
                              '\"Account\":[{' +
                              '\"CompanyName\":\"Insight4002\",\"InsightCompanyID\":\"4002\",\"Phone1\":\"(910) 334 - 0000\",\"Address1\":\"NW 360 \",' +
                              '\"Address2\":\"Apt A04\",\"City\":\"bEAVERTON\",\"State\":\"OR\",\"Country\":\"USA\",\"ZIP\":\"97006\",\"County\":\"SUMMIT\",' +
                              '\"FleetSize\":\"Small Fleet 2 - 9\",\"Description\":\"Test111\",\"URL\":\"www.ww\",\"Fax\":\"(567) 667 - 0000\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"Contacts\":[{' +
                              '\"FirstName\":\"Robert\",\"LastName\":\"Shields\",\"InsightContactID\":\"4002\",\"Title\":\"Spouse\",' +
                                '\"ContactPhone1\":\"000-000-0000\",\"ContactPhone2\":\"111-111-1111\",\"ContactFax\":\"666-666-6666\",\"ContactEmail\":\"Test@ss.com\",' +
                                '\"ContactRole\":\"Other\",\"Department\":\"Sales\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"PrivateActivity\":[{' +
                              '\"DTNAConnectId\":\"D70ROS35\",\"Act_Stage\":\"Not Started\",\"Act_DueDate\":\"2012-04-23\",\"Act_Priority\":\"High\",\"Act_Description\":\"TESTSSE\"' +
                              '}]' +
                              '}';

    // This causes a fake response to be generated
       // Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        
        // Call the method that invokes a callout
        
        string output = DTNA_DTR_Customer_Creation_WebService.DTNA_DTR_Customer_Creation(jsonstring);
       // system.debug('Output:' + jsonstring);
	    System.assert(output.contains('Success')); 
 }
 static testMethod void DTNA_DTR_CustomertestContact_WithAllPrivateOwnerShip_01()
 {
     Account accobj=new Account();     
     accobj.Name='Insight4002';
     accobj.Mainframe_ID__c='4002';
     accobj.Private_Ownership_List1__C='005d0000005fMWK,';
     accobj.Private_Ownership_List2__C='';
     accobj.Private_Ownership_List3__C='';
     accobj.Private_Ownership_List4__C='';
     accobj.Private_Ownership_List5__C='';
     upsert accobj;  
     
     Contact contobj=new Contact();
     contobj.AccountId=accobj.id;
     contobj.Mainframe_ID__c='4002';
     contobj.LastName='PPP';
     contobj.FirstName='FFF';
     contobj.Private_Ownership_List1__C='005d0000005fKb3,';
     contobj.Private_Ownership_List2__C='005d0000005fMWM,';
     contobj.Private_Ownership_List3__C='005d0000005fMWN,';
     contobj.Private_Ownership_List4__C='005d0000005fMWO,';
     contobj.Private_Ownership_List5__C='005d0000005fMWR,';
     upsert contobj;
    // system.debug('ContactAccountId:' + contobj.Id);
     String jsonstring = '{' +
                              '\"Account\":[{' +
                              '\"CompanyName\":\"Insight4002\",\"InsightCompanyID\":\"4002\",\"Phone1\":\"(910) 334 - 0000\",\"Address1\":\"NW 360 \",' +
                              '\"Address2\":\"Apt A04\",\"City\":\"bEAVERTON\",\"State\":\"OR\",\"Country\":\"USA\",\"ZIP\":\"97006\",\"County\":\"SUMMIT\",' +
                              '\"FleetSize\":\"Small Fleet 2 - 9\",\"Description\":\"Test111\",\"URL\":\"www.ww\",\"Fax\":\"(567) 667 - 0000\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"Contacts\":[{' +
                              '\"FirstName\":\"Robert\",\"LastName\":\"Shields\",\"InsightContactID\":\"4002\",\"Title\":\"Spouse\",' +
                                '\"ContactPhone1\":\"000-000-0000\",\"ContactPhone2\":\"111-111-1111\",\"ContactFax\":\"666-666-6666\",\"ContactEmail\":\"Test@ss.com\",' +
                                '\"ContactRole\":\"Other\",\"Department\":\"Sales\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"PrivateActivity\":[{' +
                              '\"DTNAConnectId\":\"D70ROS35\",\"Act_Stage\":\"Not Started\",\"Act_DueDate\":\"2012-04-23\",\"Act_Priority\":\"High\",\"Act_Description\":\"TESTSSE\"' +
                              '}]' +
                              '}';

    // This causes a fake response to be generated
       // Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        
        // Call the method that invokes a callout
        
        string output = DTNA_DTR_Customer_Creation_WebService.DTNA_DTR_Customer_Creation(jsonstring);
       // system.debug('Output:' + jsonstring);
	    System.assert(output.contains('Success')); 
 }    
    
    
    
    
    
 static testMethod void DTNA_DTR_CustomertestContact_WithAllPrivateOwnerShip_02()
 {
     Account accobj=new Account();     
     accobj.Name='Insight4002';
     accobj.Mainframe_ID__c='4002';
     accobj.Private_Ownership_List1__C='005d0000005fMWK,';
     accobj.Private_Ownership_List2__C='';
     accobj.Private_Ownership_List3__C='';
     accobj.Private_Ownership_List4__C='';
     accobj.Private_Ownership_List5__C='';
     upsert accobj;  
     
     Contact contobj=new Contact();
     contobj.AccountId=accobj.id;
     contobj.Mainframe_ID__c='4002';
     contobj.LastName='PPP';
     contobj.FirstName='FFF';
     contobj.Private_Ownership_List1__C='005d0000005fMWL,005d0000005fMVK,005d0000005fMLK,005d0000005fMJK,005d0000005fMCK,005d0000005fMWL,005d0000005fMVK,005d0000005fMLK,005d0000005fMJK,005d0000005fMCK,005d0000005fMWL,005d0000005fMVK,005d0000005fMLK,';
     contobj.Private_Ownership_List2__C='005d0000005fMWL,005d0000005fMVK,005d0000005fMLK,005d0000005fMJK,005d0000005fMCK,005d0000005fMWL,005d0000005fMVK,005d0000005fMLK,005d0000005fMJK,005d0000005fMCK,005d0000005fMWL,005d0000005fMVK,005d0000005fMLK,005d0000005fMJK,';
     contobj.Private_Ownership_List3__C='005d0000005fMWL,005d0000005fMVK,005d0000005fMLK,005d0000005fMJK,005d0000005fMCK,005d0000005fMWL,005d0000005fMVK,005d0000005fMLK,005d0000005fMJK,005d0000005fMCK,005d0000005fMWL,005d0000005fMVK,005d0000005fMLK,005d0000005fMJK,';
     contobj.Private_Ownership_List4__C='005d0000005fMWL,005d0000005fMVK,005d0000005fMLK,005d0000005fMJK,005d0000005fMCK,005d0000005fMWL,005d0000005fMVK,005d0000005fMLK,005d0000005fMJK,005d0000005fMCK,005d0000005fMWL,005d0000005fMVK,005d0000005fMLK,005d0000005fMJK,';
     contobj.Private_Ownership_List5__C='005d0000005fMWL,005d0000005fMVK,005d0000005fMLK,005d0000005fMJK,005d0000005fMCK,005d0000005fMWL,005d0000005fMVK,005d0000005fMLK,005d0000005fMJK,005d0000005fMCK,005d0000005fMWL,005d0000005fMVK,005d0000005fMLK,005d0000005fMJK,';
     upsert contobj;
    // system.debug('ContactAccountId:' + contobj.Id);
     String jsonstring = '{' +
                              '\"Account\":[{' +
                              '\"CompanyName\":\"Insight4002\",\"InsightCompanyID\":\"4002\",\"Phone1\":\"(910) 334 - 0000\",\"Address1\":\"NW 360 \",' +
                              '\"Address2\":\"Apt A04\",\"City\":\"bEAVERTON\",\"State\":\"OR\",\"Country\":\"USA\",\"ZIP\":\"97006\",\"County\":\"SUMMIT\",' +
                              '\"FleetSize\":\"Small Fleet 2 - 9\",\"Description\":\"Test111\",\"URL\":\"www.ww\",\"Fax\":\"(567) 667 - 0000\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"Contacts\":[{' +
                              '\"FirstName\":\"Robert\",\"LastName\":\"Shields\",\"InsightContactID\":\"4002\",\"Title\":\"Spouse\",' +
                                '\"ContactPhone1\":\"000-000-0000\",\"ContactPhone2\":\"111-111-1111\",\"ContactFax\":\"666-666-6666\",\"ContactEmail\":\"Test@ss.com\",' +
                                '\"ContactRole\":\"Other\",\"Department\":\"Sales\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"PrivateActivity\":[{' +
                              '\"DTNAConnectId\":\"D70ROS35\",\"Act_Stage\":\"Not Started\",\"Act_DueDate\":\"2012-04-23\",\"Act_Priority\":\"High\",\"Act_Description\":\"TESTSSE\"' +
                              '}]' +
                              '}';

    // This causes a fake response to be generated
       // Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        
        // Call the method that invokes a callout
        
        string output = DTNA_DTR_Customer_Creation_WebService.DTNA_DTR_Customer_Creation(jsonstring);
       // system.debug('Output:' + jsonstring);
	    System.assert(output.contains('Success')); 
 } 
    
    

static testMethod void DTNA_DTR_Customertest_03() {
   

    String jsonstring = '{' +
                              '\"Account\":[{' +
                              '\"CompanyName\":\"Insight4001\",\"InsightCompanyID\":\"4002\",\"Phone1\":\"(910) 334 - 0000\",\"Address1\":\"NW 360 \",' +
                              '\"Address2\":\"Apt A04\",\"City\":\"bEAVERTON\",\"State\":\"OR\",\"Country\":\"USA\",\"ZIP\":\"97006\",\"County\":\"SUMMIT\",' +
                              '\"FleetSize\":\"Small Fleet 2 - 9\",\"Description\":\"Test111\",\"URL\":\"www.ww\",\"Fax\":\"(567) 667 - 0000\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"Contacts\":[{' +
                              '\"FirstName\":\"Robert\",\"LastName\":\"Shields\",\"InsightContactID\":\"4002\",\"Title\":\"Spouse\",' +
                                '\"ContactPhone1\":\"000-000-0000\",\"ContactPhone2\":\"111-111-1111\",\"ContactFax\":\"666-666-6666\",\"ContactEmail\":\"Test@ss.com\",' +
                                '\"ContactRole\":\"Other\",\"Department\":\"Sales\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"PrivateActivity\":[{' +
                              '\"DTNAConnectId\":\"D70ROS35\",\"Act_Stage\":\"Not Started\",\"Act_DueDate\":\"2012-04-23\",\"Act_Priority\":\"High\",\"Act_Description\":\"TESTSSE\"' +
                              '}]' +
                              '}';

    // This causes a fake response to be generated
       // Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        
        // Call the method that invokes a callout
        
        string output = DTNA_DTR_Customer_Creation_WebService.DTNA_DTR_Customer_Creation(jsonstring);
       // system.debug('Output:' + jsonstring);
       System.assert(output.contains('Success'));      
	     
}
    
static testMethod void DTNA_DTR_Customertest_03_WithoutContactId() {
   

    String jsonstring = '{' +
                              '\"Account\":[{' +
                              '\"CompanyName\":\"Insight4001\",\"InsightCompanyID\":\"4002\",\"Phone1\":\"(910) 334 - 0000\",\"Address1\":\"NW 360 \",' +
                              '\"Address2\":\"Apt A04\",\"City\":\"bEAVERTON\",\"State\":\"OR\",\"Country\":\"USA\",\"ZIP\":\"97006\",\"County\":\"SUMMIT\",' +
                              '\"FleetSize\":\"Small Fleet 2 - 9\",\"Description\":\"Test111\",\"URL\":\"www.ww\",\"Fax\":\"(567) 667 - 0000\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"Contacts\":[{' +
                              '\"FirstName\":\"Robert\",\"LastName\":\"Shields\",\"InsightContactID\":\"\",\"Title\":\"Spouse\",' +
                                '\"ContactPhone1\":\"000-000-0000\",\"ContactPhone2\":\"111-111-1111\",\"ContactFax\":\"666-666-6666\",\"ContactEmail\":\"Test@ss.com\",' +
                                '\"ContactRole\":\"Other\",\"Department\":\"Sales\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"PrivateActivity\":[{' +
                              '\"DTNAConnectId\":\"D70ROS35\",\"Act_Stage\":\"Not Started\",\"Act_DueDate\":\"2012-04-23\",\"Act_Priority\":\"High\",\"Act_Description\":\"TESTSSE\"' +
                              '}]' +
                              '}';

    // This causes a fake response to be generated
       // Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        
        // Call the method that invokes a callout
        
        string output = DTNA_DTR_Customer_Creation_WebService.DTNA_DTR_Customer_Creation(jsonstring);
       // system.debug('Output:' + jsonstring);
       System.assert(output.contains('Success'));        
}
static testMethod void DTNA_DTR_Customertest_03_WithoutPrivateActivityId() {
   

    String jsonstring = '{' +
                              '\"Account\":[{' +
                              '\"CompanyName\":\"Insight4001\",\"InsightCompanyID\":\"4002\",\"Phone1\":\"(910) 334 - 0000\",\"Address1\":\"NW 360 \",' +
                              '\"Address2\":\"Apt A04\",\"City\":\"bEAVERTON\",\"State\":\"OR\",\"Country\":\"USA\",\"ZIP\":\"97006\",\"County\":\"SUMMIT\",' +
                              '\"FleetSize\":\"Small Fleet 2 - 9\",\"Description\":\"Test111\",\"URL\":\"www.ww\",\"Fax\":\"(567) 667 - 0000\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"Contacts\":[{' +
                              '\"FirstName\":\"Robert\",\"LastName\":\"Shields\",\"InsightContactID\":\"\",\"Title\":\"Spouse\",' +
                                '\"ContactPhone1\":\"000-000-0000\",\"ContactPhone2\":\"111-111-1111\",\"ContactFax\":\"666-666-6666\",\"ContactEmail\":\"Test@ss.com\",' +
                                '\"ContactRole\":\"Other\",\"Department\":\"Sales\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"PrivateActivity\":[{' +
                              '\"DTNAConnectId\":\"D70ROS35\",\"Act_Stage\":\"Not Started\",\"Act_DueDate\":\"2012-04-23\",\"Act_Priority\":\"High\",\"Act_Description\":\"\"' +
                              '}]' +
                              '}';

    // This causes a fake response to be generated
       // Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        
        // Call the method that invokes a callout
        
        string output = DTNA_DTR_Customer_Creation_WebService.DTNA_DTR_Customer_Creation(jsonstring);
       // system.debug('Output:' + jsonstring);
       System.assert(output.contains('Success'));        
}

static testMethod void DTNA_DTR_Customertest_03_WithoutPrivateConactandActivity() {
   

    String jsonstring = '{' +
                              '\"Account\":[{' +
                              '\"CompanyName\":\"Insight4001\",\"InsightCompanyID\":\"4002\",\"Phone1\":\"(910) 334 - 0000\",\"Address1\":\"NW 360 \",' +
                              '\"Address2\":\"Apt A04\",\"City\":\"bEAVERTON\",\"State\":\"OR\",\"Country\":\"USA\",\"ZIP\":\"97006\",\"County\":\"SUMMIT\",' +
                              '\"FleetSize\":\"Small Fleet 2 - 9\",\"Description\":\"Test111\",\"URL\":\"www.ww\",\"Fax\":\"(567) 667 - 0000\",\"Source\":\"Insight\"' +
                              '}]' +
                              
                              '}';

    // This causes a fake response to be generated
       // Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        
        // Call the method that invokes a callout
        
        string output = DTNA_DTR_Customer_Creation_WebService.DTNA_DTR_Customer_Creation(jsonstring);
       // system.debug('Output:' + jsonstring);
       System.assert(output.contains('Success'));        
}

static testMethod void DTNA_DTR_Customertest_03_WithoutPrivateActivitySec() {
   

    String jsonstring = '{' +
                              '\"Account\":[{' +
                              '\"CompanyName\":\"Insight4001\",\"InsightCompanyID\":\"4002\",\"Phone1\":\"(910) 334 - 0000\",\"Address1\":\"NW 360 \",' +
                              '\"Address2\":\"Apt A04\",\"City\":\"bEAVERTON\",\"State\":\"OR\",\"Country\":\"USA\",\"ZIP\":\"97006\",\"County\":\"SUMMIT\",' +
                              '\"FleetSize\":\"Small Fleet 2 - 9\",\"Description\":\"Test111\",\"URL\":\"www.ww\",\"Fax\":\"(567) 667 - 0000\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"Contacts\":[{' +
                              '\"FirstName\":\"Robert\",\"LastName\":\"Shields\",\"InsightContactID\":\"\",\"Title\":\"Spouse\",' +
                                '\"ContactPhone1\":\"000-000-0000\",\"ContactPhone2\":\"111-111-1111\",\"ContactFax\":\"666-666-6666\",\"ContactEmail\":\"Test@ss.com\",' +
                                '\"ContactRole\":\"Other\",\"Department\":\"Sales\",\"Source\":\"Insight\"' +
                              '}]' +                              
                              '}';

    // This causes a fake response to be generated
       // Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        
        // Call the method that invokes a callout
        
        string output = DTNA_DTR_Customer_Creation_WebService.DTNA_DTR_Customer_Creation(jsonstring);
       // system.debug('Output:' + jsonstring);
       System.assert(output.contains('Success'));        
} 
 static testMethod void DTNA_DTR_Customertest_03_WithoutContactSec() {
   

    String jsonstring = '{' +
                              '\"Account\":[{' +
                              '\"CompanyName\":\"Insight4001\",\"InsightCompanyID\":\"4002\",\"Phone1\":\"(910) 334 - 0000\",\"Address1\":\"NW 360 \",' +
                              '\"Address2\":\"Apt A04\",\"City\":\"bEAVERTON\",\"State\":\"OR\",\"Country\":\"USA\",\"ZIP\":\"97006\",\"County\":\"SUMMIT\",' +
                              '\"FleetSize\":\"Small Fleet 2 - 9\",\"Description\":\"Test111\",\"URL\":\"www.ww\",\"Fax\":\"(567) 667 - 0000\",\"Source\":\"Insight\"' +
                              '}],' +                              
                              '\"PrivateActivity\":[{' +
                              '\"DTNAConnectId\":\"JF21338\",\"Act_Stage\":\"Not Started\",\"Act_DueDate\":\"2012-04-23\",\"Act_Priority\":\"High\",\"Act_Description\":\"\"' +
                              '}]' +
                              '}';

    // This causes a fake response to be generated
       // Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        
        // Call the method that invokes a callout
        
        string output = DTNA_DTR_Customer_Creation_WebService.DTNA_DTR_Customer_Creation(jsonstring);
       // system.debug('Output:' + jsonstring);
       System.assert(output.contains('Success'));        
}
    
 static testMethod void DTNA_DTR_Customertest_03_WithoutAccountId() {
   

    String jsonstring = '{' +
                              '\"Account\":[{' +
                              '\"CompanyName\":\"Insight4001\",\"InsightCompanyID\":\"\",\"Phone1\":\"(910) 334 - 0000\",\"Address1\":\"NW 360 \",' +
                              '\"Address2\":\"Apt A04\",\"City\":\"bEAVERTON\",\"State\":\"OR\",\"Country\":\"USA\",\"ZIP\":\"97006\",\"County\":\"SUMMIT\",' +
                              '\"FleetSize\":\"Small Fleet 2 - 9\",\"Description\":\"Test111\",\"URL\":\"www.ww\",\"Fax\":\"(567) 667 - 0000\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"Contacts\":[{' +
                              '\"FirstName\":\"Robert\",\"LastName\":\"Shields\",\"InsightContactID\":\"\",\"Title\":\"Spouse\",' +
                                '\"ContactPhone1\":\"000-000-0000\",\"ContactPhone2\":\"111-111-1111\",\"ContactFax\":\"666-666-6666\",\"ContactEmail\":\"Test@ss.com\",' +
                                '\"ContactRole\":\"Other\",\"Department\":\"Sales\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"PrivateActivity\":[{' +
                              '\"DTNAConnectId\":\"D70ROS35\",\"Act_Stage\":\"Not Started\",\"Act_DueDate\":\"2012-04-23\",\"Act_Priority\":\"High\",\"Act_Description\":\"\"' +
                              '}]' +
                              '}';

    // This causes a fake response to be generated
       // Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        
        // Call the method that invokes a callout
        
        string output = DTNA_DTR_Customer_Creation_WebService.DTNA_DTR_Customer_Creation(jsonstring);
       // system.debug('Output:' + jsonstring);
      // System.assert(output.contains('Success'));        
}   
 static testMethod void DTNA_DTR_Customertest_03_WrongDTNAEmailId() {
   

    String jsonstring = '{' +
                              '\"Account\":[{' +
                              '\"CompanyName\":\"Insight4001\",\"InsightCompanyID\":\"4002\",\"Phone1\":\"(910) 334 - 0000\",\"Address1\":\"NW 360 \",' +
                              '\"Address2\":\"Apt A04\",\"City\":\"bEAVERTON\",\"State\":\"OR\",\"Country\":\"USA\",\"ZIP\":\"97006\",\"County\":\"SUMMIT\",' +
                              '\"FleetSize\":\"Small Fleet 2 - 9\",\"Description\":\"Test111\",\"URL\":\"www.ww\",\"Fax\":\"(567) 667 - 0000\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"Contacts\":[{' +
                              '\"FirstName\":\"Robert\",\"LastName\":\"Shields\",\"InsightContactID\":\"4002\",\"Title\":\"Spouse\",' +
                                '\"ContactPhone1\":\"000-000-0000\",\"ContactPhone2\":\"111-111-1111\",\"ContactFax\":\"666-666-6666\",\"ContactEmail\":\"Test@ss\",' +
                                '\"ContactRole\":\"Other\",\"Department\":\"Sales\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"PrivateActivity\":[{' +
                              '\"DTNAConnectId\":\"D70ROS35\",\"Act_Stage\":\"Not Started\",\"Act_DueDate\":\"2012-04-23\",\"Act_Priority\":\"High\",\"Act_Description\":\"\"' +
                              '}]' +
                              '}';

    // This causes a fake response to be generated
       // Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        
        // Call the method that invokes a callout
        
        string output = DTNA_DTR_Customer_Creation_WebService.DTNA_DTR_Customer_Creation(jsonstring);
       // system.debug('Output:' + jsonstring);
       System.assert(output.contains('Success'));        
} 
 static testMethod void DTNA_DTR_Customertest_03_UserRole() {
   

    String jsonstring = '{' +
                              '\"Account\":[{' +
                              '\"CompanyName\":\"Insight4001\",\"InsightCompanyID\":\"4002\",\"Phone1\":\"(910) 334 - 0000\",\"Address1\":\"NW 360 \",' +
                              '\"Address2\":\"Apt A04\",\"City\":\"bEAVERTON\",\"State\":\"OR\",\"Country\":\"USA\",\"ZIP\":\"97006\",\"County\":\"SUMMIT\",' +
                              '\"FleetSize\":\"Small Fleet 2 - 9\",\"Description\":\"Test111\",\"URL\":\"www.ww\",\"Fax\":\"(567) 667 - 0000\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"Contacts\":[{' +
                              '\"FirstName\":\"\",\"LastName\":\"\",\"InsightContactID\":\"4002\",\"Title\":\"Spouse\",' +
                                '\"ContactPhone1\":\"000-000-0000\",\"ContactPhone2\":\"111-111-1111\",\"ContactFax\":\"666-666-6666\",\"ContactEmail\":\"Test@ss\",' +
                                '\"ContactRole\":\"Other\",\"Department\":\"Sales\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"PrivateActivity\":[{' +
                              '\"DTNAConnectId\":\"D70JOWOJ\",\"Act_Stage\":\"Not Started\",\"Act_DueDate\":\"2012-04-23\",\"Act_Priority\":\"\",\"Act_Description\":\"TESTS\"' +
                              '}]' +
                              '}';

    // This causes a fake response to be generated
       // Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        
        // Call the method that invokes a callout
        
        string output = DTNA_DTR_Customer_Creation_WebService.DTNA_DTR_Customer_Creation(jsonstring);
       // system.debug('Output:' + jsonstring);
       System.assert(output.contains('Success'));        
} 
    static testMethod void DTNA_DTR_Customertest_03_UserRole_01() {
   

    String jsonstring = '{' +
                              '\"Account\":[{' +
                              '\"CompanyName\":\"Insight4001\",\"InsightCompanyID\":\"4002\",\"Phone1\":\"(910) 334 - 0000\",\"Address1\":\"NW 360 \",' +
                              '\"Address2\":\"Apt A04\",\"City\":\"bEAVERTON\",\"State\":\"OR\",\"Country\":\"USA\",\"ZIP\":\"97006\",\"County\":\"SUMMIT\",' +
                              '\"FleetSize\":\"Small Fleet 2 - 9\",\"Description\":\"Test111\",\"URL\":\"www.ww\",\"Fax\":\"(567) 667 - 0000\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"Contacts\":[{' +
                              '\"FirstName\":\"\",\"LastName\":\"\",\"InsightContactID\":\"4002\",\"Title\":\"Spouse\",' +
                                '\"ContactPhone1\":\"000-000-0000\",\"ContactPhone2\":\"111-111-1111\",\"ContactFax\":\"666-666-6666\",\"ContactEmail\":\"Test@ss\",' +
                                '\"ContactRole\":\"Other\",\"Department\":\"Sales\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"PrivateActivity\":[{' +
                              '\"DTNAConnectId\":\"D70JOWOJ\",\"Act_Stage\":\"Not Started\",\"Act_DueDate\":\"2012-04-23\",\"Act_Priority\":\"\",\"Act_Description\":\"TESTS\"' +
                              '}]' +
                              '}';

    // This causes a fake response to be generated
       // Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        
        // Call the method that invokes a callout
        
        string output = DTNA_DTR_Customer_Creation_WebService.DTNA_DTR_Customer_Creation(jsonstring);
       // system.debug('Output:' + jsonstring);
       System.assert(output.contains('Success'));        
}  
static testMethod void DTNA_DTR_Customertest_03_UserRole_02() {
   

    String jsonstring = '{' +
                              '\"Account\":[{' +
                              '\"CompanyName\":\"Insight4001\",\"InsightCompanyID\":\"4002\",\"Phone1\":\"(910) 334 - 0000\",\"Address1\":\"NW 360 \",' +
                              '\"Address2\":\"Apt A04\",\"City\":\"bEAVERTON\",\"State\":\"OR\",\"Country\":\"USA\",\"ZIP\":\"97006\",\"County\":\"SUMMIT\",' +
                              '\"FleetSize\":\"Small Fleet 2 - 9\",\"Description\":\"Test111\",\"URL\":\"www.ww\",\"Fax\":\"(567) 667 - 0000\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"Contacts\":[{' +
                              '\"FirstName\":\"\",\"LastName\":\"\",\"InsightContactID\":\"4002\",\"Title\":\"Spouse\",' +
                                '\"ContactPhone1\":\"000-000-0000\",\"ContactPhone2\":\"111-111-1111\",\"ContactFax\":\"666-666-6666\",\"ContactEmail\":\"Test@ss\",' +
                                '\"ContactRole\":\"Other\",\"Department\":\"Sales\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"PrivateActivity\":[{' +
                              '\"DTNAConnectId\":\"D70CHGOL\",\"Act_Stage\":\"Not Started\",\"Act_DueDate\":\"2012-04-23\",\"Act_Priority\":\"\",\"Act_Description\":\"TESTS\"' +
                              '}]' +
                              '}';

    // This causes a fake response to be generated
       // Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        
        // Call the method that invokes a callout
        
        string output = DTNA_DTR_Customer_Creation_WebService.DTNA_DTR_Customer_Creation(jsonstring);
       // system.debug('Output:' + jsonstring);
       System.assert(output.contains('Success'));        
} 
    static testMethod void DTNA_DTR_Customertest_03_UserRole_03() {
   

    String jsonstring = '{' +
                              '\"Account\":[{' +
                              '\"CompanyName\":\"Insight4001\",\"InsightCompanyID\":\"4002\",\"Phone1\":\"(910) 334 - 0000\",\"Address1\":\"NW 360 \",' +
                              '\"Address2\":\"Apt A04\",\"City\":\"bEAVERTON\",\"State\":\"OR\",\"Country\":\"USA\",\"ZIP\":\"97006\",\"County\":\"SUMMIT\",' +
                              '\"FleetSize\":\"Small Fleet 2 - 9\",\"Description\":\"Test111\",\"URL\":\"www.ww\",\"Fax\":\"(567) 667 - 0000\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"Contacts\":[{' +
                              '\"FirstName\":\"\",\"LastName\":\"\",\"InsightContactID\":\"4002\",\"Title\":\"Spouse\",' +
                                '\"ContactPhone1\":\"000-000-0000\",\"ContactPhone2\":\"111-111-1111\",\"ContactFax\":\"666-666-6666\",\"ContactEmail\":\"Test@ss\",' +
                                '\"ContactRole\":\"Other\",\"Department\":\"Sales\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"PrivateActivity\":[{' +
                              '\"DTNAConnectId\":\"D70ALKL1\",\"Act_Stage\":\"Not Started\",\"Act_DueDate\":\"2012-04-23\",\"Act_Priority\":\"\",\"Act_Description\":\"TESTS\"' +
                              '}]' +
                              '}';

    // This causes a fake response to be generated
       // Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        
        // Call the method that invokes a callout
        
        string output = DTNA_DTR_Customer_Creation_WebService.DTNA_DTR_Customer_Creation(jsonstring);
       // system.debug('Output:' + jsonstring);
       System.assert(output.contains('Success'));        
}  
    static testMethod void DTNA_DTR_Customertest_03_UserRole_04() {
   

    String jsonstring = '{' +
                              '\"Account\":[{' +
                              '\"CompanyName\":\"Insight4001\",\"InsightCompanyID\":\"4002\",\"Phone1\":\"(910) 334 - 0000\",\"Address1\":\"NW 360 \",' +
                              '\"Address2\":\"Apt A04\",\"City\":\"bEAVERTON\",\"State\":\"OR\",\"Country\":\"USA\",\"ZIP\":\"97006\",\"County\":\"SUMMIT\",' +
                              '\"FleetSize\":\"Small Fleet 2 - 9\",\"Description\":\"Test111\",\"URL\":\"www.ww\",\"Fax\":\"(567) 667 - 0000\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"Contacts\":[{' +
                              '\"FirstName\":\"\",\"LastName\":\"\",\"InsightContactID\":\"4002\",\"Title\":\"Spouse\",' +
                                '\"ContactPhone1\":\"000-000-0000\",\"ContactPhone2\":\"111-111-1111\",\"ContactFax\":\"666-666-6666\",\"ContactEmail\":\"Test@ss\",' +
                                '\"ContactRole\":\"Other\",\"Department\":\"Sales\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"PrivateActivity\":[{' +
                              '\"DTNAConnectId\":\"D70DAB60\",\"Act_Stage\":\"Not Started\",\"Act_DueDate\":\"2012-04-23\",\"Act_Priority\":\"\",\"Act_Description\":\"TESTS\"' +
                              '}]' +
                              '}';

    // This causes a fake response to be generated
       // Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        
        // Call the method that invokes a callout
        
        string output = DTNA_DTR_Customer_Creation_WebService.DTNA_DTR_Customer_Creation(jsonstring);
       // system.debug('Output:' + jsonstring);
       System.assert(output.contains('Success'));        
}  
    static testMethod void DTNA_DTR_Customertest_03_UserRole_05() {
   

    String jsonstring = '{' +
                              '\"Account\":[{' +
                              '\"CompanyName\":\"Insight4001\",\"InsightCompanyID\":\"4002\",\"Phone1\":\"(910) 334 - 0000\",\"Address1\":\"NW 360 \",' +
                              '\"Address2\":\"Apt A04\",\"City\":\"bEAVERTON\",\"State\":\"OR\",\"Country\":\"USA\",\"ZIP\":\"97006\",\"County\":\"SUMMIT\",' +
                              '\"FleetSize\":\"Small Fleet 2 - 9\",\"Description\":\"Test111\",\"URL\":\"www.ww\",\"Fax\":\"(567) 667 - 0000\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"Contacts\":[{' +
                              '\"FirstName\":\"\",\"LastName\":\"\",\"InsightContactID\":\"4002\",\"Title\":\"Spouse\",' +
                                '\"ContactPhone1\":\"000-000-0000\",\"ContactPhone2\":\"111-111-1111\",\"ContactFax\":\"666-666-6666\",\"ContactEmail\":\"Test@ss\",' +
                                '\"ContactRole\":\"Other\",\"Department\":\"Sales\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"PrivateActivity\":[{' +
                              '\"DTNAConnectId\":\"D70MARI7\",\"Act_Stage\":\"Not Started\",\"Act_DueDate\":\"2012-04-23\",\"Act_Priority\":\"\",\"Act_Description\":\"TESTS\"' +
                              '}]' +
                              '}';

    // This causes a fake response to be generated
       // Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        
        // Call the method that invokes a callout
        
        string output = DTNA_DTR_Customer_Creation_WebService.DTNA_DTR_Customer_Creation(jsonstring);
       // system.debug('Output:' + jsonstring);
       System.assert(output.contains('Success'));        
}  
    static testMethod void DTNA_DTR_Customertest_03_UserRole_06() {
   

    String jsonstring = '{' +
                              '\"Account\":[{' +
                              '\"CompanyName\":\"Insight4001\",\"InsightCompanyID\":\"4002\",\"Phone1\":\"(910) 334 - 0000\",\"Address1\":\"NW 360 \",' +
                              '\"Address2\":\"Apt A04\",\"City\":\"bEAVERTON\",\"State\":\"OR\",\"Country\":\"USA\",\"ZIP\":\"97006\",\"County\":\"SUMMIT\",' +
                              '\"FleetSize\":\"Small Fleet 2 - 9\",\"Description\":\"Test111\",\"URL\":\"www.ww\",\"Fax\":\"(567) 667 - 0000\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"Contacts\":[{' +
                              '\"FirstName\":\"\",\"LastName\":\"\",\"InsightContactID\":\"4002\",\"Title\":\"Spouse\",' +
                                '\"ContactPhone1\":\"000-000-0000\",\"ContactPhone2\":\"111-111-1111\",\"ContactFax\":\"666-666-6666\",\"ContactEmail\":\"Test@ss\",' +
                                '\"ContactRole\":\"Other\",\"Department\":\"Sales\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"PrivateActivity\":[{' +
                              '\"DTNAConnectId\":\"D70BRM41\",\"Act_Stage\":\"Not Started\",\"Act_DueDate\":\"2012-04-23\",\"Act_Priority\":\"\",\"Act_Description\":\"TESTS\"' +
                              '}]' +
                              '}';

    // This causes a fake response to be generated
       // Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        
        // Call the method that invokes a callout
        
        string output = DTNA_DTR_Customer_Creation_WebService.DTNA_DTR_Customer_Creation(jsonstring);
       // system.debug('Output:' + jsonstring);
       System.assert(output.contains('Success'));        
}  
    static testMethod void DTNA_DTR_Customertest_03_UserRole_07() {
   

    String jsonstring = '{' +
                              '\"Account\":[{' +
                              '\"CompanyName\":\"Insight4001\",\"InsightCompanyID\":\"4002\",\"Phone1\":\"(910) 334 - 0000\",\"Address1\":\"NW 360 \",' +
                              '\"Address2\":\"Apt A04\",\"City\":\"bEAVERTON\",\"State\":\"OR\",\"Country\":\"USA\",\"ZIP\":\"97006\",\"County\":\"SUMMIT\",' +
                              '\"FleetSize\":\"Small Fleet 2 - 9\",\"Description\":\"Test111\",\"URL\":\"www.ww\",\"Fax\":\"(567) 667 - 0000\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"Contacts\":[{' +
                              '\"FirstName\":\"\",\"LastName\":\"\",\"InsightContactID\":\"4002\",\"Title\":\"Spouse\",' +
                                '\"ContactPhone1\":\"000-000-0000\",\"ContactPhone2\":\"111-111-1111\",\"ContactFax\":\"666-666-6666\",\"ContactEmail\":\"Test@ss\",' +
                                '\"ContactRole\":\"Other\",\"Department\":\"Sales\",\"Source\":\"Insight\"' +
                              '}],' +
                              '\"PrivateActivity\":[{' +
                              '\"DTNAConnectId\":\"D70ERSC4\",\"Act_Stage\":\"Not Started\",\"Act_DueDate\":\"2012-04-23\",\"Act_Priority\":\"\",\"Act_Description\":\"TESTS\"' +
                              '}]' +
                              '}';

    // This causes a fake response to be generated
       // Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        
        // Call the method that invokes a callout
        
        string output = DTNA_DTR_Customer_Creation_WebService.DTNA_DTR_Customer_Creation(jsonstring);
       // system.debug('Output:' + jsonstring);
       System.assert(output.contains('Success'));        
}  
}