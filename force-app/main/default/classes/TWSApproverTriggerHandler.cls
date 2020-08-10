/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* One or two sentence summary of this class.
*
* This classes is used to share and unshare  a opportunity record to twsapprovers 
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
public Without sharing class   TWSApproverTriggerHandler extends TriggerHandler {
    
    public TWSApproverTriggerHandler (){
    }
    protected override void afterInsert() {
        Shareopporunityrecordtoapprovers();
    }
    protected override void afterupdate() {
        unShareopporunityrecordtoapprovers() ;
        Shareopporunityrecordtoapprovers();
        
    }
    protected override void afterdelete() {
        unShareopporunityrecordtoapprovers();
        
    }
    /*******************************************************************************************************
* @description: this method is used to Share opporunity record to approvers when approver  adding in 
*               in approval section of opporunity 
* @return : void 
*/
    private void Shareopporunityrecordtoapprovers() {
       
        List<OpportunityShare> lstOpportunityShare = new List<OpportunityShare>(); 
        Map<ID,String> maptwsapprovetooppyid=new  Map<ID,String>();
        Map<ID,String> mapoppyidtotwsapprove=new  Map<ID,String>();
        String strApproverid;
        String stropportunityid;
        TWS_Approver__c oldTWS_Approver ;
        TWS_Approver__c NewTWS_Approver ;
        
        system.debug('I am insert');
        for(TWS_Approver__c  objTWSApprover :  (List<TWS_Approver__c>)Trigger.new){
             stropportunityid=objTWSApprover.TWS_Deal__c;
            strApproverid=objTWSApprover.TWS_Approver__c; 
            if(Trigger.isInsert){
                    maptwsapprovetooppyid.put(objTWSApprover.TWS_Approver__c, objTWSApprover.TWS_Deal__c);
                    mapoppyidtotwsapprove.put(objTWSApprover.TWS_Deal__c,objTWSApprover.TWS_Approver__c);
            }
            if(Trigger.isupdate){
                 oldTWS_Approver = (TWS_Approver__c)trigger.oldMap.get(objTWSApprover.Id) ;
                NewTWS_Approver = (TWS_Approver__c)trigger.NewMap.get(objTWSApprover.Id) ; 
                 if( oldTWS_Approver.TWS_Approver__c!=NewTWS_Approver.TWS_Approver__c  ){
                     maptwsapprovetooppyid.put(objTWSApprover.TWS_Approver__c, objTWSApprover.TWS_Deal__c);
                     mapoppyidtotwsapprove.put(objTWSApprover.TWS_Deal__c,objTWSApprover.TWS_Approver__c);
                 }                
            }
           
        }
        User objuser = [select id,firstname from user where id=:userinfo.getuserid()];
        List<OpportunityShare> lstoppyshare=[select id,OpportunityAccessLevel,RowCause  from  OpportunityShare where OpportunityId  =: maptwsapprovetooppyid.get(strApproverid) and UserOrGroupId  =: mapoppyidtotwsapprove.get(stropportunityid)];
        system.debug('lstoppyshare.size()'+lstoppyshare.size());
        if(lstoppyshare.size()==0){
            for(TWS_Approver__c objTWSApprover1:  (List<TWS_Approver__c>)Trigger.new){
                     if(objuser.id != objTWSApprover1.TWS_Approver__c){    
                        OpportunityShare objOppyshare =new OpportunityShare();
                        objOppyshare.OpportunityId=maptwsapprovetooppyid.get(objTWSApprover1.TWS_Approver__c);
                        objOppyshare.UserOrGroupId=objTWSApprover1.TWS_Approver__c;
                        objOppyshare.OpportunityAccessLevel = 'Read';
                        objOppyshare.RowCause = Schema.OpportunityShare.RowCause.Manual;
                        lstOpportunityShare.add(objOppyshare); 
                     }
            }
        }                    
        if(!lstOpportunityShare.isEmpty()){   
            system.debug('lstOpportunityShare1234'+lstOpportunityShare);
            Try{
                upsert lstOpportunityShare;
            }Catch(Exception e){              
                System.debug('Exception'+e);
                
            }
            
        } 
        
    }
  
    /*******************************************************************************************************
* @description: this method is used to unShare opporunity record to approvers when approver  deleting  
*               approver from  approval section of opporunity 
* @return : void 
*/
    private void unShareopporunityrecordtoapprovers() {
        String strApproverid;
        String stropportunityid;
        TWS_Approver__c oldTWS_Approver ;
        TWS_Approver__c NewTWS_Approver ;
        List<TWS_Approver__c> lstoldTWS_Approver= Trigger.old;
        List<OpportunityShare> lstOpportunitySharetounshare;
        Map<ID,String> mapapproveridstounshare=new Map<ID,String>();
        Map<ID,String> maptwsapprovetooppyid=new  Map<ID,String>();
        
        User objuser = [select id,firstname from user where id=:userinfo.getuserid()]; 

        for(TWS_Approver__c objTWSApprover : (List<TWS_Approver__c>)Trigger.old){
                strApproverid=objTWSApprover.TWS_Approver__c;
                stropportunityid=objTWSApprover.TWS_Deal__c;
                
                if(Trigger.isUpdate){
                    oldTWS_Approver = (TWS_Approver__c)trigger.oldMap.get(objTWSApprover.Id) ;
                    NewTWS_Approver = (TWS_Approver__c)trigger.NewMap.get(objTWSApprover.Id) ; 
                    if(objuser.id != objTWSApprover.TWS_Approver__c &&oldTWS_Approver.TWS_Approver__c!=NewTWS_Approver.TWS_Approver__c  ){
                        
                        mapapproveridstounshare.put(objTWSApprover.TWS_Deal__c, objTWSApprover.TWS_Approver__c) ;
                        maptwsapprovetooppyid.put(objTWSApprover.TWS_Approver__c, objTWSApprover.TWS_Deal__c);
                    }
                }            
                if(Trigger.isDelete){
                  
                            mapapproveridstounshare.put(objTWSApprover.TWS_Deal__c, objTWSApprover.TWS_Approver__c) ;
                            maptwsapprovetooppyid.put(objTWSApprover.TWS_Approver__c, objTWSApprover.TWS_Deal__c);
                    
                }
            }
         lstOpportunitySharetounshare = [SELECT Id  FROM OpportunityShare WHERE RowCause = 'Manual' and UserOrGroupId =:mapapproveridstounshare.get(stropportunityid) and OpportunityId =:maptwsapprovetooppyid.get(strApproverid) ];
        system.debug('sharesToDelete1234'+lstOpportunitySharetounshare);
        if(!lstOpportunitySharetounshare.isEmpty()){
            Try{
                delete lstOpportunitySharetounshare;
            }Catch(Exception e){
                System.debug('Exception'+e);
            }
        }
    }
}