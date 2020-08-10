@isTest()
public class PricingCloneTest {
    @isTest static void test_method_one() {
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
        PricingProposal__c proposal1 = new PricingProposal__c();

        proposal1.Opportunity__c = deal.Id;
        proposal1.recordTypeId = Schema.SObjectType.PricingProposal__c.getRecordTypeInfosByName().get('International Sales Proposal').getRecordTypeId();
        proposal1.Approval_Status__c = 'Approved';

        insert proposal1;

        PricingProposal__c proposal2 = new PricingProposal__c();

        proposal2.Opportunity__c = deal.Id;
        proposal2.Reference_Configuration__c = proposal1.Id;
        proposal2.recordTypeId = Schema.SObjectType.PricingProposal__c.getRecordTypeInfosByName().get('International Sales Proposal').getRecordTypeId();

        insert proposal2;
        List<PricingProposalDynamicLineItem__c> proposalDinamicLineItemList = new List<PricingProposalDynamicLineItem__c>();

        PricingProposalDynamicLineItem__c lineItem1 = new PricingProposalDynamicLineItem__c();

        lineItem1.Name = 'test1';
        lineItem1.Amount__c = 100;
        lineItem1.PricingProposal__c = proposal1.Id;

        proposalDinamicLineItemList.add(lineItem1);

        PricingProposalDynamicLineItem__c lineItem2 = new PricingProposalDynamicLineItem__c();

        lineItem2.Name = 'test1';
        lineItem2.Amount__c = 100;
        lineItem2.PricingProposal__c = proposal2.Id;

        proposalDinamicLineItemList.add(lineItem2);

        PricingProposalDynamicLineItem__c lineItem3 = new PricingProposalDynamicLineItem__c();

        lineItem3.Name = 'test3';
        lineItem3.Amount__c = 100;
        lineItem3.PricingProposal__c = proposal2.Id;

        proposalDinamicLineItemList.add(lineItem3);



        insert proposalDinamicLineItemList;
        delete lineItem3;

        lineItem1 = [select Name from PricingProposalDynamicLineItem__c where id = :lineItem1.id];
        lineItem1.Name += 'add';
        upsert lineItem1;
        PricingClone p = new PricingClone(new ApexPages.StandardController(proposal1));
        test.startTest();


        (new PricingClone(new ApexPages.StandardController(proposal1))).newPrcingPropsal();
                test.stopTest();
    }

}