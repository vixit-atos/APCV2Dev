@isTest
public class ViewAllExtension_PrivateNote_Test
{    
    static testMethod void ViewAllExtension_PrivateNote_Test()
    {   
      Id actProspectRTid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect/Customer').getRecordTypeId();
        List<Private_Note__c> paList = new List<Private_Note__c>();
        
        Account actObj = new Account(Name='test_14feb',recordtypeid=actProspectRTid);
        insert actObj;
        
        Id prospectRTid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect/Customer').getRecordTypeId();
        Private_Note__c privActObj = new Private_Note__c (Account_RL__c=actObj.Id,Body__c='test');
        paList.add(privActObj);
        insert paList;
        
        Task_Closure_Email_Template__c tskEmailCustSetng = new Task_Closure_Email_Template__c(name='National', Object_Type__c='Opportunity', Email_Template__c='TWS_TC_Task_CompletedVFTemplate');
        insert tskEmailCustSetng;
        
        
        ApexPages.currentPage().getParameters().put('id', actObj.id);
        ApexPages.StandardSetController cntrlr = new ApexPages.StandardSetController(paList);
        ViewAllExtensionController_PrivateNote viewAllCls = new ViewAllExtensionController_PrivateNote(cntrlr);
        
        PageReference pageRef = Page.View_All_Button_page_Private_notes;
        Test.setCurrentPage(pageRef);
        viewAllCls.getPrivateActivitesNote();
        viewAllCls.getPrivateActivitesAttachments();
        viewAllCls.CancelClick();
        
    }
    
    @isTest()
    public static void viewAllAccountTestMethod(){
        Id actProspectRTid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect/Customer').getRecordTypeId();
        List<Private_Note__c> paList = new List<Private_Note__c>();
        
        Account actObj = new Account(Name='test_14feb',recordtypeid=actProspectRTid);
        insert actObj;
        
        Id prospectRTid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect/Customer').getRecordTypeId();
        Private_Note__c privActObj = new Private_Note__c (Account_RL__c=actObj.Id,Body__c='test');
        paList.add(privActObj);
        insert paList;
        
        Task_Closure_Email_Template__c tskEmailCustSetng = new Task_Closure_Email_Template__c(name='National', Object_Type__c='Opportunity', Email_Template__c='TWS_TC_Task_CompletedVFTemplate');
        insert tskEmailCustSetng;
        Attachment testAttach=new Attachment();  
        testAttach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        testAttach.body=bodyBlob;
        testAttach.parentId=privActObj.id;
        insert testAttach;
		//Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        //Attachment testAttach= new Attachment(Description='test_Attachment_14feb',body=bodyBlob, ParentId = privActObj.id);
        //insert testAttach;
        
        ApexPages.currentPage().getParameters().put('id', actObj.id);
        ApexPages.StandardSetController cntrlr = new ApexPages.StandardSetController(paList);
        ViewAllExtensionController_PrivateNote viewAllCls = new ViewAllExtensionController_PrivateNote(cntrlr);
        
        PageReference pageRef = Page.View_All_Button_page_Private_notes;
        Test.setCurrentPage(pageRef);
        viewAllCls.getPrivateActivitesNote();
        viewAllCls.getPrivateActivitesAttachments();
        viewAllCls.CancelClick();
        
    }
    
    @isTest()
    public static void viewAllContactTestMethod(){
        Id actProspectRTid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect/Customer').getRecordTypeId();
        List<Private_Note__c> paList = new List<Private_Note__c>();
        
        Account actObj = new Account(Name='test_14feb',recordtypeid=actProspectRTid);
        insert actObj;
        
        contact conObj = new contact(LastName='test con ln', accountid=actObj.id);
        insert conObj;
        
        Private_Note__c privActObj = new Private_Note__c (Contact_RL__c=conObj.Id,Body__c='test');
        paList.add(privActObj);
        insert paList;
        
        Attachment testAttach=new Attachment();  
        testAttach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        testAttach.body=bodyBlob;
        testAttach.parentId=privActObj.id;
        insert testAttach;
        
        ApexPages.currentPage().getParameters().put('id', conObj.id);
        ApexPages.StandardSetController cntrlr = new ApexPages.StandardSetController(paList);
        ViewAllExtensionController_PrivateNote viewAllCls = new ViewAllExtensionController_PrivateNote(cntrlr);
        
        PageReference pageRef = Page.View_All_Button_page_Private_notes;
        Test.setCurrentPage(pageRef);
        viewAllCls.getPrivateActivitesNote();
        viewAllCls.getPrivateActivitesAttachments();
        viewAllCls.CancelClick();
        
    }
}