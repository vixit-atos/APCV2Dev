@isTest
private class TaskTriggerHandler_Test {
    
    @isTest static void test_method_ChorletUser() {
        List<Contact> lstcontact=new List<Contact>();
        Account a = new Account(Name='S1');
        
        insert a;
        
        Contact ca = new Contact();
        ca.FirstName = 'cFN1';
        ca.LastName = 'cLN1';
        ca.phone ='1234567891';
        ca.Email = 'test@gmtestail.com';
        lstcontact.add(ca);
        upsert lstcontact;
        
        
        Profile p1 = [SELECT Id FROM Profile WHERE Name = 'DTNA - STC Charlotte'];
        // UserRole r = [select id from UserRole where DeveloperName = 'Sales_Person'];
        
        User u3 = new User(Alias = 'newUser', Email = 'newuser1@testorg.com',
                           EmailEncodingKey = 'UTF-8', LastName = 'Testing1', LanguageLocaleKey = 'en_US',
                           LocaleSidKey = 'en_US', ProfileId = p1.Id,
                           TimeZoneSidKey = 'America/Los_Angeles',UserName = 'newuser1@testorg.com.dtna.test12343554');
        
        
        Insert u3;
        System.runAs(u3) {
            
            
            Task t = new Task(
                ActivityDate = Date.today().addDays(7),
                Subject = 'Sample Task',
                
                Contact__c=ca.Id,
                OwnerId = UserInfo.getUserId(),
                Status = 'In Progress');
            
            
            insert t;
            
            
        }
    }    
    
    @isTest static void test_method_two() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'TWS/TC - Read Only'];
        
        
        
        User u2 = new User(Alias = 'newUser', Email = 'newuser@testorg.com',
                           EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                           LocaleSidKey = 'en_US', ProfileId = p.Id,
                           TimeZoneSidKey = 'America/Los_Angeles', UserName = 'newuser@testorg.com.dtna.test12343554');
        System.runAs(u2) {
            Task_Closure_Email_Template__c tskEmailCustSetng = new Task_Closure_Email_Template__c(name='TWS_TC_Deal', Object_Type__c='Opportunity', Email_Template__c='TWS_TC_Task_CompletedVFTemplate');
            insert tskEmailCustSetng;
            Task_Group_Closure_Types_List__c tskgrpcls = new Task_Group_Closure_Types_List__c(name='Controlling Group Review - TWS', StageUpdate__c='Controlling Review');
            insert tskgrpcls;
            User NAEuser =[select id,name,email from  User where  SalesUserRole__c='NAE' Limit 1];
            
            Account a = new Account (Name = 'a1');
            
            insert a;
            Contact ca = new Contact(
                
                
                FirstName = 'cFN1',
                LastName = 'cLN1',
                AccountId = a.Id,
                Email = 'test@gmtestail.com'
            );
            
            insert ca;
            
            Id domesticRecordTypeId = TWSConstants.getOpportunityRecordTypeMap().get('TWS_TC_Deal');
            
            Opportunity o = new Opportunity(Name = 'o1',DTR_Requested_to_Quote_Residual__c = true, VEH_MAKE__c = 'FTL', Account = a,RecordTypeId = domesticRecordTypeId, StageName = 'Initial Notification', CloseDate = Date.Today(),Owner=NAEuser);
            insert o;
            
            Task  t = new Task(
                ActivityDate = Date.today().addDays(7),
                Subject = 'Sample Task',
                WhatId = o.Id,
                OwnerId = UserInfo.getUserId(),
                Status = 'Pending Controlling review',
            	Type = 'Controlling Group Review - TWS');
            
            insert t;
            task objtask=[select id,Subject,status,type from Task where id=:t.id]; 
            system.debug('objtask11111111111'+objtask);
            //edit a task
            objtask.Subject = 'Edited Sample Task';
            objtask.Status='Completed';
            objtask.Type='Controlling Group Review - TWS';
            test.startTest();
            update objtask;
            test.stopTest();
            
            
        } 
    }
    
    @isTest static void test_method_one() {
        
        Account a = new Account(Name = 'a1');
        
        insert a;
        
        Contact ca = new Contact(
            
            
            FirstName = 'cFN1',
            LastName = 'cLN1',
            AccountId = a.Id,
            Email = 'test@gmtestail.com'
        );
        
        insert ca;
        Contact cna = new Contact(
            
            
            FirstName = 'cFN2',
            LastName = 'cLN2',
            Email = 'test@gmtestail.com'
        );
        
        insert cna;
        
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        
        
        User u2 = new User(Alias = 'newUser', Email = 'newuser@testorg.com',
                           EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                           LocaleSidKey = 'en_US', ProfileId = p.Id,
                           TimeZoneSidKey = 'America/Los_Angeles', UserName = 'newuser@testorg.com.dtna.test12343554');
        
        
        System.runAs(u2) {
            
            
            Task_Closure_Email_Template__c tskEmailCustSetng = new Task_Closure_Email_Template__c(name='TWS_TC_Deal', Object_Type__c='Opportunity', Email_Template__c='TWS_TC_Task_CompletedVFTemplate');
            insert tskEmailCustSetng;
            Task_Group_Closure_Types_List__c tskgrpcls = new Task_Group_Closure_Types_List__c(name='Controlling Group Review - TWS', StageUpdate__c='Controlling Review');
            insert tskgrpcls;
            
            Task [] tList = new List<Task>();
            Task t;
            
            test.startTest();
            t = new Task(
                ActivityDate = Date.today().addDays(7),
                Subject = 'Sample Task',
                WhatId = a.Id,
                OwnerId = UserInfo.getUserId(),
                Status = 'In Progress');
            
            insert t;

            task t1 = new Task(
                ActivityDate = Date.today().addDays(7),
                Subject = 'Sample Task2',
                Contact__c = cna.Id,
                WhatId = a.Id,
                OwnerId = UserInfo.getUserId(),
                Status = 'In Progress');
            
            tList.add(t1);
            
            task t2 = new Task(
                ActivityDate = Date.today().addDays(7),
                Subject = 'Sample Task3',
                Contact__c = ca.Id,
                WhatId = a.Id,
                OwnerId = UserInfo.getUserId(),
                Status = 'In Progress');
            
            tList.add(t2);
            Id ConcRecordTypeId =  [Select Id From RecordType Where SobjectType = 'Concession__c' and Name = 'FTL Mainframe Concession'].Id;
            Concession__c conc = new Concession__c(Name='12345',RecordTypeId=ConcRecordTypeId,Account__c=a.id);
            Insert conc;
            task t3 = new Task(
                ActivityDate = Date.today().addDays(7),
                Subject = 'Sample Task10',
                
                WhatId = conc.id,
                OwnerId = UserInfo.getUserId(),
                Status = 'In Progress');
            tList.add(t3);
            task t6 = new Task(
                ActivityDate = Date.today().addDays(7),
                Subject = 'Sample Task10',
                
                OwnerId = UserInfo.getUserId(),
                Status = 'In Progress');
            tList.add(t6);
            insert tList;

            task objtask2=[select id,Subject from Task where id=:t3.id]; 
           
            delete objtask2;
            task objtask3=[select id,Contact__c,Whatid,End__c,Subject from Task where id=:t6.id];
            objtask3.Contact__c = ca.Id;
            objtask3.End__c= Date.today();
            objtask3.WhatId = a.Id;
            update objtask3;
            test.stopTest();
            task t4 = new Task(
                ActivityDate = Date.today().addDays(7),
                Subject = 'Sample Task2',
                Contact__c = cna.Id,
                
                OwnerId = UserInfo.getUserId(),
                Status = 'In Progress');
            
            insert t4;
            task objtask4=[select id,Subject from Task where id=:t4.id]; 

            objtask4.Subject = 'Edited Sample Task';
            objtask4.Contact__c = ca.Id;
            update objtask4;
            
            /** task t5 = new Task(
ActivityDate = Date.today().addDays(7),
Subject = 'Sample Task2',

WhatId = a.Id,
OwnerId = UserInfo.getUserId(),
Status = 'In Progress');

insert t5;**/
             task objtask6=[select id,Contact__c,Whatid,End__c,Subject from Task where id=:t6.id];
            Private_Activity__c Pa=[select id,Contact__c,Account__c,Name,Subject__c,Account_Open_Activity_RL__c,Activity_Subject__c,Task__c,Owner__c,Status__c,Contact_RL__c,Due_Date__c from Private_Activity__c where id=:objtask6.Whatid]; 
            
             task objtask7=[select id,Contact__c,Whatid,End__c,Subject from Task where id=:t4.id];
            Private_Activity__c Pa1=[select id,Contact__c,Account__c,Name,Subject__c,Account_Open_Activity_RL__c,Activity_Subject__c,Task__c,Owner__c,Status__c,Contact_RL__c,Due_Date__c from Private_Activity__c where id=:objtask7.Whatid]; 
            Private_Activity_Redirector parAccount = new Private_Activity_Redirector(new ApexPages.StandardController(pa));
            Private_Activity_Redirector parAccount1 = new Private_Activity_Redirector(new ApexPages.StandardController(pa1));
            parAccount1.redirectToAccount();
            parAccount.redirect();
            parAccount.redirectToAccount();
            Private_Activity_Redirector parAccountA = new Private_Activity_Redirector(new ApexPages.StandardController(a));
            
            
        }
    }
}

/**  @isTest static void test_method_one() {

Account a = new Account(Name = 'a12');

insert a;

Contact ca = new Contact(


FirstName = 'cFN1',
LastName = 'cLN1',
AccountId = a.Id,
Email = 'test@gmtestail.com'
);

insert ca;
Contact cna = new Contact(


FirstName = 'cFN2',
LastName = 'cLN2',
Email = 'test@gmtestail.com'

);

insert cna;



Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];



User u2 = new User(Alias = 'newUser', Email = 'newuser@testorg.com',
EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
LocaleSidKey = 'en_US', ProfileId = p.Id,
TimeZoneSidKey = 'America/Los_Angeles', UserName = 'newuser@testorg.com.dtna.test12343554');




System.runAs(u2) {


Private_Activity__c [] pal = new List<Private_Activity__c>();

pal.add(new Private_Activity__c(Account__c = a.Id));
pal.add(new Private_Activity__c(Account__c = a.Id));
pal.add(new Private_Activity__c(Contact__c = cna.Id));
pal.add(new Private_Activity__c(Contact__c = ca.Id));
pal.add(new Private_Activity__c(Contact__c = ca.Id));

insert pal;

Task [] tList = new List<Task>();
Task t;
Event e;


//account task attached to private activity


t = new Task(
ActivityDate = Date.today().addDays(7),
Subject = 'Sample Task',
WhatId = pal[0].Id,
OwnerId = UserInfo.getUserId(),
Status = 'In Progress');

insert t;



//edit a task

t.Subject = 'Edited Sample Task';
update t;



//task from an account quickaction 

t = new Task(
ActivityDate = Date.today().addDays(7),
Subject = 'Sample Task3',
WhatId = a.Id,
OwnerId = UserInfo.getUserId(),
Status = 'In Progress');

QuickAction.QuickActionRequest req;
req = new QuickAction.QuickActionRequest();


// Some quick action name
req.quickActionName = Schema.Account.QuickAction.createPrivateTask;

// Define a record for the quick action to create
req.record = t;

// Provide the context ID (or parent ID). In this case, it is an Account record.
req.contextid = a.Id;

QuickAction.QuickActionResult res;
//res = QuickAction.performQuickAction(req);


//event from an account quickaction
e = new Event(
StartDateTime = Datetime.now(),
EndDateTime = Datetime.now(),
Subject = 'Test Event',
WhoId = ca.Id,
WhatId = a.Id);
req = new QuickAction.QuickActionRequest();


// Some quick action name
req.quickActionName = Schema.Account.QuickAction.createPrivateEvent;

// Define a record for the quick action to create
req.record = e;

// Provide the context ID (or parent ID). In this case, it is an Account record.
req.contextid = a.Id;

res = QuickAction.performQuickAction(req);


//task associated with a contact (without account)

t = new Task(
ActivityDate = Date.today().addDays(7),
Subject = 'Sample Task2',
WhoId = cna.Id,
WhatId = pal[2].Id,
OwnerId = UserInfo.getUserId(),
Status = 'In Progress');

insert t;

//task associated with a contact (with account)
t = new Task(
ActivityDate = Date.today().addDays(7),
Subject = 'Sample Task3',
WhoId = ca.Id,
WhatId = pal[3].Id,
OwnerId = UserInfo.getUserId(),
Status = 'In Progress');

insert t;

//task associated with a contact (quickaction)






Event [] eList;
e = new Event(
StartDateTime = Datetime.now(),
EndDateTime = Datetime.now(),
Subject = 'Test Event',
WhoId = ca.Id,
WhatId = pal[4].Id);

insert e;

//edit event

e.Subject = 'Suck it trebeck';
update e;


//event associated with a contact quickaction

e = new Event(
StartDateTime = Datetime.now(),
EndDateTime = Datetime.now(),
Subject = 'Test Event',
WhoId = ca.Id);


req = new QuickAction.QuickActionRequest();


// Some quick action name
req.quickActionName = Schema.Contact.QuickAction.createContactPrivateEvent;

// Define a record for the quick action to create
req.record = e;

// Provide the context ID (or parent ID). In this case, it is an Contact record.
req.contextid = ca.Id;

res = QuickAction.performQuickAction(req);


List<Private_Activity__c> paList = new List<Private_Activity__c>();
paList.add(pal[0]);

Private_Activity_Redirector parAccount = new Private_Activity_Redirector(new ApexPages.StandardController(pal[0]));
Private_Activity_Redirector parContact = new Private_Activity_Redirector(new ApexPages.StandardController(pal[3]));
Private_Activity_Redirector parSet = new Private_Activity_Redirector(new ApexPages.StandardSetController(paList));

parContact.logACall();
parAccount.redirect();

parAccount.redirectToAccount();
parContact.logContactCall();
parContact.redirectToContactEmailEditor();
parAccount.redirectToEmailEditor();


Private_Activity_Redirector parAccountA = new Private_Activity_Redirector(new ApexPages.StandardController(a));


}
}
@isTest static void test_method_two() {
Profile p = [SELECT Id FROM Profile WHERE Name = 'TWS/TC - Read Only'];



User u2 = new User(Alias = 'newUser', Email = 'newuser@testorg.com',
EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
LocaleSidKey = 'en_US', ProfileId = p.Id,
TimeZoneSidKey = 'America/Los_Angeles', UserName = 'newuser@testorg.com.dtna.test12343554');
System.runAs(u2) {
Task_Closure_Email_Template__c tskEmailCustSetng = new Task_Closure_Email_Template__c(name='TWS_TC_Deal', Object_Type__c='Opportunity', Email_Template__c='TWS_TC_Task_CompletedVFTemplate');
insert tskEmailCustSetng;
Task_Group_Closure_Types_List__c tskgrpcls = new Task_Group_Closure_Types_List__c(name='Controlling Group Review - TWS', StageUpdate__c='Controlling Review');
insert tskgrpcls;
User NAEuser =[select id,name,email from  User where  SalesUserRole__c='NAE' Limit 1];

Account a = new Account (Name = 'a1');

insert a;
Contact ca = new Contact(


FirstName = 'cFN1',
LastName = 'cLN1',
AccountId = a.Id,
Email = 'test@gmtestail.com'
);

insert ca;

Id domesticRecordTypeId = TWSConstants.getOpportunityRecordTypeMap().get('TWS_TC_Deal');

Opportunity o = new Opportunity(Name = 'o1',DTR_Requested_to_Quote_Residual__c = true, VEH_MAKE__c = 'FTL', Account = a,RecordTypeId = domesticRecordTypeId, StageName = 'Initial Notification', CloseDate = Date.Today(),Owner=NAEuser);
insert o;

Task  t = new Task(
ActivityDate = Date.today().addDays(7),
Subject = 'Sample Task',
WhatId = o.Id,
OwnerId = UserInfo.getUserId(),
Status = 'Pending Controlling review');

insert t;
task objtask=[select id,Subject,status,type from Task where id=:t.id]; 
system.debug('objtask11111111111'+objtask);
//edit a task
objtask.Subject = 'Edited Sample Task';
objtask.Status='Completed';
objtask.Type='Controlling Group Review - TWS';
test.startTest();
update objtask;
test.stopTest();

//Set<String> strwhatIDs = new Set<String>();
//strwhatIDs.add(t.WhatId);



// Implement test code
} 
} */