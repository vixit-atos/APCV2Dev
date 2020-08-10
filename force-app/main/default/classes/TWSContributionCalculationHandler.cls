public with sharing class TWSContributionCalculationHandler {

	/**
	* The keys of all the dynamic line items processed
	*/
	public static Set<String> dynamicLineItemKeySet {get;set;}

	static{
		dynamicLineItemKeySet = new Set<String>();
	}

	/**
	* Returns a Map <PricingProposalId, RelatedContributionCalculations>
	*/
	public static Map<Id, ContributionCalculationWrapper> getContributionCalculationMap(Set<Id> pricingProposalIdSet){

		Map<Id, ContributionCalculationWrapper> proposalContributionMap = new Map<Id, ContributionCalculationWrapper>();

		//get Contribution Calculation List
		List<ContributionCalculation__c> contributionCalculationList = getContributionCalculationList(pricingProposalIdSet);

		for (ContributionCalculation__c contributionCalc: contributionCalculationList){

			ContributionCalculationWrapper newContributionCalculationWrapper = getContributionCalculationWrapper(contributionCalc);

			//add the dynamic and controlling line items to the Contribution Calculation Wrapper
			setDynamicLineItems(newContributionCalculationWrapper, contributionCalc.ContributionCalcDynamicLineItem__r);
			setControllingLneItems(newContributionCalculationWrapper, contributionCalc.Controlling_Line_Items__r);

			proposalContributionMap.put(contributionCalc.PricingProposal__c, newContributionCalculationWrapper);
		}

    return proposalContributionMap;
	}

	/**
	* Queries the Contribution Calculation related with the Proposals
	*/
	public static List<ContributionCalculation__c> getContributionCalculationList(Set<Id> pricingProposalIdSet){

		List<ContributionCalculation__c> contributionCalculationList = [
			select id,
						 PricingProposal__c,
						 Contrib_Calc_Method_PL__c,
					   Source_PL__c,
						 Current_Formula__c,
					   Method_of_Calculation__c,
					   Gross_Formula_Contrib__c,
					   Concession_Amount__c,
					   New_Trucks_Trade_OA__c,
					   Resid_Reserve__c,
					   EW_Adjustment__c,
					   Option_Margin__c,
						 Std_Net_Contrib_Truck__c,
						 CCI__c,
						 Std_Net_Contrib_CCI__c,
						 Chassis_Warranty_Cont__c,
						 Engine_Warranty_Cont__c,
						 ADJ_Net_Contribution__c,
						 Dealer_Net__c,
						 Base_Model_Dnet__c,
						 Option_Content__c,
						 x_Option_Margin__c,
						 Option_Contrib__c,
						 Base_Model_Contrib__c,
						 Gross_Contribution__c,
						 B_N_Adj__c,
						 Std_CM__c,
						 Warr_Reserve__c,
						 Options__c,
						 Residuals_Gain_Loss__c,
						 CSD_Contribution__c,
						 Net_Price__c,
						 F_Sum_of_Add_l_Revenue_Impact__c,
						 Total_Selling_Price_FOB__c,
						 Total_Estimated_Cost__c,
						 Std_Net_Contrib_Truck_Per__c,
						 RMS__c,
						 PCode__c,
						 (select id, Amount__c, Name from ContributionCalcDynamicLineItem__r order by Order__c desc),
						 (select id, Name, Amount__c from Controlling_Line_Items__r order by Order__c desc)
			from ContributionCalculation__c
			where PricingProposal__c in: pricingProposalIdSet];

		return contributionCalculationList;
	}

	/**
	* Returns a wrapper for the Contribution Contribution Calculation
	*/
	public static ContributionCalculationWrapper getContributionCalculationWrapper(ContributionCalculation__c contributionCalc){

		ContributionCalculationWrapper newContributionCalculationWrapper = new ContributionCalculationWrapper();

		newContributionCalculationWrapper.id = contributionCalc.Id;
		newContributionCalculationWrapper.contribCalcMethod = contributionCalc.Contrib_Calc_Method_PL__c!=null?contributionCalc.Contrib_Calc_Method_PL__c:'-';
		newContributionCalculationWrapper.source = contributionCalc.Source_PL__c!=null?contributionCalc.Source_PL__c:'-';
		newContributionCalculationWrapper.currentFormula = contributionCalc.Current_Formula__c!=null?contributionCalc.Current_Formula__c:'-';
		newContributionCalculationWrapper.methodofCalculation = contributionCalc.Method_of_Calculation__c!=null?contributionCalc.Method_of_Calculation__c:'-';
		newContributionCalculationWrapper.grossFormulaContrib = contributionCalc.Gross_Formula_Contrib__c != null?contributionCalc.Gross_Formula_Contrib__c:0;
		newContributionCalculationWrapper.concessionAmount = contributionCalc.Concession_Amount__c!=null?contributionCalc.Concession_Amount__c:0;
		newContributionCalculationWrapper.newTrucksTradeOA = contributionCalc.New_Trucks_Trade_OA__c!=null?contributionCalc.New_Trucks_Trade_OA__c:0;
		newContributionCalculationWrapper.residReserve = contributionCalc.Resid_Reserve__c!=null?contributionCalc.Resid_Reserve__c:0;
		newContributionCalculationWrapper.eWAdjustment = contributionCalc.EW_Adjustment__c!=null?contributionCalc.EW_Adjustment__c:0;
		newContributionCalculationWrapper.optionMargin = contributionCalc.Option_Margin__c!=null?contributionCalc.Option_Margin__c:0;
		newContributionCalculationWrapper.stdNetContribTruck = contributionCalc.Std_Net_Contrib_Truck__c!=null?contributionCalc.Std_Net_Contrib_Truck__c:0;
		newContributionCalculationWrapper.cci = contributionCalc.CCI__c!=null?contributionCalc.CCI__c:0;
		newContributionCalculationWrapper.chassisWarrantyCont = contributionCalc.Chassis_Warranty_Cont__c!=null?contributionCalc.Chassis_Warranty_Cont__c:0;
		newContributionCalculationWrapper.engineWarrantyCont = contributionCalc.Engine_Warranty_Cont__c!=null?contributionCalc.Engine_Warranty_Cont__c:0;
		newContributionCalculationWrapper.adjNetContribution = contributionCalc.ADJ_Net_Contribution__c!=null?contributionCalc.ADJ_Net_Contribution__c:0;
		newContributionCalculationWrapper.dealerNet = contributionCalc.Dealer_Net__c != null?contributionCalc.Dealer_Net__c:0;
		newContributionCalculationWrapper.baseModelDnet = contributionCalc.Base_Model_Dnet__c != null?contributionCalc.Base_Model_Dnet__c:0;
		newContributionCalculationWrapper.optionContent = contributionCalc.Option_Content__c != null?contributionCalc.Option_Content__c:0;
		newContributionCalculationWrapper.xOptionMargin = contributionCalc.x_Option_Margin__c != null?contributionCalc.x_Option_Margin__c:0;
		newContributionCalculationWrapper.optionContrib = contributionCalc.Option_Contrib__c != null?contributionCalc.Option_Contrib__c:0;
		newContributionCalculationWrapper.baseModelContrib = contributionCalc.Base_Model_Contrib__c != null?contributionCalc.Base_Model_Contrib__c:0;
		newContributionCalculationWrapper.grossContribution = contributionCalc.Gross_Contribution__c != null?contributionCalc.Gross_Contribution__c:0;
		newContributionCalculationWrapper.bnAdj = contributionCalc.B_N_Adj__c != null?contributionCalc.B_N_Adj__c:0;
		newContributionCalculationWrapper.stdCM = contributionCalc.Std_CM__c != null?contributionCalc.Std_CM__c:0;
		newContributionCalculationWrapper.warrReserve = contributionCalc.Warr_Reserve__c != null?contributionCalc.Warr_Reserve__c:0;
		newContributionCalculationWrapper.options = contributionCalc.Options__c != null?contributionCalc.Options__c:0;
		newContributionCalculationWrapper.residualsGainLoss = contributionCalc.Residuals_Gain_Loss__c != null?contributionCalc.Residuals_Gain_Loss__c:0;
		newContributionCalculationWrapper.csdContribution = contributionCalc.CSD_Contribution__c != null?contributionCalc.CSD_Contribution__c:0;
		newContributionCalculationWrapper.netPrice = contributionCalc.Net_Price__c != null?contributionCalc.Net_Price__c:0;
		newContributionCalculationWrapper.sumOfAddRevenueImpact = contributionCalc.F_Sum_of_Add_l_Revenue_Impact__c != null?contributionCalc.F_Sum_of_Add_l_Revenue_Impact__c:0;
		newContributionCalculationWrapper.totalSellingPriceFOB = contributionCalc.Total_Selling_Price_FOB__c != null?contributionCalc.Total_Selling_Price_FOB__c:0;
		newContributionCalculationWrapper.totalEstimatedCost = contributionCalc.Total_Estimated_Cost__c != null?contributionCalc.Total_Estimated_Cost__c:0;
		newContributionCalculationWrapper.stdNetContribTruckPer = contributionCalc.Std_Net_Contrib_Truck_Per__c != null?contributionCalc.Std_Net_Contrib_Truck_Per__c:0;
		newContributionCalculationWrapper.rms = contributionCalc.RMS__c != null?contributionCalc.RMS__c:0;
		newContributionCalculationWrapper.pCode = contributionCalc.PCode__c != null?contributionCalc.PCode__c:0;

		return newContributionCalculationWrapper;
	}

	/**
	* Adds the dynamic line items to the Contribution Calculation Wrapper
	*/
	public static void setDynamicLineItems(ContributionCalculationWrapper contributionCalc, List<ContributionCalculationDynamicLineItem__c> dynamicLineItemList){

		contributionCalc.dynamicLineItems = new Map<String, DynamicLineItemWrapper>();

		contributionCalc.adjCM = 0;

		for (ContributionCalculationDynamicLineItem__c iter: dynamicLineItemList){

			DynamicLineItemWrapper newDynamicLineItemWrapper = new DynamicLineItemWrapper();

			newDynamicLineItemWrapper.id = iter.id;
			newDynamicLineItemWrapper.name = iter.name;
			newDynamicLineItemWrapper.amount = iter.Amount__c;

			contributionCalc.adjCM += iter.Amount__c;

			dynamicLineItemKeySet.add(iter.name);
			contributionCalc.dynamicLineItems.put(newDynamicLineItemWrapper.name, newDynamicLineItemWrapper);
		}

		contributionCalc.bnCM =  contributionCalc.bnAdj + contributionCalc.adjCM;
	}

	/**
	* Adds the controlling line items to the Contribution Calculation Wrapper
	*/
	public static void setControllingLneItems(ContributionCalculationWrapper contributionCalc, List<Controlling_Line_Item__c> controllingLineItemList){

		contributionCalc.controllingLineItems = new List<ControllingLineItemWrapper>();

		for (Controlling_Line_Item__c iter: controllingLineItemList){

			ControllingLineItemWrapper newControllingLineItemWrapper = new ControllingLineItemWrapper();

			newControllingLineItemWrapper.id = iter.id;
			newControllingLineItemWrapper.name = iter.name;
			newControllingLineItemWrapper.amount = iter.Amount__c;

			contributionCalc.controllingLineItems.add(newControllingLineItemWrapper);
		}
	}

	/**
	* Wrapper Class for ContributionCalculation__c
	*/
	public class ContributionCalculationWrapper{

		public String id {get;set;}
		public String contribCalcMethod {get;set;}
		public String source {get;set;}
		public String currentFormula {get;set;}
		public String methodofCalculation {get;set;}
		public Double grossFormulaContrib {get;set;}
		public Double concessionAmount {get;set;}
		public Double newTrucksTradeOA  {get;set;}
		public Double residReserve  {get;set;}
		public Double eWAdjustment  {get;set;}
		public Double optionMargin  {get;set;}
		public Double stdNetContribTruck {get;set;}
		public Double cci {get;set;}
		public Double stdNetContribCCI {get;set;}
		public Double chassisWarrantyCont {get;set;}
		public Double engineWarrantyCont {get;set;}
		public Double adjNetContribution {get;set;}
		public Double dealerNet {get;set;}
		public Double baseModelDnet {get;set;}
		public Double optionContent {get;set;}
		public Double xOptionMargin {get;set;}
		public Double optionContrib {get;set;}
		public Double baseModelContrib {get;set;}
		public Double grossContribution {get;set;}
		public Double bnAdj {get;set;}
		public Double stdCM {get;set;}
		public Double bnCM {get;set;}
		public Double adjCM {get;set;}
		public Double warrReserve {get;set;}
		public Double options {get;set;}
		public Double residualsGainLoss {get;set;}
		public Double csdContribution {get;set;}
		public Double netPrice {get;set;}
		public Double sumOfAddRevenueImpact {get;set;}
		public Double totalSellingPriceFOB {get;set;}
		public Double totalEstimatedCost {get;set;}
		public Double stdNetContribTruckPer {get;set;}
		public Double rms {get;set;}
		public Double pCode {get;set;}

		public Map<String, DynamicLineItemWrapper> dynamicLineItems {get;set;}
		public List<ControllingLineItemWrapper> controllingLineItems {get;set;}
	}

	public class DynamicLineItemWrapper{

		public String id {get;set;}
		public String name {get;set;}
		public Double amount {get;set;}
	}

	public class ControllingLineItemWrapper{

		public String id {get;set;}
		public String name {get;set;}
		public Double amount {get;set;}
	}

}