public with sharing class TWSPricingProposalLineItemHandler  extends TriggerHandler{

    //Set<ProposalId/ActualId>
    Set<Id> allTypeProposalSet = new Set<Id>();

    //Map<proposalId, actualId>
    private Map<Id, Id> proposalActualMap {get;set;}

    //Map<proposalId, Map<name, proposalLineItem>>
    private Map<Id, Map<String, PricingProposalDynamicLineItem__c>> proposalLineItemMap {get;set;}

    //proposalId, lineItemName
    Map<Id, Set<String>> lineItemsToUpdate = new Map<Id, Set<String>>();

    //Map<ProposalId, ConribCalcId>
    Map<Id, Id> proposalContributionCalcMap {get;set;}

    //Map<ContribCalcId, Map<ContribCalcName, ContrCalcLineItems>>
    Map<Id, Map<String, ContributionCalculationDynamicLineItem__c>> contribCalcLineItems {get;set;}

    public void setProposalMaps(List<PricingProposalDynamicLineItem__c> proposalLineItemList){

        Set <Id> proposalIdSet = new Set<Id>();
        proposalActualMap = new Map<Id, Id>();

        proposalLineItemList = [select id, Name, PricingProposal__c from PricingProposalDynamicLineItem__c where id=:proposalLineItemList];

        for(PricingProposalDynamicLineItem__c item : proposalLineItemList){
            proposalIdSet.add(item.PricingProposal__c);

            if (lineItemsToUpdate.get(item.PricingProposal__c) == null){
                lineItemsToUpdate.put(item.PricingProposal__c, new Set<String>());
            }
            lineItemsToUpdate.get(item.PricingProposal__c).add(item.Name);
        }

        for (PricingProposal__c iter: [select id, Contribution_Calculation__c, Reference_Configuration__c, RecordType.DeveloperName from PricingProposal__c where id in:proposalIdSet or Reference_Configuration__c in:proposalIdSet]){

            if (iter.RecordType.DeveloperName != 'Actual'){
                proposalActualMap.put(iter.Id, iter.Reference_Configuration__c);
                allTypeProposalSet.add(iter.Id);
                allTypeProposalSet.add(iter.Reference_Configuration__c);
            }
        }

        proposalLineItemMap = new Map<Id, Map<String, PricingProposalDynamicLineItem__c>>();

        for (PricingProposalDynamicLineItem__c lineItem: [select id, Amount__c, Name, PricingProposal__c from PricingProposalDynamicLineItem__c where PricingProposal__c in: allTypeProposalSet]){

            if (proposalLineItemMap.get(lineItem.PricingProposal__c) == null){
                proposalLineItemMap.put(lineItem.PricingProposal__c, new Map<String, PricingProposalDynamicLineItem__c>());
            }

            proposalLineItemMap.get(lineItem.PricingProposal__c).put(lineItem.Name, lineItem);
        }

    }

    public void setContribCalculationMap(List<PricingProposalDynamicLineItem__c> proposalLineItemList){

        proposalContributionCalcMap = new Map<Id, Id>();

        Set<Id> proposalIdSet = new Set<Id>();

        for (PricingProposalDynamicLineItem__c item: proposalLineItemList){
            proposalIdSet.add(item.PricingProposal__c);
        }

        for (PricingProposal__c iter: [select id, Contribution_Calculation__c from PricingProposal__c where id in:proposalIdSet]){
            proposalContributionCalcMap.put(iter.Id, iter.Contribution_Calculation__c);
        }

        List<ContributionCalculation__c> contribCalcList = [select id, (select id, Amount__c, Name from ContributionCalcDynamicLineItem__r) from ContributionCalculation__c where id in:proposalContributionCalcMap.values()];

        contribCalcLineItems = new Map<Id, Map<String, ContributionCalculationDynamicLineItem__c>>();

        for (ContributionCalculation__c iter: contribCalcList){

            Map<String, ContributionCalculationDynamicLineItem__c> itemMap = new Map<String, ContributionCalculationDynamicLineItem__c>();

            for (ContributionCalculationDynamicLineItem__c item: iter.ContributionCalcDynamicLineItem__r){

                itemMap.put(item.Name, item);
            }

            contribCalcLineItems.put(iter.Id, itemMap);
        }
    }

    private void recalculatePriceWalkLineItems(){

        List<PriceWalkLineItem__c> newPriceWalkLineItems = new List<PriceWalkLineItem__c>();

        //proposalId, Set<LineItemName>
        Map<Id, Set<String>> priceWalkLineItemsToDelete = new Map<Id, Set<String>>();

        for (Id iter: proposalActualMap.keySet()){

            Id proposal = iter;
            Id actual = proposalActualMap.get(iter);

            Set<String> lineItemsToUpdateAll = new Set<String>();

            //proposal line item names codes to update
            if (lineItemsToUpdate.get(iter)!= null){
                lineItemsToUpdateAll = lineItemsToUpdate.get(iter);
            }

            //actual proposal line item names to update
            if (actual != null && lineItemsToUpdate.get(actual) != null){
                lineItemsToUpdateAll.addAll(lineItemsToUpdate.get(actual));
            }

            for (String lineItemName: lineItemsToUpdateAll){

                System.debug('#lineItemName '+lineItemName);

                Double proposalAmount = 0;
                Double actualAmount = 0;

                //proposal
                if(proposalLineItemMap.get(iter) != null){

                    Map<String, PricingProposalDynamicLineItem__c> lineItemMap = proposalLineItemMap.get(iter);

                    System.debug('#lineItemMap '+lineItemMap);

                    if (lineItemMap.get(lineItemName) != null){
                        proposalAmount = lineItemMap.get(lineItemName).Amount__c;
                    }
                }

                //actual
                if (proposalLineItemMap.get(actual) != null){

                    Map<String, PricingProposalDynamicLineItem__c> actualLineItemMap = proposalLineItemMap.get(actual);

                    System.debug('#actualLineItemMap '+actualLineItemMap);

                    if (actualLineItemMap.get(lineItemName) != null){

                        actualAmount = actualLineItemMap.get(lineItemName).Amount__c;
                    }
                }
                
                if(proposalAmount == null) proposalAmount = 0; // AN for Amount null error fix

                System.debug('#proposalAmount '+proposalAmount);
                System.debug('#actualAmount '+actualAmount);

                PriceWalkLineItem__c newPriceWalkLineItem = new PriceWalkLineItem__c();

                newPriceWalkLineItem.Pricing_Proposal__c = proposal;
                newPriceWalkLineItem.Name = lineItemName;
                newPriceWalkLineItem.Amount__c = proposalAmount - actualAmount;

                newPriceWalkLineItems.add(newPriceWalkLineItem);

                //price walk items to delete
                if (priceWalkLineItemsToDelete.get(proposal) == null){
                    priceWalkLineItemsToDelete.put(proposal, new Set<String>());
                }

                priceWalkLineItemsToDelete.get(proposal).add(lineItemName);

            }
        }

        deleteExistingPriceWalkLineItems(priceWalkLineItemsToDelete);

        createPriceWalkLineItems(newPriceWalkLineItems);
    }

    public void deleteExistingPriceWalkLineItems(Map<Id, Set<String>> priceWalkLineItems){

        List<PriceWalkLineItem__c> lineItemsToDelete = new List<PriceWalkLineItem__c>();

        if (priceWalkLineItems.keySet() != null){

            for (PriceWalkLineItem__c iter: [select id, Pricing_Proposal__c, Name from PriceWalkLineItem__c where Pricing_Proposal__c in:priceWalkLineItems.keySet()]){

                if (priceWalkLineItems.get(iter.Pricing_Proposal__c).contains(iter.Name)){
                    lineItemsToDelete.add(iter);
                }
            }
        }

        delete lineItemsToDelete;
    }

    public void createPriceWalkLineItems(List<PriceWalkLineItem__c> newPriceWalkLineItems){

        insert newPriceWalkLineItems;
    }

    public void createContributionCalculationLineItems(List<PricingProposalDynamicLineItem__c> proposalLineItems){

        List<ContributionCalculationDynamicLineItem__c> newContribCalcLineItemList = new List<ContributionCalculationDynamicLineItem__c>();

        for (PricingProposalDynamicLineItem__c proposalLineItem: proposalLineItems){

            Id proposalId = proposalLineItem.PricingProposal__c;

            if (proposalContributionCalcMap.get(proposalId) != null){

                Id contribCalcId = proposalContributionCalcMap.get(proposalId);

                ContributionCalculationDynamicLineItem__c newContribCalcLineItem = new ContributionCalculationDynamicLineItem__c();

                newContribCalcLineItem.Name = proposalLineItem.Name;
                newContribCalcLineItem.Amount__c = proposalLineItem.Amount__c;
                newContribCalcLineItem.Contribution_Calculation__c = contribCalcId;

                newContribCalcLineItemList.add(newContribCalcLineItem);
            }
        }

        insert newContribCalcLineItemList;
    }

    public void deleteContributionCalculationLineItems(List<PricingProposalDynamicLineItem__c> proposalLineItems){

        List<ContributionCalculationDynamicLineItem__c> contribCalcLineItemListToDelete = new List<ContributionCalculationDynamicLineItem__c>();

        for (PricingProposalDynamicLineItem__c proposalLineItem: proposalLineItems){

            Id proposalId = proposalLineItem.PricingProposal__c;

            System.debug('#proposalContributionCalcMap '+proposalContributionCalcMap);

            if (proposalContributionCalcMap.get(proposalId) != null){

                Id contribCalcId = proposalContributionCalcMap.get(proposalId);

                if (contribCalcLineItems.get(contribCalcId) != null){

                    Map<String, ContributionCalculationDynamicLineItem__c> contributionCalcLineItemMap = contribCalcLineItems.get(contribCalcId);

                    if (contributionCalcLineItemMap.get(proposalLineItem.Name) != null){
                        contribCalcLineItemListToDelete.add(contributionCalcLineItemMap.get(proposalLineItem.Name));
                    }
                }
            }
        }

        delete contribCalcLineItemListToDelete;
    }

    public void updateContributionCalculationLineItems(List<PricingProposalDynamicLineItem__c> proposalLineItems){

        List<ContributionCalculationDynamicLineItem__c> contribCalcLineItemListToUpdate = new List<ContributionCalculationDynamicLineItem__c>();

        for (PricingProposalDynamicLineItem__c proposalLineItem: proposalLineItems){

            Id proposalId = proposalLineItem.PricingProposal__c;

            System.debug('#proposalContributionCalcMap '+proposalContributionCalcMap);

            if (proposalContributionCalcMap.get(proposalId) != null){

                Id contribCalcId = proposalContributionCalcMap.get(proposalId);

                if (contribCalcLineItems.get(contribCalcId) != null){

                    Map<String, ContributionCalculationDynamicLineItem__c> contributionCalcLineItemMap = contribCalcLineItems.get(contribCalcId);

                    if (contributionCalcLineItemMap.get(proposalLineItem.Name) != null){

                        ContributionCalculationDynamicLineItem__c lineItemToUpdate = contributionCalcLineItemMap.get(proposalLineItem.Name);
                        lineItemToUpdate.Amount__c = proposalLineItem.Amount__c;

                        contribCalcLineItemListToUpdate.add(lineItemToUpdate);
                    }
                }
            }
        }

        update contribCalcLineItemListToUpdate;
    }

    protected override void afterInsert() {

        List<PricingProposalDynamicLineItem__c> proposalLineItemList = (List<PricingProposalDynamicLineItem__c>)Trigger.new;

        setProposalMaps(proposalLineItemList);
        setContribCalculationMap(proposalLineItemList);
        recalculatePriceWalkLineItems();
        createContributionCalculationLineItems(proposalLineItemList);
    }

    protected override void afterUpdate() {

        List<PricingProposalDynamicLineItem__c> proposalLineItemList = new List<PricingProposalDynamicLineItem__c>();

        proposalLineItemList.addAll((List<PricingProposalDynamicLineItem__c>)Trigger.new);
        proposalLineItemList.addAll((List<PricingProposalDynamicLineItem__c>)Trigger.old);

        setProposalMaps(proposalLineItemList);
        setContribCalculationMap(proposalLineItemList);
        recalculatePriceWalkLineItems();
        updateContributionCalculationLineItems((List<PricingProposalDynamicLineItem__c>)Trigger.new);
    }

    protected override void afterDelete() {

        List<PricingProposalDynamicLineItem__c> proposalLineItemList = (List<PricingProposalDynamicLineItem__c>)Trigger.old;

        setProposalMaps(proposalLineItemList);
        setContribCalculationMap(proposalLineItemList);
        recalculatePriceWalkLineItems();
        deleteContributionCalculationLineItems(proposalLineItemList);
    }

}