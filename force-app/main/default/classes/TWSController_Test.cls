@isTest
public class TWSController_Test {
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
		proposal1.Approval_Status__c = 'Approved';

		insert proposal1;

		PricingProposal__c proposal2 = new PricingProposal__c();

		proposal2.Opportunity__c = deal.Id;
		proposal2.Reference_Configuration__c = proposal1.Id;
		proposal2.recordTypeId = proposalRecordTypeId;

		//insert proposal2;

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



		//insert proposalDinamicLineItemList;
		//delete lineItem3;

		/*lineItem1 = [select Name from PricingProposalDynamicLineItem__c where id = :lineItem1.id];
		lineItem1.Name += 'add';
		upsert lineItem1;




		List<Outgoing_Residuals_Info__c> outgoingResList = new List<Outgoing_Residuals_Info__c>();

		Outgoing_Residuals_Info__c outGoingRes1 = new Outgoing_Residuals_Info__c();
		outGoingRes1.Pricing_Proposal__c = proposal2.Id;
		outGoingRes1.Opportunity__c = deal.Id;

		outgoingResList.add(outGoingRes1);

		Outgoing_Residuals_Info__c outGoingRes2 = new Outgoing_Residuals_Info__c();
		outGoingRes2.Pricing_Proposal__c = proposal2.Id;
		outGoingRes2.Opportunity__c = deal.Id;

		outgoingResList.add(outGoingRes2);

		insert outgoingResList;

		Incoming_Used_Truck_Information__c iuti = new Incoming_Used_Truck_Information__c(Opportunity__c=deal.id);
		insert iuti;

		IncomingUsedTruckLineItem__c iutli = new IncomingUsedTruckLineItem__c(IncomingUsedTruck__c= iuti.id);
		insert iutli;
		//IncomingUsedTruckLineItem__c
		Incoming_Used_Truck_Comment__c iutc = new Incoming_Used_Truck_Comment__c(Opportunity__c=deal.id);
		insert iutc;

		//ChassisWarrantyConfigurationRollup__c
		//ChassisWarrantyPricingElement__c
		
		EngineWarrantyPricingLineItem__c ewli = new EngineWarrantyPricingLineItem__c(Opportunity__c=deal.id, PricingProposal__c=proposal1.id);
		insert ewli;

		Footer__c footer = new Footer__c(Opportunity__c=deal.id);
		insert footer;

		Footer_Line_Item__c fli = new Footer_Line_Item__c(Footer__c = footer.id);
		insert fli;

		ChassisWarrantyConfigurationRollup__c cwcr = new ChassisWarrantyConfigurationRollup__c(Opportunity__c=deal.id, PricingProposal__c = proposal1.id);
		insert cwcr;

		ChassisWarrantyPricingElement__c cwpe = new ChassisWarrantyPricingElement__c(Configuration_Chassis_Warranty_Pricing__c=cwcr.id);
		insert cwpe;*/


	}

	@isTest static void test_method_one() {

		Test.startTest();

			Opportunity deal = [select id from Opportunity where name = 'test deal'];

			TWSController.getTWSDetailInfo(deal.Id);
			

		Test.stopTest();
	}


}