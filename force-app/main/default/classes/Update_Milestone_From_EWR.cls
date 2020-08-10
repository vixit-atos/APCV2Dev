public class Update_Milestone_From_EWR {

    @InvocableMethod(label='Update Milestones')
    public static void updateMilestones(List<Engineering_Work_Request__c> ewrs) {//List<InvocableVar> invocableVarList) {//
        //get opps for updated ewrs
        List<Id> ewrOppIds = new List<Id>();
        for (Engineering_Work_Request__c ewr : ewrs)
        	ewrOppIds.add(ewr.Opportunity__c);
        Map<Id,Opportunity> opps = new Map<Id,Opportunity>([SELECT Id FROM Opportunity WHERE Id IN :ewrOppIds]);
        //get all ewrs related to opps and store as lists accessed by opp.id
        List<Engineering_Work_Request__c> relatedEwrs = [SELECT Opportunity__c,
                 JOB_CHGOVR_DATE__c,TRGT_IMPL_DATE__c,JOB_ORIG_COVR_DATE__c,
                 JOB_SCH_DSGN_DATE__c,PRELM_PKT_ISS_DATE__c,JOB_ORIG_DSGN_DATE__c,
                 FNL_PKT_RLSE_DATE__c,JOB_SCH_PKT_DATE__c,JOB_ORIG_PKT_DATE__c,
                 JOB_ORIG_STA_DATE__c,JOB_RQST_DATE__c,JOB_PSC_APPR_DATE__c
                 FROM Engineering_Work_Request__c WHERE Opportunity__c IN :opps.keySet()];
        Map<Id,List<Engineering_Work_Request__c>> oppEwrs = new Map<Id,List<Engineering_Work_Request__c>>();
        for (Engineering_Work_Request__c ewr : relatedEwrs) {
            Opportunity c = opps.get(ewr.Opportunity__c);
            List<Engineering_Work_Request__c> related = oppEwrs.get(c.Id);
            if (related == null)
                related = new List<Engineering_Work_Request__c>();
            related.add(ewr);
            oppEwrs.put(c.Id,related);
        }
        //get all existing milestones connected to opp and store wrt opp.id
        List<Milestone__c> ms = [SELECT Opportunity__c,Name,Kickoff_Date__c,
                Deadline__c,Actual_Date__c,Completed__c
                FROM Milestone__c WHERE Opportunity__c IN :opps.keySet()];
        Map<String,Milestone__c> msFromOpportunity = new Map<String,Milestone__c>();
        for (Milestone__c m : ms)
            msFromOpportunity.put(m.Opportunity__c+m.Name,m);
               
        List<Milestone_EWR_Fields__mdt> mdtObj = [SELECT Label,EWR_Kickoff__c,EWR_Deadline__c,EWR_Actual__c FROM Milestone_EWR_Fields__mdt]; 
        List<Milestone__c> toUpsert = new List<Milestone__c>();
        List<Milestone__c> toDelete = new List<Milestone__c>();
        for (Id oppId : oppEwrs.keySet()) { //for each opp
            Opportunity c = opps.get(oppId);
            List<Engineering_Work_Request__c> related = oppEwrs.get(oppId);
            
            for (Milestone_EWR_Fields__mdt mdt : mdtObj) { //check each field
                Date latestKickoff = Date.newInstance(1900,1,1);
                Date latestDeadline = Date.newInstance(1900,1,1);
                Date latestActual = Date.newInstance(1900,1,1);
                for (Engineering_Work_Request__c ewr : related) { //check all EWRs related to Opportunity
                    Date ewrKickoff = (Date) ewr.get(mdt.EWR_Kickoff__c);
                    Date ewrDeadline = (Date) ewr.get(mdt.EWR_Deadline__c);
                    Date ewrActual = (Date) ewr.get(mdt.EWR_Actual__c);
                    if (ewrKickoff != null && ewrKickoff > latestKickoff)
                        latestKickoff = ewrKickoff;
                    if (ewrDeadline != null && ewrDeadline > latestDeadline)
                        latestDeadline = ewrDeadline;
                    if (ewrActual != null && ewrActual > latestActual)
                        latestActual = ewrActual;
                }
                
                Milestone__c m = msFromOpportunity.get(oppId+mdt.Label);
                Date oldest = Date.newInstance(1900,1,1);
                Date kickoff = (latestKickoff!=oldest) ? latestKickoff : null;
                Date deadline = (latestDeadline!=oldest) ? latestDeadline : null;
                Date actual = (latestActual!=oldest) ? latestActual : null;
                Boolean completed = false;
                if (deadline!=null && deadline < Date.today()) {
                    completed = true;
                }
                
                if (m==null && (kickoff!=null || deadline!=null || actual!=null)) {
                    Milestone__c newMs = new Milestone__c(Opportunity__c=oppId, Name=mdt.Label, 
                                                  Kickoff_Date__c=kickoff, Deadline__c=deadline,
                                                  Actual_Date__c=actual, Completed__c=completed);
                    toUpsert.add(newMs);
                }
                else if (m!=null && (m.Kickoff_Date__c!=latestKickoff || m.Deadline__c!=latestDeadline || m.Actual_Date__c!=latestActual)) {         
                    m.Kickoff_Date__c = kickoff;
                    m.Deadline__c = deadline;
                    m.Actual_Date__c = actual;
                    m.Completed__c = completed;
                    toUpsert.add(m);
                } else if (m!=null && latestKickoff==oldest && latestDeadline==oldest && latestActual==oldest) {
                    toDelete.add(m);
                }
            }
        }

        System.debug('Upserting '+toUpsert);
        System.debug('Deleting '+toDelete);
        if (toUpsert.size() > 0) {
            List<Database.UpsertResult> urList = Database.upsert(toUpsert,false);
            for (Database.UpsertResult ur : urList)
                if (ur.getErrors().size() > 0)
                system.debug('Error upserting milestones '+ur.getErrors()[0].getMessage());
        }
        if (toDelete.size() > 0) {
            List<Database.DeleteResult> drList = Database.delete(toDelete,false);
            for (Database.DeleteResult dr : drList)
                if (dr.getErrors().size() > 0)
                system.debug('Error deleting milestones '+dr.getErrors()[0].getMessage());
        }
    }
}