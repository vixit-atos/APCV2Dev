@isTest

public Class UnlockRecordRequest_Test
{
    static testMethod void TestProcess()
    {
        Test.startTest();

        List<Concession__c> lst_sObj = [select Id from Concession__C order by In_Approval_Process__c desc limit 20];

        List<Id> lstIds = new List<Id>();
        for(Concession__c Conc: lst_sObj)
        {
            lstIds.add(Conc.Id);
        }

        UnlockRecordRequest.UnlockRecordRequest(lstIds);        
        
        Test.StopTest();
    }
}