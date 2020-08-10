public class PrivateActivityTriggerHandler  extends TriggerHandler  {
    public PrivateActivityTriggerHandler (){}
    protected override void afterDelete() {
     processdelete();   
    }
    
    private void processdelete() {
        
        system.debug('**************i am inside delete task');
        
        Map<Id,Task> TaskMap=new Map<Id,Task>();
        Map<Id,Event> EventMap=new Map<Id,Event>();
        String tempId;  
        set<String> TaskIds = new set<String>();
        set<String> EventIds = new set<String>();
        
        
        for(Private_Activity__c p: (List<Private_Activity__c>)trigger.old)
        {   
            tempId = p.Activity_ID__c;
            
            if(tempId != null){
                if((tempId.substring(0,3) == '00T'))
                    TaskIds.add(p.Activity_ID__c);
                if((tempId.substring(0,3) == '00U'))
                    EventIds.add(p.Activity_ID__c);
            }
        }
        
        /**@@ PGA Information Map  @@**/
        if(TaskIds.size() > 0)
            TaskMap = new Map<Id,Task>([SELECT Id,WhatId, Subject,CreatedById,  ActivityDate, ReminderDateTime, Contact__c From Task WHERE Id=:TaskIds]);
        if(EventIds.size() > 0)
            EventMap = new Map<Id,Event>([SELECT Id,WhatId,CreatedById,Contact__c From Event WHERE Id=:EventIds]);
        if(TaskMap.values().size() != null && TaskMap.values().size()>0)
            Delete TaskMap.values();
        if(EventMap.values().size() != null && EventMap.values().size()>0)
            Delete EventMap.values();
        
    }
    




}