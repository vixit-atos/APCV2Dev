trigger Deal_Meeting_AssociationTrigger on Deal_Meeting_Association__c (
	before insert, 
	before update, 
	before delete, 
	after insert, 
	after update, 
	after delete, 
	after undelete) {

		new Deal_Meeting_AssociationTriggerHandler().run();
}