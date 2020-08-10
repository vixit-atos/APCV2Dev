public class TWS_ItemsToApproveMobileController {
             
    ApexPages.standardController stdController= null;
    public TWS_ItemsToApproveMobileController(ApexPages.StandardController controller) {
        stdController=controller;
    }

    
    Set<ID> setTargetObjectIDs=new Set<ID>();
   
@AuraEnabled    
public static List<opportunity> lstopportunityapprove {get; set;}
@AuraEnabled
public static List<Concession__c> lstConcessionstoapprove {get; set;}
@AuraEnabled
public static  List<approval_item_wrapper> getItemToApprove() {
        List<approval_item_wrapper> items_to_approve = new list<approval_item_wrapper>();
        Set<ID> setTargetObjectIDs=new Set<ID>();
        map<id,ProcessInstanceWorkItem> mpaPIWIdToPIW = new map<id,ProcessInstanceWorkItem>();
        list<ProcessInstanceWorkItem> lstPIWI;
        List<id> submittedBy = new list<id>(); 
        List<User>listOfUserSumitAapprove;
        lstPIWI = [select processinstance.targetobjectid,CreatedDate ,processinstance.targetobject.name,ProcessInstance.TargetObject.type,  processinstance.SubmittedById from processinstanceworkitem where actorid = :userinfo.getuserid() Order by CreatedDate Desc];
        if(!lstPIWI.isEmpty()){
            for(ProcessInstanceWorkItem item: lstPIWI) {
                setTargetObjectIDs.add(item.processinstance.targetobjectid);
                system.debug('my debug: ' +  item.processinstance.SubmittedById );
                if(!mpaPIWIdToPIW.containsKey(item.processinstance.targetobjectid)){
                    mpaPIWIdToPIW.put(item.processinstance.targetobjectid,item); 
                    submittedBy.add(item.processinstance.SubmittedById);
                }
            }     
        }
        map<id,User> mapSubmittedByIdToUser = new map<id, User>();    
        map<id,Opportunity> mapoptyIdtoMeetingnotes = new map<id,Opportunity>();
        map<id,Concession__c> mapConcessionIdtoConcessionstatus = new map<id,Concession__c>();
        
        if(setTargetObjectIDs.size()>0){
            listOfUserSumitAapprove = [select id, name from User where id in : submittedBy] ;
            if (!listOfUserSumitAapprove.isEmpty()){
                for(User submitter: listOfUserSumitAapprove){
                    mapSubmittedByIdToUser.put( submitter.id,  submitter);
                }
            }  
        }
    
        if(setTargetObjectIDs.size()>0){
            lstopportunityapprove=[select id,Owner.name,name,Deal_Comments__c,stagename,TC_Meeting_Notes__c,CONC_STATUS_CD__c  from Opportunity where id in : setTargetObjectIDs];
            if(!lstopportunityapprove.isEmpty()){
                for(opportunity objoppy:lstopportunityapprove){
                    mapoptyIdtoMeetingnotes.put(objoppy.id,objoppy);
                }
            }
        }
        if(setTargetObjectIDs.size()>0){
            lstConcessionstoapprove =[select id,name, CONC_STATUS_CD__c from Concession__c where id in : setTargetObjectIDs];
            if(!lstConcessionstoapprove.isEmpty()){
                for(Concession__c  objConcession : lstConcessionstoapprove ){
                    mapConcessionIdtoConcessionstatus.put(objConcession.id,objConcession );
                }
            }
        }
        if(!lstPIWI.isEmpty()){
            
            for(ProcessInstanceWorkItem item: mpaPIWIdToPIW.values()) {
                
                String dateTimeValue = item.CreatedDate.format('MM/dd/yyyy hh:mm a');
                
                system.debug(dateTimeValue +'Debug2 dateTimeValue ');
                
                if(item.processinstance.TargetObject.type == 'Opportunity'){
                    system.debug(item.processinstance.targetobjectid +'Debug2 dateTimeValue ');
                    
                    items_to_approve.add(new approval_item_wrapper(item.processinstance.targetobjectid,item.processinstance.targetobject.name,item.processinstance.TargetObject.type,dateTimeValue ,mapoptyIdtoMeetingnotes.get(item.processinstance.targetobjectid).TC_Meeting_Notes__c,item.id,'', mapSubmittedByIdToUser.get(item.processinstance.SubmittedById).name )); 
                }else if(item.processinstance.TargetObject.type == 'Concession__c'){
                    system.debug(item.processinstance.targetobjectid +'Debug2 dateTimeValue ');
                    
                    
                    String sObjName = item.processinstance.targetobjectid.getSObjectType().getDescribe().getLabel();   
                    system.debug(sObjName +'sObjNameValue ');
                    
                    items_to_approve.add(new approval_item_wrapper(item.processinstance.targetobjectid,item.processinstance.targetobject.name,sObjName ,dateTimeValue ,'',item.id,mapConcessionIdtoConcessionstatus.get(item.processinstance.targetobjectid).CONC_STATUS_CD__c, mapSubmittedByIdToUser.get(item.processinstance.SubmittedById).name  ));   
                }else{
                    String sObjName = item.processinstance.targetobjectid.getSObjectType().getDescribe().getLabel();   
                    system.debug(sObjName +'sObjNameValue ');
                    items_to_approve.add(new approval_item_wrapper(item.processinstance.targetobjectid,item.processinstance.targetobject.name,sObjName ,dateTimeValue ,'',item.id,'',mapSubmittedByIdToUser.get(item.processinstance.SubmittedById).name   )); //mapSubmittedByIdToUser.get(item.processinstance.SubmittedById).name 
                    
                }
            }
        }
        system.debug('Size of appover: ' + items_to_approve.size());
        //system.debug('Appover: ' + items_to_approve.get(0));
        return items_to_approve;
    } 
}