@isTest

public class TWS_AgendaFinalisedEmailRequest_Test {
    static testMethod void AgendaFinalisedEmailRequest() {
        
        Test.startTest(); //switch to testing context
        TestUtilities tu = TestUtilities.generateTcmeetingsTest();
        PageReference pageRef = Page.TWS_FinalisedAgendaReview; //create a page reference to our Visualforce page
        ID pageid = pageRef.getParameters().put('id',tu.tcMeeting.id); //parameter id which you are passing in your page
        Test.setCurrentPage(pageRef); //set the current page to that page		
        
        ApexPages.StandardController standardController = new ApexPages.standardController(new TCMeeting__c()); //instantiate the standard controller for the TCMeeting__c object
        system.debug('standardController111'+standardController);
        TWS_AgendaFinalisedEmailRequest ext = new TWS_AgendaFinalisedEmailRequest(standardController); //construct the extension
        ext.doCancel();
        ext.SendAgendaEmail();
        Test.stopTest();
        
    }
    
}