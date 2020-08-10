@isTest
public class TWS_ICS_Generator_ControllerExt_Test {
    static testMethod void ICS_Generator() {
        Test.startTest(); //switch to testing context
      PageReference pageRef = Page.TWS_ICS_Generator;

    RecordType Rd = [select id,name from recordtype where sobjecttype='Opportunity' AND name = 'TWS-Direct TC'];
    TCMeeting__c  tcMeeting = new TCMeeting__c();
            tcMeeting.Name='Test TC Meeting';
            tcMeeting.TC_Meeting_Status__c='Agenda Finalized';
        tcMeeting.TC_Meeting_Date__c=system.today();
        insert tcMeeting;
      Opportunity obj_Opportunity = new Opportunity ();
        obj_Opportunity.Name='testoopname';
       obj_Opportunity.StageName ='Ready for TCM';
       obj_Opportunity.LEAD_CONC_NO__c = 'H64118'; 
        obj_Opportunity.CloseDate = Date.today() +1;
        obj_Opportunity.RecordTypeId=Rd.id;
        insert obj_Opportunity;
        system.debug('obj_Opportunity.StageName'+obj_Opportunity.StageName);
       Deal_Meeting_Association__c   DealMeetingAssociation = new Deal_Meeting_Association__c();
           
            DealMeetingAssociation.TC_Meeting__c=tcMeeting.id;
        DealMeetingAssociation.TWS_TC_Deal__c=obj_Opportunity.id;
        insert DealMeetingAssociation;
     system.debug('Tcmeeting111'+Tcmeeting);
     Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',obj_Opportunity.id);
            ApexPages.StandardController sc = new ApexPages.StandardController(tcMeeting);
      system.debug('ext123sc'+sc);

        TWS_ICS_Generator_ControllerExtension ext = new TWS_ICS_Generator_ControllerExtension(sc); //construct the extension
      system.debug('ext123'+ext);
  /*
        PageReference pageRef = Page.TWS_ICS_Generator; //create a page reference to our Visualforce page
        ID pageid = pageRef.getParameters().put('id',tu1.tcMeeting.id); //parameter id which you are passing in your page
        Test.setCurrentPage(pageRef); //set the current page to that page       
        
        ApexPages.StandardController standardController = new ApexPages.standardController(new TCMeeting__c()); //instantiate the standard controller for the TCMeeting__c object
        system.debug('standardController111'+standardController);
        TWS_ICS_Generator_ControllerExtension ext = new TWS_ICS_Generator_ControllerExtension(standardController); //construct the extension
  */   
}
    

}