@isTest
public class Isp_Won_or_lost_vf_page_cont_extn_Test
{ 
    @isTest()
    public static void TestMethod1(){
        
        Account actObj = new Account(Name='test_14feb');
        insert actObj;
        Id domesticRecordTypeId = TWSConstants.getOpportunityRecordTypeMap().get('International_Sales_Proposal');

        Opportunity deal = new Opportunity();

        deal.Name = 'test deal';
        deal.DealNumber__c = '12345';
        deal.StageName = 'ISP Approved';
        deal.CloseDate = date.today();
        //deal.AccountId = actObj.Id;
        deal.RecordTypeId = domesticRecordTypeId;
        deal.Won_Lost__c = 'Lost';
        deal.Lost_Reason_ISP__c=null;
        
        System.debug('#deal '+deal);
        
        insert deal;
        Approval.LockResult LoRes= approval.lock(deal.id);
        PageReference pageRef = Page.Isp_Won_or_lost_on_opp_vf_page_redirect;
        
        pageRef.getParameters().put('Id', deal.id);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController cntrlr = new ApexPages.StandardController(deal);
        Isp_Won_or_lost_vf_page_cont_extn Ispwon = new Isp_Won_or_lost_vf_page_cont_extn(cntrlr);
        
        
        
       
        Ispwon.pageAction();
        
        Ispwon.save1();
        Ispwon.Cancel1();
        
    }
    @isTest()
    public static void TestMethod2(){
        
        Account acnt = new Account(Name='Account_123');
        insert acnt;
        Id domesticRecordTypeId = TWSConstants.getOpportunityRecordTypeMap().get('International_Sales_Proposal');

        Opportunity opp = new Opportunity();

        opp.Name = 'opptest';
        opp.DealNumber__c = '67890';
        opp.StageName = 'Create TWS';
        opp.CloseDate = date.today();
        //opp.AccountId = acnt.Id;
        opp.RecordTypeId = domesticRecordTypeId;
        
        System.debug('#deal '+opp);
        
        insert opp;
        Approval.LockResult LoRes= approval.lock(opp.id);
        PageReference pageRef = Page.Isp_Won_or_lost_on_opp_vf_page_redirect;
        
        pageRef.getParameters().put('Id', opp.id);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController cntrlr = new ApexPages.StandardController(opp);
        Isp_Won_or_lost_vf_page_cont_extn Ispwon = new Isp_Won_or_lost_vf_page_cont_extn(cntrlr);
        
        
        
       
        Ispwon.pageAction();
        Ispwon.save1();
        Ispwon.Cancel1();
        
    }
}