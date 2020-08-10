@isTest
private  class APC_Master_TestClass {
    
    @testSetup static void setup() {
        
        Account ac = new Account(name ='CDCD Account', Dealer_Code__c = 'CDCD') ;
        insert ac; 
        Account ac1 = new Account(name ='YFFD Account', Dealer_Code__c = 'YFFD') ;
        insert ac1;
        
        Contact con = new Contact(LastName ='CDCD User1',AccountId = ac.Id);
        insert con;  
        
        Contact con1 = new Contact(LastName ='YFFD User1',AccountId = ac1.Id);
        insert con1;  
        String recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('APC TBB').getRecordTypeId();
        
        Accountcontactrelation acr = new Accountcontactrelation(AccountId=ac1.Id, contactId=con.Id);
        insert acr;
        
        
        String uniqueUserName = 'standarddealeruser' + DateTime.now().getTime() + '@testorg.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='DEALER-PARTNER-COMMUNITY'];
        User u = new User(Alias = 'stduser',
                          Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', 
                          LastName='Testing', 
                          LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', 
                          ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName=uniqueUserName,
                          isActive=true,
                          contactId = con.Id,
                          visibilities__c='cn=YKFD,ou=dealers,ou=organizations,o=freightliner,o=dcx.com^cn=YFFD,ou=dealers,ou=organizations,o=freightliner,o=dcx.com^cn=YBFD');
        insert u;
        case objcase = new case(status='new', accountid=ac.id, Body_Number__c='11221',Request_Type__c='TBB',Part_No__c='11111111', recordtypeid=recordtypeid,ownerId=u.Id);
        insert objcase;   
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion; 
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        ContentDocumentLink cdl = new ContentDocumentLink(
            LinkedEntityId=objcase.Id, 
            ContentDocumentId=documents[0].Id, 
            ShareType='V', 
            Visibility='AllUsers'
        );
        
        /// Data for Assigned Agent
        
        Profile profile = [Select Id From Profile where Name = 'System Administrator' limit 1];
        
        User usr1= new User();
        usr1.ProfileID = profile.Id;
        usr1.Username ='Test@Testemail.com'+ System.currentTimeMillis(); 
        usr1.LastName ='TestLastname';
        usr1.Email ='Test@Testemail.com';
        usr1.Alias ='TestAlia';
        usr1.TimeZoneSidKey ='TestCommunityNickname';
        usr1.CommunityNickname ='TestCommunityNickname';
        usr1.TimeZoneSidKey ='America/Los_Angeles';
        usr1.LocaleSidKey ='en_US';
        usr1.EmailEncodingKey ='UTF-8';
        usr1.LanguageLocaleKey ='en_US';
        insert usr1;
        System.runas(usr1){ 
            Group grp = new Group();
            grp.name = 'Test Group1';
            grp.Type = 'Regular'; 
            Insert grp; 
            
            //Create Group Member
            GroupMember grpMem1 = new GroupMember();
            grpMem1.UserOrGroupId = UserInfo.getUserId();
            grpMem1.GroupId = grp.Id;
            Insert grpMem1;
            Case cas = new Case(Status ='New', Priority = 'Medium', Origin = 'Email', Agent_Assigned__c=usr1.id,ownerId = grp.Id); 
            insert cas;
        }
        
        Template__c newTemplate = new Template__c();
        newTemplate.Group_Assigned__c = 'Core Team';
        newTemplate.Title_1__c = 'Cancel Confirmed';
        newTemplate.Template__c = 'Hello, This is a test Template';
        insert newTemplate;        
        
    }
    
    @isTest static void getDealerContactsNewTest(){  
        user u = [select id from user where contact.Account.Dealer_code__c = 'CDCD' limit 1];        
        APC_MasterController.getDealerContactsNew();
        system.runAs(u) {
            APC_MasterController.getDealerContactsNew();
        }
    }
    @isTest static void getDealerCodesTest(){     
        user u = [select id from user where contact.Account.Dealer_code__c = 'CDCD' limit 1];  
        system.runAs(u) {
            list<string> test = APC_MasterController.getDealerCodes();
            APC_MasterController.getDealerCodes();
        }
    }
    @isTest static void does_user_has_account_accessTest(){     
        user u = [select id from user where contact.Account.Dealer_code__c = 'CDCD' limit 1];  
        account ac =[select id from account limit 1];
        system.runAs(u) {
            boolean test = APC_MasterController.does_user_has_account_access(APC_ListController.getSoldtopartyfromaccountid(ac.Id));
        }
    }
    @isTest static void getUserIdTest(){                 
        string test = APC_MasterController.getUserId();        
    }  
    @isTest static void createcaserecordexternalTest(){
        Test.startTest();
        user u = [select id from user where contact.Account.Dealer_code__c = 'CDCD' limit 1];
        Test.setMock(HttpCalloutMock.class, new APC_MockHttpResponseGenerator());
        account ac =[select id from account limit 1];
        case objcase = new case(status='new', accountid=ac.id, Additional_Contacts__c='sumit.datta@daimler.com', 
                                Part_No__c='FG  LF3000', Request_Type__c='Lead Time', Lead_Time_Reason__c='Stock', Quantity__c=1);
        // case testcase = APC_MasterController.createcaserecordexternal(objcase,'[{"label":"adsa@sada.com","name":"adsa@sada.com"}]','APC Order', 'CDCD', true); 
        system.runAs(u) {
            try{
                case testcase = APC_MasterController.createcaserecordexternal(objcase,'','APC Order', ac.Id, true); 
                
                case objcase1 = new case(status='new1', Action__c='	Ship Datezzzzzz',accountid=ac.id, Additional_Contacts__c='sumit.datta@daimler.com');
                case testcase1 = APC_MasterController.createcaserecordexternal(objcase1,'','APC TBB',ac.Id, true);
            }catch(exception ex){
                
            }
        }
        Test.stopTest();
    }
    @isTest static void createcaserecordinternalTest(){
        Test.startTest();
        user u = [select id from user where contact.Account.Dealer_code__c = 'CDCD' limit 1];
        Test.setMock(HttpCalloutMock.class, new APC_MockHttpResponseGenerator());
        account ac =[select id from account limit 1];
        case objcase = new case(status='new', accountid=ac.id, Additional_Contacts__c='sumit.datta@daimler.com', 
                                Part_No__c='FG  LF3000', Request_Type__c='Lead Time', Lead_Time_Reason__c='Stock', Quantity__c=1);
        // case testcase = APC_MasterController.createcaserecordexternal(objcase,'[{"label":"adsa@sada.com","name":"adsa@sada.com"}]','APC Order', 'CDCD', true); 
        system.runAs(u) {
            try{
                case testcase = APC_MasterController.createcaserecordexternal(objcase,'','APC Order', ac.Id, false); 
                
                case objcase1 = new case(status='new1', Action__c='	Ship Datezzzzzz',accountid=ac.id, Additional_Contacts__c='sumit.datta@daimler.com');
                case testcase1 = APC_MasterController.createcaserecordexternal(objcase1,'','APC TBB', ac.Id, false);
            }catch(exception ex){
                
            }
        }
        Test.stopTest();
    }
    @isTest static void createlistofcasesexternal_withoutorder(){
        Test.startTest();  
        user u = [select id from user where contact.Account.Dealer_code__c = 'CDCD' limit 1];          
        account ac =[select id from account limit 1];        
        string contact1 = 'sumit.datta@daimler.com';
        string contact2 = 'test@email.com';
        list<string> contactlist = new list<string>();
        contactlist.add(contact1);
        contactlist.add(contact2);        
        String additionalrecipientlist = '[{"label":"adsa@sada.com","name":"adsa@sada.com"}]';        
        string dealercode = 'CDCD';        
        Case case1 = new Case(ownerid=u.Id,SAP_Order_Number__c='17433231',APC_Line_Number__c='10',Part_No__c='MBL 101573',PDC_Location__c='FL28',APC_Original_Delivery__c='',APC_Delivery__c='',APC_Invoice_Number__c='undefined',APC_Tracking_Number__c='',Description='Sumit Datta',Action__c='Reason why',Order_Status__c='Cancelled',APC_PO_Number__c='1526273OTC',APC_DTNA_PO__c='4581582015',Planner_Code__c='PT3',Vendor__c='P771');
        Case case2 = new Case(ownerid=u.Id,SAP_Order_Number__c='17433231',APC_Line_Number__c='40',Part_No__c='MBL 1012343',PDC_Location__c='FL28',APC_Original_Delivery__c='',APC_Delivery__c='',APC_Invoice_Number__c='undefined',APC_Tracking_Number__c='',Description='Sumit Datta',Action__c='Reason why',Order_Status__c='Cancelled',APC_PO_Number__c='1526273OTC',APC_DTNA_PO__c='4581582015',Planner_Code__c='PT3',Vendor__c='P778');
        
        list<Case>listorder = new list<Case>();
        listorder.add(case1);
        listorder.add(case2);
        system.runAs(u) {
            try{
                Test.setMock(HttpCalloutMock.class, new APC_mockSalesorderresponse());
                string orderlinenumberdocumentidsmapobj = '[{"OrderLineNumber":"11","documentids":[]},{"OrderLineNumber":"41","documentids":[]}]';
                APC_MasterController.createlistofcasesexternal_withoutorder(listorder,contactlist,orderlinenumberdocumentidsmapobj, additionalrecipientlist,ac.Id, true);
                
            }catch(exception ex){
                system.debug(ex.getMessage());
            }
        }
        Test.stopTest();
    }
    @isTest static void createlistofcasesinternal_withoutorder(){
        Test.startTest();  
        user u = [select id from user where contact.Account.Dealer_code__c = 'CDCD' limit 1];          
        account ac =[select id from account limit 1];        
        string contact1 = 'sumit.datta@daimler.com';
        string contact2 = 'test@email.com';
        list<string> contactlist = new list<string>();
        contactlist.add(contact1);
        contactlist.add(contact2);        
        String additionalrecipientlist = '[{"label":"adsa@sada.com","name":"adsa@sada.com"}]';        
        string dealercode = 'CDCD';        
        Case case1 = new Case(ownerid=u.Id,SAP_Order_Number__c='17433231',APC_Line_Number__c='10',Part_No__c='MBL 101573',PDC_Location__c='FL28',APC_Original_Delivery__c='',APC_Delivery__c='',APC_Invoice_Number__c='undefined',APC_Tracking_Number__c='',Description='Sumit Datta',Action__c='Reason why',Order_Status__c='Cancelled',APC_PO_Number__c='1526273OTC',APC_DTNA_PO__c='4581582015',Planner_Code__c='PT3',Vendor__c='P771');
        Case case2 = new Case(ownerid=u.Id,SAP_Order_Number__c='17433231',APC_Line_Number__c='40',Part_No__c='MBL 1012343',PDC_Location__c='FL28',APC_Original_Delivery__c='',APC_Delivery__c='',APC_Invoice_Number__c='undefined',APC_Tracking_Number__c='',Description='Sumit Datta',Action__c='Reason why',Order_Status__c='Cancelled',APC_PO_Number__c='1526273OTC',APC_DTNA_PO__c='4581582015',Planner_Code__c='PT3',Vendor__c='P778');
        
        list<Case>listorder = new list<Case>();
        listorder.add(case1);
        listorder.add(case2);
        system.runAs(u) {
            try{
                Test.setMock(HttpCalloutMock.class, new APC_mockSalesorderresponse());
                string orderlinenumberdocumentidsmapobj = '[{"OrderLineNumber":"11","documentids":[]},{"OrderLineNumber":"41","documentids":[]}]';
                APC_MasterController.createlistofcasesexternal_withoutorder(listorder,contactlist,orderlinenumberdocumentidsmapobj, additionalrecipientlist,ac.Id, false);
                
            }catch(exception ex){
                system.debug(ex.getMessage());
            }
        }
        Test.stopTest();
    }
    
    @isTest static void getuservisibilityAccountcodesTest(){
        user u = [select id from user where contact.Account.Dealer_code__c = 'CDCD' limit 1]; 
        system.runAs(u) {
            list<string> test = APC_MasterController.getuservisibilityAccountcodes();
        }
    }
    @isTest static void getuservisibleaccountdetailsTest(){
        user u = [select id from user where contact.Account.Dealer_code__c = 'CDCD' limit 1]; 
        system.runAs(u) {
            list<APC_MasterController.accountinfowrapper> test = APC_MasterController.getuservisibleaccountdetails();
        }
    }  
    @isTest static void getloggeduserprimaryaccountinfoTest(){
        user u = [select id from user where contact.Account.Dealer_code__c = 'CDCD' limit 1]; 
        system.runAs(u) {
            APC_MasterController.accountinfowrapper test = APC_MasterController.getloggeduserprimaryaccountinfo();
        }
    }   
    @isTest static void getDealerContactsSelectedAccountTest(){
        List<Contact> test =  APC_MasterController.getDealerContactsSelectedAccount('CDCD');
    }
    @isTest static void decryptedpasswordTest(){
        
        String paragonCredentails = System.label.Paragan_Credentials;
        APC_Paragon_Credentials__mdt paragonCredentials = [SELECT ID, User_Name__c,key__c,encrypted_password__c FROM APC_Paragon_Credentials__mdt WHERE MasterLabel =: paragonCredentails];
        system.debug('paragonCredentials       ' + paragonCredentials);
        String Password = APC_MasterController.decryptedpassword(paragonCredentials.encrypted_password__c,paragonCredentials.key__c);
    }
    @isTest static void findduplicatecaseforTBBTest(){
        try{
            APC_MasterController.findduplicatecaseforTBBserverside('11221','','CDCD');
            APC_MasterController.findduplicatecaseforTBBserverside('11221','CDCD','');
        }catch(exception ex){
            
        }
        
    } // Change here
    @isTest static void findduplicateforbucket1Test(){
        account ac = [select id from account where Dealer_Code__c = 'CDCD'];
        try{
            APC_MasterController.findduplicateforbucket1(ac.Id, '11111111', 'Core Inquiry','10','7514289');
            APC_MasterController.findduplicateforcreditdebit(ac.Id, '11111111', 'Credit/Debit Request','10','7514289');
            APC_MasterController.findduplicateforReturnnumber(ac.Id, '11111111', 'PDC Return','10','7514289');
            APC_MasterController.findduplicateforbucket1pricerequest(ac.Id, '11111111', 'PDC Return','10','7514289');
        }catch(exception ex){
            
        }
        
    }
    @isTest static void getpartvalidateTest(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new APC_MockHttpResponseGenerator());
        APC_MasterController.CaseAPIWrapper objwrapper = APC_MasterController.getpartvalidate('FG  LF3000');
        Test.stopTest();
    }
    @isTest static void getRecordTypeTest(){
        Try {
            String test = APC_MasterController.getRecordType('11111111111');
        }Catch(exception ex){
            
        }
    }
    @isTest static void getAccountIdTest(){
        Try {
            contact c = [select id from contact where lastname = 'CDCD User1' ];
            String test = APC_MasterController.getAccountId(c.Id);
            String test1 = APC_MasterController.getAccountId('1111');
            
        }Catch(exception ex){
            
        }
    }
    @isTest static void getDefaultRecordTypeTest(){
        Try {
            
            list<APC_MasterController.KeyValue> test = APC_MasterController.getDefaultRecordType();
            String test1 = APC_MasterController.getusernameinfo();
        }Catch(exception ex){
            
        }
    }
    @isTest static void fileuploadfunctionalityTest(){
        try{            
            
            List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
            Account acct = [select id from account where dealer_code__c = 'CDCD'];
            
            List<ContentDocument> documentsInfo = APC_MasterController.getDocuments(
                new Map<String, Object>{
                    'docIds' => new List<Object>{ documents[0].Id }
                }
            );
            List<ContentDocumentLink> cdls = APC_MasterController.createDocumentLinks(
                new Map<String, Object>{
                    'files' => new List<Object>{ new Map<Object,Object>{ 'Id'=>documents[0].Id } },
                        'recordId' => acct.Id
                        }
            );
            Boolean deleteInfo = APC_MasterController.deleteFiles(
                new Map<String, Object>{
                    'fileIds' => new List<Object>{ documents[0].Id }
                }
            );
            List<ContentDocumentLink> cdls1 = APC_MasterController.createDocumentLinksfrompills(
                new Map<String, Object>{
                    'files' => new List<Object>{ new Map<Object,Object>{ 'Id'=>documents[0].Id } },
                        'recordId' => acct.Id
                        }
            );
            
        }Catch(exception ex){
            
        }
    }
    @isTest static void withoutsharingmastercontrollermethodsTest(){
        case c = [select id from case limit 1];
        list<ContentNote> getadditionalrecipient = APC_WithoutSharingMasterController.getadditionalrecipientContentNotes(c.Id);
        List<ContentDocument> getExistingFilesInfo1 = APC_WithoutSharingMasterController.getExistingFilesInfo1(c.Id);
        
    }
    @isTest static void APC_AssignAgentTest(){
        case objcase = [select id, Agent_Assigned__c from case where Agent_Assigned__c != null limit 1];
        APC_AgentAssignedControllers.fetchLookUpValues(objcase.Id);
        APC_AgentAssignedControllers.saveAgent(objcase.Id,objcase.Agent_Assigned__c);
        APC_AgentAssignedControllers.saveAgent('caseid',objcase.Agent_Assigned__c);
    }
    @isTest static void FeedThisTest(){
        user Portalusr = [select id from user where contact.Account.Dealer_code__c = 'CDCD' limit 1];
        Test.StartTest(); 
        System.runAs ( Portalusr ) { 
            
            recordtype rt = [select id from recordtype where sobjecttype = 'case' and name like'APC%' limit 1];
            Case case1 = new Case(status='Resolved',Body_Number__c='11221',recordtypeId = rt.id,Type_Of_Request__c = 'Credit Inquiry');       
            Case case2 = new Case(status='New',Body_Number__c='11221',recordtypeId = rt.id,Type_Of_Request__c = 'Credit Inquiry'); 
            insert case1;
            insert case2;
            FeedItem ff = new FeedItem();
            ff.ParentId = case1.id;
            ff.body = 'test';
            insert ff;
            
            FeedComment fc = new FeedComment();
            fc.CommentBody = 'legal test';            
            fc.FeedItemId = ff.Id;              
            insert fc;
            
            FeedItem ff1 = new FeedItem();
            ff1.ParentId = case2.id;
            ff1.body = 'test';
            insert ff1;
            
            FeedComment fc1 = new FeedComment();
            fc1.CommentBody = 'legal test';            
            fc1.FeedItemId = ff1.Id;              
            insert fc1;
            
            
        }   
        Test.StopTest();      
    }
    // Additional Information Test Class Begins
    @isTest static void getDealerContactsNewTest_AdditionalInformationController(){  
        user u = [select id from user where contact.Account.Dealer_code__c = 'CDCD' limit 1];
        Case caseid=[select id,Additional_Recipients__c from case limit 1];   
        String Caseid1=caseid.Id;
        String acaselist=caseid.Additional_Recipients__c;
        String [] AdditionalContacts = new List<String>();
        system.runAs(u) {            
            APC_AdditionalInformationController.getContacts(Caseid1);
        }
    }
    @isTest static void getContactsinternaltest(){  
        user u = [select id from user where contact.Account.Dealer_code__c = 'CDCD' limit 1];
        Case caseid=[select id,Additional_Recipients__c from case limit 1];   
        String Caseid1=caseid.Id;
        String acaselist=caseid.Additional_Recipients__c;
        String [] AdditionalContacts = new List<String>();
        system.runAs(u) {
            APC_AdditionalInformationController.getContacts(Caseid1);
        }
    }
    @isTest static void getCaseTest(){  
        user u = [select id from user where contact.Account.Dealer_code__c = 'CDCD' limit 1];
        Case caseid=[select id,Additional_Recipients__c from case limit 1];   
        String Caseid1=caseid.Id;
        String acaselist=caseid.Additional_Recipients__c;
        String [] AdditionalContacts = new List<String>();
        system.runAs(u) {
            APC_AdditionalInformationController.getCase(Caseid1);
        }
    }
    @isTest static void getadditionalrecipientTest(){  
        user u = [select id from user where contact.Account.Dealer_code__c = 'CDCD' limit 1];
        Case caseid=[select id,Additional_Recipients__c from case limit 1];   
        String Caseid1=caseid.Id;
        String acaselist=caseid.Additional_Recipients__c;
        String [] AdditionalContacts = new List<String>();
        system.runAs(u) {
            APC_AdditionalInformationController.getadditionalrecipientContentNotes(Caseid1);
        }
    }
    @isTest static void removeAdditionalRecipientsDataTest(){  
        user u = [select id from user where contact.Account.Dealer_code__c = 'CDCD' limit 1];
        Case caseid=[select id,Additional_Recipients__c from case limit 1];
        
        String Caseid1=caseid.Id;      
        system.runAs(u) {          
            APC_AdditionalInformationController.recipientpill WrapCl=new  APC_AdditionalInformationController.recipientpill();
            APC_AdditionalInformationController.removeAdditionalRecipientsDataContentNote(Caseid1,'{"label":"adsa@sada.com","name":"adsa@sada.com"}');
        }
    }    
    @isTest static void getUIThemeDescriptiontest(){  
        user u = [select id from user where contact.Account.Dealer_code__c = 'CDCD' limit 1];
        Case caseid=[select id,Additional_Recipients__c from case limit 1];
        String Caseid1=caseid.Id;
        String acaselist=caseid.Additional_Recipients__c;
        String [] AdditionalContacts = new List<String>(); 
        system.runAs(u) {
            APC_AdditionalInformationController.getUIThemeDescription();
            APC_AdditionalInformationController.getloggeduseraccountid();
        }
    }    
    @isTest static void saveCaseAdditionalContactsDatatest(){  
        user u = [select id from user where contact.Account.Dealer_code__c = 'CDCD' limit 1];
        Case caseid=[select id,Additional_Contacts__c from case limit 1];   
        String Caseid1=caseid.Id;
        String acaselist=caseid.Additional_Contacts__c;
        String [] AdditionalContacts = new List<String>();
        AdditionalContacts.add(acaselist);
        system.runAs(u) {
            try{ 
                APC_AdditionalInformationController.saveCaseAdditionalContactsData(Caseid1,AdditionalContacts);
            }catch(DMLException e){
                system.assertEquals(e.getMessage(), e.getMessage()); 
            }
            
        }
    }
    @isTest static void saveCaseAdditionalContactsDatatestNegative(){  
        user u = [select id from user where contact.Account.Dealer_code__c = 'CDCD' limit 1];
        Case caseid=[select id,Additional_Contacts__c from case limit 1];   
        String Caseid1=caseid.Id;
        String acaselist=caseid.Additional_Contacts__c;
        String [] AdditionalContacts = new List<String>();
        AdditionalContacts.add(acaselist);
        system.runAs(u) {           
            try{ 
                APC_AdditionalInformationController.saveCaseAdditionalContactsData(Caseid1,AdditionalContacts);
            }catch(DMLException e){
                system.assertEquals(e.getMessage(), e.getMessage()); 
            }
            
        }
    }
    @isTest static void saveAdditionalRecipientsDataTest(){  
        user u = [select id from user where contact.Account.Dealer_code__c = 'CDCD' limit 1];
        Case caseid=[select id,Additional_Recipients__c from case limit 1];
        String Caseid1=caseid.Id;
        String acaselist=caseid.Additional_Recipients__c;
        String [] AdditionalContacts = new List<String>();
        AdditionalContacts.add(acaselist);
        
        
        
        system.runAs(u) {
            APC_AdditionalInformationController.recipientpill WrapCl=new  APC_AdditionalInformationController.recipientpill();
            WrapCl.label='teadsa@sada.comst';
            WrapCl.name='testNameadsa@sada.com';
            try{ 
                APC_AdditionalInformationController.saveAdditionalRecipientsDataContentNote(Caseid1,'{"label":"adsa@sada.com","name":"adsa@sada.com"}');
            }catch(DMLException e){
                system.assertEquals(e.getMessage(), e.getMessage()); 
            }
            
        }
    }
    // Additional Information Test Class Ends    
    // APC_FileUploadController Test Begins
    @isTest static void APC_FileUploadControllerTest(){
        Map<String, Object> params = new Map<String, Object>();
        
        Account acct = [select id from account where dealer_code__c = 'CDCD']; 
        case objcase = [select id from case limit 1];
        String myUserId = APC_Fileuploadcontroller.getUserId();
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        List<ContentDocumentLink> cdls = APC_Fileuploadcontroller.createDocumentLinks(
            new Map<String, Object>{
                'files' => new List<Object>{ new Map<Object,Object>{ 'Id'=>documents[0].Id } },
                    'recordId' => acct.Id
                    }
        );
        
        /*    List<ContentDocument> filesInfo = APC_Fileuploadcontroller.getFilesInfo(
new Map<String, Object>{
'files' => new List<Object>{ new Map<Object,Object>{ 'documentId'=>documents[0].Id } },
'recordId' => acct.Id
}
);*/
        List<ContentDocument> filesInfo1 = APC_Fileuploadcontroller.getFilesInfoExternal(
            new Map<String, Object>{
                'files' => new List<Object>{ new Map<Object,Object>{ 'documentId'=>documents[0].Id } },
                    'recordId' => acct.Id
                    }
        );
        List<ContentDocument> documentsInfo = APC_Fileuploadcontroller.getDocuments(
            new Map<String, Object>{
                'docIds' => new List<Object>{ documents[0].Id }
            }
        );
        
        APC_FileuploadController.getExistingFilesInfo();
        
        APC_FileuploadController.getExistingFilesInfo1(objcase.Id);
        try{
            APC_FileuploadController.createDocumentLinks1(null);
        }catch(Exception ex){}
        APC_FileuploadController.createDocumentLinks1(new Map<String, Object>{
            'files' => new List<Object>{ new Map<Object,Object>{ 'documentId'=>documents[0].Id } },
                'recordId' => acct.Id
                }
                                                     );
        APC_FileuploadController.createDocumentLinksExternal(new Map<String, Object>{
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
    // APC_FileUploadController Test Ends    
    // Template Controller Begins
    public static testmethod void fetchTemplateTest(){        
        Template__c Template = APC_TemplateController.fetchTemplate('Core Team', 'Cancel Confirmed');
        system.assertEquals(Template.Template__c, 'Hello, This is a test Template');
        APC_TemplateController.PicklistEntryWrapper obj = new APC_TemplateController.PicklistEntryWrapper();
        
        obj.defaultValue = 'test';
        obj.value = 'test';
        APC_TemplateController.getRoleInfo();
        APC_TemplateController.saveTemplate(template.id, 'Core Team', 'Cancel Confirmed', 'description', true, 'templatedata', false);  
        try{
            
            APC_TemplateController.saveTemplate(null, null, null, null, true, null, false);
        }catch(Exception ex){
            
        }
        
    }    
    public static testmethod void fetchTitlesTest(){
        APC_TemplateController.fetchTitles('Core Team',true);
        APC_TemplateController.fetchTitles('Core Team',false);
        
    }
    public static testmethod void getDependentMapTest(){
        sObject sObj = Schema.getGlobalDescribe().get('Template__c').newSObject() ;
        APC_TemplateController.getDependentMap(sObj,'Group_Assigned__c','Title_c__c');
        APC_TemplateController.getDependentMap(sObj,'Group_Assigned__c','Title_1__c');	
        return;
    }
    // Template Controller Ends 
    // APC_LookupController Begins
    public static testmethod void fetchAccount_test(){
        APC_Lookupcontroller.fetchAccount('CDCD');
        APC_Lookupcontroller.fetchContacts('CDCD');
        APC_Lookupcontroller.fetchcontactslist('CDCD');
    }
    // APC_LookupController End
    // APC_ListController Begins
    @isTest static void APC_ListControllerTest1(){
        string test = APC_ListController.getUserName();
        list<string> testlist = APC_ListController.getPickListValuesIntoList();        
    }
    @isTest static void APC_ListController_getCaseRecordsTest(){
        List<APC_ListController.CaseWrapper> test = APC_ListController.getCaseRecords('','','','');
    }
    @isTest static void APC_ListController_getAllValuesTest(){
        Test.startTest();
        try{
            account ac =[select id from account limit 1];
            Test.setMock(HttpCalloutMock.class, new APC_mockSalesorderresponse());
            Map<String,Object> test = APC_ListController.getAllValues('17412491','',ac.Id,'Existing Order', false);
            Map<String,Object> test1 = APC_ListController.getAllValues('','1528066',ac.Id,'Existing Order', false);
        }catch(exception ex){
            
        }
        
        Test.stopTest();
    }
    @isTest static void APC_ListController_getReceivedOrderFromParagonTest(){
        Test.startTest();
        try{
            account ac =[select id from account limit 1];
            Test.setMock(HttpCalloutMock.class, new APC_mockSalesorderresponse());
            Map<String,Object> test = APC_ListController.getReceivedOrderFromParagon('SAP_Order_Number__c','17412491',ac.Id,'Received Order', false);
            Map<String,Object> test1 = APC_ListController.getReceivedOrderFromParagon('Return_Number__c','61581139',ac.Id,'Received Order', false);
        }catch(exception ex){
            
        }
        
        Test.stopTest();
    }
    @isTest static void APC_utilityclass_test(){
        list<String> testlist = new list<String>();
        testlist.add('sumit;sam;super');
        testlist.add('superduper');
        List<list<String>> test = APC_utilityclass.getadditionaldealercontacts(testlist);
    }
    // APC_ListController Ends
    // APC_MasterController new Methods Start
    @isTest static void APC_MasterControllerPicklisttest(){     
        List<APC_MasterController.picklistwrapper1> testlistpk = APC_MasterController.getPicklistvalues('Case', 'Ship_Method__c');
        List<APC_MasterController.picklistwrapper1> testlistdpk = APC_MasterController.getdependentPicklistvalues('Case', 'Request_Type__c','Credit/Debit Request','Type_of_Request__c');
        List<APC_MasterController.picklistwrapper1> testlistpk1 = APC_MasterController.getPriorityPicklistValue();
        List<APC_MasterController.picklistwrapper1> testlistpk2 = APC_MasterController.getOriginPicklistValue();
        list<case> objcaselist = [select id,APC_Line_Number__c from case];
        string orderlinenumberdocumentidsmapobj = '[{"OrderLineNumber":"11","documentids":[]},{"OrderLineNumber":"41","documentids":[]}]';
        List<ContentDocumentLink> list_CDL = APC_MasterController.createDocumentLinksformultiplecases(objcaselist,orderlinenumberdocumentidsmapobj);
    }
    @isTest static void APC_MasterControllerDuplicatechecktest1(){    
        Test.startTest();        
        Test.setMock(HttpCalloutMock.class, new APC_mockSalesorderresponse());
        APC_MasterController.findordertosoldtopartyrelation('','17412491','','KHMD');
        Test.stopTest();
    }
    @isTest static void APC_MasterControllerDuplicatechecktest2(){    
        Test.startTest();        
        account a = [select id from account limit 1];
        Test.setMock(HttpCalloutMock.class, new APC_mockSalesorderresponse());
        APC_MasterController.findordertosoldtopartyrelation(a.Id,'17412491','','');
        Test.stopTest();
    }
    // APC_MasterController new Methods End
    // APC_FlowInClauseActionClass Start
    @isTest static void APC_FlowInClauseActionClass_Test(){
        APC_FlowInClauseActionClass.FlowInputParameters[] input = new APC_FlowInClauseActionClass.FlowInputParameters[]{};
        case objcase = new case(status='new',  Body_Number__c='11221',Request_Type__c='TBB',Part_No__c='11111111' );
        insert objcase;         
        String content = 'Hello';
        ContentNote note = new ContentNote(
            Title = 'Test',
            Content = Blob.valueOf(content)
        );
        insert note;        
        
        ContentDocumentLink cdl = new ContentDocumentLink(
            LinkedEntityId=objcase.Id, 
            ContentDocumentId=note.Id, 
            ShareType='V', 
            Visibility='AllUsers'
        );
        insert cdl;
        
        APC_FlowInClauseActionClass.FlowInputParameters inputrecord = new APC_FlowInClauseActionClass.FlowInputParameters();
        inputrecord.CaseID = objcase.Id; 
        input.add(inputrecord); 
        APC_FlowInClauseActionClass.FlowOutputParameters[] result  = APC_FlowINClauseActionClass.filterRecords(input);
    }
    // APC_FlowInClauseActionClass End
    
    
}