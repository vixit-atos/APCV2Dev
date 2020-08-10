public without sharing class Isp_Won_or_lost_vf_page_cont_extn {
    public Opportunity Opp{get;set;}
    public String oppId{get;set;}
    public String oppstage{get;set;}
    public Isp_Won_or_lost_vf_page_cont_extn(ApexPages.StandardController controller) {
        oppId=ApexPages.currentPage().getParameters().get('Id');
        if(oppId !=null)
            opp= [select id,Lost_Reason_ISP__c,StageName,Won_Lost_Comments__c,Won_Lost__c from opportunity where id=:oppId];
        oppstage=opp.StageName;
    }
    public PageReference pageAction() {
        
        if((oppstage!= 'ISP Approved')){
            PageReference pageRef = new PageReference('/'+oppId+'/e?retURL='+oppId);
            //pageRef.setRedirect(True);
            return pageRef;
        }
        else{
            PageReference pageRef = new PageReference('/apex/Isp_Won_or_lost_on_opportunity_vf_page?Id='+oppId);
            // pageRef.setRedirect(True);
            return pageRef;
            
        }
        
        
        
        
    }
    public pagereference save1(){
        //if(!approval.islocked(opp.id)){
        Approval.UnlockResult UnLoRes= approval.unlock(opp.id);
        if (UnLoRes.isSuccess()) 
        {   
            if (opp.Won_Lost__c =='Lost' && opp.Lost_Reason_ISP__c==null)
            { 	 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Warning,'Please Select a Lost reason as the Deal is Lost');
             ApexPages.addMessage(myMsg);
             //opp.Lost_Reason_ISP__c=null;
             return null;
            }
            
            else{
                update opp;
                Approval.LockResult LoRes= approval.lock(opp.id);
                if(LoRes.isSuccess())
                {
                    system.debug('The record updated and locked successfully');
                    PageReference pageRef = new PageReference('/'+opp.id);
                    pageRef.setRedirect(True);
                    return pageRef;
                }
                
                else
                {
                    for(Database.Error err : LoRes.getErrors()) {
                        System.debug('The following error has occurred while locking.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Opportunity fields that affected this error: ' + err.getFields());
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Warning,'Error is '+err.getMessage()+' Please contact your administrator');
                        ApexPages.addMessage(myMsg);
                        
                        
                    }
                    
                    return null;
                    
                }
                
            }        
        }
        else
        {
            for(Database.Error err : UnLoRes.getErrors()) {
                System.debug('The following error has occurred While Unlocking.');                    
                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                System.debug('Opportunity fields that affected this error: ' + err.getFields());
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Warning,'Error is '+err.getMessage()+' Please contact your administrator');
                ApexPages.addMessage(myMsg);
                
            }
            return null;
        }
        
        //}
        //return null;
    }
    public pagereference Cancel1(){
        PageReference pageRef = new PageReference('/'+opp.id);
        pageRef.setRedirect(True);
        return pageRef;
        
    }
    
    
}