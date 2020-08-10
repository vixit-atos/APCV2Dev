trigger TWSPricingProposalLineItemTrigger on PricingProposalDynamicLineItem__c (after insert, after update, after delete) {

  new TWSPricingProposalLineItemHandler().run();
}