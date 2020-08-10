@isTest

public class APC_Lookupcontrollertest {

    public static testmethod void fetchAccount_test()
    {
        Account ac = new Account(name ='CDCD Account', Dealer_Code__c = 'CDCD') ;
        insert ac; 
        Account ac1 = new Account(name ='YFFD Account', Dealer_Code__c = 'YFFD') ;
        insert ac1;
        
        Contact con = new Contact(LastName ='CDCD User1',AccountId = ac.Id);
        insert con;  
        
        APC_Lookupcontroller.fetchAccount('CDCD');
        APC_Lookupcontroller.fetchContacts('CDCD');
        APC_Lookupcontroller.fetchcontactslist('CDCD');
    }
    
}