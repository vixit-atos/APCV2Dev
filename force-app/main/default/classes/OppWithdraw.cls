// Class name: Oppwithdraw 
// created: Feb 23, 2018 11:33PM
// Author: vineel
// Description: this class represents for withdrawing approvals after the record is approved & unlocked



public class OppWithdraw {
    public Id oppId {get;set;}
    public Opportunity opp{get;set;}
    public OppWithdraw(){
        opp = new Opportunity();
        oppId = ApexPages.currentPage().getParameters().get('oppid');
        if(oppId != null){
            Opp = [select Id, Name,Owner.Name,RevisionDate__c,Customer__c,Related_TC_Deal__c,RecordTypeId,
                   
                   DatePrepared__c,ISP_Probability_of_Success__c,Country__c,Prospect_Customer__c,Account_City__c,Account_State__c,DATE_DELV_RQST__c,OrderReceivedFrom__c,
                   
                   OrderReceivedTo__c,DATE_LATEST_ACCEPT__c,VEH_MAKE__c,Make__c,Deal_Type__c,NewOrRevision__c,Escalators__c,Description,StageName,Withdraw_Reason__c,CloseDate from Opportunity where id=:oppId];
                   
              if(opp.StageName == 'Pending Approval'){
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Cannot withdraw'));
              } 
        }
    }
    public PageReference oppinsert(){
    if(opp.StageName == 'Pending Approval'){
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Cannot withdraw'));
              return null;
              } else{
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        TWSClone tc = new TWSClone(sc);
        //Pagereference p = new Pagereference('/'+OppId);
        //Opp.Stagename = 'Create TWS';
        //update opp;
        return tc.deepCloneWithdraw();
        /*PageReference detailPage = new ApexPages.StandardController(newOpportunity).view();

        detailPage.setRedirect(true);
        retrun detailPage;*/
        }
    }
    public Pagereference cancel(){
        Pagereference p = new Pagereference('/'+OppId);
        return p;  
    }
}