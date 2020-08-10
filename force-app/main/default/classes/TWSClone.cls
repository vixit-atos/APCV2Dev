public with sharing class TWSClone {

    private ApexPages.StandardController standardController;

    private Opportunity opportunityRecord {get; set;}

    private Opportunity newOpportunity {get; set;}

    public TWSClone(ApexPages.StandardController standardController) {

        opportunityRecord = (Opportunity) standardController.getRecord();
    }
    
    
    public PageReference deepCloneWithdraw() {

        newOpportunity = opportunityRecord.clone(false, true);
        newOpportunity.Name =  newOpportunity.Name;
        Opportunity oppRec= [select id,AccountId,Date_Submitted_for_Controlling_Review__c from Opportunity where id=:opportunityRecord.Id];
        //newOpportunity.Related_TC_Deal__c = opportunityRecord.Id;
       // if(opportunityRecord.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('International Sales Proposal Submitted').getRecordTypeId()){
        //       newOpportunity.RecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('International Sales Proposal').getRecordTypeId();
      //  }
        //newOpportunity.Withdraw_Reason__c = opportunityRecord.Withdraw_Reason__c;
        newOpportunity.RevisionDate__c = null;
        newOpportunity.TC_Decision__c = null;
        newOpportunity.StageName='Create TWS';
        
        newOpportunity.AccountId= oppRec.AccountId;
    // newOpportunity.Date_Submitted_for_Controlling_Review__c = oppRec.Date_Submitted_for_Controlling_Review__c;
        System.debug('#newOpportunity ' + newOpportunity);
    try{
                insert newOpportunity;
        }catch(DmlException e){
        System.debug('Exception occurred on insert: ' + e.getMessage()); 
        
        }
      

        clonePricingProposal();
        cloneIncommingUsedTruckInfo();
        cloneComments();
        cloneFooters();
        //cloneApprovers();
       // cloneFiles();
        //cloneTCMeetingNotes();
       // cloneNotificationRecipient();
        delete opportunityRecord;
        PageReference detailPage = new ApexPages.StandardController(newOpportunity).view();

        detailPage.setRedirect(true);

        return detailPage;
    }

    public PageReference deepClone() {

        newOpportunity = opportunityRecord.clone(false, true);
        newOpportunity.Name = '(Copy) ' + newOpportunity.Name;
        newOpportunity.Related_TC_Deal__c = opportunityRecord.Id;
        //if(opportunityRecord.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('International Sales Proposal Submitted').getRecordTypeId())
            
        
        //newOpportunity.Withdraw_Reason__c = opportunityRecord.Withdraw_Reason__c;
        newOpportunity.RevisionDate__c = null;
        newOpportunity.TC_Decision__c = null;
        newOpportunity.StageName='Create TWS';

        System.debug('#newOpportunity ' + newOpportunity);
        
        //Check if NAE/NAD/DM/RGM has been changed their role
        Opportunity opp = [SELECT NAEU__r.SalesUserRole__c, NAD_U__r.SalesUserRole__c, DistrictManager__r.SalesUserRole__c, RGM_U__r.SalesUserRole__c FROM opportunity WHERE id =: opportunityRecord.id];
        if (opp.NAEU__r.SalesUserRole__c != 'NAE') {  newOpportunity.NAEU__c  = null;}
        if( opp.NAD_U__r.SalesUserRole__c != 'NAD') {  newOpportunity.NAD_U__c  = null; }
        if( opp.DistrictManager__r.SalesUserRole__c != 'DM') {  newOpportunity.DistrictManager__c  = null; }
        if( opp.RGM_U__r.SalesUserRole__c != 'RGM') {  newOpportunity.RGM_U__c  = null; }
        
            try{
                insert newOpportunity;
        }catch(DmlException e){
        System.debug('Exception occurred on insert: ' + e.getMessage()); 
        
        }

      

        clonePricingProposal();
        cloneIncommingUsedTruckInfo();
        cloneComments();
        cloneFooters();
        cloneApprovers();
        //cloneTCMeetingNotes();
       if(newOpportunity.RecordTypeID == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('International Sales Proposal').getRecordTypeId())
       
       { cloneFiles();
        cloneNotificationRecipient();
      }
        PageReference detailPage = new ApexPages.StandardController(newOpportunity).view();

        detailPage.setRedirect(true);

        return detailPage;
    }

    public void clonePricingProposal() {

        List<PricingProposal__c> newActualList = new List<PricingProposal__c>();
        List<PricingProposal__c> newProposalList = new List<PricingProposal__c>();
        Map<Id, PricingProposal__c> oldProposalMap = new Map<Id, PricingProposal__c>();
        Map<Id, Id> oldProposalOldActualMap = new Map<Id, Id>();
        Map<Id, PricingProposal__c> oldActualNewActualMap = new Map<Id, PricingProposal__c>();
        Map<Id, PricingProposal__c> oldProposalNewProposalMap = new Map<Id, PricingProposal__c>();

        List<PricingProposal__c> oldProposalAllType = new List<PricingProposal__c>();

        List<PricingProposal__c> pricingProposalList = TWSPricingProposalHandler.getPricingProposalList(opportunityRecord.Id);

        Map<ID, PricingProposal__c> copiedMap = new Map<ID, PricingProposal__c>();
        List<PricingProposal__c> allProps = [select Id,
                Name,
                FEX_Rate__c,
                FET_percentage__c,
                BaseModel__c,
                Reference_Configuration__c,
                ConcessionNumber__c,
                NumberOfUnitsColMin__c,
                NumberOfUnitsColMax__c,
                NumberOfUnitsDealMin__c,
                NumberOfUnitsDealMax__c,
                DTRResiduals__c,
                DTRTrades__c,
                ReferenceSerialNumber__c,
                SleeperType__c,
                EngineMakeHP__c,
                Transmission__c,
                AxleMakeConfig__c,
                PriceLevel__c,
                Dealer_Net__c,
                Dealer_Net_CAD__c,
                Dealer_Net_Disc__c,
                Concession_Percent__c,
                Disc_Min__c,
                Concession_Dollars__c,
                Concession_Dollars_CAD__c,
                Freight__c,
                Freight_CAD__c,
                Dealer_Cost__c,
                Dealer_Cost_CAD__c,
                Dealer_Profit__c,
                Dealer_Profit_CAD__c,
                Selling_Price__c,
                FET_Exempt__c,
                FET_Base__c,
                FET_Base_12__c,
                Less_Tire_Credit__c,
                FET__c,
                CSD_Warranty__c,
                CSD_Warranty_CAD__c,
                Engine_Warranty__c,
                Engine_Warranty_CAD__c,
                Total_Selling_Price__c,
                Total_Selling_Price_CAD__c,
                Contribution_Calculation__c,
                Domicile_Fee__c,
                Dealer_PDI__c,
                Flooring__c,
                Other_Charges__c,
                Dealer_Over_Allowance__c,
                Dealer_Over_Allowance_CAD__c,
                Total_Retail__c,
                Base_Model_Retail__c,
                F_Total_Dnet__c,
                F_Base_Model_Dnet_85__c,
                Base_Model_Discount__c,
                F_Base_Model_Net_Price__c,
                F_Option_Retail__c,
                Option_Discount_at_Retail__c,
                Option_Discount__c,
                Net_Option_Discount__c,
                Option_Dnet__c,
                F_Net_Price_Before_Adj__c,
                F_Effective_Conc__c,
                Standard_Concession__c,
                Daimler_Latina_Add__c,
                DTNA_RSM_Add__c,
                Requested_Add__c,
                Total_Concession__c,
                Approval_Status__c,
                QSpec__c,
                Reference_Configuration__r.Contribution_Calculation__c,
                (select Id,
                 Name,
                 Amount__c,
                 PricingProposal__c
                 from PricingProposalDynamicLineItem__r),
                (select Id,
                 Name,
                 FEX_Rate__c,
                 DTR_Split__c,
                 Dealer_Split__c,
                 Residual_Type__c,
                 Residual_Commit_Number__c,
                 Term_Months__c,
                 Term_Mileage__c,
                 Show_Amnt__c,
                 Show_CAD__c,
                 Hard_Amnt__c,
                 Hard_CAD__c,
                 General_Reserve__c,
                 General_Reserve_CAD__c,
                 Specific_Reserve__c,
                 Specific_Reserve_CAD__c,
                 fTotal_Reserve__c,
                 PWV_Value__c,
                 Rollout_Penalty__c,
                 Rollout_Penalty_CAD__c,
                 Mileage_Penalty__c,
                 Mileage_Penalty_CAD__c,
                 Pricing_Proposal__c
                 from Outgoing_Residuals_Information__r limit 1)
                 from PricingProposal__c
                where Opportunity__c = :opportunityRecord.Id];
                Map<ID, PricingProposal__c> mapToCopy = new Map<ID, PricingProposal__c>(allProps);

        PricingProposal__c tempPP;


        //copy all the proposals

        for (PricingProposal__c iter : allProps) {
            tempPP = iter.clone();
            tempPP.Reference_Configuration__c = null;
            tempPP.Opportunity__c = newOpportunity.id;
            
            copiedMap.put(iter.id,tempPP);
        }

        
            try{
              insert copiedMap.values();
        }catch(DmlException e){
        System.debug('Exception occurred on insert: ' + e.getMessage()); 
        
        }
    
      


        //set all the references

        for(PricingProposal__c iter : mapToCopy.values()) {
            if (iter.Reference_Configuration__c != null) {
                copiedMap.get(iter.id).Reference_Configuration__c = copiedMap.get(iter.Reference_Configuration__c).Id;
            }
        }
        List<Opportunity> oppRecordType = [SELECT ID, RecordTypeID FROM Opportunity WHERE ID =: opportunityRecord.id];
        if(oppRecordType[0].RecordTypeID != Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('International Sales Proposal').getRecordTypeId()){
        
        
            try{
              upsert copiedMap.values();
        }catch(DmlException e){
        System.debug('Exception occurred on insert: ' + e.getMessage()); 
        
        }
    
      
            }

/*
        for (PricingProposal__c iter : mapToCopy.values()) {
            if (iter.Reference_Configuration__c == null) {
                //clone
                tempPP = iter.clone();
                tempPP.Opportunity__c = newOpportunity.id;
                copiedMap.put(iter.id,tempPP);
                mapToCopy.remove(iter.id);
                System.debug('Cloning no ref:' + iter.Name);


            }

        }
        
        try{
             insert copiedMap.values();
        }catch(DmlException e){
        System.debug('Exception occurred on insert: ' + e.getMessage()); 
        
        }
    


      
        
        

        while (!mapToCopy.isEmpty()) {
            List<PricingProposal__c> tempList = new List<PricingProposal__c>();

            for (PricingProposal__c iter : mapToCopy.values()) {
                if (copiedMap.containsKey(iter.Reference_Configuration__c)) {
                    //clone
                    tempPP = iter.clone();
                    tempPP.Opportunity__c = newOpportunity.id;
                    tempPP.Reference_Configuration__c = copiedMap.get(iter.Reference_Configuration__c).id;
                    
                    System.debug('Cloning ref:' + iter.Name + ' setting ' + copiedMap.get(iter.Reference_Configuration__c)) ;

                    copiedMap.put(iter.id,tempPP);

                    tempList.add(tempPP);
                    
                    mapToCopy.remove(iter.id);
                    
                }

            }

            System.debug('Inserting' + tempList);
            
            try{
            if(tempList.size()>0){
                insert tempList;
            }
        }catch(DmlException e){
        System.debug('Exception occurred on insert: ' + e.getMessage()); 
        
        }
    

         
            
            System.debug('After' + tempList);

        }
*/
        clonePricingProposalItems(allProps, copiedMap);
        cloneOutgoingResiduals(allProps, copiedMap);
        cloneChassisWarrantyInfo(copiedMap);
        cloneEngineWarrantyInfo(copiedMap);
/*
        //everything but actual
        for (PricingProposal__c iter : pricingProposalList) {
            oldProposalMap.put(iter.Id, iter);
            oldProposalOldActualMap.put(iter.Id, iter.Reference_Configuration__c);
            oldProposalAllType.add(iter);
        }

        Map<Id, PricingProposal__c> oldActualMap = TWSPricingProposalHandler.getProposalMap(new Set<Id>(oldProposalOldActualMap.values()));

        //clone references
        for (PricingProposal__c iter : oldActualMap.values()) {

            PricingProposal__c actualProposal = iter.clone();

            if (actualProposal.Less_Tire_Credit__c == null) {
                actualProposal.Less_Tire_Credit__c = 0;
            }
            if (actualProposal.Dealer_Profit__c == null) {
                actualProposal.Dealer_Profit__c = 0;
            }

            actualProposal.Opportunity__c = newOpportunity.Id;
            newActualList.add(actualProposal);

            oldProposalAllType.add(iter);
            oldActualNewActualMap.put(iter.Id, actualProposal);

            oldProposalNewProposalMap.put(iter.Id, actualProposal);
        }

        //insert reference Proposals
            try{
            if(newActualList.size()>0){
                insert newActualList;
            }
        }catch(DmlException e){
        System.debug('Exception occurred on insert: ' + e.getMessage()); 
        
        }
    

        List<PricingProposal__c> proposalToUpdate = new List<PricingProposal__c>();

        //clone proposals
        for (PricingProposal__c iter : pricingProposalList) {

            PricingProposal__c proposal = iter.clone();

            if (proposal.Less_Tire_Credit__c == null) {
                proposal.Less_Tire_Credit__c = 0;
            }
            if (proposal.Dealer_Profit__c == null) {
                proposal.Dealer_Profit__c = 0;
            }

            proposal.Opportunity__c = newOpportunity.Id;

            if (iter.Reference_Configuration__c != null) {
                proposal.Reference_Configuration__c = oldActualNewActualMap.get(iter.Reference_Configuration__c).Id;
            }

            newProposalList.add(proposal);
            oldProposalNewProposalMap.put(iter.Id, proposal);
        }

        //insert Proposals
            try{
            if(newProposalList.size()>0){
                insert newProposalList;
            }
        }catch(DmlException e){
        System.debug('Exception occurred on insert: ' + e.getMessage()); 
        
        }
      
  

        clonePricingProposalItems(oldProposalAllType, oldProposalNewProposalMap);
        cloneOutgoingResiduals(oldProposalAllType, oldProposalNewProposalMap);
        cloneChassisWarrantyInfo(oldProposalNewProposalMap);
        cloneEngineWarrantyInfo(oldProposalNewProposalMap);

        */
    }

    public void clonePricingProposalItems(List<PricingProposal__c> proposalList, Map<Id, PricingProposal__c> oldProposalNewProposalMap) {

        List<PricingProposalDynamicLineItem__c> newlineItemList = new List<PricingProposalDynamicLineItem__c> ();

        for (PricingProposal__c iter : proposalList) {

            for (PricingProposalDynamicLineItem__c item : iter.PricingProposalDynamicLineItem__r) {

                PricingProposalDynamicLineItem__c newLineItem = item.clone();
                newLineItem.PricingProposal__c = oldProposalNewProposalMap.get(item.PricingProposal__c).Id;

                newlineItemList.add(newLineItem);
            }
        }

        System.debug('#newlineItemList ' + newlineItemList);
        try{
            if(newlineItemList.size()>0){
                insert newlineItemList;
            }
        }catch(DmlException e){
        System.debug('Exception occurred on insert: ' + e.getMessage()); 
        
        }
      

    }

    public void cloneComments() {

        List<Deal_Summary_Pricing_Strategy__c> newDealSummaryAndPricingStrategyList = new List<Deal_Summary_Pricing_Strategy__c>();
        List<Contribution_Cost_Comment__c> newContributionCostCommentsList = new List<Contribution_Cost_Comment__c>();
        List<Residual_Quote_Comment__c> newResidualQuoteCommentsList = new List<Residual_Quote_Comment__c>();
        List<Chassis_Extended_Warranty_Comment__c> newChassisWarrantyCommentsList = new List<Chassis_Extended_Warranty_Comment__c>();
        List<Engine_Extended_Warranty_Comment__c> newEngineWarrantyCommentsList = new List<Engine_Extended_Warranty_Comment__c>();
        List<Commitment_Outside_Sales_Terms__c> newCommitmentsOutsideSalesTermsList = new List<Commitment_Outside_Sales_Terms__c>();

        Opportunity opp = [
                              select Id,
                              (select id, Comment__c from Contribution_Cost_Comments__r),
                              (select id, Comment__c from Residual_Quote_Comments__r),
                              (select id, Comment__c from Chassis_Extended_Warranty_Comments__r),
                              (select id, Comment__c from Engine_Extended_Warranty_Comments__r),
                              (select id, Comment__c from Commitments_Outside_Sales_Terms__r),
                              (select id, Deal_Summary_Pricing_Strategy__c from Deal_Summary_Pricing_Strategy__r)
                              from Opportunity
                              where id = : opportunityRecord.Id];

        System.debug('#opp ' + opp);

        for (Deal_Summary_Pricing_Strategy__c iter : opp.Deal_Summary_Pricing_Strategy__r) {

            Deal_Summary_Pricing_Strategy__c newDealSummaryAndPricingStrategy = iter.clone();
            newDealSummaryAndPricingStrategy.Opportunity__c = newOpportunity.Id;

            newDealSummaryAndPricingStrategyList.add(newDealSummaryAndPricingStrategy);
        }
try{
            if(newDealSummaryAndPricingStrategyList.size()>0){
                insert newDealSummaryAndPricingStrategyList;
            }
        }catch(DmlException e){
        System.debug('Exception occurred on insert: ' + e.getMessage()); 
        
        }
      

        for (Contribution_Cost_Comment__c iter : opp.Contribution_Cost_Comments__r) {

            Contribution_Cost_Comment__c newContributionCostComment = iter.clone();
            newContributionCostComment.Opportunity__c = newOpportunity.Id;

            newContributionCostCommentsList.add(newContributionCostComment);
        }
try{
            if(newContributionCostCommentsList.size()>0){
                insert newContributionCostCommentsList;
            }
        }catch(DmlException e){
        System.debug('Exception occurred on insert: ' + e.getMessage()); 
        
        }
        

        for (Residual_Quote_Comment__c iter : opp.Residual_Quote_Comments__r) {

            Residual_Quote_Comment__c newResidualQuoteComment = iter.clone();
            newResidualQuoteComment.Opportunity__c = newOpportunity.Id;

            newResidualQuoteCommentsList.add(newResidualQuoteComment);
        }
try{
            if(newResidualQuoteCommentsList.size()>0){
                insert newResidualQuoteCommentsList;
            }
        }catch(DmlException e){
        System.debug('Exception occurred on insert: ' + e.getMessage()); 
        
        }
       

        for (Chassis_Extended_Warranty_Comment__c iter : opp.Chassis_Extended_Warranty_Comments__r) {

            Chassis_Extended_Warranty_Comment__c newChassisExtendedWarantyComment = iter.clone();
            newChassisExtendedWarantyComment.Opportunity__c = newOpportunity.Id;

            newChassisWarrantyCommentsList.add(newChassisExtendedWarantyComment);
        }
        try{
            if(newChassisWarrantyCommentsList.size()>0){
                insert newChassisWarrantyCommentsList;
            }
        }catch(DmlException e){
        System.debug('Exception occurred on insert: ' + e.getMessage()); 
        
        }
      

        for (Engine_Extended_Warranty_Comment__c iter : opp.Engine_Extended_Warranty_Comments__r) {

            Engine_Extended_Warranty_Comment__c newEngineWarantyComment = iter.clone();
            newEngineWarantyComment.Opportunity__c = newOpportunity.Id;

            newEngineWarrantyCommentsList.add(newEngineWarantyComment);
        }
        try{
            if(newEngineWarrantyCommentsList.size()>0){
                insert newEngineWarrantyCommentsList;
            }
        }catch(DmlException e){
        System.debug('Exception occurred on insert: ' + e.getMessage()); 
        
        }
       

        for (Commitment_Outside_Sales_Terms__c iter : opp.Commitments_Outside_Sales_Terms__r) {

            Commitment_Outside_Sales_Terms__c newCommitmentsOutsideSalesTerm = iter.clone();
            newCommitmentsOutsideSalesTerm.Opportunity__c = newOpportunity.Id;

            newCommitmentsOutsideSalesTermsList.add(newCommitmentsOutsideSalesTerm);
        }
        try{
            if(newCommitmentsOutsideSalesTermsList.size()>0){
                insert newCommitmentsOutsideSalesTermsList;
            }
        }catch(DmlException e){
        System.debug('Exception occurred on insert: ' + e.getMessage()); 
        
        }
       
    }

    public void cloneOutgoingResiduals(List<PricingProposal__c> proposalList, Map<Id, PricingProposal__c> oldProposalNewProposalMap) {

        List<Outgoing_Residuals_Info__c> newOutgoingResidualList = new List<Outgoing_Residuals_Info__c> ();

        for (PricingProposal__c iter : proposalList) {

            for (Outgoing_Residuals_Info__c item : iter.Outgoing_Residuals_Information__r) {

                Outgoing_Residuals_Info__c newOutgoingResidual = item.clone();
                newOutgoingResidual.Pricing_Proposal__c = oldProposalNewProposalMap.get(item.Pricing_Proposal__c).Id;
                newOutgoingResidual.Opportunity__c = newOpportunity.Id;

                newOutgoingResidualList.add(newOutgoingResidual);
            }
        }

        System.debug('#newOutgoingResidualList ' + newOutgoingResidualList);
        
        
        try{
            if(newOutgoingResidualList.size()>0){
                insert newOutgoingResidualList;
            }
        }catch(DmlException e){
        System.debug('Exception occurred on insert: ' + e.getMessage()); 
        
        }


  
    }

    public void cloneIncommingUsedTruckInfo() {

        Map<Id, Incoming_Used_Truck_Information__c> oldNewIncomingUsedTruckMap = new Map<Id, Incoming_Used_Truck_Information__c>();

        List<Incoming_Used_Truck_Information__c> newIncomingUsedTruckList = new List<Incoming_Used_Truck_Information__c>();

        List<Incoming_Used_Truck_Information__c> incomingUsedTruckInfoList = TWSIncomingUsedTruckHandler.getIncomingUsedTruckList(opportunityRecord.Id);

        for (Incoming_Used_Truck_Information__c iter : incomingUsedTruckInfoList) {

            Incoming_Used_Truck_Information__c newIncomingUsedTruckInfo = iter.clone();
            newIncomingUsedTruckInfo.Opportunity__c = newOpportunity.Id;

            newIncomingUsedTruckList.add(newIncomingUsedTruckInfo);

            oldNewIncomingUsedTruckMap.put(iter.Id, newIncomingUsedTruckInfo);
        }

        System.debug('#newIncomingUsedTruckList ' + newIncomingUsedTruckList);
        
            
        try{
            if(newIncomingUsedTruckList.size()>0){
                insert newIncomingUsedTruckList;
            }
        }catch(DmlException e){
        System.debug('Exception occurred on insert: ' + e.getMessage()); 
        
        }

    

        cloneIncommingUsedTruckInfoLineItems(incomingUsedTruckInfoList, oldNewIncomingUsedTruckMap);
        cloneIncommingUsedTruckInfoComments(incomingUsedTruckInfoList, oldNewIncomingUsedTruckMap);
    }

    public void cloneIncommingUsedTruckInfoLineItems(List<Incoming_Used_Truck_Information__c> incomingUsedTruckList, Map<Id, Incoming_Used_Truck_Information__c> oldNewIncomingUsedTruckMap) {

        List<IncomingUsedTruckLineItem__c> newIncomingUsedTruckLineItemList = new List<IncomingUsedTruckLineItem__c> ();

        for (Incoming_Used_Truck_Information__c iter : incomingUsedTruckList) {

            for (IncomingUsedTruckLineItem__c item : iter.IncomingUsedTruckLineItem__r) {

                IncomingUsedTruckLineItem__c newLineItem = item.clone();
                newLineItem.IncomingUsedTruck__c = oldNewIncomingUsedTruckMap.get(item.IncomingUsedTruck__c).Id;

                newIncomingUsedTruckLineItemList.add(newLineItem);
            }
        }

        System.debug('#newIncomingUsedTruckLineItemList ' + newIncomingUsedTruckLineItemList);
        
        try{
            if(newIncomingUsedTruckLineItemList.size()>0){
                insert newIncomingUsedTruckLineItemList;
            }
        }catch(DmlException e){
        System.debug('Exception occurred on insert: ' + e.getMessage()); 
        
        }

   
    }

    public void cloneIncommingUsedTruckInfoComments(List<Incoming_Used_Truck_Information__c> incomingUsedTruckList, Map<Id, Incoming_Used_Truck_Information__c> oldNewIncomingUsedTruckMap) {

        List<Incoming_Used_Truck_Comment__c> newIncomingUsedTruckCommentsList = new List<Incoming_Used_Truck_Comment__c> ();

        for (Incoming_Used_Truck_Information__c iter : incomingUsedTruckList) {

            for (Incoming_Used_Truck_Comment__c item : iter.Incoming_Used_Truck_Comments__r) {

                Incoming_Used_Truck_Comment__c newComment = item.clone();
                newComment.Incoming_Used_Truck_Information__c = oldNewIncomingUsedTruckMap.get(item.Incoming_Used_Truck_Information__c).Id;
                newComment.Opportunity__c = newOpportunity.Id;

                newIncomingUsedTruckCommentsList.add(newComment);
            }
        }

        System.debug('#newIncomingUsedTruckCommentsList ' + newIncomingUsedTruckCommentsList);
        
        try{
            if(newIncomingUsedTruckCommentsList.size()>0){
                insert newIncomingUsedTruckCommentsList;
            }
        }catch(DmlException e){
        System.debug('Exception occurred on insert: ' + e.getMessage()); 
        
        }

       
    }

    public void cloneChassisWarrantyInfo(Map<Id, PricingProposal__c> oldProposalNewProposalMap) {

        List<ChassisWarrantyConfigurationRollup__c> newchassisWarrantyInfoList = new List<ChassisWarrantyConfigurationRollup__c>();

        Set<Id> proposalIds = oldProposalNewProposalMap.keySet();

        Map<Id, ChassisWarrantyConfigurationRollup__c> oldNewChassisWrrantyMap = new Map<Id, ChassisWarrantyConfigurationRollup__c>();

        List<ChassisWarrantyConfigurationRollup__c> chassisWarrantyInfoList = TWSChassisWarrantyHandler.getChassisWarrantyList(proposalIds);

        for (ChassisWarrantyConfigurationRollup__c iter : chassisWarrantyInfoList) {

            ChassisWarrantyConfigurationRollup__c newChassiWarrantyInfo = iter.clone();
            newChassiWarrantyInfo.Opportunity__c = newOpportunity.Id;
            newChassiWarrantyInfo.PricingProposal__c = oldProposalNewProposalMap.get(iter.PricingProposal__c).Id;

            newchassisWarrantyInfoList.add(newChassiWarrantyInfo);

            oldNewChassisWrrantyMap.put(iter.Id, newChassiWarrantyInfo);
        }

        System.debug('#newchassisWarrantyInfoList ' + newchassisWarrantyInfoList);
        try{
            if(newchassisWarrantyInfoList.size()>0){
                insert newchassisWarrantyInfoList;
            }
        }catch(DmlException e){
        System.debug('Exception occurred on insert: ' + e.getMessage()); 
        
        }
       

        cloneChassisWarrantyElements(chassisWarrantyInfoList, oldNewChassisWrrantyMap);
    }

    public void cloneChassisWarrantyElements(List<ChassisWarrantyConfigurationRollup__c> chassisWarrantyInfoList, Map<Id, ChassisWarrantyConfigurationRollup__c> oldNewChassisWrrantyMap) {

        List<ChassisWarrantyPricingElement__c> chassisWarrantyElementList = new List<ChassisWarrantyPricingElement__c>();

        for (ChassisWarrantyConfigurationRollup__c iter : chassisWarrantyInfoList) {

            for (ChassisWarrantyPricingElement__c elem : iter.Chassis_Warranty_Pricing_Elements__r) {

                ChassisWarrantyPricingElement__c newchassisWarrantyElement = elem.clone();
                newchassisWarrantyElement.Configuration_Chassis_Warranty_Pricing__c = oldNewChassisWrrantyMap.get(elem.Configuration_Chassis_Warranty_Pricing__c).Id;

                chassisWarrantyElementList.add(newchassisWarrantyElement);
            }
        }

        try{
            if(chassisWarrantyElementList.size()>0){
                insert chassisWarrantyElementList;
            }
        }catch(DmlException e){
        System.debug('Exception occurred on insert: ' + e.getMessage()); 
        
        }
        
       

    }

    public void cloneEngineWarrantyInfo(Map<Id, PricingProposal__c> oldProposalNewProposalMap) {

        List<EngineWarrantyPricingLineItem__c> newEngineWarrantyInfoList = new List<EngineWarrantyPricingLineItem__c>();

        Set<Id> proposalIds = oldProposalNewProposalMap.keySet();

        List<EngineWarrantyPricingLineItem__c> engineWarrantyInfoList = TWSEngineWarrantyHandler.getEngineWarrantyList(opportunityRecord.Id);

        for (EngineWarrantyPricingLineItem__c iter : engineWarrantyInfoList) {

            EngineWarrantyPricingLineItem__c newEngineWarrantyInfo = iter.clone();
            newEngineWarrantyInfo.Opportunity__c = newOpportunity.Id;
            newEngineWarrantyInfo.PricingProposal__c = oldProposalNewProposalMap.get(iter.PricingProposal__c).Id;

            newEngineWarrantyInfoList.add(newEngineWarrantyInfo);
        }

        System.debug('#newEngineWarrantyInfoList ' + newEngineWarrantyInfoList);
        
        try{
            if(newEngineWarrantyInfoList.size()>0){
                insert newEngineWarrantyInfoList;
            }
        }catch(DmlException e){
        System.debug('Exception occurred on insert: ' + e.getMessage()); 
        
        }

    
    }

    public void cloneFooters() {

        List<Footer__c> newFooterList = new List<Footer__c>();

        List<Footer__c> footerList = TWSFooterHandler.getFooterList(opportunityRecord.Id);

        Map<Id, Footer__c> oldIdNewFooter = new Map<Id, Footer__c>();

        for (Footer__c footer : footerList) {

            Footer__c newFooter = footer.clone();
            newFooter.Opportunity__c = newOpportunity.Id;

            newFooterList.add(newFooter);
            oldIdNewFooter.put(footer.Id, newFooter);
        }
        try{
            if(newFooterList.size()>0){
                insert newFooterList;
            }
        }catch(DmlException e){
        System.debug('Exception occurred on insert: ' + e.getMessage()); 
        
        }
       

        List<Footer_Line_Item__c> itemList = new List<Footer_Line_Item__c>();

        for (Footer__c footer : footerList) {

            for (Footer_Line_Item__c item : footer.Footer_Line_Items__r) {

                Footer_Line_Item__c newItem = item.clone();

                newItem.Footer__c = oldIdNewFooter.get(item.Footer__c).Id;

                itemList.add(newItem);
            }
        }
        try{
            if(itemList.size()>0){
                insert itemList;
            }
        }catch(DmlException e){
        System.debug('Exception occurred on insert: ' + e.getMessage()); 
        
        }
       
    }

    public void cloneApprovers() {

        List<TWS_Approver__c> newApproverList = new List<TWS_Approver__c>();

        List<TWS_Approver__c> approverList = [select id, Name, TWS_Approver__c, TWS_Deal__c, Actual_Approver__c  from TWS_Approver__c where TWS_Deal__c = : opportunityRecord.Id];

        for (TWS_Approver__c approver : approverList) {

            TWS_Approver__c newApprover = approver.clone();
            newApprover.TWS_Deal__c = newOpportunity.Id;
            newApprover.Actual_Approver__c = newApprover.TWS_Approver__c;
            newApproverList.add(newApprover);
        }
        try{
            if(newApproverList.size()>0){
                insert newApproverList;
            }
        }catch(DmlException e){
        System.debug('Exception occurred on insert: ' + e.getMessage()); 
        
        }
       
    }

    public void cloneTCMeetingNotes() {

        List<TC_Meeting_Note__c> newTCMeetingNoteList = new List<TC_Meeting_Note__c>();

        List<TC_Meeting_Note__c> tCMeetingNoteList = [select id, Name, TC_Meeting__c, TCM_Note__c, TWS_Deal__c from TC_Meeting_Note__c where TWS_Deal__c = : opportunityRecord.Id];

        for (TC_Meeting_Note__c note : tCMeetingNoteList) {

            TC_Meeting_Note__c newNote = note.clone();
            newNote.TWS_Deal__c = newNote.Id;

            newTCMeetingNoteList.add(newNote);
        }
        
        try{
            if(newTCMeetingNoteList.size()>0){
                insert newTCMeetingNoteList;
            }
        }catch(DmlException e){
        System.debug('Exception occurred on insert: ' + e.getMessage()); 
        
        }
        
      
    }

    public void cloneNotificationRecipient() {

        List<Notification_Recipient__c> newNotificationRecipientList = new List<Notification_Recipient__c>();

        List<Notification_Recipient__c> notificationRecipientList = [select id, Name, Send_Email__c, Email_Sent__c, Notification_Recipient__c from Notification_Recipient__c where TWS_Deal__c = : opportunityRecord.Id];

        for (Notification_Recipient__c notification : notificationRecipientList) {

            Notification_Recipient__c newNotification = notification.clone();
            newNotification.TWS_Deal__c = newOpportunity.Id;

            newNotificationRecipientList.add(newNotification);
        }
        
        try{
            if(newNotificationRecipientList.size()>0){
                insert newNotificationRecipientList;
            }
        }catch(DmlException e){
        System.debug('Exception occurred on insert: ' + e.getMessage()); 
        
        }
        
        
    
    }
    
    public void cloneFiles() {

        List<ContentDocumentLink> newContentDocumentLinkList = new List<ContentDocumentLink>();
        
List<ContentDocumentLink> allContentDocumentLink=[SELECT ContentDocumentId,Id,IsDeleted,LinkedEntityId,ShareType,SystemModstamp,Visibility  FROM ContentDocumentLink WHERE LinkedEntityId = : opportunityRecord.Id];
    system.debug('allContentDocumentLink::::'+allContentDocumentLink);

        for (ContentDocumentLink allContentDocument : allContentDocumentLink) {

            ContentDocumentLink  newContentDocumentLink  = allContentDocument.clone();
            newContentDocumentLink.LinkedEntityId = newOpportunity.Id;
            newContentDocumentLink.ShareType = 'V';


            newContentDocumentLinkList.add(newContentDocumentLink);
        }

       
        
        
        try{
            if(newContentDocumentLinkList.size()>0){
                insert newContentDocumentLinkList;
            }
        }catch(DmlException e){
        System.debug('Exception occurred on insert: ' + e.getMessage()); 
        
        }
    }
}