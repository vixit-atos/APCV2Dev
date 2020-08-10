trigger AdminToolTrigger on Administrative_Tool__c (
    before insert,
    after insert,
    before update,
    after update,
    before delete,
    after delete
) 
{
  new AdminTool_TriggerHandler().run();
}