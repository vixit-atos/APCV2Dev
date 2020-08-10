@isTest
private class TWSPricingProposalLineItemHandlerTest {

    @testSetup static void setup() {

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

        insert deal;

        Id proposalRecordTypeId = TWSConstants.getPricingProposalRecordTypeMap().get('Proposal');
        Id actualRecordTypeId = TWSConstants.getPricingProposalRecordTypeMap().get('Actual');

        PricingProposal__c proposal1 = new PricingProposal__c();

        proposal1.Name = 'actual test';
        proposal1.Opportunity__c = deal.Id;
        proposal1.Approval_Status__c =  'Approved';
        //proposal1.recordTypeId = proposalRecordTypeId;

        insert proposal1;

        PricingProposal__c proposal2 = new PricingProposal__c();

        proposal2.Name = 'proposal test';
        proposal2.Opportunity__c = deal.Id;
        proposal1.Approval_Status__c =  'Proposed';
        proposal2.Reference_Configuration__c = proposal1.Id;
        //proposal2.recordTypeId = proposalRecordTypeId;

        insert proposal2;

    }

    @isTest static void test_method_one() {

        Test.startTest();

            PricingProposal__c proposalTest = [select id from PricingProposal__c where Name='proposal test'];
            PricingProposal__c actualTest = [select id from PricingProposal__c where Name='actual test'];

            List<PricingProposalDynamicLineItem__c> proposalDinamicLineItemList = new List<PricingProposalDynamicLineItem__c>();

            PricingProposalDynamicLineItem__c lineItem1 = new PricingProposalDynamicLineItem__c();

            lineItem1.Name = 'test1';
            lineItem1.Amount__c = 200;
            lineItem1.PricingProposal__c = proposalTest.Id;

            proposalDinamicLineItemList.add(lineItem1);

            PricingProposalDynamicLineItem__c lineItem2 = new PricingProposalDynamicLineItem__c();

            lineItem2.Name = 'test1';
            lineItem2.Amount__c = 100;
            lineItem2.PricingProposal__c = actualTest.Id;

            proposalDinamicLineItemList.add(lineItem2);

            insert proposalDinamicLineItemList;

            List<PricingProposalDynamicLineItem__c> priceWalkLineItems = [select id, Name, Amount__c from PricingProposalDynamicLineItem__c];

            Map<String, Double> amountMap = new Map<String, Double>();

            for (PricingProposalDynamicLineItem__c iter: priceWalkLineItems){
                amountMap.put(iter.Name, iter.Amount__c);
            }

            System.assertEquals(amountMap.get('test1'), lineItem1.Amount__c - lineItem2.Amount__c, 'the price walk amount is not correct');

        Test.stopTest();

    }

}