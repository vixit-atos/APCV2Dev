/**
    * ─────────────────────────────────────────────────────────────────────────────────────────────────┐
    * One or two sentence summary of this class.
    *
    * This class is used to share and unshare  a SalesContract record to SalesContractApprovers 
    * 
    * ──────────────────────────────────────────────────────────────────────────────────────────────────
    * @author         Hareesh goud nellykonda   
    * @modifiedBy          
    * @version        1.0
    * @created        03-23-2017
    * @modified       MM-DD-YYYY
    * ──────────────────────────────────────────────────────────────────────────────────────────────────
    * @changes
    * modifiedBy            
    * MM-DD-YYYY      Explanation of the change.  Multiple lines can be used to explain the change, but
    *                 each line should be indented till left aligned with the previous description text.
    *
    * modifiedBy           
    * MM-DD-YYYY      Each change to this file should be documented by incrementing the version number,
    *                 and adding a new entry to this @changes list. Note that there is a single blank
    *                 line between each @changes entry.
    * ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
public class TWSSalesContractApproverTriggerHandler extends TriggerHandler {
public TWSSalesContractApproverTriggerHandler (){
    }
    protected override void afterInsert() {
        ShareSalesContractrecordtoapprovers();
    }
    protected override void afterupdate() {
        unShareSalesContractrecordtoapprovers() ;
        ShareSalesContractrecordtoapprovers();
    }
    protected override void afterdelete() {
        unShareSalesContractrecordtoapprovers();
        
    }
     /*******************************************************************************************************
    * @description: this method is used to Share SalesContract record to approvers when approver  adding  
    *               in approval section of SalesContract record 
    * @return : void 
    */
     private void ShareSalesContractrecordtoapprovers() {
        List<Sales_Contract_Approver__c> lstnewSalesContractApprover= Trigger.new;
        List<OpportunityShare> lstOpportunityShare = new List<OpportunityShare>(); 
        Set<ID> setoppyids=new Set<ID>();
        Map<ID,String> mapapprovetoscid=new  Map<ID,String>();
         Map<ID,String> mapscidtoOppyid=new  Map<ID,String>();
          Map<ID,String> mapscidApproverid=new  Map<ID,String>();
          String strApproverid;
          String strSalesContractid;
          Sales_Contract_Approver__c oldSalesContract_Approver ;
         Sales_Contract_Approver__c NewSalesContract_Approver;
         
        for(Sales_Contract_Approver__c  objSalesContractApprover : lstnewSalesContractApprover){
            strSalesContractid=objSalesContractApprover.Sales_Contract__c;
            strApproverid=objSalesContractApprover.Contract_Approver__c;
                  if(Trigger.isInsert){
                        mapapprovetoscid.put(objSalesContractApprover.Contract_Approver__c, objSalesContractApprover.Sales_Contract__c);  
                        mapscidApproverid.put(objSalesContractApprover.Sales_Contract__c, objSalesContractApprover.Contract_Approver__c);
                  }
            if(Trigger.isupdate){
                 oldSalesContract_Approver = (Sales_Contract_Approver__c)trigger.oldMap.get(objSalesContractApprover.Id) ;
                 NewSalesContract_Approver = (Sales_Contract_Approver__c)trigger.NewMap.get(objSalesContractApprover.Id) ; 
                    if(oldSalesContract_Approver.Contract_Approver__c!=NewSalesContract_Approver.Contract_Approver__c){
                         mapapprovetoscid.put(objSalesContractApprover.Contract_Approver__c, objSalesContractApprover.Sales_Contract__c);  
                         mapscidApproverid.put(objSalesContractApprover.Sales_Contract__c, objSalesContractApprover.Contract_Approver__c);
                    }
                
             }
        }
        system.debug('maptwsapprovetooppyid'+setoppyids);
         List<Sales_Contract__c> lstSalesContracts=[select id,Opportunity__c from Sales_Contract__c where id in:mapapprovetoscid.values() ];
         for(Sales_Contract__c objSalesContract:lstSalesContracts ){
             mapscidtoOppyid.put(objSalesContract.id,objSalesContract.Opportunity__c);
         }
                 User objuser = [select id,firstname from user where id=:userinfo.getuserid()];
          
        List<OpportunityShare> lstoppyshare=[select id,OpportunityAccessLevel,RowCause  from  OpportunityShare where OpportunityId  =: mapscidtoOppyid.get(strSalesContractid) and UserOrGroupId  =: mapscidApproverid.get(strSalesContractid)];
         if(lstoppyshare.size()==0){
            for(Sales_Contract_Approver__c  objSalesContractApprover : lstnewSalesContractApprover ){
                    if(objuser.id != objSalesContractApprover.Contract_Approver__c){
                OpportunityShare objOppyshare =new OpportunityShare();
                objOppyshare.OpportunityId=mapscidtoOppyid.get(objSalesContractApprover.Sales_Contract__c);
                objOppyshare.UserOrGroupId=objSalesContractApprover.Contract_Approver__c;
                objOppyshare.OpportunityAccessLevel = 'Read';
                objOppyshare.RowCause = Schema.OpportunityShare.RowCause.Manual;
                lstOpportunityShare.add(objOppyshare);         
                   }
            }
        }
        if(!lstOpportunityShare.isEmpty()){   
            system.debug('lstOpportunityShare1234'+lstOpportunityShare);
            Try{
            insert lstOpportunityShare;
            }Catch(Exception e){
                System.debug('Exception'+e);
                
            }
            
        } 
    }
    
    /*******************************************************************************************************
    * @description: this method is used to unShare SalesContract record to approvers when approver  deleting  
    *               approver from  approval section of SalesContract record 
    * @return : void 
    */
    private void unShareSalesContractrecordtoapprovers() {
        List<Sales_Contract_Approver__c> lstoldSalesContractApprover= Trigger.old;
        String strApproverid;
        String strSalesContractid;
        Map<ID,String> mapscidtoOppyid=new  Map<ID,String>();
        Map<ID,String> mapapprovetoscid=new  Map<ID,String>();
        Map<ID,String> mapsalesconIDtoApproveID=new  Map<ID,String>();
        Sales_Contract_Approver__c oldSalesContract_Approver ;
         Sales_Contract_Approver__c NewSalesContract_Approver;
        User objuser = [select id,firstname from user where id=:userinfo.getuserid()]; 
        for(Sales_Contract_Approver__c objSalesContractApprover : lstoldSalesContractApprover){
            strApproverid=objSalesContractApprover.Contract_Approver__c;
            strSalesContractid= objSalesContractApprover.Sales_Contract__c;
             if(Trigger.isupdate){
                 oldSalesContract_Approver = (Sales_Contract_Approver__c)trigger.oldMap.get(objSalesContractApprover.Id) ;
                 NewSalesContract_Approver = (Sales_Contract_Approver__c)trigger.NewMap.get(objSalesContractApprover.Id) ; 
                    if(objuser.id != objSalesContractApprover.Contract_Approver__c && oldSalesContract_Approver.Contract_Approver__c!=NewSalesContract_Approver.Contract_Approver__c){
            
                            mapapprovetoscid.put(objSalesContractApprover.Contract_Approver__c , objSalesContractApprover.Sales_Contract__c );
                            mapsalesconIDtoApproveID.put(objSalesContractApprover.Sales_Contract__c, objSalesContractApprover.Contract_Approver__c);
                    }
             }
                       if(Trigger.isDelete){
                                  mapapprovetoscid.put(objSalesContractApprover.Contract_Approver__c , objSalesContractApprover.Sales_Contract__c );
                                  mapsalesconIDtoApproveID.put(objSalesContractApprover.Sales_Contract__c, objSalesContractApprover.Contract_Approver__c);
                      }
        }
         List<Sales_Contract__c> lstSalesContracts=[select id,Opportunity__c from Sales_Contract__c where id in:mapapprovetoscid.values() ];
         for(Sales_Contract__c objSalesContract:lstSalesContracts ){
             mapscidtoOppyid.put(objSalesContract.id,objSalesContract.Opportunity__c);
         }
        List<OpportunityShare> lstOpportunitySharetounshare = [SELECT Id  FROM OpportunityShare WHERE RowCause = 'Manual' and UserOrGroupId =:mapsalesconIDtoApproveID.get(strSalesContractid) and OpportunityId =:mapscidtoOppyid.get(strSalesContractid)];
        system.debug('sharesToDelete1234'+lstOpportunitySharetounshare);
        if(!lstOpportunitySharetounshare.isEmpty()){
            Try{
            delete lstOpportunitySharetounshare;
            } Catch(Exception e){
                System.debug('Exception'+e);
                
            }
        }
    }
}