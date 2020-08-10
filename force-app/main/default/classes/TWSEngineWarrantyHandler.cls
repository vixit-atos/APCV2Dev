public with sharing class TWSEngineWarrantyHandler {

	/**
	* Returns List<EngineWarrantyWrapper> for the EngineWarrantyPricingLineItem__c related with the opportunity
	*/
	public static List<EngineWarrantyWrapper> getEngineWarrantyWrapperMap(Id opportunityId){

		List<EngineWarrantyWrapper> engineWarrantyWrapperList = new List<EngineWarrantyWrapper>();

		List<EngineWarrantyPricingLineItem__c> engineWarrantyList = getEngineWarrantyList(opportunityId);

		for (EngineWarrantyPricingLineItem__c iter: engineWarrantyList){

			EngineWarrantyWrapper newEngineWarrantyWrapper = new EngineWarrantyWrapper();

			newEngineWarrantyWrapper.id = iter.id;
			newEngineWarrantyWrapper.quoteNumber = iter.Name;
			newEngineWarrantyWrapper.coverageDescription = iter.Coverage_Description__c!= null?iter.Coverage_Description__c:'';
			newEngineWarrantyWrapper.timeMileage = iter.Time_Mileage__c!= null?iter.Time_Mileage__c:'';
			newEngineWarrantyWrapper.deduct = iter.Deduct__c!= null?iter.Deduct__c:0;
			newEngineWarrantyWrapper.deductCAD = iter.Deduct_CAD__c!= null?iter.Deduct_CAD__c:0;
			newEngineWarrantyWrapper.highwayOrVocation = iter.Highway_or_Vocation__c!= null?iter.Highway_or_Vocation__c:'';
			newEngineWarrantyWrapper.highTorque = iter.High_Torque__c!= null?iter.High_Torque__c:'';
			newEngineWarrantyWrapper.fmvDeferredRevenue = iter.FMV_Deferred_Revenue__c!= null?iter.FMV_Deferred_Revenue__c:0;
			newEngineWarrantyWrapper.fmvDeferredRevenueCAD = iter.FMV_Deferred_Revenue_CAD__c!= null?iter.FMV_Deferred_Revenue_CAD__c:0;
			newEngineWarrantyWrapper.ewCost = iter.EW_Cost__c!= null?iter.EW_Cost__c:0;
			newEngineWarrantyWrapper.ewCostCAD = iter.EW_Cost_CAD__c!= null?iter.EW_Cost_CAD__c:0;
			newEngineWarrantyWrapper.csdEwMargin = iter.fCSD_EW_Margin_1_2__c!= null?iter.fCSD_EW_Margin_1_2__c:0;
			newEngineWarrantyWrapper.csdEwMarginCAD = iter.CSD_EW_Margin_1_2_CAD__c!= null?iter.CSD_EW_Margin_1_2_CAD__c:0;
			newEngineWarrantyWrapper.pCodeValue = iter.P_Code_Value__c!= null?iter.P_Code_Value__c:0;
			newEngineWarrantyWrapper.pCodeValueCAD = iter.P_Code_Value_CAD__c!= null?iter.P_Code_Value_CAD__c:0;
			newEngineWarrantyWrapper.xFerCostAdj = iter.X_Fer_Cost_Adj__c!= null?iter.X_Fer_Cost_Adj__c:0;
			newEngineWarrantyWrapper.xFerCostAdjCAD = iter.X_Fer_Cost_Adj_CAD__c!= null?iter.X_Fer_Cost_Adj_CAD__c:0;
			newEngineWarrantyWrapper.netImpact = iter.fNet_Impact_4_5__c!= null?iter.fNet_Impact_4_5__c:0;
			newEngineWarrantyWrapper.netImpactCAD = iter.Net_Impact_4_5_CAD__c!= null?iter.Net_Impact_4_5_CAD__c:0;
			newEngineWarrantyWrapper.dtnaMargin = iter.fDTNA_Margin_3_6__c!= null?iter.fDTNA_Margin_3_6__c:0;
			newEngineWarrantyWrapper.dtnaMarginCAD = iter.DTNA_Margin_3_6_CAD__c!= null?iter.DTNA_Margin_3_6_CAD__c:0;
			newEngineWarrantyWrapper.customerPrice = iter.fCustomer_Price_1_4__c!= null?iter.fCustomer_Price_1_4__c:0;
			newEngineWarrantyWrapper.customerPriceCAD = iter.Customer_Price_1_4_CAD__c!= null?iter.Customer_Price_1_4_CAD__c:0;
			newEngineWarrantyWrapper.engine = iter.Engine__c!= null?iter.Engine__c:'';
			newEngineWarrantyWrapper.spp = iter.SPP_Y_N__c!= null?iter.SPP_Y_N__c:'';
			newEngineWarrantyWrapper.pricingProposalName = iter.PricingProposal__r.Name!= null?iter.PricingProposal__r.Name:'';

			engineWarrantyWrapperList.add(newEngineWarrantyWrapper);
		}

		return engineWarrantyWrapperList;
	}

	/**
	* Returns the list of EngineWarrantyPricingLineItem__c related with the Opportunity
	*/
	public static List<EngineWarrantyPricingLineItem__c> getEngineWarrantyList(Id opportunityId){

		List<EngineWarrantyPricingLineItem__c> engineWarrantyList = [
			select id,
						 Name,
						 Coverage_Description__c,
						 Time_Mileage__c,
						 Deduct__c,
						 Deduct_CAD__c,
						 Highway_or_Vocation__c,
						 High_Torque__c,
						 FMV_Deferred_Revenue__c,
						 FMV_Deferred_Revenue_CAD__c,
						 EW_Cost__c,
						 EW_Cost_CAD__c,
						 fCSD_EW_Margin_1_2__c,
						 CSD_EW_Margin_1_2_CAD__c,
						 P_Code_Value__c,
						 P_Code_Value_CAD__c,
						 X_Fer_Cost_Adj__c,
						 X_Fer_Cost_Adj_CAD__c,
						 fNet_Impact_4_5__c,
						 Net_Impact_4_5_CAD__c,
						 fDTNA_Margin_3_6__c,
						 DTNA_Margin_3_6_CAD__c,
						 fCustomer_Price_1_4__c,
						 Customer_Price_1_4_CAD__c,
						 Engine__c,
						 SPP_Y_N__c,
						 PricingProposal__c,
						 PricingProposal__r.Name
			from EngineWarrantyPricingLineItem__c
			where Opportunity__c =:opportunityId
		];

		return engineWarrantyList;
	}


	/**
	* Wrapper class for EngineWarrantyPricingLineItem__c
	*/
	public class EngineWarrantyWrapper{

		public String id {get;set;}
		public String quoteNumber {get;set;}
		public String coverageDescription {get;set;}
		public String timeMileage {get;set;}
		public Double deduct {get;set;}
		public Double deductCAD {get;set;}
		public String highwayOrVocation {get;set;}
		public String highTorque {get;set;}
		public Double fmvDeferredRevenue {get;set;}
		public Double fmvDeferredRevenueCAD {get;set;}
		public Double ewCost {get;set;}
		public Double ewCostCAD {get;set;}
		public Double csdEwMargin {get;set;}
		public Double csdEwMarginCAD {get;set;}
		public Double pCodeValue {get;set;}
		public Double pCodeValueCAD {get;set;}
		public Double xFerCostAdj {get;set;}
		public Double xFerCostAdjCAD {get;set;}
		public Double netImpact {get;set;}
		public Double netImpactCAD {get;set;}
		public Double dtnaMargin {get;set;}
		public Double dtnaMarginCAD {get;set;}
		public Double customerPrice {get;set;}
		public Double customerPriceCAD {get;set;}
		public String engine {get;set;}
		public String spp {get;set;}
		public String pricingProposalName {get;set;}
	}
}