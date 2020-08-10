@isTest
public class MDMAddressToAccountAddressSynch_Test {
    
   
    static MDM_Address__c addr = new MDM_Address__c();
    static Account a = new Account(Name='Test Account');
    
    static {
    	
        
        
        insert a;
        
        addr.Account__c = a.Id;
        addr.Address_Line_1__c = 'Line 1';
        addr.Address_Line_2__c = 'Line 2';
        addr.City__c = 'City';
        addr.Country__c = 'Country';
        
        insert addr;
        
    }
  
    
    
    static testMethod void validateMailingAddressSynch(){
        
        MDMAddressToAccountAddressSynch.synchAddress(addr.Id, 'Mailing');
		
  	    a = [select 
                               		BillingCity,
                               		BillingCountry,
                               		BillingPostalCode,
                               		BillingState,
                               		BillingStreet, 
                               		 
                               		ShippingCity,
                               		ShippingCountry,
                               		ShippingPostalCode,
                               		ShippingState,
                               		ShippingStreet

                               		

                               from Account 
                               where ID=:a.Id];
        System.assertEquals(addr.Address_Line_1__c, a.BillingStreet);
    }
    
    static testMethod void validatePhysicalAddressSynch(){
        
        MDMAddressToAccountAddressSynch.synchAddress(addr.Id, 'Physical');
        
          	    a = [select 
                               		BillingCity,
                               		BillingCountry,
                               		BillingPostalCode,
                               		BillingState,
                               		BillingStreet, 
                               		 
                               		ShippingCity,
                               		ShippingCountry,
                               		ShippingPostalCode,
                               		ShippingState,
                               		ShippingStreet

                               		

                               from Account 
                               where ID=:a.Id];
        
        
        System.assertEquals(addr.Address_Line_1__c, a.ShippingStreet);
    }

}