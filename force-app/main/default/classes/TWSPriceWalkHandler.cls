public with sharing class TWSPriceWalkHandler {

	public static Map<Id, PriceWalkWrapper> getPriceWalkWrapperMap(Opportunity deal, List<PricingProposal__c> proposalList){

		System.debug('#proposalList '+proposalList);

		Map<Id, PriceWalkWrapper> priceWalkWrapperMap = new Map<Id, PriceWalkWrapper>();

		Map<Id, Double> totalMap = new Map<Id, Double>();
		Map<Id, Double> previousMap = new Map<Id, Double>();
		Map<Id, String> previousNameMap = new Map<Id, String>();

		List<PriceWalkLineItem__c> lineItems = [

			select id,
						Name,
						Mainframe_Code__c,
						Amount__c,
						Pricing_Proposal__c,
						Pricing_Proposal__r.Reference_Configuration__r.Dealer_Cost__c,
						Pricing_Proposal__r.Reference_Configuration__r.Name,
						Pricing_Proposal__r.Price_Walk_Total__c,
						Pricing_Proposal__r.fPrice_Walk_Total__c
			from PriceWalkLineItem__c
			where Pricing_Proposal__c in: proposalList
		];

		Map<Id, List<PriceWalkLineItem__c>> proposalLineItemMap = new Map<Id, List<PriceWalkLineItem__c>> ();

		for (PriceWalkLineItem__c iter: lineItems){

			System.debug('#item '+iter);

			if (proposalLineItemMap.get(iter.Pricing_Proposal__c) == null){
				proposalLineItemMap.put(iter.Pricing_Proposal__c, new List<PriceWalkLineItem__c>());
			}

			proposalLineItemMap.get(iter.Pricing_Proposal__c).add(iter);

		}

		for (PricingProposal__c iter: proposalList){

			PriceWalkWrapper newPriceWalkWrapper = new PriceWalkWrapper();

			newPriceWalkWrapper.dynamicLineDiffMap = new Map<String, Double>();

			newPriceWalkWrapper.previous = 0;
			newPriceWalkWrapper.total = 0;

			if (proposalLineItemMap.get(iter.Id) != null){

				for (PriceWalkLineItem__c lineItem: proposalLineItemMap.get(iter.Id)){
					newPriceWalkWrapper.dynamicLineDiffMap.put(lineItem.Name, lineItem.Amount__c);

					totalMap.put(lineItem.Pricing_Proposal__c, lineItem.Pricing_Proposal__r.fPrice_Walk_Total__c);

					Double previousVal = 0;
					String previousName = '';

					if (lineItem.Pricing_Proposal__r.Reference_Configuration__r != null){
						previousVal = lineItem.Pricing_Proposal__r.Reference_Configuration__r.Dealer_Cost__c;
						previousName = '('+lineItem.Pricing_Proposal__r.Reference_Configuration__r.Name+')';
					}
					previousMap.put(lineItem.Pricing_Proposal__c, previousVal);
					previousNameMap.put(lineItem.Pricing_Proposal__c, previousName);

				}

				newPriceWalkWrapper.previous = previousMap.get(iter.Id);
				newPriceWalkWrapper.previousName = previousNameMap.get(iter.Id);
				newPriceWalkWrapper.total = totalMap.get(iter.Id);
			}

			//newPriceWalkWrapper.specs = 0;
			//newPriceWalkWrapper.spdOverrides = 0;

			priceWalkWrapperMap.put(iter.Id, newPriceWalkWrapper);
		}

		return priceWalkWrapperMap;
	}

	public class PriceWalkWrapper {

    public Double previous {get;set;}
		public String previousName {get;set;}
		public Double specs {get;set;}
		public Double spdOverrides {get;set;}
    public Double total {get;set;}

		//<name, amountDiff>
		public Map<String, Double> dynamicLineDiffMap {get;set;}
  }

}