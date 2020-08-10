public without sharing class UnlockRecordRequest 
{
    @InvocableMethod(label='Unlock Record Request' description='Unlock Provided Record')
    public static void UnlockRecordRequest (List<Id> lstIds) 
    {
        System.debug(Approval.Unlock(lstIds));
    }
}