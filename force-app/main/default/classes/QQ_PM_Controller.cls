public with sharing class QQ_PM_Controller {

    @AuraEnabled
    public static ASP_QQ__c submitPMquote(ASP_QQ__c quoteobj , List <ASP_PM_Line_Items__c> quoteitemlst , List <PM_Line_Item_AddOn__c> addonlst){
        Map<String, ASP_PM_Line_Items__c> qqitemmap = new Map<String, ASP_PM_Line_Items__c>();
        insert quoteobj;
        
        quoteobj = [SELECT Id,Name FROM ASP_QQ__c WHERE Id = :quoteobj.Id];
        
        if(quoteitemlst.size() > 0){
            List <ASP_PM_Line_Items__c> newquoteitemlst = new List <ASP_PM_Line_Items__c> ();
            for(ASP_PM_Line_Items__c qqitem : quoteitemlst)
            {
                qqitem.ASP_QQ__c = quoteobj.Id; 
                newquoteitemlst.add(qqitem); 
            }
           insert newquoteitemlst;
            
            for(ASP_PM_Line_Items__c qqitemobj : newquoteitemlst)
            {
                qqitemmap.put(qqitemobj.Offer_Master_Id__c, qqitemobj);
            } 
            
        }
        
        if(addonlst.size() > 0){
            List <PM_Line_Item_AddOn__c> addonarray = new List <PM_Line_Item_AddOn__c> ();
            
            for(PM_Line_Item_AddOn__c addonobj : addonlst ){
                addonobj.PM_Line_Items__c = qqitemmap.get(addonobj.Offer_Master_Id__c).Id;
                addonarray.add(addonobj);
            }
           insert addonarray;
        } 

        
        return quoteobj;
        
    }
}