@isTest
public class TestDataFactory_Opportunity
{
	public static List<Opportunity> createOpportunitys(Integer Int_numOpt, String TestOpportunityName, String Str_LeadConcNo)
    {
        List<Opportunity> list_OpportunityObj = new List<Opportunity>();
        
        for(Integer i=1;i<=Int_numOpt;i++)
        {
            Opportunity obj_Opportunity = new Opportunity (Name=TestOpportunityName + i,
                                                           StageName = 'New', 
                                                           LEAD_CONC_NO__c = Str_LeadConcNo, 
                                                           CloseDate = Date.today() +1);

            list_OpportunityObj.add(obj_Opportunity);
        }
        insert list_OpportunityObj;
        return list_OpportunityObj;
    }
}