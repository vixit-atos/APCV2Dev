public class EmailmessageTriggerHandler  extends TriggerHandler  {
    public EmailmessageTriggerHandler (){}
    protected override void afterDelete() {
       processdelete(); 
    }
        private void processdelete() {
        
        system.debug('**************i am inside delete task');
        
        Map<Id,Private_Activity__c> PGAMap=new Map<Id,Private_Activity__c>();
        String tempId;  
        set<String> PgaIds = new set<String>();
        
        
        for(EmailMessage E: (List<EmailMessage>)trigger.old)
        {   
            tempId = E.ActivityId;
            
            if(tempId != null){
                if((tempId.substring(0,3) == '00T'))
                    PGAIds.add(E.ActivityId);
            }
        }
        
        /**@@ PGA Information Map  @@**/
        if(PGAIds.size() > 0)
            PGAMap = new Map<Id,Private_Activity__c>([SELECT Id,Subject__c, Activity_ID__c, Task__c,Status__c,Due_Date__c, Owner__c,Account__c,Account_Open_Activity_RL__c,Contact__c,Contact_RL__c From Private_Activity__c WHERE Activity_ID__c=:PGAIds]);
        if(PGAMap.values().size() != null && PGAMap.values().size()>0)
            Delete PGAMap.values();
        
    }

    
    
}