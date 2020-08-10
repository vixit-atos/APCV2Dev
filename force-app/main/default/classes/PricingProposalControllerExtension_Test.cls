@isTest
public class PricingProposalControllerExtension_Test {
    @isTest static void test_method_one1() {
        list<PricingProposal__c> lstpproposal = new list<PricingProposal__c>();
        Account acc = new Account();
        
        acc.Name = 'test account';
        
        insert acc;
        
        Id domesticRecordTypeId = TWSConstants.getOpportunityRecordTypeMap().get('TWS_TC_Deal');
        
        Opportunity deal = new Opportunity();
        
        deal.Name = 'test deal';
        deal.DealNumber__c = '12345';
        deal.StageName = 'Create WS';
        deal.CloseDate = date.today();
        deal.AccountId = acc.Id;
        deal.RecordTypeId = domesticRecordTypeId;
        
        System.debug('#deal '+deal);
        
        insert deal;
        
        Deal_Summary_Pricing_Strategy__c dealSummaryComment = new Deal_Summary_Pricing_Strategy__c();
        
        dealSummaryComment.Deal_Summary_Pricing_Strategy__c = 'test';
        dealSummaryComment.Opportunity__c = deal.Id;
        
        insert dealSummaryComment;
        
        Id proposalRecordTypeId = TWSConstants.getPricingProposalRecordTypeMap().get('Proposal');
        Id actualRecordTypeId = TWSConstants.getPricingProposalRecordTypeMap().get('Actual');
        
        PricingProposal__c proposal1 = new PricingProposal__c();
        
        proposal1.Opportunity__c = deal.Id;
        
        proposal1.recordTypeId = proposalRecordTypeId;
        
        proposal1.ReferenceSerialNumber__c='1234';
        
        proposal1.Approval_Status__c = 'Approved';
        
        insert proposal1;
        lstpproposal.add(proposal1);
        proposal1.Approval_Status__c = 'Proposed';
        update proposal1;
        
        PricingProposal__c proposal2 = new PricingProposal__c();
        
        proposal2.Opportunity__c = deal.Id;
        proposal2.Reference_Configuration__c = proposal1.Id;
        proposal2.Approval_Status__c = 'Proposed';
        proposal2.recordTypeId = proposalRecordTypeId;
        
        
        //insert proposal2;
        PageReference ref = Page.TWSSpecImport; 
        ref.getParameters().put('id', proposal1.Id);
        Test.setCurrentPage(ref);
        ApexPages.StandardController sc = new ApexPages.StandardController(deal);
        ApexPages.currentPage().getParameters().put('parent',deal.id);
        PricingProposalControllerExtension ext = new PricingProposalControllerExtension(sc); //construct the extension
        ext.isISPRecordType = true;
        Id domesticRecordTypeId1 = TWSConstants.getOpportunityRecordTypeMap().get('TWS_TC_Deal');
        update proposal1;
        
        
        
        ext.cancel();
        TWS_OData_URLs__c twsodatacs=new TWS_OData_URLs__c();
        twsodatacs.name='url_base';
        twsodatacs.url__c='https://test123-DlrInfo.prd.freightliner.com:48512';
        insert  twsodatacs;
        TWS_Record_Type_Map__c twartcs=new TWS_Record_Type_Map__c();
        twartcs.name='TWS_TC_Deal';
        twartcs.Pricing_proposal_Approval_status__c='Actual';
        insert twartcs;
        system.debug('proposal1.Approval_Status__c '+proposal1.Approval_Status__c );
        ext.save();
        //ext.onload();
        ext.oppRecordtypeCheck = true;
        PricingProposalTriggerHandler.deleteConCal(lstpproposal);
        
        
    }
    
}