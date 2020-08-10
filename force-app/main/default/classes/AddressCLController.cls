public with sharing class AddressCLController {
    
    // an instance variable for the standard controller
    private ApexPages.StandardController controller {get; set;}
    
    // the object being referenced via url
    private Account account {get;set;}
    // the variable being set from the commandlink
    
    public ID	addrID {get;set;}
    private MDM_Address__c addr;
    // initialize the controller
    public AddressCLController(ApexPages.StandardController controller) {
        
        //initialize the stanrdard controller
        this.controller = controller;
        // load the current record
        this.account = (Account)controller.getRecord();
        
    }
    
    private void getAddr() {
        addr = [select 
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
                Country__c,
                
                Used_As_Mailing__c,
                Used_As_Physical__c,
                Hidden__c
                from MDM_Address__c 
                where ID=:addrID];
    }
    
    // reset address
    
    private void clearMailingFlags() {
        List<MDM_Address__c> addrList =  [select Used_As_Physical__c, Used_As_Mailing__c from MDM_Address__c where Account__c = :account.id and Used_As_Mailing__c = true]; 
        for(MDM_Address__c a: addrList) {
            
                 a.Used_As_Mailing__c = false; 
                 a.Usage_Flag__c = calcUsageFlag(a);
        }

		update addrList;  
        
    }
    
    private void clearPhysicalFlags() {
        List<MDM_Address__c> addrList =  [select Used_As_Physical__c, Used_As_Mailing__c from MDM_Address__c where Account__c = :account.id and Used_As_Physical__c = true];
        for(MDM_Address__c a: addrList) {
            
            a.Used_As_Physical__c = false;
            a.Usage_Flag__c = calcUsageFlag(a);    	
             
                 
        }
        update addrList;
    }
    
    private string calcUsageFlag(MDM_Address__c a) {
        
        
        if(a.Used_As_Mailing__c & a.Used_As_Physical__c) {            
            return 'Both';
        } else if (a.Used_As_Mailing__c) {
            return 'Mailing';
        } else if (a.Used_As_Physical__c) {
        	return 'Physical';            
        } else {
            return '';
        }
    }    
    
    // handle the action of the commandlink
    public PageReference processShipLinkClick() {
        getAddr();
        
        addr.Account__r.ShippingCity = addr.City__c;
        addr.Account__r.ShippingCountry = addr.Country__c;
        addr.Account__r.ShippingPostalCode = addr.PostalCode__c;
        addr.Account__r.ShippingState = addr.State_Code__c;
        addr.Account__r.ShippingStreet = addr.Address_Line_1__c;
        
        clearPhysicalFlags();
        addr.Used_As_Physical__c = true;
        addr.Usage_Flag__c = calcUsageFlag(addr);
        
        update addr;
        update addr.account__r;
        return null;
    }
    
    public PageReference processMailLinkClick() {

        getAddr();
        
        addr.Account__r.BillingCity = addr.City__c;
        addr.Account__r.BillingCountry = addr.Country__c;
        addr.Account__r.BillingPostalCode = addr.PostalCode__c;
        addr.Account__r.BillingState = addr.State_Code__c;
        addr.Account__r.BillingStreet = addr.Address_Line_1__c;
        
        clearMailingFlags();
        addr.Used_As_Mailing__c = true;
        addr.Usage_Flag__c = calcUsageFlag(addr);
        
        update addr;
        update addr.account__r;
        return null;
    }
	/*    
    public PageReference processHideLinkClick() {

        getAddr();
        
        System.debug('YAP Hiding this');
        addr.Hidden__c = true;
        update addr;
        update account.MDM_Addresses_Active__r;
        return null;
    }
    */
}