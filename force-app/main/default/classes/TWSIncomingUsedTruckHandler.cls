public with sharing class TWSIncomingUsedTruckHandler {

	public static List<IncomingUsedTruckWrapper> getIncomingUsedTruckWrapperList(Id opportunityId){

		List<IncomingUsedTruckWrapper> incomingUsedTrackWrapperList = new List<IncomingUsedTruckWrapper>();

		List<Incoming_Used_Truck_Information__c> incomingUsedTrackList = getIncomingUsedTruckList(opportunityId);

		for (Incoming_Used_Truck_Information__c iter: incomingUsedTrackList){

			IncomingUsedTruckWrapper newIncomingUsedTruckWrapper = new IncomingUsedTruckWrapper();

			newIncomingUsedTruckWrapper.id = iter.id;
			newIncomingUsedTruckWrapper.name = iter.name != null? iter.name: '';
			newIncomingUsedTruckWrapper.dtrParticipation = iter.Did_DTR_Participate__c != null? iter.Did_DTR_Participate__c: '';
			newIncomingUsedTruckWrapper.dtrNumber = iter.DTR__c != null? iter.DTR__c: 0;
			newIncomingUsedTruckWrapper.dlrNumber = iter.DLR__c != null? iter.DLR__c: 0;
			newIncomingUsedTruckWrapper.totalTrades = iter.Total_Trades__c != null? iter.Total_Trades__c: 0;
			newIncomingUsedTruckWrapper.mileage = iter.Mileage__c != null? iter.Mileage__c: 0;
			newIncomingUsedTruckWrapper.rollout = iter.Rollout__c != null? iter.Rollout__c: 0;
			newIncomingUsedTruckWrapper.rolloutCAD = iter.Rollout_CAD__c != null? iter.Rollout_CAD__c: 0;
			newIncomingUsedTruckWrapper.mileagePenalty = iter.Mileage_Penalty__c != null? iter.Mileage_Penalty__c: 0;
			newIncomingUsedTruckWrapper.mileagePenaltyCAD = iter.Mileage_Penalty_CAD__c != null? iter.Mileage_Penalty_CAD__c: 0;
			newIncomingUsedTruckWrapper.totalDTNAOARequired = iter.Total_DTNA_OA_Required__c != null? iter.Total_DTNA_OA_Required__c: 0;
			newIncomingUsedTruckWrapper.totalCountOfNew = iter.Total_Count_of_New__c != null? iter.Total_Count_of_New__c: 0;
			newIncomingUsedTruckWrapper.oaRequiredPerNew = iter.OA_Required_Per_New__c != null? iter.OA_Required_Per_New__c: 0;
			newIncomingUsedTruckWrapper.oaRequiredPerNewCAD = iter.O_A_Required_Per_New_CAD__c != null? iter.O_A_Required_Per_New_CAD__c: 0;
			newIncomingUsedTruckWrapper.previousDeal = iter.Previous_Deal__c != null? iter.Previous_Deal__c: false;

			newIncomingUsedTruckWrapper.incomingUsedTruckItems = new List<IncomingUsedTruckItem>();

			for (IncomingUsedTruckLineItem__c lineItem: iter.IncomingUsedTruckLineItem__r){

				IncomingUsedTruckItem newIncomingUsedTruckItem = new IncomingUsedTruckItem();

				newIncomingUsedTruckItem.trGR = lineItem.TR_GR__c != null?lineItem.TR_GR__c:'';
				newIncomingUsedTruckItem.agreementNumber = lineItem.Agreement_Number__c != null?lineItem.Agreement_Number__c:'';
				newIncomingUsedTruckItem.qty = lineItem.QTY__c != null?lineItem.QTY__c:0;
				newIncomingUsedTruckItem.yearMake = lineItem.Year_Make__c != null?lineItem.Year_Make__c:'';
				newIncomingUsedTruckItem.modelSleeperEngine = lineItem.Model_Sleeper_Engine__c != null?lineItem.Model_Sleeper_Engine__c:'';
				newIncomingUsedTruckItem.showDollars = lineItem.Show_Dollars__c != null?lineItem.Show_Dollars__c:0;
				newIncomingUsedTruckItem.showDollarsCAD = lineItem.Show_Dollars_CAD__c != null?lineItem.Show_Dollars_CAD__c:0;
				newIncomingUsedTruckItem.hardDollars = lineItem.Hard_Dollars__c != null?lineItem.Hard_Dollars__c:0;
				newIncomingUsedTruckItem.hardDollarsCAD = lineItem.Hard_Dollars_CAD__c != null?lineItem.Hard_Dollars_CAD__c:0;
				newIncomingUsedTruckItem.perUnitOA = lineItem.fPer_Unit_OA__c != null?lineItem.fPer_Unit_OA__c:0;
				newIncomingUsedTruckItem.totalDTNAOARequired = lineItem.fTotal_DTNA_OA_Required__c != null?lineItem.fTotal_DTNA_OA_Required__c:0;
				newIncomingUsedTruckItem.mileageBand = lineItem.Mileage_Band__c != null?lineItem.Mileage_Band__c:'';
				newIncomingUsedTruckItem.quarterTurnIn = lineItem.Quarter_Turn_In__c != null?lineItem.Quarter_Turn_In__c:'';

				newIncomingUsedTruckWrapper.incomingUsedTruckItems.add(newIncomingUsedTruckItem);
			}

			newIncomingUsedTruckWrapper.comments = '';

			for(Incoming_Used_Truck_Comment__c comment: iter.Incoming_Used_Truck_Comments__r){
				newIncomingUsedTruckWrapper.comments += comment.Body__c;
			}

			incomingUsedTrackWrapperList.add(newIncomingUsedTruckWrapper);
		}

		return incomingUsedTrackWrapperList;
	}

	public static List<Incoming_Used_Truck_Information__c> getIncomingUsedTruckList(Id opportunityId){

		List<Incoming_Used_Truck_Information__c> incomingUsedTruckList = [
			select id,
						 Name,
						 Did_DTR_Participate__c,
						 DTR__c,
						 DLR__c,
						 Total_Trades__c,
						 Mileage__c,
						 Rollout__c,
						 Rollout_CAD__c,
						 Mileage_Penalty__c,
						 Mileage_Penalty_CAD__c,
						 Total_DTNA_OA_Required__c,
						 Total_Count_of_New__c,
						 OA_Required_Per_New__c,
						 O_A_Required_Per_New_CAD__c,
						 Previous_Deal__c,
						 (select id,
						 				 Name,
						 				 TR_GR__c,
										 Agreement_Number__c,
										 QTY__c,
										 Year_Make__c,
										 Model_Sleeper_Engine__c,
										 Show_Dollars__c,
										 Show_Dollars_CAD__c,
										 Hard_Dollars__c,
										 Hard_Dollars_CAD__c,
										 fPer_Unit_OA__c,
										 fTotal_DTNA_OA_Required__c,
										 IncomingUsedTruck__c,
										 Mileage_Band__c,
										 Quarter_Turn_In__c
							from IncomingUsedTruckLineItem__r order by Agreement_Number__c),
							(select id,
											Name,
											Incoming_Used_Truck_Information__c,
											Body__c
							from Incoming_Used_Truck_Comments__r)
			from Incoming_Used_Truck_Information__c
			where Opportunity__c =:	opportunityId
			order by Previous_Deal__c desc
		];

		return incomingUsedTruckList;
	}

	public class IncomingUsedTruckWrapper{

		public String id {get;set;}
		public String name {get;set;}
		public String dtrParticipation {get;set;}
		public Double dtrNumber {get;set;}
		public Double dlrNumber {get;set;}
		public Double totalTrades {get;set;}
		public Double mileage {get;set;}
		public Double rollout {get;set;}
		public Double rolloutCAD {get;set;}
		public Double mileagePenalty {get;set;}
		public Double mileagePenaltyCAD {get;set;}
		public Double totalDTNAOARequired {get;set;}
		public Double totalCountOfNew {get;set;}
		public Double oaRequiredPerNew {get;set;}
		public Double oaRequiredPerNewCAD {get;set;}
		public Boolean previousDeal {get;set;}

		public String comments {get;set;}
		public List<IncomingUsedTruckItem> incomingUsedTruckItems {get;set;}
	}

	public class IncomingUsedTruckItem{

		public String trGR {get;set;}
		public String agreementNumber {get;set;}
		public Double qty {get;set;}
		public String yearMake {get;set;}
		public String modelSleeperEngine {get;set;}
		public Double showDollars {get;set;}
		public Double showDollarsCAD {get;set;}
		public Double hardDollars {get;set;}
		public Double hardDollarsCAD {get;set;}
		public Double perUnitOA {get;set;}
		public Double totalDTNAOARequired {get;set;}
		public String mileageBand {get;set;}
		public String quarterTurnIn {get;set;}
	}
}