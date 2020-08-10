@isTest

public class TWS_TCMeetingextension_Test {
	static testMethod void newtcmeetingOverride() {
	
		
		        TestUtilities tu = TestUtilities.generateTcmeetingsTest();

		Test.startTest(); //switch to testing context
		
		PageReference pageRef = Page.TWS_TCMeetingpage; //create a page reference to our Visualforce page
		Test.setCurrentPage(pageRef); //set the current page to that page
		ApexPages.StandardController standardController = new ApexPages.standardController(new TCMeeting__c()); //instantiate the standard controller for the TCMeeting__c object
		TWS_TCMeetingextension ext = new TWS_TCMeetingextension(standardController); //construct the extension
		
		//pass some parameters to the page
		pageRef.getParameters().put('save_new', '1'); //set save_new key value pair
		//pageRef.getParameters().put('conid', contacts[0].Id); //set conid key value pair
	//	pageRef.getParameters().put('accid', Tcmeetings[0].Id); //set Tcmeetings key value pair
		pageRef.getParameters().put('save', '1'); //set save key value pair
		
		//execute the logic
		String validationURLString = ext.DefaultTCMeetingName().getURL(); //get the resulting url from the prepopulateValues method
		
		//validate the results
		System.assertEquals(true, validationURLString.toLowerCase().contains('nooverride=1')); //string contains the nooverride key value pair
		System.assertEquals(true, validationURLString.contains('/a13/e')); //string contains the new TCMeeting__c URL
	//	System.assertEquals(true, validationURLString.contains('name')); //string contains the opp3 key
		System.assertEquals(false, validationURLString.toLowerCase().contains('save_new=1')); //string doesn't contain save_new=1
		System.assertEquals(false, validationURLString.toLowerCase().contains('save=1')); //string doesn't contain save=1
		
		Test.stopTest(); //revert back to normal context
	}

}