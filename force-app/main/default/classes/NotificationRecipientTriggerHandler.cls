/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* One or two sentence summary of this class.
*
* This classes is used to share and unshare  a opportunity record to NotificationRecipient 
* 
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Hareesh goud nellykonda   
* @modifiedBy          
* @version        1.0
* @created        05-04-2017
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
public class NotificationRecipientTriggerHandler extends TriggerHandler{
    
    
    public NotificationRecipienttriggerHandler(){
    }
    
    protected override void afterInsert() {
        ShareopporunityrecordtoNotificationRecipients();
    }
    protected override void afterupdate() {
        UnShareopporunityrecordtoNotificationRecipients() ;
        ShareopporunityrecordtoNotificationRecipients();
        
    }
    protected override void afterdelete() {
        UnShareopporunityrecordtoNotificationRecipients();
        
    }
    private void ShareopporunityrecordtoNotificationRecipients() {
        Notification_Recipient__c oldNotification_Recipient ;
        Notification_Recipient__c NewNotification_Recipient;
        String strNotification_Recipientid;
        String strOpportunityid;
        List<OpportunityShare> lstOpportunityShare = new List<OpportunityShare>();
        Map<String,String> mapOppyidtoNotifiRecID =new Map<String,String>();
        Map<String,String> mapNotifiRecIDtoOppyID =new Map<String,String>();
        
        
        for(Notification_Recipient__c objNotification_Recipient: (List<Notification_Recipient__c>)Trigger.new){
            strNotification_Recipientid=objNotification_Recipient.Notification_Recipient__c;
            strOpportunityid=objNotification_Recipient.TWS_Deal__c;
            if(Trigger.isInsert){
                mapOppyidtoNotifiRecID.put(objNotification_Recipient.TWS_Deal__c, objNotification_Recipient.Notification_Recipient__c);
                mapNotifiRecIDtoOppyID.put(objNotification_Recipient.Notification_Recipient__c, objNotification_Recipient.TWS_Deal__c) ;
            }
            if(Trigger.isupdate){
                oldNotification_Recipient = (Notification_Recipient__c)trigger.oldMap.get(objNotification_Recipient.Id) ;
                NewNotification_Recipient = (Notification_Recipient__c)trigger.NewMap.get(objNotification_Recipient.Id) ;
                if( oldNotification_Recipient.Notification_Recipient__c!=NewNotification_Recipient.Notification_Recipient__c  ){
                    mapOppyidtoNotifiRecID.put(objNotification_Recipient.TWS_Deal__c, objNotification_Recipient.Notification_Recipient__c);
                    mapNotifiRecIDtoOppyID.put(objNotification_Recipient.Notification_Recipient__c, objNotification_Recipient.TWS_Deal__c) ;
                }    
            }
        }
        
        User objuser = [select id,firstname from user where id=:userinfo.getuserid()];
        //List<OpportunityShare> lstoppyshare=[select id,OpportunityAccessLevel,RowCause  from  OpportunityShare where OpportunityId  =: mapNotifiRecIDtoOppyID.get(strNotification_Recipientid) and UserOrGroupId  =: mapOppyidtoNotifiRecID.get(strOpportunityid)];
        List<OpportunityShare> lstoppyshare=[select id,OpportunityAccessLevel,RowCause,OpportunityId,UserOrGroupId  from  OpportunityShare where UserOrGroupId  IN : mapOppyidtoNotifiRecID.values()]; //@Satish
        
        List<OpportunityShare> lstOpportunityShare1 = new List<OpportunityShare>(); //@satish
        
        //if(lstoppyshare.size()==0 ){
        for(Notification_Recipient__c objNotification_Recipient: (List<Notification_Recipient__c>)Trigger.new){
            
            if(objuser.id != objNotification_Recipient.Notification_Recipient__c){
                //@satish   
                for(OpportunityShare objlstoppyshare: lstoppyshare){
                    if(objlstoppyshare.UserOrGroupId==objNotification_Recipient.Notification_Recipient__c && objlstoppyshare.OpportunityId==objNotification_Recipient.TWS_Deal__c)
                        lstOpportunityShare1.add(objlstoppyshare);
                }
                if(lstOpportunityShare1.size()==0 ){                   //@satish
                    OpportunityShare objOppyshare =new OpportunityShare();
                    //objOppyshare.OpportunityId=mapNotifiRecIDtoOppyID.get(objNotification_Recipient.Notification_Recipient__c);
                    objOppyshare.OpportunityId=objNotification_Recipient.TWS_Deal__c;
                    
                    objOppyshare.UserOrGroupId=objNotification_Recipient.Notification_Recipient__c;
                    objOppyshare.OpportunityAccessLevel = 'Read';
                    objOppyshare.RowCause = Schema.OpportunityShare.RowCause.Manual;
                    lstOpportunityShare.add(objOppyshare);
                }
            }
            
        }
        //}
        if(!lstOpportunityShare.isEmpty()){   
            system.debug('lstOpportunityShare1234'+lstOpportunityShare);
            Try{
                upsert lstOpportunityShare;
            }Catch(Exception e){              
                System.debug('Exception'+e);
                
            }
            
        } 
    }
    private void UnShareopporunityrecordtoNotificationRecipients() {
        Notification_Recipient__c oldNotification_Recipient ;
        Notification_Recipient__c NewNotification_Recipient;
        String strNotification_Recipientid;
        String strOpportunityid;
        List<OpportunityShare> lstOpportunitySharetounshare = new List<OpportunityShare>();
        Map<String,String> mapOppyidtoNotifiRecID =new Map<String,String>();
        Map<String,String> mapNotifiRecIDtoOppyID =new Map<String,String>();
        User objuser = [select id,firstname from user where id=:userinfo.getuserid()]; 
        for(Notification_Recipient__c objNotification_Recipient: (List<Notification_Recipient__c>)Trigger.old){
            strNotification_Recipientid=objNotification_Recipient.Notification_Recipient__c;
            strOpportunityid=objNotification_Recipient.TWS_Deal__c;
            if(Trigger.isupdate){
                oldNotification_Recipient = (Notification_Recipient__c)trigger.oldMap.get(objNotification_Recipient.Id) ;
                NewNotification_Recipient = (Notification_Recipient__c)trigger.NewMap.get(objNotification_Recipient.Id) ;
                if( objuser.id != objNotification_Recipient.Notification_Recipient__c && oldNotification_Recipient.Notification_Recipient__c!=NewNotification_Recipient.Notification_Recipient__c  ){
                    mapOppyidtoNotifiRecID.put(objNotification_Recipient.TWS_Deal__c, objNotification_Recipient.Notification_Recipient__c);
                    mapNotifiRecIDtoOppyID.put(objNotification_Recipient.Notification_Recipient__c, objNotification_Recipient.TWS_Deal__c) ;
                }    
            }
            if(Trigger.isDelete){
                mapOppyidtoNotifiRecID.put(objNotification_Recipient.TWS_Deal__c, objNotification_Recipient.Notification_Recipient__c);
                mapNotifiRecIDtoOppyID.put(objNotification_Recipient.Notification_Recipient__c, objNotification_Recipient.TWS_Deal__c) ;
            }    
        }
        //lstOpportunitySharetounshare = [select id,OpportunityAccessLevel,RowCause  from  OpportunityShare where RowCause = 'Manual' and OpportunityId  =: mapNotifiRecIDtoOppyID.get(strNotification_Recipientid) and UserOrGroupId  =: mapOppyidtoNotifiRecID.get(strOpportunityid)];
        system.debug('sharesToDelete1234'+mapOppyidtoNotifiRecID.values());
        List<OpportunityShare> lstoppysharetounshare = [select id,OpportunityAccessLevel,RowCause,UserOrGroupId,OpportunityId from  OpportunityShare where RowCause = 'Manual' and UserOrGroupId  IN : mapOppyidtoNotifiRecID.values()]; //@satish
        system.debug('sharesToDelete1234'+lstoppysharetounshare);
        
        //@Satish       
        for(Notification_Recipient__c objNotification_Recipient: (List<Notification_Recipient__c>)Trigger.old){
            
            
            for(OpportunityShare objlstoppyshare: lstoppysharetounshare){
                if(objlstoppyshare.UserOrGroupId==objNotification_Recipient.Notification_Recipient__c && objlstoppyshare.OpportunityId==objNotification_Recipient.TWS_Deal__c)
                    lstOpportunitySharetounshare.add(objlstoppyshare);
            }
        }
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