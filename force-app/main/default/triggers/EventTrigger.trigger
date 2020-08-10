trigger EventTrigger on Event (after delete, after insert, after undelete, after update, before delete, before insert, before update) 
{
     if(EventInviteURLPrefix__c.getInstance().PrivateActivityTriggerToggle__c || Test.isRunningTest() || !UserInfo.getUserName().contains('crmapiadmin@daimler.com'))
        new EventTriggerHandler().run();
}