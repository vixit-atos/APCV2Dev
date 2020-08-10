public class TCMeetingNotesTriggerHandler extends TriggerHandler {
    
    public TCMeetingNotesTriggerHandler(){
    }
    protected override void afterDelete() {
        UpdateTCmeetingnotes();   
    }
    
    @TestVisible private void UpdateTCmeetingnotes() { 
        
        List<TC_Meeting_Note__c> lstnewTCMeetingNotes=Trigger.old;
            Set<ID>  OppyIDs =new Set<ID>();        
            system.debug('lstnewTCMeetingNotes123'+lstnewTCMeetingNotes);
            for(TC_Meeting_Note__c objTcmeetingnotes : lstnewTCMeetingNotes){
            OppyIDs.add(objTcmeetingnotes.TWS_Deal__c);
            }
        system.debug('OppyIDsOppyIDs123'+OppyIDs);
     List<Opportunity> lstoppystoupdate = [select id,TC_Meeting_Notes__c from  Opportunity where id in:OppyIDs];
     // Call the Flow
        Map<String, Object> params = new Map<String, String>();
        for(Opportunity objOppy:lstoppystoupdate) {
        params.put('DealId', objOppy.Id);
         System.debug('Flow params1111 ' + params);
        }
        Flow.Interview.TWS_TC_Meeting_Note_Rollup helloWorldFlow = new Flow.Interview.TWS_TC_Meeting_Note_Rollup(params);
                // System.debug(' helloWorldFlow 1111 ' + helloWorldFlow);

        helloWorldFlow.start();
        
        // Obtain the results
        String returnValue = (String) helloWorldFlow.getVariableValue('ReturnValue');
        System.debug('Flow returned ' + returnValue);
    }
                
                
}