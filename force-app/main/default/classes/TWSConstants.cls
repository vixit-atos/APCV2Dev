public with sharing class TWSConstants {

	//Map<DeveloperName, Id>
	private static Map<String, Id> pricingProposalRecordTypeMap;

	//Map<DeveloperName, Id>
	private static Map<String, Id> opportunityRecordTypeMap;

	public static Map<String, Id> getPricingProposalRecordTypeMap(){

			if (pricingProposalRecordTypeMap == null){

				pricingProposalRecordTypeMap = new Map<String, Id>();

				List<RecordType> recordTypeList = [select Id, DeveloperName from RecordType where sObjectType='PricingProposal__c'];

				for (RecordType iter: recordTypeList){
					pricingProposalRecordTypeMap.put(iter.DeveloperName, iter.Id);
				}
			}

			return pricingProposalRecordTypeMap;
	}

	public static Map<String, Id> getOpportunityRecordTypeMap(){

			if (opportunityRecordTypeMap == null){

				opportunityRecordTypeMap = new Map<String, Id>();

				List<RecordType> recordTypeList = [select Id, DeveloperName from RecordType where sObjectType='Opportunity'];

				System.debug('#recordTypeList '+recordTypeList);

				for (RecordType iter: recordTypeList){
					opportunityRecordTypeMap.put(iter.DeveloperName, iter.Id);
				}
			}

			return opportunityRecordTypeMap;
	}

}