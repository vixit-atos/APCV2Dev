public with sharing class TestUtilities {
	
	public Contact 		aContac			{get; set;}
	public Attachment 	aAttachment		{get; set;}
    public TCMeeting__c tcMeeting	{get; set;}
    public   Deal_Meeting_Association__c DealMeetingAssociation {get; set;}
	
	public void generateContact(){

	    this.aContac 				= new Contact();
	    this.aContac.firstName 		= 'Test';
	    this.aContac.LastName 		= 'Test'; 
	    
	    insert this.aContac;

	    this.aAttachment = new Attachment();
	    this.aAttachment.Body = Blob.valueOf('String');
	}
    	public void generateTcmeetings(){
          tcMeeting = new TCMeeting__c();
            tcMeeting.Name='Test TC Meeting';
            tcMeeting.TC_Meeting_Status__c='Agenda Finalized';
                        
    List<TCMeeting__c> Tcmeetings = new List<TCMeeting__c>();
		Tcmeetings.add(tcMeeting);
		insert Tcmeetings;
        }
    
    public void generateDealMeetingAssociation(){
        Opportunity obj_Opportunity = new Opportunity (Name='testoopname',
                                                           StageName = 'New', 
                                                           LEAD_CONC_NO__c = 'H64118', 
                                                           CloseDate = Date.today() +1);
        insert obj_Opportunity;
          DealMeetingAssociation = new Deal_Meeting_Association__c();
            tcMeeting = new TCMeeting__c();
            tcMeeting.Name='Test TC Meeting123';
            tcMeeting.TC_Meeting_Status__c='Agenda Finalized';
         insert Tcmeeting;
            DealMeetingAssociation.TC_Meeting__c=tcMeeting.id;
        DealMeetingAssociation.TWS_TC_Deal__c=obj_Opportunity.id;
                        
    List<Deal_Meeting_Association__c> DealMeetingAssociations = new List<Deal_Meeting_Association__c>();
		DealMeetingAssociations.add(DealMeetingAssociation);
		insert DealMeetingAssociations;
        }
	public static TestUtilities generateTest(){
		TestUtilities e = new TestUtilities();
		e.generateContact();
		return e;
	}
    public static TestUtilities generateTcmeetingsTest(){
		TestUtilities e = new TestUtilities();
		e.generateTcmeetings();
		return e;
	}
    public static TestUtilities generateDealMeetingAssociations(){
		TestUtilities e = new TestUtilities();
		e.generateDealMeetingAssociation();
		return e;
	}

}