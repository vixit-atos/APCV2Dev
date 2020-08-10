public with sharing class TWSFooterHandler {

	public static List<FooterWrapper> getFooterWrapperList(Id opportunityId){

		List<FooterWrapper> footerWrapperList = new List<FooterWrapper>();

		List<Footer__c> footerList = getFooterList(opportunityId);

		for (Footer__c iter: footerList){

			FooterWrapper newFooterWrapper = new FooterWrapper();

			newFooterWrapper.title = iter.Title__c!= null? iter.Title__c: '';
			newFooterWrapper.body = iter.Body__c != null? iter.Body__c: '';
			newFooterWrapper.type = iter.RecordType.Name;
			newFooterWrapper.rmsBasePeriod = iter.RMS_Base_Period__c != null? iter.RMS_Base_Period__c: '';
			newFooterWrapper.rmsEffectiveDate = iter.RMS_Effective_Date__c != null? iter.RMS_Effective_Date__c.format(): '';
			newFooterWrapper.peSubTotalCustomer1 = iter.PE_TotalCustomer1__c != null? iter.PE_TotalCustomer1__c: 0;
			newFooterWrapper.peSubTotalCustomer2 = iter.PE_TotalCustomer2__c != null? iter.PE_TotalCustomer2__c: 0;
			newFooterWrapper.peSubTotalTarget1 = iter.PE_TotalTarget1__c != null? iter.PE_TotalTarget1__c: 0;
			newFooterWrapper.peSubTotalTarget2 = iter.PE_TotalTarget2__c != null? iter.PE_TotalTarget2__c: 0;
			newFooterWrapper.peTotalTarget = iter.PE_TotalTarget__c != null? iter.PE_TotalTarget__c: 0;
			newFooterWrapper.peTotalCustomer = iter.PE_TotalCustomer__c != null? iter.PE_TotalCustomer__c: 0;
			newFooterWrapper.peRatio = iter.PE_Ratio__c != null? iter.PE_Ratio__c: 0;

			newFooterWrapper.lineItemKeySet = new Map<Decimal, Set<String>>();
			newFooterWrapper.valuesPerType = new Map<String, Map<String, String>>();

			for (Footer_Line_Item__c lineItem: iter.Footer_Line_Items__r){

				if (lineItem.Column__c == null){
					lineItem.Column__c = 0;
				}

				if(newFooterWrapper.lineItemKeySet.get(lineItem.Column__c) == null){
					newFooterWrapper.lineItemKeySet.put(lineItem.Column__c, new Set<String>());
				}
				newFooterWrapper.lineItemKeySet.get(lineItem.Column__c).add(lineItem.name);

				if (lineItem.Type__c == null){
					lineItem.Type__c = 'default';
				}

				if (newFooterWrapper.valuesPerType.get(lineItem.Type__c) == null){
					newFooterWrapper.valuesPerType.put(lineItem.Type__c, new Map<String, String>());
				}

				String value = lineItem.Value__c != null? lineItem.Value__c: '';

				if (lineItem.Currency_Value__c != null){
					value = String.valueOf(lineItem.Currency_Value__c);
				}

				newFooterWrapper.valuesPerType.get(lineItem.Type__c).put(lineItem.name, value);
			}

			footerWrapperList.add(newFooterWrapper);
		}

		return footerWrapperList;
	}

	public static List<Footer__c> getFooterList(Id opportunityId){

		List<Footer__c> footerList = [
			select id,
						Title__c,
						Body__c,
						RecordType.Name,
						RMS_Base_Period__c,
						RMS_Effective_Date__c,
						PE_TotalCustomer1__c,
						PE_TotalCustomer2__c,
						PE_TotalTarget1__c,
						PE_TotalTarget2__c,
						PE_TotalCustomer__c,
						PE_TotalTarget__c,
						PE_Ratio__c,
						(select id, Footer__c, Name, Value__c, Currency_Value__c, Type__c, Column__c from Footer_Line_Items__r)
			from Footer__c
			where Opportunity__c =:opportunityId
			order by View_Order__c
		];

		return footerList;
	}

	public class FooterWrapper{

		public String type {get;set;}
		public String title {get;set;}
		public String body {get;set;}
		public String rmsBasePeriod {get;set;}
		public String rmsEffectiveDate {get;set;}
		public Double peSubTotalCustomer1 {get;set;}
		public Double peSubTotalCustomer2 {get;set;}
		public Double peSubTotalTarget1 {get;set;}
		public Double peSubTotalTarget2 {get;set;}
		public Double peTotalTarget {get;set;}
		public Double peTotalCustomer {get;set;}
		public Double peRatio {get;set;}

		//Map<columnNumber, Set<Label>>
		public Map<Decimal, Set<String>> lineItemKeySet {get;set;}

		//Map<Type, Map<Label, Value>>
		public Map<String, Map<String, String>> valuesPerType {get;set;}
	}
}