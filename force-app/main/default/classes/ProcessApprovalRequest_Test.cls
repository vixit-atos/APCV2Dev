@isTest(SeeAllData=true)

public Class ProcessApprovalRequest_Test
{
    static testMethod void TestProcess()
    {
        Test.startTest();

        List<Concession__c> lst_sObj_Con = [select Id from Concession__C where ID in (Select TargetObjectId From ProcessInstance Where Status = 'Pending') limit 20];
		List<Campaign_Initiator__C> lst_sObj_CI = [select Id from Campaign_Initiator__C where ID in (Select TargetObjectId From ProcessInstance Where Status = 'Pending') limit 20];

        List<Id> lstIds = new List<Id>();
        for(Concession__c Conc: lst_sObj_Con)
        {
            lstIds.add(Conc.Id);
        }
        
        for(Campaign_Initiator__C CI: lst_sObj_CI)
        {
            lstIds.add(CI.Id);
        }

        ProcessApprovalRequest.invokeApproveProcessApprovalRequest(lstIds);        
        
        Test.StopTest();
    }
}