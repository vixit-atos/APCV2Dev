/**
* ---------------------------------------------------------------------------------------------------
* @author         Christopher McDonald   
* @modifiedBy          
* @version        1.0
* @created        05-29-2018
* @modified       
* ---------------------------------------------------------------------------------------------------
*/
public class PCSDataGenerator implements Queueable {
    public Map<String, Integer> methodCallMap{get;set;}
    
    public PCSDataGenerator(Map<String, Integer> methodCalls){
        this.methodCallMap = methodCalls;
    }
    public void execute(QueueableContext context) {
        SavePoint save = Database.setSavepoint();
        Boolean errorFound = FALSE;
       	Boolean rollbackBool = FALSE;
        List<Account> accountList = new List<Account>();//Holds the generic accounts to insert
        List<Contact> contactList = new List<Contact>();//Holds the generic contacts to insert
        List<TCMeeting__c> tcMeetingList = new List<TCMeeting__c>();//Holds generic TCMeetings
        //Generate generic base objects
        List<RecordType> rtList = [SELECT Id, Name, SObjectType FROM RecordType];
        for(RecordType rt : rtList){
            /*
            if(rt.sObjectType == 'Account'){accountList.add(createAccount('TestAccount ' + rt.Name, rt.Name));}
            else if(rt.sObjectType =='Contact'){contactList.add(createContact('TestContact ' + rt.Name, rt.Name, null));}
            else if(rt.sObjectType =='TCMeeting__c'){tcMeetingList.add(createTCMeeting('TestTCMeeting ' + rt.Name, rt.Name, system.Today()+30));}
        	*/
        }
        
        //Insert all basic lists into the server
        if(checkForError(Database.insert(accountList, false)) == TRUE){rollbackBool = TRUE;}
        if(rollbackBool == FALSE){
            if(checkForError(Database.insert(contactList, false)) == TRUE){rollbackBool = TRUE;}
            if(rollbackBool == FALSE){
                if(checkForError(Database.insert(tcMeetingList, false)) == TRUE){rollbackBool = TRUE;}
            }
        }
        system.debug('@@@Map Values(If Null then panic)' + methodCallMap.values());
        for(String s : methodCallMap.keySet()){
            if(methodCallMap.get(s) > 0){
                methodSwitch(s, methodCallMap.get(s));
            }
        }
    }
    
    @TestVisible static private void methodSwitch(String methodName, Integer iterations){
        //Uses same base for all
        String uniqueIdentifier;
        if(methodName == 'AccountContact'){
            uniqueIdentifier = randomStringGenerator();
            accountContact(iterations, uniqueIdentifier, 'Dealership', 'Dealership Contact');
        }else if(methodName == 'AccountConcession'){
            uniqueIdentifier = randomStringGenerator();
            accountConcession(iterations, uniqueIdentifier, 'Dealership', 'WST Mainframe Concession');
        }else if(methodName == 'bareOpportunity'){
           uniqueIdentifier = randomStringGenerator();
           bareOpportunity(iterations, uniqueIdentifier, 'Dealership', 'Dealership Contact', 'WST Mainframe Concession', 'TC Meeting', 'Sales Contract');  
        }else if(methodName == 'fullOpportunity'){
            uniqueIdentifier = randomStringGenerator();
            fullOpportunityLoad(iterations, uniqueIdentifier, 'Dealership', 'Dealership Contact', 'WST Mainframe Concession', 'TC Meeting', 'Sales Contract');
        }
    }
    
    @TestVisible static private Boolean accountContact(Integer numberOfAccountContacts, String uniqueIdentifier, String accountRecordType, String contactRecordType){
        List<Account> acctList = new List<Account>();
        List<Contact> contactList = new List<Contact>();
        for(Integer i = 0; i<numberOfAccountContacts; i++){ acctList.add(createAccount('TestAccountContact'+uniqueIdentifier+i, accountRecordType));} //Creates an Account to connect to the Contact
        
        if(checkForError(Database.insert(acctList, false)) == TRUE){/*return TRUE;*/}//Returns error if the insert causes any error
        for(Integer i = 0; i<numberOfAccountContacts; i++){contactList.add(createContact('TestContactAccount'+i, contactRecordType, acctList[i].Id));}//Created a connected contact to previously made Accounts
        if(checkForError(Database.insert(contactList, false)) == TRUE){/*return TRUE;*/}//Returns error if the insert causes any error
        return FALSE;//Reaches here if no errors occur
    }
    
    @TestVisible static private Boolean accountConcession(Integer numberOfAccountConcessions, String uniqueIdentifier, String accountRecordType, String concessionRecordType){
        List<Account> acctList = new List<Account>();
        List<Concession__c> concessionList = new List<Concession__C>();
        for(Integer i = 0; i<numberOfAccountConcessions; i++){ acctList.add(createAccount('TestAccountConcession'+uniqueIdentifier+i, accountRecordType));} //Creates an Account to connect to the Contact
        if(checkForError(Database.insert(acctList, false)) == TRUE){return TRUE;}//Returns error if the insert causes any error
        
        for(Integer i = 0; i<numberOfAccountConcessions; i++){concessionList.add(createConcession('TestConcessionAccount'+i, concessionRecordType, acctList[i].Id));}//Creates a connection concession to previously made accounts
		if(checkForError(Database.insert(concessionList, false)) == TRUE){return TRUE;}//Returns error if the insert causes any error
        return FALSE;
    }

    @TestVisible static private Boolean bareOpportunity(Integer numberOfOpportunities, String uniqueIdentifier, String accountRecordType, String contactRecordType, String concessionRecordType, String tcMeetingRecordType, String opportunityRecordType){
        system.debug('@@@inside bareOpp');
        List<Account> acctList = new List<Account>();
        List<Contact> contactList = new List<Contact>();
        List<Concession__c> concessionList = new List<Concession__c>();
        List<Meeting_Attendee__c> attendeeList = new List<Meeting_Attendee__c>();
        List<TCMeeting__c> tcMeetingList = new List<TCMeeting__c>();
        List<Opportunity> oppList = new List<Opportunity>();

        for(Integer i = 0; i<numberOfOpportunities; i++){ acctList.add(createAccount('TestOppAccount'+uniqueIdentifier+i, accountRecordType));} //Creates an Account to connect to the Contact
        if(checkForError(Database.insert(acctList, false)) == TRUE){return TRUE;}//Returns error if the insert causes any error
        
        for(Integer i = 0; i<numberOfOpportunities; i++){contactList.add(createContact('TestOppContact'+uniqueIdentifier+i, contactRecordType, acctList[i].Id));}//Created a connected contact to previously made Accounts
        if(checkForError(Database.insert(contactList, false)) == TRUE){return TRUE;}//Returns error if the insert causes any error
        
        for(Integer i = 0; i<numberOfOpportunities; i++){concessionList.add(createConcession('TestOppConcession'+uniqueIdentifier+i, concessionRecordType, acctList[i].Id));}//Creates a connection concession to previously made accounts
		if(checkForError(Database.insert(concessionList, false)) == TRUE){return TRUE;}//Returns error if the insert causes any error
        
        for(Integer i = 0; i<numberOfOpportunities; i++){tcMeetingList.add(createTCMeeting('TestOppTCMeeting'+uniqueIdentifier+i, tcMeetingRecordType, system.Today()+30));}//Creates a connection concession to previously made accounts
		if(checkForError(Database.insert(tcMeetingList, false)) == TRUE){return TRUE;}//Returns error if the insert causes any error
        
        for(Integer i = 0; i<numberOfOpportunities; i++){attendeeList.add(createMeetingAttendee('TestTCAttendee'+uniqueIdentifier+i, tcMeetingList[i].Id));}//Creates a connection concession to previously made accounts
        if(checkForError(Database.insert(attendeeList, false)) == TRUE){return TRUE;}//Returns error if the insert causes any error
        
        for(Integer i = 0; i<numberOfOpportunities; i++){oppList.add(createOpportunity('TestOpportunity'+uniqueIdentifier+i, 'TWS-Dealer TC', acctList[i].Id, concessionList[i].Id, contactList[i].Id, tcMeetingList[i].Id, 'New', system.today()+30, ''));}
        if(checkForError(Database.insert(oppList, false)) == TRUE){return TRUE;}   
        system.debug('@@@Exiting Opp' + oppList);
        return FALSE;
    }
    
    @TestVisible static private Boolean fullOpportunityLoad(Integer numberOfOpportunities, String uniqueIdentifier, String accountRecordType, String contactRecordType, String concessionRecordType, String tcMeetingRecordType, String opportunityRecordType){
        system.debug('@@@inside fullOpp');
        List<Account> acctList = new List<Account>();
        List<Contact> contactList = new List<Contact>();
        List<Concession__c> concessionList = new List<Concession__c>();
        List<Meeting_Attendee__c> attendeeList = new List<Meeting_Attendee__c>();
        List<TCMeeting__c> tcMeetingList = new List<TCMeeting__c>();
        List<Opportunity> oppList = new List<Opportunity>();    
    	List<TWS_Approver__c> apprList = new List<TWS_Approver__c>();
        List<Sales_Contract__c> contractList = new List<Sales_Contract__c>();
        List<Deal_Meeting_Association__c> dmaList = new List<Deal_Meeting_Association__c>();
        List<Task> tList = new List<Task>();
        List<Event> eList = new List<Event>();
        
        for(Integer i = 0; i<numberOfOpportunities; i++){ acctList.add(createAccount('TestOppAccount'+uniqueIdentifier+i, accountRecordType));} //Creates an Account to connect to the Contact
        if(checkForError(Database.insert(acctList, false)) == TRUE){return TRUE;}//Returns error if the insert causes any error
        
        for(Integer i = 0; i<numberOfOpportunities; i++){contactList.add(createContact('TestOppContact'+uniqueIdentifier+i, contactRecordType, acctList[i].Id));}//Created a connected contact to previously made Accounts
        if(checkForError(Database.insert(contactList, false)) == TRUE){return TRUE;}//Returns error if the insert causes any error
        
        for(Integer i = 0; i<numberOfOpportunities; i++){concessionList.add(createConcession('TestOppConcession'+uniqueIdentifier+i, concessionRecordType, acctList[i].Id));}//Creates a connection concession to previously made accounts
		if(checkForError(Database.insert(concessionList, false)) == TRUE){return TRUE;}//Returns error if the insert causes any error
        
        for(Integer i = 0; i<numberOfOpportunities; i++){tcMeetingList.add(createTCMeeting('TestOppTCMeeting'+uniqueIdentifier+i, tcMeetingRecordType, system.Today()+30));}//Creates a connection concession to previously made accounts
		if(checkForError(Database.insert(tcMeetingList, false)) == TRUE){return TRUE;}//Returns error if the insert causes any error
        
        for(Integer i = 0; i<numberOfOpportunities; i++){attendeeList.add(createMeetingAttendee('TestTCAttendee'+uniqueIdentifier+i, tcMeetingList[i].Id));}//Creates a connection concession to previously made accounts
        if(checkForError(Database.insert(attendeeList, false)) == TRUE){return TRUE;}//Returns error if the insert causes any error
        
        for(Integer i = 0; i<numberOfOpportunities; i++){oppList.add(createOpportunity('TestOpportunity'+uniqueIdentifier+i, 'TWS-Dealer TC', acctList[i].Id, concessionList[i].Id, contactList[i].Id, tcMeetingList[i].Id, 'Ready for TCM', system.today()+30, 'TC Deal'));}
        if(checkForError(Database.insert(oppList, false)) == TRUE){return TRUE;}  
        
        for(Integer i = 0; i<numberOfOpportunities; i++){apprList.add(createApprover(oppList[0].Id));}
        if(checkForError(Database.insert(apprList, false)) == TRUE){return TRUE;} 

        for(Integer i = 0; i<numberOfOpportunities; i++){contractList.add(createSalesContract('Draft'+uniqueIdentifier+i, oppList[0].Id));}
        if(checkForError(Database.insert(contractList, false)) == TRUE){return TRUE;} 
        
        for(Integer i = 0; i<numberOfOpportunities; i++){tList.add(createTask(contractList[i].Id, contactList[i].Id));}
        if(checkForError(Database.insert(tList, false)) == TRUE){return TRUE;} 
        
        for(Integer i = 0; i<numberOfOpportunities; i++){eList.add(createEvent(contractList[i].Id, contactList[i].Id, system.now()+30, 1));}
        if(checkForError(Database.insert(eList, false)) == TRUE){return TRUE;} 
        
        for(Integer i = 0; i<numberOfOpportunities; i++){dmaList.add(createDealMeetingAssociation(tcMeetingList[0].Id, oppList[0].Id));}
        if(checkForError(Database.insert(dmaList, false)) == TRUE){return TRUE;}
        system.debug('@@@Exiting Opp' + oppList);
        return FALSE;
    }
   
    //Object creation methods
    @TestVisible static private Account createAccount(String accountName, String recordTypeName){
        return new Account(Name = accountName, RecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId());
    }
        
    @TestVisible static private Contact createContact(String contactName, String recordTypeName, Id accountId){
        return new Contact(LastName = contactName, RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId(), AccountId = accountId);
    }
    
    @TestVisible static private TCMeeting__c createTCMeeting(String tcName, String recordTypeName, Date tcDate){
        return new TCMeeting__c(Name = tcName, RecordTypeId = Schema.SObjectType.TCMeeting__c.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId(), TC_Meeting_Date__c = tcDate);
    }
   
    @TestVisible static private Meeting_Attendee__c createMeetingAttendee(String attendeeName, Id tcMeetingId){
        return new Meeting_Attendee__c(Name = attendeeName, TC_Meeting__c = tcMeetingId);
    }
    
    @TestVisible static private Concession__c createConcession(String concessionName, String recordTypeName, Id accountId){
        //Dealer Account styled Concession
        return new Concession__c(Name = concessionName, recordTypeId = Schema.SObjectType.Concession__c.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId(), Account__c = accountId, CloseDate__c = system.Today()+30);   
    }
    
    @TestVisible static private Opportunity createOpportunity(String opportunityName, String recordTypeName, Id accountId, Id concessionId, Id contactId, Id tcMeetingId, String stage, Date clDate, String dealType){
        return new Opportunity(Name = opportunityName, recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId(), AccountId = accountId,Contact__c = contactId,Concession__c = concessionId,TC_Meeting__c = tcMeetingId, StageName = stage, CloseDate = system.today()+30, Deal_Type__c = dealType);   
    }
    
    @TestVisible static private TWS_Approver__c createApprover(Id oppId){
        return new TWS_Approver__c(TWS_Deal__c = oppId);
    }
    
    @TestVisible static private Sales_Contract__c createSalesContract(String status, Id Oppid){
        return new Sales_Contract__c(Approval_Status__c = status, Opportunity__c = oppId);
    }   

    @TestVisible static private Task createTask(Id sObjectId, Id contactId){
        return new Task(WhatID = sObjectID, WhoId = contactId, Subject = 'Test');
    }
    
    @TestVisible static private Event createEvent(Id sObjectId, Id contactId, Datetime actDate, Integer minutes){
        return new Event(WhatID = sObjectID, WhoId = contactId, Subject = 'Test', ActivityDateTime = actDate, DurationInMinutes = minutes);
    }
    
    @TestVisible static private Deal_Meeting_Association__c createDealMeetingAssociation(Id tcMeetingID, Id oppId){
        return new Deal_Meeting_Association__c(TC_Meeting__c = tcMeetingID, TWS_TC_Deal__c = oppId);
    }
    
    //Support methods
    @TestVisible static private Boolean checkForError(Database.SaveResult[] srList){
        for(Database.SaveResult sr: srList){
            if(!sr.isSuccess()){
                return TRUE;
            }
        }
        return FALSE;
    }
    
    @TestVisible static private String randomStringGenerator(){
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
    	String randStr = '';
    	while (randStr.length() < 5) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
    	return randStr; 
    }
}