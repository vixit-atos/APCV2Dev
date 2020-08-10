public with sharing class Deal_Meeting_AssociationTriggerHandler extends TriggerHandler {
	public Deal_Meeting_AssociationTriggerHandler() {}

	protected override void beforeDelete() {
	
		Opportunity [] oList = new List<Opportunity>();

		for (Deal_Meeting_Association__c dma : (List<Deal_Meeting_Association__c>) Trigger.old) {
            if (dma.TWS_TC_Deal__c != null) {


                Opportunity o = [select id, TC_Meeting__c from Opportunity where id = :dma.TWS_TC_Deal__c];
                o.TC_Meeting__c = null;
                o.StageName = 'Ready for TCM';
 
                oList.add(o);
            }
        }

       	if (oList.size()>0) update oList;

	}
}