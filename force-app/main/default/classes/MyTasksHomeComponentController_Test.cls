@isTest
public class MyTasksHomeComponentController_Test
{  
    @testSetup static void testSetup(){
        MyTasksHomeComponentController_Test.custSettingMethod();
        Id actProspectRTid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect/Customer').getRecordTypeId();
        List<Account> acctlist = new List<Account>();
        List<Opportunity> opplist = new List<Opportunity>();
        List<Contact> contlist = new List<Contact>();
        Account actObj = new Account(Name='test_14feb',recordtypeid=actProspectRTid);
        Account actObj1 = new Account(Name='sftest',recordtypeid=actProspectRTid);
        acctlist.add(actObj);
        acctlist.add(actObj1);
        insert acctlist;
        
        Opportunity opp = new opportunity(Name='Test',Accountid=actObj.Id,StageName = 'Sub Stage',CloseDate =Date.newInstance(2008,12,31));
        Opportunity opp1 = new opportunity(Name='No Duplicates have been found',Accountid=actObj.Id,StageName = 'Sub Stage',CloseDate =Date.newInstance(2008,12,31));
        opplist.add(opp);
        opplist.add(opp1);
        Insert opplist;
		
        
        Contact conObj = new contact(LastName='test con ln', accountid=actObj.id, Email='test@gmtestail.com');
        Contact conObj1 = new contact(LastName='This is not a duplicate', accountid=actObj.id, Email='test@gmtest3ail.com');
        contlist.add(conObj);
        contlist.add(conObj1);
        insert contlist;
        
        Private_Activity__c privActObj = new Private_Activity__c (Contact__c=conObj.Id,Account__c=actObj.Id,Subject__c='test');
        insert privActObj;
        
        Sales_Contract__c con = new Sales_Contract__c(Name='Test',Opportunity__c=opp1.id);
        Insert con;
        Concession__c conc = new Concession__c(Name='Testconc',Account__c=actObj.id);
        Insert conc;
        
        Task_Closure_Email_Template__c tskEmailCustSetng = new Task_Closure_Email_Template__c(name='National', Object_Type__c='Opportunity', Email_Template__c='TWS_TC_Task_CompletedVFTemplate');
        insert tskEmailCustSetng;
        Task_Group_Closure_Types_List__c tskgrpcls = new Task_Group_Closure_Types_List__c(name='Controlling Group Review - TWS', StageUpdate__c='Controlling Review');
        insert tskgrpcls;
    }
    public static void  custSettingMethod(){
        LIst<AllObjects__c> Objlist = new List<AllObjects__c>();
        AllObjects__c Obj = new AllObjects__c();
        //for(Integer i=0;i<5;i++){
        
        //Objlist.add(Obj);
        Obj = new AllObjects__c(Name='Contract',Object_API__c='Contract',Standard_custom__c='Standard');
        Objlist.add(Obj);
        Obj = new AllObjects__c(Name='Account',Object_API__c='Account',Standard_custom__c='Standard');
        Objlist.add(Obj);
        Obj = new AllObjects__c(Name='Opportunity',Object_API__c='Opportunity',Standard_custom__c='Standard');
        Objlist.add(Obj);
        Obj = new AllObjects__c(Name='Private_Activity__c',Object_API__c='Private_Activity__c',Standard_custom__c='Custom');
        Objlist.add(Obj);
        Obj = new AllObjects__c(Name='Sales_Contract__c',Object_API__c='Sales_Contract__c',Standard_custom__c='Custom');
        Objlist.add(Obj);
         Obj = new AllObjects__c(Name='Concession__c',Object_API__c='Concession__c',Standard_custom__c='Custom');
        Objlist.add(Obj);
        Insert Objlist;
    } 
    static testmethod void test1(){
        test.startTest();
        List<Contact> contactList = [Select ID from Contact WHERE LastName='test con ln'];
        List<Private_Activity__c> privActObj = [Select ID from Private_Activity__c LIMIT 1];
        ApexPages.currentPage().getParameters().put('id', contactList[0].id);
        Id actProspectRTid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect/Customer').getRecordTypeId();
        
        List<task> Talist = new List<Task>();
        Task testTask; 
        DateTime TodayDt = Date.newInstance(2008,12,31);
        testTask = new Task(Description='test_task_14feb', Subject='testSubj', WhatId = privActObj[0].id,Status='Open',Priority='High',ActivityDate=Date.newInstance(2008,12,31)-1,Type = 'Controlling Group Review - TWS');
        Talist.add(testTask);
        DataBase.Insert(Talist);
        MyTasksHomeComponentController viewAllCls = new MyTasksHomeComponentController();
        PageReference pageRef = Page.My_Task_Home_Component_Vfpage;
        Test.setCurrentPage(pageRef);
        viewAllCls.getValues();
        viewAllCls.selectedOption = 'Overdue';
        viewAllCls.Onchange();
        viewAllCls.getTaskList();
        test.StopTest();
    }
    static testmethod void test2(){
        test.startTest();
        List<Contact> contactList = [Select ID from Contact WHERE LastName='test con ln'];
        List<Private_Activity__c> privActObj = [Select ID from Private_Activity__c LIMIT 1];
        List<Account> acctList = [SELECT ID FROM Account LIMIT 1];
        ApexPages.currentPage().getParameters().put('id', contactList[0].id);
        Id actProspectRTid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect/Customer').getRecordTypeId();
        
        List<task> Talist = new List<Task>();
        Task testTask; 
        DateTime TodayDt = Date.newInstance(2008,12,31);
        testTask = new Task(Description='test_task_14feb', Subject='testSubj', WhatId = acctList[0].id,Whoid=contactList[0].id,Status='Open',Priority='High',ActivityDate=Date.newInstance(2008,12,31)+1,Type = 'Controlling Group Review - TWS');
        Talist.add(testTask);
        DataBase.Insert(Talist);
        MyTasksHomeComponentController viewAllCls = new MyTasksHomeComponentController();
        PageReference pageRef = Page.My_Task_Home_Component_Vfpage;
        Test.setCurrentPage(pageRef);
        viewAllCls.getValues();
        viewAllCls.selectedOption = 'Today';
        viewAllCls.Onchange();
        viewAllCls.getTaskList();
        test.StopTest();
    }
    static testmethod void test3(){
        test.startTest();
        List<Contact> contactList = [Select ID from Contact WHERE LastName='test con ln'];
        List<Private_Activity__c> privActObj = [Select ID from Private_Activity__c LIMIT 1];
        List<Account> acctList = [SELECT ID FROM Account LIMIT 1];
        ApexPages.currentPage().getParameters().put('id', contactList[0].id);
        Id actProspectRTid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect/Customer').getRecordTypeId();
        List<task> Talist = new List<Task>();
        Task testTask; 
        DateTime TodayDt = Date.newInstance(2008,12,31);
		testTask = new Task(Description='test_task_14feb', Subject='testSubj',WhoId = contactlist[0].Id,Status='Open',Priority='High',ActivityDate=Date.newInstance(2008,12,31),Type = 'Controlling Group Review - TWS');
        Talist.add(testTask);
        DataBase.Insert(Talist);
        MyTasksHomeComponentController viewAllCls = new MyTasksHomeComponentController();
        PageReference pageRef = Page.My_Task_Home_Component_Vfpage;
        Test.setCurrentPage(pageRef);
        viewAllCls.getValues();
        viewAllCls.selectedOption = 'Today + Overdue';
        viewAllCls.Onchange();
        viewAllCls.getTaskList();
        test.StopTest();
    }
    static testmethod void test4(){
        test.startTest();
        List<Contact> contactList = [Select ID from Contact WHERE LastName='test con ln'];
        List<Private_Activity__c> privActObj = [Select ID from Private_Activity__c LIMIT 1];
        List<Opportunity> opplist = [SELECT ID FROM Opportunity LIMIT 1];
        ApexPages.currentPage().getParameters().put('id', contactList[0].id);
        Id actProspectRTid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect/Customer').getRecordTypeId();
        
        List<task> Talist = new List<Task>();
        Task testTask; 
        DateTime TodayDt = Date.newInstance(2008,12,31);
		ApexPages.currentPage().getParameters().put('id', opplist[0].id);
        testTask = new Task(Description='test_task_14feb', Subject='testSubj', WhatId = opplist[0].id,Status='Open',Priority='High',ActivityDate=Date.newInstance(2008,12,31)-1,Type = 'Controlling Group Review - TWS');        
		DataBase.Insert(testTask);
        MyTasksHomeComponentController viewAllCls = new MyTasksHomeComponentController();
        PageReference pageRef = Page.My_Task_Home_Component_Vfpage;
        Test.setCurrentPage(pageRef);
        viewAllCls.getValues();
        viewAllCls.selectedOption = 'Tomorrow';
        viewAllCls.Onchange();
        viewAllCls.getTaskList();
        test.StopTest();
    }
    static testmethod void test5(){
        test.startTest();
        List<Contact> contactList = [Select ID from Contact WHERE LastName='test con ln'];
        List<Private_Activity__c> privActObj = [Select ID from Private_Activity__c LIMIT 1];
        List<Opportunity> opplist = [SELECT ID FROM Opportunity LIMIT 1];
        List<Concession__C> conclist = [SELECT ID FROM Concession__c LIMIT 1];
        ApexPages.currentPage().getParameters().put('id', contactList[0].id);
        Id actProspectRTid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect/Customer').getRecordTypeId();
        
        List<task> Talist = new List<Task>();
        Task testTask; 
        DateTime TodayDt = Date.newInstance(2008,12,31);
		ApexPages.currentPage().getParameters().put('id', opplist[0].id);
        testTask = new Task(Description='test_task_14feb', Subject='testSubj', WhatId = conclist[0].id,WhoId = contactList[0].Id,Status='Open',Priority='High',ActivityDate=Date.newInstance(2008,12,31)+6,Type = 'Controlling Group Review - TWS');
        Talist.add(testTask);
		DataBase.Insert(Talist);
        MyTasksHomeComponentController viewAllCls = new MyTasksHomeComponentController();
        PageReference pageRef = Page.My_Task_Home_Component_Vfpage;
        Test.setCurrentPage(pageRef);
        viewAllCls.getValues();
        viewAllCls.selectedOption = 'Next 7 Days';
        viewAllCls.Onchange();
        viewAllCls.getTaskList();
        test.StopTest();
    }
	static testmethod void test6(){
        test.startTest();
        List<Contact> contactList = [Select ID from Contact WHERE LastName='test con ln'];
        List<Private_Activity__c> privActObj = [Select ID from Private_Activity__c LIMIT 1];
        List<Opportunity> opplist = [SELECT ID FROM Opportunity LIMIT 1];
        List<Concession__C> conclist = [SELECT ID FROM Concession__c LIMIT 1];
        ApexPages.currentPage().getParameters().put('id', contactList[0].id);
        Id actProspectRTid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect/Customer').getRecordTypeId();
        
        List<task> Talist = new List<Task>();
        Task testTask; 
        DateTime TodayDt = Date.newInstance(2008,12,31);
		ApexPages.currentPage().getParameters().put('id', opplist[0].id);
         testTask = new Task(Description='test_task_14feb', Subject='testSubj', WhatId = conclist[0].id,Status='Open',Priority='High',ActivityDate=Date.newInstance(2008,12,31)+30,Type = 'Controlling Group Review - TWS');
        Talist.add(testTask);
		DataBase.Insert(Talist);
        MyTasksHomeComponentController viewAllCls = new MyTasksHomeComponentController();
        PageReference pageRef = Page.My_Task_Home_Component_Vfpage;
        Test.setCurrentPage(pageRef);
        viewAllCls.getValues();
        viewAllCls.selectedOption = 'Next 7 Days + Overdue';
        viewAllCls.Onchange();
        viewAllCls.getTaskList();
        test.StopTest();
    }
    static testmethod void test7(){
        test.startTest();
        List<Account> acctlist = [Select id from account limit 1];
        List<Contact> contactList = [Select ID from Contact WHERE LastName='test con ln'];
        List<Private_Activity__c> privActObj = [Select ID from Private_Activity__c LIMIT 1];
        List<Opportunity> opplist = [SELECT ID FROM Opportunity LIMIT 1];
        List<Concession__C> conclist = [SELECT ID FROM Concession__c LIMIT 1];
        ApexPages.currentPage().getParameters().put('id', contactList[0].id);
        Id actProspectRTid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect/Customer').getRecordTypeId();
        
        List<task> Talist = new List<Task>();
        Task testTask; 
        DateTime TodayDt = Date.newInstance(2008,12,31);
		ApexPages.currentPage().getParameters().put('id', opplist[0].id);
        testTask = new Task(Description='test_task_14feb', Subject='testSubj', WhatId = acctlist[0].id,Status='Open',Priority='High',ActivityDate=Date.newInstance(2008,12,31)-1,Type = 'Controlling Group Review - TWS');
        Talist.add(testTask);
		DataBase.Insert(Talist);
        MyTasksHomeComponentController viewAllCls = new MyTasksHomeComponentController();
        PageReference pageRef = Page.My_Task_Home_Component_Vfpage;
        Test.setCurrentPage(pageRef);
        viewAllCls.getValues();
        viewAllCls.selectedOption = 'This Month';
        viewAllCls.Onchange();
        viewAllCls.getTaskList();
        test.StopTest();
    }
    static testmethod void test8(){
        test.startTest();
        List<Account> acctlist = [Select id from account limit 1];
        List<Contact> contactList = [Select ID from Contact WHERE LastName='test con ln'];
        List<Private_Activity__c> privActObj = [Select ID from Private_Activity__c LIMIT 1];
        List<Opportunity> opplist = [SELECT ID FROM Opportunity LIMIT 1];
        List<Concession__C> conclist = [SELECT ID FROM Concession__c LIMIT 1];
        ApexPages.currentPage().getParameters().put('id', contactList[0].id);
        Id actProspectRTid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect/Customer').getRecordTypeId();
        
        List<task> Talist = new List<Task>();
        Task testTask; 
        DateTime TodayDt = Date.newInstance(2008,12,31);
		ApexPages.currentPage().getParameters().put('id', opplist[0].id);
		testTask = new Task(Description='test_task_14feb', Subject='testSubj', WhatId = null,Status='Open',Priority='High',ActivityDate=Date.newInstance(2008,12,31)-1,Type = 'Controlling Group Review - TWS');
        Talist.add(testTask);
		DataBase.Insert(Talist);
        MyTasksHomeComponentController viewAllCls = new MyTasksHomeComponentController();
        PageReference pageRef = Page.My_Task_Home_Component_Vfpage;
        Test.setCurrentPage(pageRef);
        viewAllCls.getValues();
        viewAllCls.selectedOption = 'All Open';
        viewAllCls.Onchange();
        viewAllCls.getTaskList();
        test.StopTest();
    }
    /*
    static testMethod void ViewAllExtensionControllerAccOpp_Test()
    {   
        MyTasksHomeComponentController_Test.custSettingMethod();
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect/Customer').getRecordTypeId();
        
        Account actObj = new Account(Name='test_14feb',recordtypeid=RecordTypeIdAccount);
        insert actObj;
        contact conObj = new contact(LastName='test con ln', accountid=actObj.id,Email='test@gmtestail.com');
        insert conObj;
        //  Opportunity opp = new opportunity(Name='Test',Accountid=actObj .Id,StageName = 'Sub Stage',CloseDate =Date.newInstance(2008,12,31));
        //  Insert opp;
        
        Task_Closure_Email_Template__c tskEmailCustSetng = new Task_Closure_Email_Template__c(name='National', Object_Type__c='Opportunity', Email_Template__c='TWS_TC_Task_CompletedVFTemplate');
        insert tskEmailCustSetng;
        Task_Group_Closure_Types_List__c tskgrpcls = new Task_Group_Closure_Types_List__c(name='Controlling Group Review - TWS', StageUpdate__c='Controlling Review');
        insert tskgrpcls;
        ApexPages.currentPage().getParameters().put('id',  actObj.id);
        
        
        Task testTask; 
        DateTime TodayDt = Date.newInstance(2008,12,31);
        
        testTask = new Task(Description='test_task_14feb', Subject='testSubj', WhatId = actObj.id,Whoid=conObj.id,Status='Open',Priority='High',ActivityDate=Date.newInstance(2008,12,31)-1);
        Insert testTask;
        Concession__c con = new Concession__c(Name='Test');
        Insert con;
        
        MyTasksHomeComponentController viewAllCls = new MyTasksHomeComponentController();
        
        PageReference pageRef = Page.My_Task_Home_Component_Vfpage;
        Test.setCurrentPage(pageRef);
        
        viewAllCls.getValues();
        viewAllCls.Onchange();
        viewAllCls.getTaskList();
    } 
    */
    
    /** Account,opportunity condtion **/ /*
    static testMethod void ViewAllExtensionControllerAcc_Test()
    {   
        MyTasksHomeComponentController_Test.custSettingMethod();
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect/Customer').getRecordTypeId();
        
        Account actObj = new Account(Name='test_14feb',recordtypeid=RecordTypeIdAccount);
        insert actObj;
        contact conObj = new contact(LastName='test con ln', accountid=actObj.id,Email='test@gmtestail.com');
        insert conObj;
        Opportunity opp = new opportunity(Name='Test',Accountid=actObj .Id,StageName = 'Sub Stage',CloseDate =Date.newInstance(2008,12,31));
        Insert opp;
        Concession__c con = new Concession__c(Name='Test');
        Insert con;
        Private_Activity__c privActObj = new Private_Activity__c (Account__c=actObj.Id,Contact__c=conObj.Id,Subject__c='test');
        //paList.add(privActObj);
        insert privActObj ;
        
        
        
        
        Task_Closure_Email_Template__c tskEmailCustSetng = new Task_Closure_Email_Template__c(name='National', Object_Type__c='Opportunity', Email_Template__c='TWS_TC_Task_CompletedVFTemplate');
        insert tskEmailCustSetng;
        Task_Group_Closure_Types_List__c tskgrpcls = new Task_Group_Closure_Types_List__c(name='Controlling Group Review - TWS', StageUpdate__c='Controlling Review');
        insert tskgrpcls;
        
        
        
        Task testTask; 
        DateTime TodayDt = Date.newInstance(2008,12,31);
        testTask = new Task(Description='test_task_14feb', Subject='testSubj', WhatId = con.id,Status='Open',Priority='High',ActivityDate=Date.newInstance(2008,12,31)-1);
        Insert testTask;
        testTask = new Task(Description='test_task_14feb', Subject='testSubj', WhatId = con.id,Status='Open',Priority='High',ActivityDate=Date.newInstance(2008,12,31)-1);
        Insert testTask;
        testTask = new Task(Description='test_task_14feb', Subject='testSubj',WhoId = conObj.Id, WhatId = actObj.id,Status='Open',Priority='High',ActivityDate=Date.newInstance(2008,12,31)-1);
        Insert testTask;
        ApexPages.currentPage().getParameters().put('id', opp.id);
        
        testTask = new Task(Description='test_task_14feb', Subject='testSubj', WhatId = opp.id,Status='Open',Priority='High',ActivityDate=Date.newInstance(2008,12,31)-1);
        Insert testTask;
        
        
        testTask = new Task(Description='test_task_14feb', Subject='testSubj',WhoId = conObj.Id, Status='Open',Priority='High',ActivityDate=Date.newInstance(2008,12,31)-1);
        Insert testTask;
        
        ApexPages.currentPage().getParameters().put('id',  actObj.id);
        
        testTask = new Task(Description='test_task_14feb', Subject='testSubj', WhatId = actObj.id,Status='Open',Priority='High',ActivityDate=Date.newInstance(2008,12,31)-1);
        Insert testTask;
        
        
        MyTasksHomeComponentController viewAllCls = new MyTasksHomeComponentController();
        
        PageReference pageRef = Page.My_Task_Home_Component_Vfpage;
        Test.setCurrentPage(pageRef);
        
        viewAllCls.getValues();
        viewAllCls.Onchange();
        viewAllCls.getTaskList();
    }
    
     
    @isTest()
    public static void viewAllAccountTestMethod(){
        MyTasksHomeComponentController_Test.custSettingMethod();
        Private_Activity__c privActObj;
        Task testTask;
        contact conObj;
        Id actProspectRTid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect/Customer').getRecordTypeId();
        List<Private_Activity__c> paList = new List<Private_Activity__c>();
        
        Account actObj = new Account(Name='test_14feb',recordtypeid=actProspectRTid);
        insert actObj;
        
        conObj = new contact(LastName='test con ln', accountid=actObj.id,Email='test@gmtestail.com');
        insert conObj;
        
        Id prospectRTid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect/Customer').getRecordTypeId();
        
        privActObj = new Private_Activity__c (Account__c=actObj.Id,Contact__c=conObj.Id,Subject__c='test');
        insert privActObj;
        
        Task_Closure_Email_Template__c tskEmailCustSetng = new Task_Closure_Email_Template__c(name='National', Object_Type__c='Opportunity', Email_Template__c='TWS_TC_Task_CompletedVFTemplate');
        insert tskEmailCustSetng;
        Task_Group_Closure_Types_List__c tskgrpcls = new Task_Group_Closure_Types_List__c(name='Controlling Group Review - TWS', StageUpdate__c='Controlling Review');
        insert tskgrpcls;
        
        testTask= new Task(Description='test_task_14feb', Subject='testSubj', WhatId = privActObj.id);
        insert testTask;
        
        conObj = new contact(LastName='test con ln',Email='test@gmtestail.com');
        insert conObj;
        
        privActObj = new Private_Activity__c (Contact__c=conObj.Id,Subject__c='test');
        //paList.add(privActObj);
        insert privActObj;
        
        testTask= new Task(Description='test_task_14feb', Subject='testSubj', WhatId = privActObj.id);
        insert testTask;
        
        ApexPages.currentPage().getParameters().put('id', privActObj.id);
        
        MyTasksHomeComponentController viewAllCls = new MyTasksHomeComponentController();
        
        PageReference pageRef = Page.My_Task_Home_Component_Vfpage;
        Test.setCurrentPage(pageRef);
        
        viewAllCls.getValues();
        viewAllCls.Onchange();
        viewAllCls.getTaskList();
        
    }
   */ 
    /*
    @isTest()
    public static void viewAllContactTestMethod(){
        MyTasksHomeComponentController_Test.custSettingMethod();
        Id actProspectRTid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect/Customer').getRecordTypeId();
        List<Private_Activity__c> paList = new List<Private_Activity__c>();
        
        Account actObj = new Account(Name='test_14feb',recordtypeid=actProspectRTid);
        insert actObj;
        
         Account actObj1 = new Account(Name='sftest',recordtypeid=actProspectRTid);
        insert actObj1;
        
        Opportunity opp = new opportunity(Name='Test',Accountid=actObj.Id,StageName = 'Sub Stage',CloseDate =Date.newInstance(2008,12,31));
        Insert opp;
        
        Opportunity opp1 = new opportunity(Name='Test1',Accountid=actObj.Id,StageName = 'Sub Stage',CloseDate =Date.newInstance(2008,12,31));
        Insert opp1;
        
        
        
        contact conObj = new contact(LastName='test con ln', accountid=actObj.id, Email='test@gmtestail.com');
        insert conObj;
        
         contact conObj1 = new contact(LastName='test con ln1', accountid=actObj.id, Email='test@gmtestail.com');
        insert conObj1;
        
        Private_Activity__c privActObj = new Private_Activity__c (Contact__c=conObj.Id,Account__c=actObj.Id,Subject__c='test');
        paList.add(privActObj);
        insert paList;
        
          Sales_Contract__c con = new Sales_Contract__c(Name='Test',Opportunity__c=opp1.id);
        Insert con;
         Concession__c conc = new Concession__c(Name='Testconc',Account__c=actObj.id);
        Insert conc;
        
        Task_Closure_Email_Template__c tskEmailCustSetng = new Task_Closure_Email_Template__c(name='National', Object_Type__c='Opportunity', Email_Template__c='TWS_TC_Task_CompletedVFTemplate');
        insert tskEmailCustSetng;
        Task_Group_Closure_Types_List__c tskgrpcls = new Task_Group_Closure_Types_List__c(name='Controlling Group Review - TWS', StageUpdate__c='Controlling Review');
        insert tskgrpcls;
        
        ApexPages.currentPage().getParameters().put('id', conObj.id);
        
        List<task> Talist = new List<Task>();
        Task testTask; 
        DateTime TodayDt = Date.newInstance(2008,12,31);
        testTask = new Task(Description='test_task_14feb', Subject='testSubj', WhatId = privActObj.id,Status='Open',Priority='High',ActivityDate=Date.newInstance(2008,12,31)-1,Type = 'Controlling Group Review - TWS');
        Talist.add(testTask);
         testTask = new Task(Description='test_task_14feb', Subject='testSubj', WhatId = actObj.id,Whoid=conObj.id,Status='Open',Priority='High',ActivityDate=Date.newInstance(2008,12,31)+1,Type = 'Controlling Group Review - TWS');
        Talist.add(testTask);
        
        testTask = new Task(Description='test_task_14feb', Subject='testSubj',WhoId = conObj.Id,Status='Open',Priority='High',ActivityDate=Date.newInstance(2008,12,31),Type = 'Controlling Group Review - TWS');
        Talist.add(testTask);
        
        
        testTask = new Task(Description='test_task_14feb', Subject='testSubj', WhatId = opp.id,WhoId = conObj.Id,Status='Open',Priority='High',ActivityDate=Date.newInstance(2008,12,31)+6,Type = 'Controlling Group Review - TWS');
        Talist.add(testTask);
        testTask = new Task(Description='test_task_14feb', Subject='testSubj', WhatId = conc.id,WhoId = conObj.Id,Status='Open',Priority='High',ActivityDate=Date.newInstance(2008,12,31)+6,Type = 'Controlling Group Review - TWS');
        Talist.add(testTask);
        
        
        testTask = new Task(Description='test_task_14feb', Subject='testSubj',WhoId = conObj1.Id, Status='Open',Priority='High',ActivityDate=Date.newInstance(2008,12,31)+7,Type = 'Controlling Group Review - TWS');
        //Talist.add(testTask);
        
         testTask = new Task(Description='test_task_14feb', Subject='testSubj', WhatId = con.id,Status='Open',Priority='High',ActivityDate=Date.newInstance(2008,12,31)+30,Type = 'Controlling Group Review - TWS');
        Talist.add(testTask);
       
        
        testTask = new Task(Description='test_task_14feb', Subject='testSubj', WhatId = actObj1.id,Status='Open',Priority='High',ActivityDate=Date.newInstance(2008,12,31)-1,Type = 'Controlling Group Review - TWS');
        Talist.add(testTask);
        
         testTask = new Task(Description='test_task_14feb', Subject='testSubj', WhatId = null,Status='Open',Priority='High',ActivityDate=Date.newInstance(2008,12,31)-1,Type = 'Controlling Group Review - TWS');
        Talist.add(testTask);
        
        DataBase.Insert(Talist);
        
        MyTasksHomeComponentController viewAllCls = new MyTasksHomeComponentController();
        
        PageReference pageRef = Page.My_Task_Home_Component_Vfpage;
        Test.setCurrentPage(pageRef);
        viewAllCls.getValues();
        
        test.startTest();
        viewAllCls.selectedOption = 'Overdue';
        viewAllCls.Onchange();
        viewAllCls.getTaskList();
        viewAllCls.selectedOption = 'Today';
        viewAllCls.Onchange();
        viewAllCls.getTaskList();
        viewAllCls.selectedOption = 'Today + Overdue';
         viewAllCls.Onchange();
        viewAllCls.getTaskList();
         viewAllCls.selectedOption = 'Tomorrow';
         viewAllCls.Onchange();
        viewAllCls.getTaskList();
         viewAllCls.selectedOption = 'Next 7 Days';
        viewAllCls.Onchange();
        viewAllCls.getTaskList();
         viewAllCls.selectedOption = 'Next 7 Days + Overdue';
        viewAllCls.Onchange();
        viewAllCls.getTaskList();
         viewAllCls.selectedOption = 'This Month';
         viewAllCls.Onchange();
        viewAllCls.getTaskList();
        test.stopTest();
        viewAllCls.selectedOption = 'All Open';
        viewAllCls.Onchange();
        viewAllCls.getTaskList();
       test.stopTest();
    }
*/
}