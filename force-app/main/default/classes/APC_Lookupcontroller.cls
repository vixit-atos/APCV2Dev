/* 	
 * FileName		:	APC_Lookupcontroller.apxc
 * Developer	:	Chandrika Gandepalli
*/ 

public with sharing class APC_Lookupcontroller {
    @AuraEnabled
    public static List<Account> fetchAccount(String searchKeyWord) {
        List<Account> returnList = new List <Account> ();
        for(Account acc: [select id, Name,Dealer_Code__c from Account where Dealer_Code__c LIKE: searchKeyWord + '%']) {
            returnList.add(acc);
        }
        return returnList;
    }
    
    @AuraEnabled
    public static List<String> fetchContacts(String dealerCode) {
         List<String> contactsreturn = new List<String>();
        //contactsreturn.add('--select--');
        for(Contact cnt:  [select id, Name,FirstName,LastName from Contact where Dealer_Code__c = : dealerCode and active__c = true]) {
            //returnList.add(cnt);
            contactsreturn.add(cnt.Name);
        }
        System.debug('contactsreturn==>'+contactsreturn);
        return contactsreturn;
    }
    
    @AuraEnabled
    public static List<Contact> fetchcontactslist(String dealerCode) {
         List<Contact> contactsreturn = new List<Contact>();
        contactsreturn =  [select id, Name,FirstName,LastName, Email from Contact where accountid = : dealerCode and active__c = true];
        //contactsreturn.add('--select--');
        //for(Contact cnt:  [select id, Name,FirstName,LastName from Contact where Dealer_Code__c = : dealerCode]) {
            //returnList.add(cnt);
           // contactsreturn.add(cnt.Name);
       // }
        System.debug('contactsreturn==>'+contactsreturn);
        return contactsreturn;
    }
    
}