trigger PricingProposalTrigger on PricingProposal__c (
    before insert, 
    before update, 
    before delete, 
    after insert, 
    after update, 
    after delete, 
    after undelete) {

    new PricingProposalTriggerHandler().run();
     if (Trigger.isBefore ) {
        if (Trigger.isInsert) {}  
        if (Trigger.isUpdate) {
          
           
        }
        if (Trigger.isDelete) {
         PricingProposalTriggerHandler.deleteConCal(Trigger.old);
        }
        }
}