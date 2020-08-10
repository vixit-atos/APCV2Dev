public with sharing class PricingProposalControllerExtension {
    
    public PricingProposal__c pricingproposal {get;set;}
    public Boolean blnCnsn{get;set;}
    public Boolean blnRefSer{get;set;}
    public Boolean Qspec{get;set;}
    public String stropportunityid;
    public Boolean oppRecordtypeCheck {get;set;}
    public Boolean isISPRecordType{get;set;}
    
    
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public PricingProposalControllerExtension(ApexPages.StandardController stdController) {
        //this.mysObject = (sObject)stdController.getRecord();
        
        blnCnsn = false;
        blnRefSer = false;
        Qspec = false;
        System.debug(ApexPages.currentPage().getParameters().keySet());
        stropportunityid = ApexPages.currentPage().getParameters().get('parent');
        
        pricingproposal = new PricingProposal__c(Opportunity__c = stropportunityid,  DTRResiduals__c='No', DTRTrades__c='No');
        Opportunity objOpporunity   = [select id,RecordTypeId,REcordType.DeveloperName from Opportunity where id = :stropportunityid];
         
        if(objOpporunity.REcordType.DeveloperName.contains('International_Sales_Proposal'))
            oppRecordtypeCheck  = true;
        else
            oppRecordtypeCheck = false;
              
        system.debug('11111111111pricingproposal'+pricingproposal);
    }
    public PageReference save() {
        Opportunity objOpporunity   = [select id, RecordTypeId from Opportunity where id = :stropportunityid]; 
        String oRT_DN = [select developername from RecordType where id = :objOpporunity.RecordTypeId].developername;
        system.debug('11111111111objPricingProposal'+pricingproposal.Approval_Status__c);
        
        if(pricingproposal.Approval_Status__c=='Approved'){
            String targetRT = TWS_Record_Type_Map__c.getInstance(oRT_DN).Pricing_proposal_Approval_status__c;
            ID rtID = [select id from recordtype where sobjecttype = 'PricingProposal__c' and DeveloperName = :targetRT].id;
            pricingproposal.RecordTypeId=rtID;
        }
        if(pricingproposal.Approval_Status__c=='Proposed'){
            String targetRT = TWS_Record_Type_Map__c.getInstance(oRT_DN).Pricing_Proposal_RT__c;
            ID rtID = [select id from recordtype where sobjecttype = 'PricingProposal__c' and DeveloperName = :targetRT].id;
            pricingproposal.RecordTypeId=rtID;
        }
        new TWSSpecImporter(pricingproposal).ImportSpecs();
        system.debug('22222222222save:::::::::::::::'+pricingproposal);
        //insert pricingproposal;
        return new ApexPages.StandardController(pricingproposal).view();
    }
    
    public PageReference cancel() {
        return new PageReference('/' + pricingproposal.Opportunity__c);
    }
}