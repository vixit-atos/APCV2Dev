@isTest
public class TestDataFactory_Account 
{
	public static List<Account> createAccounts(Integer Int_numAccts, String TestAccountName) 
    {
        List<Account> list_AccountObj = new List<Account>();
        
        for(Integer i=1;i<=Int_numAccts;i++) 
        {
            Account obj_Account = new Account(Name=TestAccountName + i,Dealer_Code__c=TestAccountName + i);
            list_AccountObj.add(obj_Account);
        }        
        insert list_AccountObj;
        return list_AccountObj;
    }
}