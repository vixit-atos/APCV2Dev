@isTest
public class ViewAllButtonOnContactController_Test
{    
    static testMethod void ViewAllButtonOnContactController()
    {   
      Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect/Customer').getRecordTypeId();

      Account testAccount = new Account(Name='test_14feb',recordtypeid=RecordTypeIdAccount);
      insert testAccount;
      
      Private_Activity__c testPrivateActivity = new Private_Activity__c (Account__c=testAccount.Id,Subject__c='test');
      insert testPrivateActivity;
      
      Task testTask= new Task(Description='test_task_14feb' , WhatId = testPrivateActivity.id);
      //insert testTask;
      
    }
    
/*    @isTest()
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
        ViewAllButtonOnContactController viewAllCls = new ViewAllButtonOnContactController();
        
        PageReference pageRef = Page.ViewAllButtonOnContact;
        Test.setCurrentPage(pageRef);
        
        viewAllCls.CancelClick();
        
    }*/
    
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
        ViewAllButtonOnContactController viewAllCls = new ViewAllButtonOnContactController();
        
        PageReference pageRef = Page.ViewAllButtonOnContact;
        Test.setCurrentPage(pageRef);
       
        viewAllCls.CancelClick();
        
    }
}