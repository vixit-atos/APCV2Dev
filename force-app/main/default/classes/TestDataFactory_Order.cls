@isTest
public class TestDataFactory_Order 
{
	public static List<Order> createOrders(Integer Int_numOrd, String Str_TestOrderName, String Str_ConcNumber)
    {
        List<Order> list_OrderObj = new List<Order>();
        List<Account> List_Accounts = TestDataFactory_Account.createAccounts(1,'OrdTstAcc'+Str_TestOrderName);
        system.debug(List_Accounts[0]);
        system.debug(List_Accounts[0].Id);
        for(Integer i=1;i<=Int_numOrd;i++)
        {
            Order obj_Order = new Order (Account = List_Accounts[0],
                                         AccountId = List_Accounts[0].Id,
                                         Name = Str_TestOrderName+i,
                                         Status = 'Draft',
                                         VEH_SER_NO__c = Str_TestOrderName+i,
                                         CONC_NO__c = Str_ConcNumber,
                                         EffectiveDate = Date.today());
			list_OrderObj.add(obj_Order);
        }
        
        insert list_OrderObj;
        return list_OrderObj;
    }
}