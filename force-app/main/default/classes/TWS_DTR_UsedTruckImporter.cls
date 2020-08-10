public with sharing class TWS_DTR_UsedTruckImporter {

	//need trade quote #
	//and opportunity id

	public  Incoming_Used_Truck_Information__c iuti { get; set;}


	Map<string, Map<string, List<string>>> importMap;
	List<IncomingUsedTruckLineItem__c> incomingTruckList;
	String currencyISOStr = 'USD';

	public TWS_DTR_UsedTruckImporter(ApexPages.StandardController stdController) {




		String opp = ApexPages.currentPage().getParameters().get('parent');

		//let's figure out the currency
		Opportunity o = [select  RecordTypeId from Opportunity where id = :opp];
		RecordType  rt = [select DeveloperName from RecordType where id = :o.RecordTypeId];

		if (rt.DeveloperName == 'TWS_TC_Canadian_Deal' ) currencyISOStr = 'CAD';


		System.debug(ApexPages.currentPage().getParameters().keySet());

		iuti = new Incoming_Used_Truck_Information__c(Opportunity__c = opp);
		importMap = new Map<string, Map<string, List<string>>>();
		incomingTruckList = new List<IncomingUsedTruckLineItem__c>();
	}


	void importTrucks() {

		Map<string, List<string>> currMap;
		String base = TWS_OData_URLs__c.getInstance('url_base').URL__c;
		String url;



		url = base + TWS_OData_URLs__c.getInstance('TradeQuoteSpecs').URL__c;
		url = url.Replace('{{quote_no}}', iuti.Agreement__c);

		ODataUtils.fillMap(ODataUtils.getOdata(url),importMap, new String [] {'QuoteNumber','QuoteGroup'});

		url = base + TWS_OData_URLs__c.getInstance('TradeQuoteValues').URL__c;
		url = url.Replace('{{quote_no}}', iuti.Agreement__c);

		ODataUtils.fillMap(ODataUtils.getOdata(url),importMap, new String [] {'QuoteNumber','QuoteGroup'});
		

		//ODataUtils.print(importList);

	}

	public PageReference save() {

		importTrucks();

		Decimal mp, roll;

		Set<Decimal> mps = new Set<Decimal>();
		Set<Decimal> rolls = new Set<Decimal>();


		insert iuti;



		for (Map<string, List<string>> m: importMap.values()) {

			mp = m.get('HardAdjustPerMile')[1] == null || m.get('HardAdjustPerMile')[1] == ''?null:Decimal.valueOf(m.get('HardAdjustPerMile')[1]);
			roll = m.get('HardRolloutAmount')[1] == null || m.get('HardRolloutAmount')[1] == ''?null:Decimal.valueOf(m.get('HardRolloutAmount')[1]);

			mps.add(mp);
			rolls.add(roll);

			IncomingUsedTruckLineItem__c li = new IncomingUsedTruckLineItem__c(
				//CurrencyISOCode = currencyISOStr,
				IncomingUsedTruck__c = iuti.id,
				TR_GR__c = 'TR',
				Agreement_Number__c = iuti.Agreement__c + '('+m.get('QuoteGroup')[1]+')',

				QTY__c = m.get('Quantity')[1] == null || m.get('Quantity')[1] == ''  ? null: Decimal.valueOf(m.get('Quantity')[1]),
				Year_Make__c = m.get('Year')[1] + '/' + m.get('Make')[1],
				Model_Sleeper_Engine__c = m.get('Model')[1] + '/' +
					m.get('SleeperSize')[1]+m.get('Cab')[1] + '/' +
					m.get('EngineModel')[1],
				Mileage_Penalty__c = mp,
				Rollout__c = roll

				);
			li.Name = li.Year_Make__c ;

			if (li.Name.length()>1)
			incomingTruckList.add(li);
		}



		insert incomingTruckList;

		System.Debug('MPS: ' + mps + ' ROLLS: ' + rolls);

		if (mps.size() == 1) iuti.Mileage_Penalty__c = (new List<Decimal>(mps))[0];
		if (rolls.size() == 1) iuti.Rollout__c =  (new List<Decimal>(rolls))[0];

		update iuti;

		//insert pricingproposal;
		return new ApexPages.StandardController(iuti).view();

	}

	public PageReference cancel() {

		return new PageReference('/' + iuti.Opportunity__c);

	}



}