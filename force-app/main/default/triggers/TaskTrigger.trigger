trigger TaskTrigger on Task (after delete, after insert, after undelete, after update, before delete, before insert, before update) 
{
    if(EventInviteURLPrefix__c.getInstance().PrivateActivityTriggerToggle__c || Test.isRunningTest() || !UserInfo.getUserName().contains('crmapiadmin@daimler.com'))
    {
        new TaskTriggerHandler().run();
    }
   /* if(Trigger.isAfter){
            if (Trigger.isInsert || Trigger.isUpdate) {               
                    if (GlobalUtility.runOnceOnAfter()) {
                  TaskTriggerActionsEXt.updateoppstage(Trigger.new);
                  }
               
            }
        } */
}