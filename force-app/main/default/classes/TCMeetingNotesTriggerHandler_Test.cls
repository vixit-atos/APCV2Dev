@isTest
public class TCMeetingNotesTriggerHandler_Test {

static testMethod void Tcmeetingnotedelete() {

TCMeeting__c objtcmeeting =new TCMeeting__c();
objtcmeeting.name='Test Tc meeting name';
insert objtcmeeting;


TC_Meeting_Note__c objTcmmetingnote =new TC_Meeting_Note__c ();
objTcmmetingnote.TCM_Note__c='test tcmeetin notes ';
objTcmmetingnote.TC_Meeting__c=objtcmeeting.id;
insert objTcmmetingnote;
objTcmmetingnote.TCM_Note__c='test meeting note update';
delete objTcmmetingnote;


}

}