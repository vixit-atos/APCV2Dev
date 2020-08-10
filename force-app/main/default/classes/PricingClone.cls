// Class name: Pricing Clone
// created: Feb 23, 2018 11:33PM
// Author: vineel
// Description: this class represents  copy of  pricing clone and dynamic line items 

public class PricingClone {
    public PricingProposal__c oldRecord{get;set;}
    public PricingProposal__c newRecord{get;set;}
    public Pricingclone(ApexPages.StandardController standardController){
        oldRecord = (PricingProposal__c) standardController.getRecord();
    }
    public PageReference newPrcingPropsal(){
        oldRecord = [select Id,Name,Opportunity__c,ConcessionNumber__c,QSpec__c,Reference_Configuration__c,ReferenceSerialNumber__c,Approval_Status__c,
                     NumberOfUnitsColMin__c,NumberOfUnitsColMax__c,BaseModel__c,Transmission__c,EngineMakeHP__c,SleeperType__c,AxleMakeConfig__c,Contribution_Calculation__c,
                     PriceLevel__c,Dealer_Net__c,Standard_Concession__c,Concession_Percent__c,Daimler_Latina_Add__c,Requested_Add__c,DTNA_RSM_Add__c,Total_Concession__c,Concession_Dollars__c,
                     Freight__c,Dealer_Cost__c,Total_Selling_Price__c,RecordtypeId from PricingProposal__c where id=:oldRecord.Id];
        if(oldRecord.RecordTypeID == Schema.SObjectType.PricingProposal__c.getRecordTypeInfosByName().get('International Sales Proposal').getRecordTypeId()){
            newRecord = new PricingProposal__c();
            newRecord.Name = 'Copy'+oldRecord.Name;
            newRecord.RecordTypeID=oldRecord.RecordTypeID;
            newRecord.Opportunity__c = oldRecord.Opportunity__c;
            newRecord.ConcessionNumber__c = oldRecord.ConcessionNumber__c;
            newRecord.QSpec__c = oldRecord.QSpec__c ;
            newRecord.Reference_Configuration__c = oldRecord.Reference_Configuration__c ;
            newRecord.ReferenceSerialNumber__c = oldRecord.ReferenceSerialNumber__c ;
            newRecord.Approval_Status__c = oldRecord.Approval_Status__c ;
            newRecord.NumberOfUnitsColMin__c = oldRecord.NumberOfUnitsColMin__c ;
            newRecord.NumberOfUnitsColMax__c = oldRecord.NumberOfUnitsColMax__c ;
            newRecord.BaseModel__c = oldRecord.BaseModel__c ;
            newRecord.Transmission__c = oldRecord.Transmission__c ;
            newRecord.EngineMakeHP__c = oldRecord.EngineMakeHP__c ;
            newRecord.SleeperType__c = oldRecord.SleeperType__c ;
            newRecord.AxleMakeConfig__c = oldRecord.AxleMakeConfig__c ;
            newRecord.Contribution_Calculation__c = oldRecord.Contribution_Calculation__c ;
            newRecord.PriceLevel__c = oldRecord.PriceLevel__c ;
            newRecord.Dealer_Net__c = oldRecord.Dealer_Net__c ;
            newRecord.Standard_Concession__c = oldRecord.Standard_Concession__c ;
            newRecord.Concession_Percent__c = oldRecord.Concession_Percent__c ;
            newRecord.Daimler_Latina_Add__c = oldRecord.Daimler_Latina_Add__c ;
            newRecord.Requested_Add__c = oldRecord.Requested_Add__c ;
            newRecord.DTNA_RSM_Add__c = oldRecord.DTNA_RSM_Add__c ;
            newRecord.Freight__c = oldRecord.Freight__c ;
            
           
            
            try{
                Insert newRecord;
            }catch(DmlException e){
                System.debug('Exception occurred on insert: ' + e.getMessage()); 
            
            }
            cloneDynamicpricing();
        }
        PageReference detailPage = new ApexPages.StandardController(newRecord).view();
        
        detailPage.setRedirect(true);
        
        return detailPage;
    }
    public void cloneDynamicpricing(){
        List<PricingProposalDynamicLineItem__c> lstOldPDL = new list<PricingProposalDynamicLineItem__c>();
        List<PricingProposalDynamicLineItem__c> lstNewPDL = new list<PricingProposalDynamicLineItem__c>();
        lstOldPDL = [select Id,Name,Amount__c,Line_Item_Mainframe_Code_Mapping__c,Line_Item__c,Order__c,PricingProposal__c from PricingProposalDynamicLineItem__c where PricingProposal__c=:oldRecord.Id];
        if(lstOldPDL.size()>0){
            for(PricingProposalDynamicLineItem__c pd:lstOldPDL){
                PricingProposalDynamicLineItem__c temp = pd.clone();
                temp.PricingProposal__c = newRecord.Id;
                lstNewPDL.add(temp);
            }
        }
        
        try{
            if(lstNewPDL.size()>0){
                insert lstNewPDL;
            }
        }catch(DmlException e){
        System.debug('Exception occurred on insert: ' + e.getMessage()); 
        
        }
        
    }
    
}