/*
05/07/2015 Created by Anto Nirmal for updating the Lead Concension Lookup up relationship field
*/

trigger DTNA_Concession_Update on Opportunity (before update,after insert) 
{
    List<String> Lst_Str_LeadConcession = new List<String>();
    Map<String,String> map_LeadConcession = new Map<String,String>();

    for(Opportunity LeadConcession: Trigger.new)
    {
        if(LeadConcession.Name != LeadConcession.LEAD_CONC_NO__c)
            lst_Str_LeadConcession.add(LeadConcession.LEAD_CONC_NO__c);
    }

    if(!lst_Str_LeadConcession.isEmpty())
    {
        for(Opportunity LeadMap: [Select Name,Id From Opportunity where Name in :lst_Str_LeadConcession])
            map_LeadConcession.put(LeadMap.Name,LeadMap.Id);
        
        if (Trigger.isInsert)
        {
            System.debug('Insert');
            List<Opportunity> lst_Concession =  [select Id,Name,LEAD_CONC_NO__c,LeadConcession__c from Opportunity 
                                                 where Id IN :Trigger.new];
            for(Opportunity LeadConcession: lst_Concession)
            {
                if(LeadConcession.Name != LeadConcession.LEAD_CONC_NO__c)
                { 
                    LeadConcession.LeadConcession__c = map_LeadConcession.get(LeadConcession.LEAD_CONC_NO__c);
                }
            }
            update (lst_Concession);
            System.debug('Lead' + Lst_Str_LeadConcession);
            System.debug('Map' + map_LeadConcession);
            System.debug('ListConcession' + lst_Concession);
        }
        
        if (Trigger.isUpdate)
        {   
            System.debug('Update');
            for(Opportunity LeadConcession: Trigger.new)
            {
                if(LeadConcession.Name != LeadConcession.LEAD_CONC_NO__c)
                {                    
                    LeadConcession.LeadConcession__c = map_LeadConcession.get(LeadConcession.LEAD_CONC_NO__c);
                    System.debug(LeadConcession.LeadConcession__c);
                }
            }
            System.debug('Lead' + Lst_Str_LeadConcession);
            System.debug('Map' + map_LeadConcession);
        }
    }
}