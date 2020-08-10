public with sharing class TWSOutgoingResidualsInfoHandler {

	/**
	* Returns a Wrapper for the Outgoing_Residuals_Info__c
	*/
	public static OutgoingResidualsWrapper getOutgoingResidualsInfoWrapper(Outgoing_Residuals_Info__c outgoingResidualsInfo){

		OutgoingResidualsWrapper newOutgoingResidualsWrapper = new OutgoingResidualsWrapper();

		newOutgoingResidualsWrapper.id = outgoingResidualsInfo.id;
		newOutgoingResidualsWrapper.dtrSplit = outgoingResidualsInfo.DTR_Split__c;
		newOutgoingResidualsWrapper.dealerSplit = outgoingResidualsInfo.Dealer_Split__c;
		newOutgoingResidualsWrapper.residualType = outgoingResidualsInfo.Residual_Type__c;
		newOutgoingResidualsWrapper.residualCommitNumber = outgoingResidualsInfo.Residual_Commit_Number__c;
		newOutgoingResidualsWrapper.termMonths = outgoingResidualsInfo.Term_Months__c;
		newOutgoingResidualsWrapper.termMileage = outgoingResidualsInfo.Term_Mileage__c;
		newOutgoingResidualsWrapper.showAmount = outgoingResidualsInfo.Show_Amnt__c;
		newOutgoingResidualsWrapper.showAmountCAD = outgoingResidualsInfo.Show_CAD__c!=null ? outgoingResidualsInfo.Show_CAD__c:0;
		newOutgoingResidualsWrapper.hardAmount = outgoingResidualsInfo.Hard_Amnt__c;
		newOutgoingResidualsWrapper.hardAmountCAD = outgoingResidualsInfo.Hard_CAD__c!=null ? outgoingResidualsInfo.Hard_CAD__c:0;
		newOutgoingResidualsWrapper.generalReserve = outgoingResidualsInfo.General_Reserve__c;
		newOutgoingResidualsWrapper.generalReserveCAD = outgoingResidualsInfo.General_Reserve_CAD__c != null? outgoingResidualsInfo.General_Reserve_CAD__c:0;
		newOutgoingResidualsWrapper.specificReserve = outgoingResidualsInfo.Specific_Reserve__c;
		newOutgoingResidualsWrapper.specificReserveCAD = outgoingResidualsInfo.Specific_Reserve_CAD__c != null ? outgoingResidualsInfo.Specific_Reserve_CAD__c:0;
		newOutgoingResidualsWrapper.totalReserve = outgoingResidualsInfo.fTotal_Reserve__c;
		newOutgoingResidualsWrapper.pWVValue = outgoingResidualsInfo.PWV_Value__c!=null?outgoingResidualsInfo.PWV_Value__c:0;
		newOutgoingResidualsWrapper.rolloutPenalty = outgoingResidualsInfo.Rollout_Penalty__c;
		newOutgoingResidualsWrapper.rolloutPenaltyCAD = outgoingResidualsInfo.Rollout_Penalty_CAD__c != null ? outgoingResidualsInfo.Rollout_Penalty_CAD__c:0;
		newOutgoingResidualsWrapper.mileagePenalty = outgoingResidualsInfo.Mileage_Penalty__c;
		newOutgoingResidualsWrapper.mileagePenaltyCAD = outgoingResidualsInfo.Mileage_Penalty_CAD__c != null?outgoingResidualsInfo.Mileage_Penalty_CAD__c:0;
		newOutgoingResidualsWrapper.fexRate = outgoingResidualsInfo.FEX_Rate__c != null ? outgoingResidualsInfo.FEX_Rate__c:0;

		return newOutgoingResidualsWrapper;
	}

	/**
	* Wrapper Class for Outgoing_Residuals_Info__c
	*/
	public class OutgoingResidualsWrapper{

		public String id {get;set;}
		public Double fexRate {get;set;}
		public Double dtrSplit {get;set;}
		public Double dealerSplit {get;set;}
		public String residualType {get;set;}
		public String residualCommitNumber {get;set;}
		public String termMonths {get;set;}
		public Double termMileage {get;set;}
		public Double showAmount {get;set;}
		public Double showAmountCAD {get;set;}
		public Double hardAmount {get;set;}
		public Double hardAmountCAD {get;set;}
		public Double generalReserve {get;set;}
		public Double generalReserveCAD {get;set;}
		public Double specificReserve {get;set;}
		public Double specificReserveCAD {get;set;}
		public Double totalReserve {get;set;}
		public Double pWVValue {get;set;}
		public Double rolloutPenalty {get;set;}
		public Double rolloutPenaltyCAD {get;set;}
		public Double mileagePenalty {get;set;}
		public Double mileagePenaltyCAD {get;set;}
	}
}