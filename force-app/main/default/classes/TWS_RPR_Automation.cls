global class TWS_RPR_Automation {
	
	public void setRPR() {


		
		Set<String> concIdSet = new Set<String>();
		Map<String,ID> concOppMap = new Map<string,ID>();
		Map<String,Boolean> oppStatusMap = new Map<String,Boolean>();


		//find all pricing proposals that are published 

		PricingProposal__c [] ppl = [
		select 
			id, 
			ConcessionNumber__c, 
			Opportunity__c, 
			Opportunity__r.StageName 
		from 
			PricingProposal__c 
		where 
			PricingProposal__c.ConcessionNumber__c != null and 
			Opportunity__r.StageName = 'Published' and 
			Reference_Configuration__c != null
			];

		for (PricingProposal__c pp : ppl ) {
			
			System.debug(LoggingLevel.DEBUG, 'Looking at pp:' + PP.ConcessionNumber__c);

			concIdSet.add(pp.ConcessionNumber__c);
			concOppMap.put(pp.ConcessionNumber__c,pp.Opportunity__c);
			oppStatusMap.put(pp.Opportunity__c,True);

		}


		//find all the concessions backing the pricing proposals

		ID oppId;

		if (concIdSet.size()>0) {
			Concession__c [] cl  = [select CONC_STATUS_CD__c, Name from Concession__c where Name in:concIdSet ];
			
			Map<string, TWS_RPR_Complete_Statuses__c> vcs = TWS_RPR_Complete_Statuses__c.getAll();
			
			for  (Concession__c c : cl) {
				System.debug(LoggingLevel.DEBUG, 'processing concession:' + c.Name + 'containsKey' + vcs.containsKey(c.CONC_STATUS_CD__c) 

					+ 'Key:' + c.CONC_STATUS_CD__c);




				oppId = concOppMap.get(c.Name);
				oppStatusMap.put(oppId, oppStatusMap.get(oppId) &&  vcs.containsKey(c.CONC_STATUS_CD__c));

			}

		}

		//now we need to figure out which opportunies we need to update

		for(Id i: oppStatusMap.keySet()) {
			if (oppStatusMap.get(i) == false) oppStatusMap.remove(i);
		}

		Opportunity [] ol  = [select id, StageName, Name from opportunity where id in:oppStatusMap.keyset()];

		for (Opportunity o: ol) {

			System.debug(LoggingLevel.DEBUG, 'Updating' + o.name);
			o.StageName = 'RPR Concession / Complete';
		}

		upsert ol;

	}

}