public class PricingProposalTriggerHandler extends TriggerHandler {

    Map<Id, PricingProposal__c> oldMap;

    Map<Id, Opportunity> opportunityMap {get;set;}

    public PricingProposalTriggerHandler() {
        oldMap = (Map<Id, PricingProposal__c>)Trigger.oldMap;
    }



    protected override void afterInsert() {


        //importSpecs();
        setOpportunityMap();
        updateDTRApprovers();

    }

    protected override void beforeUpdate() {


        //importSpecs();
        setOpportunityMap();
        updateDTRApprovers();

    }



    public void setOpportunityMap(){

        Set<Id> opportunityIdSet = new Set<Id>();

        for (PricingProposal__c pp : (List<PricingProposal__c>)Trigger.new) {
            opportunityIdSet.add(pp.Opportunity__c);
        }

        opportunityMap = new Map<Id, Opportunity>([select id, RecordType.DeveloperName from Opportunity where id in:opportunityIdSet]);
    }


    private void updateDTRApprovers() {
        //go through every pricing proposal

        List<Approver_Configuration__c> tal;
        List<TWS_Approver__c> twsAL  = new List<TWS_Approver__c>();
      //  List<Sales_Contract_Approver__c> salesContractApprovers  = new List<Sales_Contract_Approver__c>();
        List<String> param = new List<String> {'DTR'};

        //users in tal not in dtr approver list

        Map<Id, PricingProposal__c> oldMap = (Map<Id, PricingProposal__c>)Trigger.oldMap;

        /*
        if (oldMap == null) {

            System.debug('Old Map:' + oldMap);
            return;
        }*/

        Boolean noTrades, noResiduals;

        for (PricingProposal__c pp : (List<PricingProposal__c>)Trigger.new) {

            if (oldMap != null) {
                noTrades = oldMap.get(pp.Id).DTRTrades__c != 'Yes';
                noResiduals = oldMap.get(pp.Id).DTRResiduals__c != 'Yes';
            } else {
                noTrades = true;
                noResiduals = true;
            }

            if ((pp.DTRResiduals__c == 'Yes' && noResiduals) || (pp.DTRTrades__c == 'Yes' && noTrades)) {

                String opptyRecordType = opportunityMap.get(pp.Opportunity__c).RecordType.DeveloperName;

                // PROCESS 1
                String procName = RT_Approval_Process_Map__c.getInstance(opptyRecordType).Picklist_Value__c;

                tal = [SELECT
                       Approver__c
                       FROM Approver_Configuration__c
                       WHERE Make__c IN :param
                             and Process__c = :procName
                       and Approver__c not in (select TWS_Approver__c from TWS_Approver__c where TWS_Deal__c = :pp.Opportunity__c)];

                if ( tal.size()  > 0 ) {
                    for (Approver_Configuration__c a : tal) {
                        twsAL.add(new TWS_Approver__c(TWS_Deal__c = pp.Opportunity__c, TWS_Approver__c = a.Approver__c));

                    }
                } else {
                    System.debug('All DTR Approvers present');
                }

                // PROCESS 2
                procName = RT_Approval_Process_Map__c.getInstance(opptyRecordType).Process_2_Picklist_Value__c;

              /*  tal = [SELECT
                       Approver__c
                       FROM Approver_Configuration__c
                       WHERE Make__c IN :param
                             and Process__c = :procName
                       and Approver__c not in (select Contract_Approver__c from Sales_Contract_Approver__c where TWS_Deal__c = :pp.Opportunity__c)];

                if ( tal.size()  > 0 ) {
                    for (Approver_Configuration__c a : tal) {
           //TO Be changed Anto              salesContractApprovers.add(new Sales_Contract_Approver__c(TWS_Deal__c = pp.Opportunity__c, Contract_Approver__c = a.Approver__c));
                    }
                } else {
                    System.debug('All DTR Approvers present');
                }*/

            } else {
                System.debug(pp.Name + ' :No DTR Specified');
            }
        }

        if (twsAL.size() > 0) {insert twsAL;}
     //   if (salesContractApprovers.size() > 0){insert salesContractApprovers;}


    }
     public static void deleteConCal(list<PricingProposal__c> PPList) {
    
    List<Id> lstId = new List<Id>();
    if(PPList.size()>0){
    
        for(PricingProposal__c ppdetails:PPList){
        If(ppdetails.Contribution_Calculation__c!=null || ppdetails.Contribution_Calculation__c!=''){
        
            lstId.add(ppdetails.Contribution_Calculation__c);
        }
    }
    If(lstId.size()>0){
    
        List<ContributionCalculation__c> cclist = [Select Id from ContributionCalculation__c where Id in:lstId ];
        delete cclist;
    }
    }
    
    
    }
    
    
}