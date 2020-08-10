global with sharing class MDMAddressToAccountAddressSynch {
    

	// Class method to synch address in an MDM Object to the Account.
	// Input 
	// 	 MDM Address ID
	// 	 Address Type
	// Return
	//   String that indicates success or failure.
     
     webservice static string synchAddress(ID MDM_id, String addrType) {
        
        string result = '';
        
        MDM_Address__c addr = [select 
                               		Account__r.BillingCity,
                               		Account__r.BillingCountry,
                               		Account__r.BillingPostalCode,
                               		Account__r.BillingState,
                               		Account__r.BillingStreet, 
                               		 
                               		Account__r.ShippingCity,
                               		Account__r.ShippingCountry,
                               		Account__r.ShippingPostalCode,
                               		Account__r.ShippingState,
                               		Account__r.ShippingStreet,
                       		
                               		Address_Line_1__c, 
                               		Address_Line_2__c, 
                               		
                               		City__c,
                               		PostalCode__c,
                               		State_Code__c,
                               		Country__c
                               from MDM_Address__c 
                               where ID=:MDM_id];
        
        if (addrType == 'Mailing') {
            
            addr.Account__r.BillingCity = addr.City__c;
            addr.Account__r.BillingCountry = addr.Country__c;
            addr.Account__r.BillingPostalCode = addr.PostalCode__c;
            addr.Account__r.BillingState = addr.State_Code__c;
            addr.Account__r.BillingStreet = addr.Address_Line_1__c;
      
        } else {
            
            addr.Account__r.ShippingCity = addr.City__c;
            addr.Account__r.ShippingCountry = addr.Country__c;
            addr.Account__r.ShippingPostalCode = addr.PostalCode__c;
            addr.Account__r.ShippingState = addr.State_Code__c;
            addr.Account__r.ShippingStreet = addr.Address_Line_1__c;
      
        }
        
        update addr.Account__r;
        
        return result;
        
    }
    
    
}