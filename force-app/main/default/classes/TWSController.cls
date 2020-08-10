public with sharing class TWSController {

    public static Opportunity   currentTWS;
    

    

    public static Deal_Meeting_Association__c lastTCMeeting {get;set;}

    public TWSController(ApexPages.StandardController controller) {
    }

  @RemoteAction
  @ReadOnly
  public static TWSDetailWrapper getTWSDetailInfo(Id opportunityId){
            
        TWSDetailWrapper detailInfo = new TWSDetailWrapper();
        system.debug('opportunityId::'+opportunityId);
      
        currentTWS = getCurrentTWS(opportunityId);

    if (!currentTWS.Deal_Meeting_Associations__r.isEmpty()){
        lastTCMeeting = currentTWS.Deal_Meeting_Associations__r.get(0);
    }

        //Id domesticRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('TWS Dealer/Direct').getRecordTypeId();
        //Id canadianRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('TWS/TC Canadian Deal').getRecordTypeId();
        //Id nationalRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('TWS/TC National Deal').getRecordTypeId();
        Id internationalRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('International Sales Proposal').getRecordTypeId();
        //Id salesProposalRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Sales Proposal').getRecordTypeId();
        Id canadianRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('TWS-Canadian TC').getRecordTypeId();
        Id nationalRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('TWS-Ryder/Penske TC').getRecordTypeId();
        Id salesProposalRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('TWS-Dealer SP').getRecordTypeId();
        Id domesticRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('TWS-Dealer TC').getRecordTypeId();
        
      //   Id isp1RecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('International Sales Proposal Submitted').getRecordTypeId();

      
      
      
      if (currentTWS.recordTypeId == domesticRecordType){
            detailInfo.dealType = 'Domestic';
        }
        else if (currentTWS.recordTypeId == canadianRecordType){
            detailInfo.dealType = 'Canadian';
        }
        else if (currentTWS.recordTypeId == nationalRecordType){
            detailInfo.dealType = 'National';
        }
        else if (currentTWS.recordTypeId == internationalRecordType){
            detailInfo.dealType = 'International';
        }
        else if (currentTWS.recordTypeId == salesProposalRecordType){
            detailInfo.dealType = 'Sales Proposal';
        }
     //   else if (currentTWS.recordTypeId == isp1RecordType){
      //      detailInfo.dealType = 'International';
     //   }

        /*List<CurrencyType> currencyList = [Select Id, ConversionRate From CurrencyType Where IsoCode = 'CAD'];

        if (!currencyList.isEmpty()){
            detailInfo.FEXRate = currencyList.get(0).ConversionRate;
        }
        */
        detailInfo.FEXRate = 1;

    setTWSHeaderInfo(detailInfo);
        setDealSummaryAndEscalators(detailInfo);
    setTWSPricingProposalInfo(detailInfo);
        setContributionAndCostComments(detailInfo);
        setResidualQuoteComments(detailInfo);
        setCommitmentOutsideSalesTerms(detailInfo);
        setChassisWarrantyQuoteNumber(detailInfo);
        setChassisExtendedWarrantyComments(detailInfo);
        setEngineWarrantyQuoteNumber(detailInfo);
        setEngineExtendedWarrantyComments(detailInfo);
        setIncomingUsedTruckInfo(detailInfo);
        setFooterList(detailInfo);
        setEngineWarrantyList(detailInfo);

    return detailInfo;
  }

  public static void setTWSHeaderInfo(TWSDetailWrapper detailInfo){

      TWSHeaderWrapper headerWrapper = new TWSHeaderWrapper();

      headerWrapper.doaInitials = currentTWS.Owner.Name;
      headerWrapper.title = currentTWS.Name;
      headerWrapper.dealNumber = currentTWS.DealNumber__c;
      headerWrapper.customer = currentTWS.Account.Name;
      headerWrapper.modelYear = (currentTWS.MY__c!=null)?currentTWS.MY__c.replaceAll(';',', '):'';
      headerWrapper.datePrepared = currentTWS.DatePrepared__c != null? currentTWS.DatePrepared__c.format(): '';
      headerWrapper.newOrRevision = currentTWS.NewOrRevision__c;
      headerWrapper.revisionDate = currentTWS.RevisionDate__c != null? currentTWS.RevisionDate__c.format(): '';
      headerWrapper.dealerCode = currentTWS.SO_CD__c;
      headerWrapper.districtManager = currentTWS.DistrictManager__r.Name;
      headerWrapper.customerCityState = currentTWS.Account.BillingCity + ',' + currentTWS.Account.BillingState;
      headerWrapper.reqDeliveryFrom = currentTWS.DATE_DELV_RQST__c != null? currentTWS.DATE_DELV_RQST__c.format(): '';
      headerWrapper.reqDeliveryTo = currentTWS.DATE_LATEST_ACCEPT__c != null? currentTWS.DATE_LATEST_ACCEPT__c.format(): '';
      headerWrapper.priceProtect = currentTWS.PriceProtect__c;
      headerWrapper.orderReceivedFrom = currentTWS.OrderReceivedFrom__c != null? currentTWS.OrderReceivedFrom__c.format(): '';
      headerWrapper.orderReceivedTo = currentTWS.OrderReceivedTo__c != null? currentTWS.OrderReceivedTo__c.format(): '';
      headerWrapper.competition = currentTWS.CMPTR_CD__c;
            headerWrapper.specNumber = currentTWS.Spec_Number__c!=null?currentTWS.Spec_Number__c:0;
            headerWrapper.country = currentTWS.Country__c!=null?currentTWS.Country__c:'';
  
      if (lastTCMeeting != null ){
                headerWrapper.TCDate = lastTCMeeting.TC_Meeting__r.TC_Meeting_Date__c.format();
      }
            else{
                headerWrapper.TCDate = '-';
            }
      detailInfo.header = headerWrapper;
  }

    public static void setDealSummaryAndEscalators(TWSDetailWrapper detailInfo){

        detailInfo.dealSummary = '';

        List<Deal_Summary_Pricing_Strategy__c> dealSummaryList = [select id, Deal_Summary_Pricing_Strategy__c from Deal_Summary_Pricing_Strategy__c where Opportunity__c=:currentTWS.Id];

        for (Deal_Summary_Pricing_Strategy__c iter: dealSummaryList){

            detailInfo.dealSummary += iter.Deal_Summary_Pricing_Strategy__c+'\n';
        }
        detailInfo.escalators = (currentTWS.Escalators__c != null)?currentTWS.Escalators__c:'';
    }

    public static void setEngineWarrantyList(TWSDetailWrapper detailInfo){

        detailInfo.engineWarrantyList = TWSEngineWarrantyHandler.getEngineWarrantyWrapperMap(currentTWS.Id);
    }

    public static Opportunity getCurrentTWS(Id opportunityId){

    Opportunity oppty = [select Id,
                                Name,
                                DealNumber__c,
                                AccountId,
                                Account.Name,
                                Account.BillingCity,
                                Account.BillingState,
                                Owner.Name,
                                                                MY__c,
                                Model_Year__c,
                                DatePrepared__c,
                                NewOrRevision__c,
                                RevisionDate__c,
                                SO_CD__c,
                                DistrictManager__r.Name,
                                DATE_DELV_RQST__c,
                                DATE_LATEST_ACCEPT__c,
                                PriceProtect__c,
                                OrderReceivedFrom__c,
                                OrderReceivedTo__c,
                                CMPTR_CD__c,
                                                                DTR_Requested_to_Quote_Residual__c,
                                                                Escalators__c,
                                                                Chassis_Warranty_Quote__c,
                                                                Engine_Warranty_Quote__c,
                                                                RecordTypeId,
                                                                Spec_Number__c,
                                                                Country__c,
                                                                (select id, Comment__c from Contribution_Cost_Comments__r),
                                                                (select id, Comment__c from Residual_Quote_Comments__r),
                                                                (select id, Comment__c from Chassis_Extended_Warranty_Comments__r),
                                                                (select id, Comment__c from Engine_Extended_Warranty_Comments__r),
                                (select id, TC_Meeting__r.TC_Meeting_Date__c from Deal_Meeting_Associations__r where TC_Meeting__c != null and TC_Meeting__r.TC_Meeting_Date__c != null order by TC_Meeting__r.TC_Meeting_Date__c desc),
                                                                (select id, Comment__c from Commitments_Outside_Sales_Terms__r)
                                        from    Opportunity
                    where id=:opportunityId];

        System.debug('#oppty '+oppty);

        return oppty;
  }

    public static void setTWSPricingProposalInfo(TWSDetailWrapper detailInfo){

        detailInfo.dynamicProposalLineKeys = new Set<String>();
        detailInfo.dynamicProposalLineAmountMap = new Map<Id, Map<String, String>>();
        detailInfo.dynamicProposalLineDoubleAmountMap = new Map<Id, Map<String, Double>>();
        detailInfo.contributionCalcDynamicItemsKeySet = new Set<String>();
        detailInfo.priceWalkLabels = new Set<String>();

        Set<Id> referenceIdSet = new Set<Id>();
        Set<Id> allTypeProposalIdSet = new Set<Id>();

        //get Pricing Proposals
    List<TWSPricingProposalWrapper> pricingProposalWrapperList = new List<TWSPricingProposalWrapper>();

    //List<PricingProposal__c> pricingProposalList = TWSPricingProposalHandler.getPricingProposalList(currentTWS.Id);
        List<PricingProposal__c> pricingProposalList = TWSPricingProposalHandler.getPricingProposalListWithReference(currentTWS.Id);

        //collect reference ids and contribution calculation ids
        for (PricingProposal__c iter: pricingProposalList){
            referenceIdSet.add(iter.Reference_Configuration__c);
            //allTypeProposalIdSet.add(iter.id);

            if (iter.Reference_Configuration__c != null){
                allTypeProposalIdSet.add(iter.Reference_Configuration__c);
            }
        }

        //proposal
        pricingProposalList = TWSPricingProposalHandler.getPricingProposalNotInTheList(referenceIdSet, currentTWS.Id);
        for (PricingProposal__c iter: pricingProposalList){
            allTypeProposalIdSet.add(iter.id);
        }

        //get Reference Configuration Proposals
        Map<Id, PricingProposal__c> referenceProposalMap = TWSPricingProposalHandler.getProposalMap(referenceIdSet);

        //get Contribution Calculations
        Map<Id, TWSContributionCalculationHandler.ContributionCalculationWrapper> contributionCalculationMap = TWSContributionCalculationHandler.getContributionCalculationMap(allTypeProposalIdSet);
        //get Chassis Warranty
        Map<Id, TWSChassisWarrantyHandler.ChassisWarrantyWrapper> chassisWarrantyMap = TWSChassisWarrantyHandler.getChassisWarrantyMap(allTypeProposalIdSet);

        //priceWalk
        Map<Id, TWSPriceWalkHandler.PriceWalkWrapper> priceWalkMap = TWSPriceWalkHandler.getPriceWalkWrapperMap(currentTWS, pricingProposalList);

        for (PricingProposal__c iter: pricingProposalList){

        TWSPricingProposalWrapper newPricingProposalWrapper = new TWSPricingProposalWrapper();

        //pricing proposal
            newPricingProposalWrapper.pricingProposal = createPricingProposalWrapper(iter, contributionCalculationMap, chassisWarrantyMap, detailInfo);

            //pricing proposal reference
            PricingProposal__c reference = referenceProposalMap.get(iter.Reference_Configuration__c);

            if (reference != null){
                newPricingProposalWrapper.pricingProposalReference = createPricingProposalWrapper(reference, contributionCalculationMap, chassisWarrantyMap, detailInfo);
            }

            //Proposal dynamicLineItems
            detailInfo.dynamicProposalLineAmountMap.put(iter.Id, new Map<String, String>());
            detailInfo.dynamicProposalLineDoubleAmountMap.put(iter.Id, new Map<String, Double>());

            for (PricingProposalDynamicLineItem__c lineItem: iter.PricingProposalDynamicLineItem__r){

                String label = lineItem.Name;
                Double doubleAmount = lineItem.Amount__c != null ? lineItem.Amount__c: 0;
                String amount = '$'+doubleAmount.format();

                detailInfo.dynamicProposalLineKeys.add(label);

                detailInfo.dynamicProposalLineAmountMap.get(iter.Id).put(label, amount);
                detailInfo.dynamicProposalLineDoubleAmountMap.get(iter.Id).put(label, doubleAmount);
            }

            //Reference dynamicLineItems

            if (reference != null){

                detailInfo.dynamicProposalLineAmountMap.put(reference.Id, new Map<String, String>());
                detailInfo.dynamicProposalLineDoubleAmountMap.put(reference.Id, new Map<String, Double>());

                for (PricingProposalDynamicLineItem__c lineItem: reference.PricingProposalDynamicLineItem__r){

                    String label = lineItem.Name;
                    Double doubleAmount = lineItem.Amount__c != null ? lineItem.Amount__c: 0;
                    String amount = '$'+doubleAmount.format();

                    detailInfo.dynamicProposalLineKeys.add(label);

                    detailInfo.dynamicProposalLineAmountMap.get(reference.Id).put(label, amount);
                    detailInfo.dynamicProposalLineDoubleAmountMap.get(reference.Id).put(label, doubleAmount);
                }
            }

            //priceWalk
            newPricingProposalWrapper.priceWalk = priceWalkMap.get(iter.Id);

            for (String label: newPricingProposalWrapper.priceWalk.dynamicLineDiffMap.keySet()){
                detailInfo.priceWalkLabels.add(label);
            }

            /*
            //price walk
            newPricingProposalWrapper.priceWalk = new PriceWalkWrapper();

            if (newPricingProposalWrapper.pricingProposalReference != null){
                newPricingProposalWrapper.priceWalk.previous = newPricingProposalWrapper.pricingProposalReference.dealerCost;
            }
            else{
                newPricingProposalWrapper.priceWalk.previous = 0;
            }
            newPricingProposalWrapper.priceWalk.specs = 0;
            newPricingProposalWrapper.priceWalk.spdOverrides = 0;
            newPricingProposalWrapper.priceWalk.total = newPricingProposalWrapper.priceWalk.previous;

            newPricingProposalWrapper.priceWalk.dynamicLineDiffMap = new Map<String, Double>();

            for (String key: detailInfo.dynamicProposalLineKeys.keySet()){

                Double amountProposal = 0;
                Double amountReference = 0;

                if (detailInfo.dynamicProposalLineDoubleAmountMap.get(iter.Id) != null){
                    if (detailInfo.dynamicProposalLineDoubleAmountMap.get(iter.Id).get(key) != null){
                        amountProposal = Double.valueOf(detailInfo.dynamicProposalLineDoubleAmountMap.get(iter.Id).get(key));
                    }
                }
                if (reference != null && detailInfo.dynamicProposalLineDoubleAmountMap.get(reference.Id) != null){
                    if (detailInfo.dynamicProposalLineDoubleAmountMap.get(reference.Id).get(key) != null){
                        amountReference = Double.valueOf(detailInfo.dynamicProposalLineDoubleAmountMap.get(reference.Id).get(key));
                    }
                }

                Double doubleDiff = amountReference - amountProposal;

                if (detailInfo.dealType == 'Canadian'){
                    doubleDiff = (doubleDiff / detailInfo.FEXRate);
                }

                newPricingProposalWrapper.priceWalk.dynamicLineDiffMap.put(key, doubleDiff);

                newPricingProposalWrapper.priceWalk.total += doubleDiff;
            }
            */
        pricingProposalWrapperList.add(newPricingProposalWrapper);
        }

        //get the dynamic contribution calculation key set
        detailInfo.contributionCalcDynamicItemsKeySet = TWSContributionCalculationHandler.dynamicLineItemKeySet;
        //get the dynamic chassis warranty key Map
        detailInfo.chassisWarrantyElementsKeyMap = TWSChassisWarrantyHandler.chassisWarrantyElementsKeyMap;

        //return
        detailInfo.pricingProposalList = pricingProposalWrapperList;
    }

    public static TWSPricingProposalHandler.PricingProposalWrapper createPricingProposalWrapper(PricingProposal__c proposal, Map<Id, TWSContributionCalculationHandler.ContributionCalculationWrapper> contributionCalcMap, Map<Id, TWSChassisWarrantyHandler.ChassisWarrantyWrapper> chassisWarrantyMap, TWSDetailWrapper detailInfo){

        TWSPricingProposalHandler.PricingProposalWrapper pricingProposal = TWSPricingProposalHandler.getPricingProposalWrapper(proposal);

        //Contribution Calculation
        pricingProposal.contributionCalc = new TWSContributionCalculationHandler.ContributionCalculationWrapper();

        if (contributionCalcMap.get(proposal.Id) != null){
            pricingProposal.contributionCalc = contributionCalcMap.get(proposal.Id);
        }

        //Outgoing Residuals
        if (!proposal.Outgoing_Residuals_Information__r.isEmpty()){
            pricingProposal.OutgoingResidualsInfo = TWSOutgoingResidualsInfoHandler.getOutgoingResidualsInfoWrapper(proposal.Outgoing_Residuals_Information__r.get(0));

            detailInfo.dtrRequestedToQuoteResidual = currentTWS.DTR_Requested_to_Quote_Residual__c?'YES':'NO';
        }

        //Chassis Warranty
        pricingProposal.chassisWarranty = new TWSChassisWarrantyHandler.ChassisWarrantyWrapper();

        if (chassisWarrantyMap.get(proposal.Id) != null){
            pricingProposal.chassisWarranty = chassisWarrantyMap.get(proposal.Id);
        }

        return pricingProposal;
    }

    public static void setResidualQuoteComments(TWSDetailWrapper detailInfo){

        detailInfo.residualQuoteComments = '';

        for (Residual_Quote_Comment__c iter: currentTWS.Residual_Quote_Comments__r){
            detailInfo.residualQuoteComments += iter.Comment__c + '\n';
        }
    }

    public static void setCommitmentOutsideSalesTerms(TWSDetailWrapper detailInfo){

        detailInfo.commitmentOutsideSalesTerms = '';

        for (Commitment_Outside_Sales_Terms__c iter: currentTWS.Commitments_Outside_Sales_Terms__r){
            detailInfo.commitmentOutsideSalesTerms += iter.Comment__c + '\n';
        }
    }

    public static void setContributionAndCostComments(TWSDetailWrapper detailInfo){

        detailInfo.contributionAndCostComments = '';

        for (Contribution_Cost_Comment__c iter: currentTWS.Contribution_Cost_Comments__r){
            detailInfo.contributionAndCostComments += iter.Comment__c + '\n';
        }
    }

    public static void setChassisExtendedWarrantyComments(TWSDetailWrapper detailInfo){

        detailInfo.chassisExtendedWarrantyComments = '';

        for (Chassis_Extended_Warranty_Comment__c iter: currentTWS.Chassis_Extended_Warranty_Comments__r){
            detailInfo.chassisExtendedWarrantyComments += iter.Comment__c + '\n';
        }
    }

    public static void setChassisWarrantyQuoteNumber(TWSDetailWrapper detailInfo){

        detailInfo.chassisWarrantyQuoteNumber = currentTWS.Chassis_Warranty_Quote__c;
    }

    public static void setEngineWarrantyQuoteNumber(TWSDetailWrapper detailInfo){

        detailInfo.engineWarrantyQuoteNumber = currentTWS.Engine_Warranty_Quote__c;
    }

    public static void setEngineExtendedWarrantyComments(TWSDetailWrapper detailInfo){

        detailInfo.engineExtendedWarrantyComments = '';

        for (Engine_Extended_Warranty_Comment__c iter: currentTWS.Engine_Extended_Warranty_Comments__r){
            detailInfo.engineExtendedWarrantyComments += iter.Comment__c + '\n';
        }
    }

    public static void setIncomingUsedTruckInfo(TWSDetailWrapper detailInfo){

        detailInfo.incomingUsedTruckList = TWSIncomingUsedTruckHandler.getIncomingUsedTruckWrapperList(currentTWS.Id);
    }

    public static void setFooterList(TWSDetailWrapper detailInfo){

        detailInfo.footerList = TWSFooterHandler.getFooterWrapperList(currentTWS.Id);
    }

  /** Wrapper Classes to return the TWSDetail info **/
  public class TWSDetailWrapper{

        public String dealType {get;set;}
        public Double fexRate {get;set;}

    public TWSHeaderWrapper header {get;set;}
    public List<TWSPricingProposalWrapper> pricingProposalList {get;set;}
        public String dealSummary {get;set;}
        public String escalators {get;set;}
        public String contributionAndCostComments {get;set;}
        public String dtrRequestedToQuoteResidual {get;set;}
        public String chassisWarrantyQuoteNumber {get;set;}
        public String residualQuoteComments {get;set;}
        public String commitmentOutsideSalesTerms   {get;set;}
        public String chassisExtendedWarrantyComments {get;set;}
        public String engineWarrantyQuoteNumber {get;set;}
        public String engineExtendedWarrantyComments {get;set;}
        public List<TWSIncomingUsedTruckHandler.IncomingUsedTruckWrapper> incomingUsedTruckList {get;set;}
        public List<TWSFooterHandler.FooterWrapper> footerList {get;set;}
        public Set<String> priceWalkLabels {get;set;}

        //Set<LineItem Name>
        public Set<String> dynamicProposalLineKeys {get;set;}
        //Map<proposalId, Map<LineItem Name, DinamicLineItemAmountSTRING>>
        public Map<Id, Map<String, String>> dynamicProposalLineAmountMap {get;set;}
        //Map<proposalId, Map<LineItem Name, DinamicLineItemAmountDOUBLE>>
        public Map<Id, Map<String, Double>> dynamicProposalLineDoubleAmountMap {get;set;}
        //Set<ConntributionCalcLabel>
        public Set<String> contributionCalcDynamicItemsKeySet{get;set;}
        //Map<QuoteNumber, ChassisWarrantyElement>
        public Map<String, String> chassisWarrantyElementsKeyMap {get;set;}
        //engine warranty
        List<TWSEngineWarrantyHandler.EngineWarrantyWrapper> engineWarrantyList{get;set;}
    }

  public class TWSHeaderWrapper{

    public String doaInitials {get;set;}
    public String title {get;set;}
    public String dealNumber {get;set;}
    public String customer {get;set;}
    public String modelYear {get;set;}
    public String TCDate {get;set;}
    public String datePrepared {get;set;}
    public String newOrRevision {get;set;}
    public String revisionDate {get;set;}
    public String dealerCode {get;set;}
    public String districtManager {get;set;}
    public String customerCityState {get;set;}
    public String reqDeliveryFrom {get;set;}
    public String reqDeliveryTo {get;set;}
    public String priceProtect {get;set;}
    public String orderReceivedFrom {get;set;}
    public String orderReceivedTo {get;set;}
    public String competition {get;set;}
        public Double specNumber {get;set;}
        public String country {get;set;}
  }

  public class TWSPricingProposalWrapper{

    public TWSPricingProposalHandler.PricingProposalWrapper pricingProposal {get;set;}
    public TWSPricingProposalHandler.PricingProposalWrapper pricingProposalReference {get;set;}

    public TWSPriceWalkHandler.PriceWalkWrapper priceWalk {get;set;}
  }

}