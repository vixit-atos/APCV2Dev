@isTest public class PCSDataGeneratorTest {
	@testSetup static void setup(){
        insert new ConcessionRCURequest__c(Name = 'Endpoint');
        insert new EventInviteURLPrefix__c(TWSResidualPrefix__c = '.com/apex', TWSwsPrefix__c = '.com/apex');
        insert new Contact(LastName = 'T3$T',Email = 'test@gmtestail.com',RecordTypeID = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Dealership Contact').getRecordTypeId());
    	insert new Approver_Configuration__c(Process__c = 'Sales Contract', Approver__c = '005d0000005fVA5AAM', Make__c = 'FTL');
    }  
    
    @isTest static void testGenericDriverRun(){
        test.StartTest();
            Map<String, Integer> methodCalls = new Map<String, Integer>();
            methodCalls.put('AccountContact', 1);
            methodCalls.put('AccountConcession', 1);
            methodCalls.put('bareOpportunity', 1);
            methodCalls.put('fullOpportunity', 1);
            System.enqueueJob(new PCSDataGenerator(methodCalls));
        test.StopTest();
    }
    
    @isTest static void testSwitch(){
        test.startTest();
            Map<String, Integer> methodCalls = new Map<String, Integer>();
            PCSDataGenerator.methodSwitch('AccountContact', 1);
            PCSDataGenerator.methodSwitch('AccountConcession', 2);
            PCSDataGenerator.methodSwitch('bareOpportunity', 2);
            PCSDataGenerator.methodSwitch('fullOpportunityLoad', 2);
        test.stopTest();
    }
    
    @isTest static void testGenericDataGeneration(){
        List<Account> acctList = new List<Account>();
        List<Contact> contList = new List<Contact>();
        List<TCMeeting__c> tcList = new List<TCMeeting__c>();

        test.startTest();
        insert PCSDataGenerator.createAccount('Test', 'Dealership');
        insert PCSDataGenerator.createContact('Test', 'Dealership Contact', null);
        insert PCSDataGenerator.createTCMeeting('Test', 'TC Meeting', system.Today()+30);
        test.stopTest();
        
        acctList = [SELECT ID FROM Account];
        contList = [SELECT ID FROM Contact];
        tcList = [SELECT ID FROM TCMeeting__c];
        system.assertNotEquals(0, acctList.size());
        system.assertNotEquals(0, contList.size());
        system.assertNotEquals(0, tcList.size());
    }
    
    @isTest static void testAccountContactCreation(){
        test.StartTest();
        PCSDataGenerator.accountContact(1, 'te$t', 'Dealership', 'Dealership Contact');
        test.stopTest();
        List<Account> acctList = [SELECT ID FROM Account];
        List<Contact> contList = [SELECT ID, AccountID FROM Contact WHERE AccountID != NULL];
        system.assertEquals(1, contList.size());
        system.assertEquals(acctList[0].Id, contList[0].accountId);
    }
    
    @isTest static void testAccountConcessionCreation(){
        test.StartTest();
        PCSDataGenerator.accountConcession(1, 'te$t', 'Dealership', 'WST Mainframe Concession');
        test.stopTest();
        List<Account> acctList = [SELECT ID FROM Account LIMIT 1];
        List<Concession__c> concList = [SELECT ID, Account__c FROM Concession__C WHERE Account__c != NULL];
        system.assertEquals(1, concList.size());
        system.assertEquals(acctList[0].Id, concList[0].account__c);
    }
    
    @isTest static void testBareOpportunity(){
        test.StartTest();
        PCSDataGenerator.bareOpportunity(1, 'oppObject', 'Dealership', 'Dealership Contact', 'WST Mainframe Concession', 'TC Meeting', 'Sales Contract');
        test.stoptest();
        List<Account> acctList = [SELECT ID FROM Account LIMIT 1];
        List<Contact> contList = [SELECT ID, Name, AccountID FROM Contact WHERE Email != 'test@gmtestail.com' LIMIT 1];
        List<Concession__c> concList = [SELECT ID, Account__c FROM Concession__C LIMIT 1];
        List<TCMeeting__c> tcList = [SELECT ID FROM TCMeeting__c LIMIT 1];
		List<Opportunity> oppList = [SELECT ID, AccountID, Contact__c, Concession__c, TC_Meeting__c FROM Opportunity LIMIT 1];
        List<Meeting_Attendee__c> attendeeList = [SELECT ID, TC_Meeting__c FROM Meeting_Attendee__c LIMIT 1];
        //Test Contact Relationships
        system.assertEquals(1, contList.size());
        system.assertEquals(acctList[0].Id, contList[0].accountId);
        //Test Concession Relationships
        system.assertEquals(1, concList.size());
        system.assertEquals(acctList[0].Id, concList[0].account__c);
        //Test Opportunity Relationships
        System.assertEquals(acctList[0].Id, oppList[0].accountId);
        System.assertEquals(contList[0].Id, oppList[0].contact__c);
        System.assertEquals(concList[0].Id, oppList[0].Concession__c);
        System.assertEquals(tcList[0].Id, oppList[0].TC_Meeting__c);
    }

    @isTest static void fullOpportunityLoad(){
        test.StartTest();
        PCSDataGenerator.fullOpportunityLoad(1, 'oppObject', 'Dealership', 'Dealership Contact', 'WST Mainframe Concession', 'TC Meeting', 'Sales Contract');
        test.stoptest();
        List<Account> acctList = [SELECT ID FROM Account LIMIT 1];
        List<Contact> contList = [SELECT ID, AccountID FROM Contact WHERE Email != 'test@gmtestail.com' LIMIT 1];
        List<Concession__c> concList = [SELECT ID, Account__c FROM Concession__C LIMIT 1];
        List<TCMeeting__c> tcList = [SELECT ID FROM TCMeeting__c LIMIT 1];
		List<Opportunity> oppList = [SELECT ID, AccountID, Contact__c, Concession__c, TC_Meeting__c, CloseDate FROM Opportunity LIMIT 1];
        List<Meeting_Attendee__c> attendeeList = [SELECT ID, TC_Meeting__c FROM Meeting_Attendee__c LIMIT 1];
        List<TWS_Approver__c> apprList = [SELECT ID, TWS_Deal__c FROM TWS_Approver__c LIMIT 1];
        List<Sales_Contract__c> contractList = [SELECT ID, Opportunity__c FROM Sales_Contract__c LIMIT 1];
        List<Deal_Meeting_Association__c> dmaList = [SELECT ID, TC_Meeting__c, TWS_TC_Deal__c FROM Deal_Meeting_Association__c LIMIT 1];
        List<Task> tList = [SELECT ID, WhatID, WhoId FROM Task LIMIT 1];
        List<Event> eList = [SELECT ID, WhatID, WhoId FROM Event LIMIT 1];
        //Test Contact Relationships
        system.assertEquals(1, contList.size());
        system.assertEquals(acctList[0].Id, contList[0].accountId);
        //Test Concession Relationships
        system.assertEquals(1, concList.size());
        system.assertEquals(acctList[0].Id, concList[0].account__c);
        //Test Opportunity Relationships
        System.assertEquals(acctList[0].Id, oppList[0].accountId);
        System.assertEquals(contList[0].Id, oppList[0].contact__c);
        System.assertEquals(concList[0].Id, oppList[0].Concession__c);
        System.assertEquals(tcList[0].Id, oppList[0].TC_Meeting__c);
        //Test Approver Relationship
        System.assertEquals(oppList[0].Id, apprList[0].TWS_Deal__c);
        //Test Sales Contract Relationship
        System.assertEquals(oppList[0].Id, contractList[0].Opportunity__c);
        //Test Task Sales Contract Relationships
        System.assertEquals(contractList[0].Id, tList[0].WhatID);
        System.assertEquals(NULL, tList[0].WhoId);//Task always removes Contact, regardless of PA Creation
        //Test Event Sales Contract Relationships
        System.assertEquals(contractList[0].Id, eList[0].WhatID);
        System.assertEquals(contList[0].Id, eList[0].WhoId);
        //Test Deal Meeting Association Relationships
        System.assertEquals(tcList[0].Id, dmaList[0].TC_Meeting__c);
        System.assertEquals(oppList[0].Id, dmaList[0].TWS_TC_Deal__c);
    }
    @isTest static void testCheckErrorFail(){
        List<Account> acctList = new List<Account>();
        acctList.add(new Account());
        PCSDataGenerator.checkForError(Database.insert(acctList, false));
    }
}