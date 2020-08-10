public with sharing class TWSPricingProposalHandler {

	/**
	* Queries the Proposals related with the Opportunity
	*/
	public static List<PricingProposal__c> getPricingProposalList(Id opportunityId){

		List<PricingProposal__c> pricingProposalList = [select Id,
																													 Name,
																													 FEX_Rate__c,
																													 BaseModel__c,
																													 ConcessionNumber__c,
																													 NumberOfUnitsColMin__c,
																													 NumberOfUnitsColMax__c,
																													 NumberOfUnitsDealMin__c,
																													 NumberOfUnitsDealMax__c,
																													 DTRResiduals__c,
																													 DTRTrades__c,
																													 ReferenceSerialNumber__c,
																													 SleeperType__c,
																													 EngineMakeHP__c,
																													 Transmission__c,
																													 AxleMakeConfig__c,
																													 PriceLevel__c,
																													 Dealer_Net__c,
																													 Dealer_Net_CAD__c,
																													 Dealer_Net_Disc__c,
																													 Concession_Percent__c,
																													 Disc_Min__c,
																													 Concession_Dollars__c,
																													 Concession_Dollars_CAD__c,
																													 Freight__c,
																													 Freight_CAD__c,
																													 Dealer_Cost__c,
																													 Dealer_Cost_CAD__c,
																													 Dealer_Profit__c,
																													 Dealer_Profit_CAD__c,
																													 Selling_Price__c,
																													 FET_Exempt__c,
																													 FET_Base__c,
																													 FET_Base_12__c,
																													 Less_Tire_Credit__c,
																													 FET__c,
																													 CSD_Warranty__c,
																													 CSD_Warranty_CAD__c,
																													 Engine_Warranty__c,
																													 Engine_Warranty_CAD__c,
																													 Total_Selling_Price__c,
																													 Total_Selling_Price_CAD__c,
																													 Contribution_Calculation__c,
																													 Domicile_Fee__c,
																													 Dealer_PDI__c,
																													 Flooring__c,
																													 Other_Charges__c,
																													 Dealer_Over_Allowance__c,
																													 Dealer_Over_Allowance_CAD__c,
																													 Total_Retail__c,
																													 Base_Model_Retail__c,
																													 F_Total_Dnet__c,
																													 F_Base_Model_Dnet_85__c,
																													 Base_Model_Discount__c,
																													 F_Base_Model_Net_Price__c,
																													 F_Option_Retail__c,
																													 Option_Discount_at_Retail__c,
																													 Option_Discount__c,
																													 Net_Option_Discount__c,
																													 Option_Dnet__c,
																													 F_Net_Price_Before_Adj__c,
																													 F_Effective_Conc__c,
																													 Standard_Concession__c,
																													 Daimler_Latina_Add__c,
																													 DTNA_RSM_Add__c,
																													 Requested_Add__c,
																													 Total_Concession__c,
																													 Approval_Status__c,
																													 Reference_Configuration__r.Contribution_Calculation__c,
																													 (select Id,
																																	 Name,
																																	 Amount__c,
																																	 PricingProposal__c
																														from PricingProposalDynamicLineItem__r),
																														(select Id,
																																		Name,
																																		FEX_Rate__c,
																																		DTR_Split__c,
																																		Dealer_Split__c,
																																		Residual_Type__c,
																																		Residual_Commit_Number__c,
																																		Term_Months__c,
																																		Term_Mileage__c,
																																		Show_Amnt__c,
																																		Show_CAD__c,
																																		Hard_Amnt__c,
																																		Hard_CAD__c,
																																		General_Reserve__c,
																																		General_Reserve_CAD__c,
																																		Specific_Reserve__c,
																																		Specific_Reserve_CAD__c,
																																		fTotal_Reserve__c,
																																		PWV_Value__c,
																																		Rollout_Penalty__c,
																																		Rollout_Penalty_CAD__c,
																																		Mileage_Penalty__c,
																																		Mileage_Penalty_CAD__c,
																																		Pricing_Proposal__c
																														from Outgoing_Residuals_Information__r limit 1)
																							from PricingProposal__c
																							where Opportunity__c =:opportunityId /*and Reference_Configuration__c != null*/
																							and recordtype.DeveloperName != 'Actual'];
	   return pricingProposalList;
	}

	/**
	* Returns a Map<ProposalId, ProposalRecord>
	*/
	public static Map<Id, PricingProposal__c> getProposalMap(Set<Id> proposalIdSet){

		Map<Id, PricingProposal__c> proposalMap = new Map<Id, PricingProposal__c>([select Id,
																																											 Name,
																																											 FEX_Rate__c,
																																											 BaseModel__c,
																																											 ConcessionNumber__c,
																																											 NumberOfUnitsColMin__c,
																																											 NumberOfUnitsColMax__c,
																																											 NumberOfUnitsDealMin__c,
																																											 NumberOfUnitsDealMax__c,
																																											 DTRResiduals__c,
																																											 DTRTrades__c,
																																											 ReferenceSerialNumber__c,
																																											 SleeperType__c,
																																											 EngineMakeHP__c,
																																											 Transmission__c,
																																											 AxleMakeConfig__c,
																																											 PriceLevel__c,
																																											 Dealer_Net__c,
																																											 Dealer_Net_CAD__c,
																																											 Dealer_Net_Disc__c,
																																											 Concession_Percent__c,
																																											 Disc_Min__c,
																																											 Concession_Dollars__c,
																																											 Concession_Dollars_CAD__c,
																																											 Freight__c,
																																											 Freight_CAD__c,
																																											 Dealer_Cost__c,
																																											 Dealer_Cost_CAD__c,
																																											 Dealer_Profit__c,
																																											 Dealer_Profit_CAD__c,
																																											 Selling_Price__c,
																																											 FET_Exempt__c,
																																											 FET_Base__c,
																																											 FET_Base_12__c,
																																											 Less_Tire_Credit__c,
																																											 FET__c,
																																											 CSD_Warranty__c,
																																											 CSD_Warranty_CAD__c,
																																											 Engine_Warranty__c,
																																											 Engine_Warranty_CAD__c,
																																											 Total_Selling_Price__c,
																																											 Total_Selling_Price_CAD__c,
																																											 Contribution_Calculation__c,
																																											 Domicile_Fee__c,
																																											 Dealer_PDI__c,
																																											 Flooring__c,
																																											 Other_Charges__c,
																																											 Dealer_Over_Allowance__c,
																																											 Dealer_Over_Allowance_CAD__c,
																																											 Total_Retail__c,
																																											 Base_Model_Retail__c,
																																											 F_Total_Dnet__c,
																																											 F_Base_Model_Dnet_85__c,
																																											 Base_Model_Discount__c,
																																											 F_Base_Model_Net_Price__c,
																																											 F_Option_Retail__c,
																																											 Option_Discount_at_Retail__c,
																																											 Option_Discount__c,
																																											 Net_Option_Discount__c,
																																											 Option_Dnet__c,
																																											 F_Net_Price_Before_Adj__c,
																																											 F_Effective_Conc__c,
																																											 Standard_Concession__c,
																																											 Daimler_Latina_Add__c,
																																											 DTNA_RSM_Add__c,
																																											 Requested_Add__c,
																																											 Total_Concession__c,
																																											 Approval_Status__c,
																																											 (select Id,
																																											 			   Name,
																																															 Amount__c,
																																															 PricingProposal__c
																																											  from PricingProposalDynamicLineItem__r)
																																					 				from PricingProposal__c
																																									where id in:proposalIdSet]);
		return proposalMap;
	}

	public static List<PricingProposal__c> getPricingProposalListWithReference(Id opportunityId){

		List<PricingProposal__c> pricingProposalList = [select Id,
																													 Name,
																													 FEX_Rate__c,
																													 BaseModel__c,
																													 ConcessionNumber__c,
																													 NumberOfUnitsColMin__c,
																													 NumberOfUnitsColMax__c,
																													 NumberOfUnitsDealMin__c,
																													 NumberOfUnitsDealMax__c,
																													 DTRResiduals__c,
																													 DTRTrades__c,
																													 ReferenceSerialNumber__c,
																													 SleeperType__c,
																													 EngineMakeHP__c,
																													 Transmission__c,
																													 AxleMakeConfig__c,
																													 PriceLevel__c,
																													 Dealer_Net__c,
																													 Dealer_Net_CAD__c,
																													 Dealer_Net_Disc__c,
																													 Concession_Percent__c,
																													 Disc_Min__c,
																													 Concession_Dollars__c,
																													 Concession_Dollars_CAD__c,
																													 Freight__c,
																													 Freight_CAD__c,
																													 Dealer_Cost__c,
																													 Dealer_Cost_CAD__c,
																													 Dealer_Profit__c,
																													 Dealer_Profit_CAD__c,
																													 Selling_Price__c,
																													 FET_Exempt__c,
																													 FET_Base__c,
																													 FET_Base_12__c,
																													 Less_Tire_Credit__c,
																													 FET__c,
																													 CSD_Warranty__c,
																													 CSD_Warranty_CAD__c,
																													 Engine_Warranty__c,
																													 Engine_Warranty_CAD__c,
																													 Total_Selling_Price__c,
																													 Total_Selling_Price_CAD__c,
																													 Contribution_Calculation__c,
																													 Domicile_Fee__c,
																													 Dealer_PDI__c,
																													 Flooring__c,
																													 Other_Charges__c,
																													 Dealer_Over_Allowance__c,
																													 Dealer_Over_Allowance_CAD__c,
																													 Total_Retail__c,
																													 Base_Model_Retail__c,
																													 F_Total_Dnet__c,
																													 F_Base_Model_Dnet_85__c,
																													 Base_Model_Discount__c,
																													 F_Base_Model_Net_Price__c,
																													 F_Option_Retail__c,
																													 Option_Discount_at_Retail__c,
																													 Option_Discount__c,
																													 Net_Option_Discount__c,
																													 Option_Dnet__c,
																													 F_Net_Price_Before_Adj__c,
																													 F_Effective_Conc__c,
																													 Standard_Concession__c,
																													 Daimler_Latina_Add__c,
																													 DTNA_RSM_Add__c,
																													 Requested_Add__c,
																													 Total_Concession__c,
																													 Reference_Configuration__r.Contribution_Calculation__c,
																													 Approval_Status__c,
																													 (select Id,
																																	 Name,
																																	 Amount__c,
																																	 PricingProposal__c
																														from PricingProposalDynamicLineItem__r),
																														(select Id,
																																		Name,
																																		FEX_Rate__c,
																																		DTR_Split__c,
																																		Dealer_Split__c,
																																		Residual_Type__c,
																																		Residual_Commit_Number__c,
																																		Term_Months__c,
																																		Term_Mileage__c,
																																		Show_Amnt__c,
																																		Show_CAD__c,
																																		Hard_Amnt__c,
																																		Hard_CAD__c,
																																		General_Reserve__c,
																																		General_Reserve_CAD__c,
																																		Specific_Reserve__c,
																																		Specific_Reserve_CAD__c,
																																		fTotal_Reserve__c,
																																		PWV_Value__c,
																																		Rollout_Penalty__c,
																																		Rollout_Penalty_CAD__c,
																																		Mileage_Penalty__c,
																																		Mileage_Penalty_CAD__c,
																																		Pricing_Proposal__c
																														from Outgoing_Residuals_Information__r limit 1)
																							from PricingProposal__c
																							where Opportunity__c =:opportunityId
																							and Reference_Configuration__c != null
																							and recordtype.DeveloperName != 'Actual'];
	   return pricingProposalList;
	}

	public static List<PricingProposal__c> getPricingProposalNotInTheList(Set<Id> proposalIdSet, Id opportunityId){

		List<PricingProposal__c> pricingProposalList = [select Id,
																													 Name,
																													 FEX_Rate__c,
																													 BaseModel__c,
																													 ConcessionNumber__c,
																													 NumberOfUnitsColMin__c,
																													 NumberOfUnitsColMax__c,
																													 NumberOfUnitsDealMin__c,
																													 NumberOfUnitsDealMax__c,
																													 DTRResiduals__c,
																													 DTRTrades__c,
																													 ReferenceSerialNumber__c,
																													 SleeperType__c,
																													 EngineMakeHP__c,
																													 Transmission__c,
																													 AxleMakeConfig__c,
																													 PriceLevel__c,
																													 Dealer_Net__c,
																													 Dealer_Net_CAD__c,
																													 Dealer_Net_Disc__c,
																													 Concession_Percent__c,
																													 Disc_Min__c,
																													 Concession_Dollars__c,
																													 Concession_Dollars_CAD__c,
																													 Freight__c,
																													 Freight_CAD__c,
																													 Dealer_Cost__c,
																													 Dealer_Cost_CAD__c,
																													 Dealer_Profit__c,
																													 Dealer_Profit_CAD__c,
																													 Selling_Price__c,
																													 FET_Exempt__c,
																													 FET_Base__c,
																													 FET_Base_12__c,
																													 Less_Tire_Credit__c,
																													 FET__c,
																													 CSD_Warranty__c,
																													 CSD_Warranty_CAD__c,
																													 Engine_Warranty__c,
																													 Engine_Warranty_CAD__c,
																													 Total_Selling_Price__c,
																													 Total_Selling_Price_CAD__c,
																													 Contribution_Calculation__c,
																													 Domicile_Fee__c,
																													 Dealer_PDI__c,
																													 Flooring__c,
																													 Other_Charges__c,
																													 Dealer_Over_Allowance__c,
																													 Dealer_Over_Allowance_CAD__c,
																													 Total_Retail__c,
																													 Base_Model_Retail__c,
																													 F_Total_Dnet__c,
																													 F_Base_Model_Dnet_85__c,
																													 Base_Model_Discount__c,
																													 F_Base_Model_Net_Price__c,
																													 F_Option_Retail__c,
																													 Option_Discount_at_Retail__c,
																													 Option_Discount__c,
																													 Net_Option_Discount__c,
																													 Option_Dnet__c,
																													 F_Net_Price_Before_Adj__c,
																													 F_Effective_Conc__c,
																													 Standard_Concession__c,
																													 Daimler_Latina_Add__c,
																													 DTNA_RSM_Add__c,
																													 Requested_Add__c,
																													 Total_Concession__c,
																													 Reference_Configuration__r.Contribution_Calculation__c,
																													 Approval_Status__c,
																													 (select Id,
																																	 Name,
																																	 Amount__c,
																																	 PricingProposal__c
																														from PricingProposalDynamicLineItem__r),
																														(select Id,
																																		Name,
																																		FEX_Rate__c,
																																		DTR_Split__c,
																																		Dealer_Split__c,
																																		Residual_Type__c,
																																		Residual_Commit_Number__c,
																																		Term_Months__c,
																																		Term_Mileage__c,
																																		Show_Amnt__c,
																																		Show_CAD__c,
																																		Hard_Amnt__c,
																																		Hard_CAD__c,
																																		General_Reserve__c,
																																		General_Reserve_CAD__c,
																																		Specific_Reserve__c,
																																		Specific_Reserve_CAD__c,
																																		fTotal_Reserve__c,
																																		PWV_Value__c,
																																		Rollout_Penalty__c,
																																		Rollout_Penalty_CAD__c,
																																		Mileage_Penalty__c,
																																		Mileage_Penalty_CAD__c,
																																		Pricing_Proposal__c
																														from Outgoing_Residuals_Information__r limit 1)
																							from PricingProposal__c
																							where Opportunity__c =:opportunityId
																							and id not in:proposalIdSet];
	   return pricingProposalList;
	}

	/**
	* Returns a wrapper for PricingProposal__c
	*/
	public static PricingProposalWrapper getPricingProposalWrapper(PricingProposal__c proposal){

		PricingProposalWrapper newPricingProposalWrapper = new PricingProposalWrapper();

		System.debug('#proposal '+proposal);

		newPricingProposalWrapper.id = proposal.id;
		newPricingProposalWrapper.name = proposal.Name;
		newPricingProposalWrapper.baseModel = proposal.BaseModel__c;
		newPricingProposalWrapper.fexRate = proposal.FEX_Rate__c != null?proposal.FEX_Rate__c:1;
		newPricingProposalWrapper.concessionNumber = proposal.ConcessionNumber__c;
		newPricingProposalWrapper.numberOfUnitsColMax = proposal.NumberOfUnitsColMax__c != null? proposal.NumberOfUnitsColMax__c.format(): ' ';
		newPricingProposalWrapper.numberOfUnitsColMin = proposal.NumberOfUnitsColMin__c != null? proposal.NumberOfUnitsColMin__c.format(): '-';
		newPricingProposalWrapper.numberOfUnitsDealMax = proposal.NumberOfUnitsDealMax__c != null? proposal.NumberOfUnitsDealMax__c.format(): '-';
		newPricingProposalWrapper.numberOfUnitsDealMin = proposal.NumberOfUnitsDealMin__c != null? proposal.NumberOfUnitsDealMin__c.format(): '-';
		newPricingProposalWrapper.dtrResiduals = proposal.DTRResiduals__c;
		newPricingProposalWrapper.dtrTrades = proposal.DTRTrades__c;
		newPricingProposalWrapper.referenceSerialNumber = proposal.ReferenceSerialNumber__c!=null?proposal.ReferenceSerialNumber__c:'-';
		newPricingProposalWrapper.sleeperType = proposal.SleeperType__c;
		newPricingProposalWrapper.engineMakeHP = proposal.EngineMakeHP__c;
		newPricingProposalWrapper.transmission = proposal.Transmission__c;
		newPricingProposalWrapper.axleMakeConfig = proposal.AxleMakeConfig__c;
		newPricingProposalWrapper.priceLevel = proposal.PriceLevel__c;
		newPricingProposalWrapper.dealerNet = proposal.Dealer_Net__c != null? proposal.Dealer_Net__c:0;
		newPricingProposalWrapper.dealerNetCAD = proposal.Dealer_Net_CAD__c != null? proposal.Dealer_Net_CAD__c:0;
		newPricingProposalWrapper.dealerNetDisc = proposal.Dealer_Net_Disc__c != null? proposal.Dealer_Net_Disc__c.format():'-';
		newPricingProposalWrapper.concessionPercent = proposal.Concession_Percent__c != null? proposal.Concession_Percent__c.format():'-';
		newPricingProposalWrapper.discMin = proposal.Disc_Min__c != null? proposal.Disc_Min__c.format():'-';
		newPricingProposalWrapper.concessionDollars = proposal.Concession_Dollars__c != null? proposal.Concession_Dollars__c:0;
		newPricingProposalWrapper.concessionDollarsCAD = proposal.Concession_Dollars_CAD__c != null? proposal.Concession_Dollars_CAD__c:0;
		newPricingProposalWrapper.freight = proposal.Freight__c != null? proposal.Freight__c:0;
		newPricingProposalWrapper.freightCAD = proposal.Freight_CAD__c != null? proposal.Freight_CAD__c:0;
		newPricingProposalWrapper.dealerCost = proposal.Dealer_Cost__c != null? proposal.Dealer_Cost__c:0;
		newPricingProposalWrapper.dealerCostCAD = proposal.Dealer_Cost_CAD__c != null? proposal.Dealer_Cost_CAD__c:0;
		newPricingProposalWrapper.dealerProfit = proposal.Dealer_Profit__c != null? proposal.Dealer_Profit__c:0;
		newPricingProposalWrapper.dealerProfitCAD = proposal.Dealer_Profit_CAD__c != null? proposal.Dealer_Profit_CAD__c:0;
		newPricingProposalWrapper.sellingPrice = proposal.Selling_Price__c != null? proposal.Selling_Price__c:0;
		newPricingProposalWrapper.fetExempt = proposal.FET_Exempt__c != null? proposal.FET_Exempt__c:0;
		newPricingProposalWrapper.fetBase = proposal.FET_Base__c != null? proposal.FET_Base__c:0;
		newPricingProposalWrapper.fetBase12Percent = proposal.FET_Base_12__c != null? proposal.FET_Base_12__c:0;
		newPricingProposalWrapper.lessTireCredit = proposal.Less_Tire_Credit__c != null? +proposal.Less_Tire_Credit__c:0;
		newPricingProposalWrapper.fet = proposal.FET__c != null? proposal.FET__c:0;
		newPricingProposalWrapper.csdWarranty = proposal.CSD_Warranty__c != null? proposal.CSD_Warranty__c:0;
		newPricingProposalWrapper.csdWarrantyCAD = proposal.CSD_Warranty_CAD__c != null? proposal.CSD_Warranty_CAD__c:0;
		newPricingProposalWrapper.engineWarrantyVal = proposal.Engine_Warranty__c != null? proposal.Engine_Warranty__c:0;
		newPricingProposalWrapper.engineWarrantyValCAD = proposal.Engine_Warranty_CAD__c != null? proposal.Engine_Warranty_CAD__c:0;
		newPricingProposalWrapper.totalSellingPrice = proposal.Total_Selling_Price__c != null? proposal.Total_Selling_Price__c:0;
		newPricingProposalWrapper.totalSellingPriceCAD = proposal.Total_Selling_Price_CAD__c != null? proposal.Total_Selling_Price_CAD__c:0;
		newPricingProposalWrapper.domicileFee = proposal.Domicile_Fee__c != null? proposal.Domicile_Fee__c:0;
		newPricingProposalWrapper.dealerPDI = proposal.Dealer_PDI__c != null? proposal.Dealer_PDI__c:0;
		newPricingProposalWrapper.flooring = proposal.Flooring__c != null? proposal.Flooring__c:0;
		newPricingProposalWrapper.otherCharges = proposal.Other_Charges__c != null? proposal.Other_Charges__c:0;
		newPricingProposalWrapper.dealerOverAllowance = proposal.Dealer_Over_Allowance__c != null? proposal.Dealer_Over_Allowance__c:0;
		newPricingProposalWrapper.dealerOverAllowanceCAD = proposal.Dealer_Over_Allowance_CAD__c != null? proposal.Dealer_Over_Allowance_CAD__c:0;
		newPricingProposalWrapper.totalRetail = proposal.Total_Retail__c != null? proposal.Total_Retail__c:0;
		newPricingProposalWrapper.baseModelRetail = proposal.Base_Model_Retail__c != null? proposal.Base_Model_Retail__c:0;
		newPricingProposalWrapper.totalDnet = proposal.F_Total_Dnet__c != null? proposal.F_Total_Dnet__c:0;
		newPricingProposalWrapper.baseModelDnet = proposal.F_Base_Model_Dnet_85__c != null? proposal.F_Base_Model_Dnet_85__c:0;
		newPricingProposalWrapper.baseModelDiscount = proposal.Base_Model_Discount__c != null? proposal.Base_Model_Discount__c:0;
		newPricingProposalWrapper.baseModelNetPrice = proposal.F_Base_Model_Net_Price__c != null? proposal.F_Base_Model_Net_Price__c:0;
		newPricingProposalWrapper.optionRetail = proposal.F_Option_Retail__c != null? proposal.F_Option_Retail__c:0;
		newPricingProposalWrapper.optionDiscountAtRetail = proposal.Option_Discount_at_Retail__c != null? proposal.Option_Discount_at_Retail__c:0;
		newPricingProposalWrapper.optionDiscount = proposal.Option_Discount__c != null? proposal.Option_Discount__c:0;
		newPricingProposalWrapper.netOptionDiscount = proposal.Net_Option_Discount__c != null? proposal.Net_Option_Discount__c:0;
		newPricingProposalWrapper.optionDnet = proposal.Option_Dnet__c != null? proposal.Option_Dnet__c:0;
		newPricingProposalWrapper.netPriceBeforeAdj = proposal.F_Net_Price_Before_Adj__c != null? proposal.F_Net_Price_Before_Adj__c:0;
		newPricingProposalWrapper.effectiveConc = proposal.F_Effective_Conc__c != null? proposal.F_Effective_Conc__c:0;
		newPricingProposalWrapper.standardConcession = proposal.Standard_Concession__c != null? proposal.Standard_Concession__c:0;
		newPricingProposalWrapper.daimlerLatinaAdd = proposal.Daimler_Latina_Add__c != null? proposal.Daimler_Latina_Add__c:0;
		newPricingProposalWrapper.dtnaRSMAdd = proposal.DTNA_RSM_Add__c != null? proposal.DTNA_RSM_Add__c:0;
		newPricingProposalWrapper.requestedAdd = proposal.Requested_Add__c != null? proposal.Requested_Add__c:0;
		newPricingProposalWrapper.totalConcession = proposal.Total_Concession__c != null? proposal.Total_Concession__c:0;

		return newPricingProposalWrapper;
	}

	/**
	* Wrapper class for PricingProposal__c
	*/
	public class PricingProposalWrapper{

			public String id {get;set;}
      public String name {get;set;}
			public Double fexRate {get;set;}
      public String baseModel {get;set;}
      public String concessionNumber {get;set;}
      public String numberOfUnitsColMax {get;set;}
      public String numberOfUnitsColMin {get;set;}
      public String numberOfUnitsDealMax {get;set;}
      public String numberOfUnitsDealMin {get;set;}
      public String dtrResiduals {get;set;}
      public String dtrTrades {get;set;}
      public String referenceSerialNumber {get;set;}
      public String sleeperType {get;set;}
      public String engineMakeHP {get;set;}
			public String transmission {get;set;}
			public String axleMakeConfig {get;set;}
			public String priceLevel {get;set;}
			public Double dealerNet {get;set;}
			public Double dealerNetCAD {get;set;}
			public String dealerNetDisc {get;set;}
			public String concessionPercent {get;set;}
			public String discMin {get;set;}
			public Double concessionDollars {get;set;}
			public Double concessionDollarsCAD {get;set;}
			public Double freight {get;set;}
			public Double freightCAD {get;set;}
			public Double dealerCost {get;set;}
			public Double dealerCostCAD {get;set;}
			public Double dealerProfit {get;set;}
			public Double dealerProfitCAD {get;set;}
			public Double sellingPrice {get;set;}
			public Double fetExempt {get;set;}
			public Double fetBase {get;set;}
			public Double fetBase12Percent {get;set;}
			public Double lessTireCredit {get;set;}
			public Double fet{get;set;}
			public Double csdWarranty {get;set;}
			public Double csdWarrantyCAD {get;set;}
			public Double engineWarrantyVal {get;set;}
			public Double engineWarrantyValCAD {get;set;}
			public Double totalSellingPrice {get;set;}
			public Double totalSellingPriceCAD {get;set;}
			public Double domicileFee {get;set;}
			public Double dealerPDI {get;set;}
			public Double flooring {get;set;}
			public Double otherCharges {get;set;}
			public Double dealerOverAllowance {get;set;}
			public Double dealerOverAllowanceCAD {get;set;}
			public Double totalRetail {get;set;}
			public Double baseModelRetail {get;set;}
			public Double totalDnet {get;set;}
			public Double baseModelDnet {get;set;}
			public Double baseModelDiscount {get;set;}
			public Double baseModelNetPrice {get;set;}
			public Double optionRetail {get;set;}
			public Double optionDiscountAtRetail {get;set;}
			public Double optionDiscount {get;set;}
			public Double netOptionDiscount {get;set;}
			public Double optionDnet {get;set;}
			public Double netPriceBeforeAdj {get;set;}
			public Double effectiveConc {get;set;}
			public Double standardConcession {get;set;}
			public Double daimlerLatinaAdd {get;set;}
			public Double dtnaRSMAdd {get;set;}
			public Double requestedAdd {get;set;}
			public Double totalConcession {get;set;}

			public TWSContributionCalculationHandler.ContributionCalculationWrapper contributionCalc {get;set;}
			public TWSOutgoingResidualsInfoHandler.OutgoingResidualsWrapper outgoingResidualsInfo {get;set;}
			public TWSChassisWarrantyHandler.ChassisWarrantyWrapper chassisWarranty {get;set;}
  }

}