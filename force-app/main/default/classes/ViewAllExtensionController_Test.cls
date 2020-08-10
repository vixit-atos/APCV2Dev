@isTest
public class ViewAllExtensionController_Test
{    
@testSetup static void testSetup(){
    User adminUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
    System.runAs(adminUser){
        Contact mandatoryContact = new Contact();
        mandatoryContact.FirstName = 'Test';
        mandatoryContact.LastName = 'Test';
        String email = 'test@gmtestail.com';
        mandatoryContact.Email = email.replaceAll( '\\s+', '');
        mandatoryContact.Phone = '0000000000';
        insert mandatoryContact;
        
        List<Task_Group_Closure_Types_List__c> customSettings = new List<Task_Group_Closure_Types_List__c>();
        
        Task_Group_Closure_Types_List__c ispSettings = new Task_Group_Closure_Types_List__c();
        ispSettings.Name = 'Controlling Group Review - ISP';
        ispSettings.StageUpdate__c = 'Controlling Review';
        customSettings.add(ispSettings);
        
        Task_Group_Closure_Types_List__c ASPReviewSettings = new Task_Group_Closure_Types_List__c();
        ASPReviewSettings.Name = 'ASP Group Review - TWS';
        ASPReviewSettings.StageUpdate__c = 'Controlling Review';
        customSettings.add(ASPReviewSettings);
        
        Task_Group_Closure_Types_List__c ASPQuoteSettings = new Task_Group_Closure_Types_List__c();
        ASPQuoteSettings.Name = 'ASP Group Quote - TWS';
        ASPQuoteSettings.StageUpdate__c = 'Controlling Review';
        customSettings.add(ASPQuoteSettings);
        
        Task_Group_Closure_Types_List__c TWSSettings = new Task_Group_Closure_Types_List__c();
        TWSSettings.Name = 'Controlling Group Review - TWS';
        TWSSettings.StageUpdate__c = 'Controlling Review';
        customSettings.add(TWSSettings);
        
        Task_Group_Closure_Types_List__c DTRSettings = new Task_Group_Closure_Types_List__c();
        DTRSettings.Name = 'DTR Group Review - TWS';
        DTRSettings.StageUpdate__c = 'Controlling Review';
        customSettings.add(DTRSettings);
        
        insert customSettings;
    }
}
    static testMethod void ViewAllExtensionController_Test()
    {   
      Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect/Customer').getRecordTypeId();

      Account testAccount = new Account(Name='test_14feb',recordtypeid=RecordTypeIdAccount);
      insert testAccount;
      
      Private_Activity__c testPrivateActivity = new Private_Activity__c (Account__c=testAccount.Id,Subject__c='test');
      insert testPrivateActivity;
      
      Task testTask= new Task(Description='test_task_14feb' , WhatId = testPrivateActivity.id);
      //insert testTask;
      
    }
    
    @isTest()
    public static void viewAllAccountTestMethod(){
        Id actProspectRTid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect/Customer').getRecordTypeId();
        List<Private_Activity__c> paList = new List<Private_Activity__c>();
        
        Account actObj = new Account(Name='test_14feb',recordtypeid=actProspectRTid);
        insert actObj;
        
        Id prospectRTid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect/Customer').getRecordTypeId();
        Private_Activity__c privActObj = new Private_Activity__c (Account__c=actObj.Id,Subject__c='test');
        paList.add(privActObj);
        insert paList;
        
        Task_Closure_Email_Template__c tskEmailCustSetng = new Task_Closure_Email_Template__c(name='National', Object_Type__c='Opportunity', Email_Template__c='TWS_TC_Task_CompletedVFTemplate');
        insert tskEmailCustSetng;
        
        Task testTask= new Task(Description='test_task_14feb', Subject='testSubj', WhatId = privActObj.id);
        insert testTask;
        
        ApexPages.currentPage().getParameters().put('id', actObj.id);
        ApexPages.StandardSetController cntrlr = new ApexPages.StandardSetController(paList);
        ViewAllExtensionController viewAllCls = new ViewAllExtensionController(cntrlr);
        
        PageReference pageRef = Page.View_All_Button_Vfpage;
        Test.setCurrentPage(pageRef);
        viewAllCls.getPrivateActivitesTask();
        viewAllCls.getPrivateActivitesEvents();
        viewAllCls.CancelClick();
        
    }
    
    @isTest()
    public static void viewAllContactTestMethod(){
        Id actProspectRTid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect/Customer').getRecordTypeId();
        List<Private_Activity__c> paList = new List<Private_Activity__c>();
        
        Account actObj = new Account(Name='test_14feb',recordtypeid=actProspectRTid);
        insert actObj;
        
        contact conObj = new contact(LastName='test con ln', accountid=actObj.id);
        insert conObj;
        
        Private_Activity__c privActObj = new Private_Activity__c (Contact__c=conObj.Id,Subject__c='test');
        paList.add(privActObj);
        insert paList;
        
        ApexPages.currentPage().getParameters().put('id', conObj.id);
        ApexPages.StandardSetController cntrlr = new ApexPages.StandardSetController(paList);
        ViewAllExtensionController viewAllCls = new ViewAllExtensionController(cntrlr);
        
        PageReference pageRef = Page.View_All_Button_Vfpage;
        Test.setCurrentPage(pageRef);
        viewAllCls.getPrivateActivitesTask();
        viewAllCls.getPrivateActivitesEvents();
        viewAllCls.CancelClick();
        
    }
}