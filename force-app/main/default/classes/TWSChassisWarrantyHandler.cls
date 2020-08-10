public with sharing class TWSChassisWarrantyHandler {

	public static Map<String, String> chassisWarrantyElementsKeyMap {get;set;}

	static{
		chassisWarrantyElementsKeyMap = new Map<String, String>();
	}

	/**
	* Returns a Map<proposalId, ChassisWarranty>
	*/
	public static Map<Id, ChassisWarrantyWrapper> getChassisWarrantyMap(Set<Id> pricingProposalIdSet){

		Map<Id, ChassisWarrantyWrapper> chassisWarrantyMap = new Map<Id, ChassisWarrantyWrapper>();

		List<ChassisWarrantyConfigurationRollup__c> chassisWarrantyList = getChassisWarrantyList(pricingProposalIdSet);

		for (ChassisWarrantyConfigurationRollup__c iter: chassisWarrantyList){

			ChassisWarrantyWrapper newChassisWarrantyWrapper = getChassisWarrantyWrapper(iter);
			chassisWarrantyMap.put(iter.PricingProposal__c, newChassisWarrantyWrapper);
		}

		return chassisWarrantyMap;
	}

	/**
	* Queries the ChassisWarrantyConfigurationRollup__c related with the PricingProposal__c
	*/
	public static List<ChassisWarrantyConfigurationRollup__c> getChassisWarrantyList(Set<Id> pricingProposalIdSet){

		List<ChassisWarrantyConfigurationRollup__c> chassisWarrantyList = [

			select id,
						 Name,
						 PricingProposal__c,
						 Total_EWC_Quoted_Price__c,
						 Total_EWC_Quoted_Price_CAD__c,
						 Warranty_Reserve__c,
						 Warranty_Reserve_CAD__c,
						 Expected_Extended_Chassis_Warranty_Cost__c,
						 Expected_Ext_Chassis_Warranty_Cost_CAD__c,
						 Projected_Extended_Chassis_Warranty_Marg__c,
						 Projected_Ext_Chassis_Warr_Marg_CAD__c,
						 (select id, Name, Description__c, SPP__c, EWC_Quoted_Price__c, EWC_Quoted_Price_CAD__c, Configuration_Chassis_Warranty_Pricing__c from Chassis_Warranty_Pricing_Elements__r)
			from ChassisWarrantyConfigurationRollup__c
			where PricingProposal__c in:pricingProposalIdSet
		];

		return chassisWarrantyList;
	}

	/**
	* Returns a wrapper for the ChassisWarrantyConfigurationRollup__c
	*/
	public static ChassisWarrantyWrapper getChassisWarrantyWrapper(ChassisWarrantyConfigurationRollup__c chassisWarranty){

			ChassisWarrantyWrapper newChassisWarrantyWrapper = new ChassisWarrantyWrapper();

			newChassisWarrantyWrapper.id = chassisWarranty.Id;
			newChassisWarrantyWrapper.totalEWCQuotedPrice = chassisWarranty.Total_EWC_Quoted_Price__c!=null?chassisWarranty.Total_EWC_Quoted_Price__c:0;
			newChassisWarrantyWrapper.totalEWCQuotedPriceCAD = chassisWarranty.Total_EWC_Quoted_Price_CAD__c!=null?chassisWarranty.Total_EWC_Quoted_Price_CAD__c:0;
			newChassisWarrantyWrapper.warrantyReserve = chassisWarranty.Warranty_Reserve__c!=null?chassisWarranty.Warranty_Reserve__c:0;
			newChassisWarrantyWrapper.warrantyReserveCAD = chassisWarranty.Warranty_Reserve_CAD__c!=null?chassisWarranty.Warranty_Reserve_CAD__c:0;
			newChassisWarrantyWrapper.expectedExtendedCost = chassisWarranty.Expected_Extended_Chassis_Warranty_Cost__c!=null?chassisWarranty.Expected_Extended_Chassis_Warranty_Cost__c:0;
			newChassisWarrantyWrapper.expectedExtendedCostCAD = chassisWarranty.Expected_Ext_Chassis_Warranty_Cost_CAD__c!=null?chassisWarranty.Expected_Ext_Chassis_Warranty_Cost_CAD__c:0;
			newChassisWarrantyWrapper.projectedExtendedMarg = chassisWarranty.Projected_Extended_Chassis_Warranty_Marg__c!=null?chassisWarranty.Projected_Extended_Chassis_Warranty_Marg__c:0;
			newChassisWarrantyWrapper.projectedExtendedMargCAD = chassisWarranty.Projected_Ext_Chassis_Warr_Marg_CAD__c!=null?chassisWarranty.Projected_Ext_Chassis_Warr_Marg_CAD__c:0;

			newChassisWarrantyWrapper.dynamicLineItemMap = new Map<String, DynamicLineItemWrapper>();

			for (ChassisWarrantyPricingElement__c iter: chassisWarranty.Chassis_Warranty_Pricing_Elements__r){

				DynamicLineItemWrapper newDynamicLineItemWrapper = new DynamicLineItemWrapper();

				newDynamicLineItemWrapper.dBCodeOrQuoteNumber = iter.Name;
				newDynamicLineItemWrapper.description = iter.Description__c!=null?iter.Description__c:'';
				newDynamicLineItemWrapper.eWCQuotedPrice = iter.EWC_Quoted_Price__c!=null?iter.EWC_Quoted_Price__c:0;
				newDynamicLineItemWrapper.eWCQuotedPriceCAD = iter.EWC_Quoted_Price_CAD__c!=null?iter.EWC_Quoted_Price_CAD__c:0;
				newDynamicLineItemWrapper.spp = iter.SPP__c!=null?iter.SPP__c:'';

				newChassisWarrantyWrapper.dynamicLineItemMap.put(iter.Name, newDynamicLineItemWrapper);

				chassisWarrantyElementsKeyMap.put(iter.Name, iter.Description__c);

			}

			return newChassisWarrantyWrapper;
	}

	/**
	* Wrapper class for ChassisWarrantyConfigurationRollup__c
	*/
	public class ChassisWarrantyWrapper{

		public String id {get;set;}
		public Double totalEWCQuotedPrice {get;set;}
		public Double totalEWCQuotedPriceCAD {get;set;}
		public Double warrantyReserve {get;set;}
		public Double warrantyReserveCAD {get;set;}
		public Double expectedExtendedCost {get;set;}
		public Double expectedExtendedCostCAD {get;set;}
		public Double projectedExtendedMarg {get;set;}
		public Double projectedExtendedMargCAD {get;set;}

		//Map<QuoteNumber, DynamicLineItem>
		public Map<String, DynamicLineItemWrapper> dynamicLineItemMap {get;set;}
	}

	public class DynamicLineItemWrapper{

		public String dBCodeOrQuoteNumber {get;set;}
		public String description {get;set;}
		public Double eWCQuotedPrice {get;set;}
		public Double eWCQuotedPriceCAD {get;set;}
		public String spp {get;set;}
	}
}