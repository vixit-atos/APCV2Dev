@isTest
private class AddressCLController_Test {

	@isTest static void test_method_one() {

		Account a = new Account(Name = 'a');
		insert a;


		MDM_Address__c [] addrList = new List<MDM_Address__c>();

		addrList.add(new MDM_Address__c(Name = 'n0', OBJECT_ROWID__c = 0, Account__c = a.Id));
		addrList.add(new MDM_Address__c(Name = 'n1', OBJECT_ROWID__c = 1, Account__c = a.Id));
		addrList.add(new MDM_Address__c(Name = 'n2', OBJECT_ROWID__c = 2, Account__c = a.Id));
		
		insert addrList;

		AddressCLController acl = new AddressCLController(new ApexPages.StandardController(a));



		acl.addrID = addrList[0].id;
		acl.processMailLinkClick();
		//assert mailing address was updated


		acl.addrID = addrList[1].id;
		acl.processShipLinkClick();
		//one ship, one mail


		

		acl.addrID = addrList[0].id;
		acl.processShipLinkClick();

		acl.addrID = addrList[2].id;
		acl.processMailLinkClick();




		//now it should be both

		


	}



}