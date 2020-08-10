/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Purpose:
* This class is used as an controller for the vf page -PartsDealerBusinessPlan- which is used 
* to Maintain the Business Plan for the users
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Anto  
* @modifiedBy          
* @version        1.3
* @created        
* @modified       04-20-2018
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes 1.3
* modifiedBy      Anto      
* 04-10-2017      Label Changes and added Save and Refresh Button
* 
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes 1.4
* modifiedBy      Chris      
* 09-04-2018      Added Delete functionality to Save and Refresh
* 
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/


public without sharing class DTNA_Parts_Business_Plan 
{
    public String str_NewEditRead {get;set;}
    public Id BPId{get;set;}
    public Business_Plan__c Obj_BusPlan {get;set;}
    public List<Dealer_Performance_Category__c> Lst_Dealer_Performance_Category {get;set;}
    public List<Task> Lst_TOP_Objectives {get;set;}
    public List<Task> Lst_TOP_ImpPlan {get;set;}
    public List<Business_Plan_Detail__c> Lst_BPD_EarnbackOpportunities {get;set;}
    public List<Business_Plan_Detail__c> Lst_BPD_RegFleetConquests {get;set;}
    public List<ID> deleteList{get;set;}
    public DTNA_Parts_Business_Plan(ApexPages.StandardController controller) 
    {
        BPId = ApexPages.currentPage().getParameters().get('id');
        str_NewEditRead = '';
        deleteList = new List<ID>();
        if(BPId  != null)
        {
            Obj_BusPlan = [SELECT Id,Account__c, Account__r.Name, Account__r.Senior_Regional_Parts_Manager__c, Account__r.Regional_Parts_Manager__c,Account__r.Dealer_Code__c, Additional_Notes__c, Year__c, Name, Top_DTNA_Improvements_Action_Plan__c, Top_Objectives_Action_Plan__c, 
             Parts_Contact__c,Location__c from Business_Plan__c  where id = :BPId];
            Lst_Dealer_Performance_Category = [select Id,name,Business_Plan__c, Previous_Year_Purchases__c, Target_Growth__c,Objective_s__c,  Total_YTD_Purchases__c, YTD__c from Dealer_Performance_Category__c where Business_Plan__c=:BPId ORDER by CreatedDate];
            Lst_TOP_Objectives = [SELECT Id,Subject,Owner.Name,OwnerId,ActivityDate,CallObject,Status,Description,Action_Required__c,Delete__c from task where RecordType.DeveloperName = 'Parts_Task' and type='Top Objectives' and whatId=:BPId ORDER by CreatedDate];
            Lst_TOP_ImpPlan = [SELECT Id,Subject,Owner.Name,OwnerId,ActivityDate,Status,Description,Action_Required__c,Delete__c from task where RecordType.DeveloperName = 'Parts_Task' and type='Top DTNA Improvement Items' and whatId=:BPId ORDER by CreatedDate];
            Lst_BPD_EarnbackOpportunities = [SELECT Id, Name, Products__c, RecordType.Name, Opportunity__c,YTD_Opportunity__c,Remaining_Opportunity__c, Fleet__c, Target_Date__c, Completed__C,Summary__C, Delete__c from Business_Plan_Detail__c where RecordType.DeveloperName = 'Earnback_Opportunities' and Business_Plan__c=:BPId ORDER by CreatedDate];
            Lst_BPD_RegFleetConquests = [SELECT Id, Name, Products__c, Fleet__c, RecordType.Name, Opportunity__c,YTD_Opportunity__c,Remaining_Opportunity__c, Target_Date__c, Completed__C,Summary__C from Business_Plan_Detail__c where RecordType.DeveloperName = 'Regional_Fleet_Conquests' and Business_Plan__c=:BPId ORDER by CreatedDate];
        }
        else
        {
            Obj_BusPlan = new Business_Plan__c();
            Lst_Dealer_Performance_Category = new List<Dealer_Performance_Category__c>();
            Lst_TOP_Objectives = new List<Task>();
            Lst_TOP_ImpPlan = new List<Task>();
            Lst_BPD_EarnbackOpportunities = new List<Business_Plan_Detail__c>();
            Lst_BPD_RegFleetConquests = new List<Business_Plan_Detail__c>();
        }
        if(Lst_Dealer_Performance_Category.size() == 0)
        {
            Lst_Dealer_Performance_Category.add(new Dealer_Performance_Category__c(Name='Parts Revenue',Business_Plan__c=BPId));
            //upsert Lst_Dealer_Performance_Category;
        }
    }
    
    public pagereference ReloadPage()
    {
        PageReference BPPage = Page.PartsDealerBusinessPlan;
        BPPage.getParameters().put('Id',BPId);
        BPPage.setRedirect(true);
        return BPPage;
    }
    
    public pagereference goBack()
    {
        PageReference BPPage = new PageReference('/' + BPId);
        BPPage.setRedirect(true);
        return BPPage;
    }
    
    public PageReference SavePage()
    {
        List<ID> trueDeleteList = new List<ID>();
        try
        {
            if(Lst_TOP_Objectives.size() > 0){
                for(Integer i = 0; i < Lst_TOP_Objectives.size(); i++){
                    if(Lst_TOP_Objectives[i].delete__c == true){
                        deleteList.add(Lst_TOP_Objectives[i].id);
                        Lst_TOP_Objectives.remove(i);
                    }
                }
            }
            if(Lst_TOP_ImpPlan.size() > 0){
                for(Integer i = 0; i < Lst_TOP_ImpPlan.size(); i++){
                    if(Lst_TOP_ImpPlan[i].delete__c == true){
                        deleteList.add(Lst_TOP_ImpPlan[i].id);
                        Lst_TOP_ImpPlan.remove(i);
                    }
                }
            }
            if(Lst_BPD_EarnbackOpportunities.size() > 0){
                for(Integer i = 0; i < Lst_BPD_EarnbackOpportunities.size(); i++){
                    if(Lst_BPD_EarnbackOpportunities[i].delete__c == true){
                        deleteList.add(Lst_BPD_EarnbackOpportunities[i].id);
                        Lst_BPD_EarnbackOpportunities.remove(i);
                    }
                }
            }
            update Obj_BusPlan;
            upsert Lst_TOP_Objectives;
            upsert Lst_TOP_ImpPlan;          
            upsert Lst_Dealer_Performance_Category;  
            upsert Lst_BPD_EarnbackOpportunities;
            upsert Lst_BPD_RegFleetConquests;

            if(deleteList.size() > 0){
                for(Integer i = 0; i < deleteList.size(); i++){//Check for null ids
                    if(deleteList[i]!= null){
                        trueDeleteList.add(deleteList[i]);
                    }
                }
                Database.delete(trueDeleteList, false);
            }
            
            PageReference BPPage = Page.PartsDealerBusinessPlan;
            BPPage.getParameters().put('Id',BPId);
            BPPage.setRedirect(true);
            return BPPage;
        }
        catch(Exception e)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,e.getMessage()));
        }        
        return null;
    }

 /*   public PageReference QuickSavePage()
    {
        try
        {
            update Obj_BusPlan;
            upsert Lst_TOP_Objectives;
            upsert Lst_TOP_ImpPlan;
            upsert Lst_Dealer_Performance_Category;
            upsert Lst_BPD_EarnbackOpportunities;
            upsert Lst_BPD_RegFleetConquests;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Update Complete. Please reload to process the recalculations.'));
        }
        catch(Exception e)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,e.getMessage()));
        }
        return null;
    }*/
    
    public PageReference NewDealerPerformanceCategory() 
    {
        Dealer_Performance_Category__c ObjDlrPerfCategory = new Dealer_Performance_Category__c();
        ObjDlrPerfCategory.Business_Plan__c=BPId;
        Lst_Dealer_Performance_Category.add(ObjDlrPerfCategory);
        return null;
    }

    public PageReference NewTopObjective() 
    {
        Task ObjTask = new Task();
        ObjTask.WhatId=BPId;
        ObjTask.Type='Top Objectives';
        ObjTask.RecordTypeId=Schema.SObjectType.Task.getRecordTypeInfosByName().get('Parts Task').getRecordTypeId();
        Lst_TOP_Objectives.add(ObjTask);
        return null;
    }
    
    public PageReference NewImpItems() 
    {
        Task ObjTask = new Task();
        ObjTask.WhatId=BPId;
        ObjTask.Type='Top DTNA Improvement Items';
        ObjTask.RecordTypeId=Schema.SObjectType.Task.getRecordTypeInfosByName().get('Parts Task').getRecordTypeId();
        Lst_TOP_ImpPlan.add(ObjTask);
        return null;
    }
    
    public PageReference NewEarnbackOppt() 
    {
        Business_Plan_Detail__c ObjBPD = new Business_Plan_Detail__c();
        ObjBPD.Business_Plan__c=BPId;
        ObjBPD.RecordTypeId=Schema.SObjectType.Business_Plan_Detail__c.getRecordTypeInfosByName().get('Earnback Opportunities').getRecordTypeId();
        Lst_BPD_EarnbackOpportunities.add(ObjBPD);
        return null;
    }
    
    public PageReference NewRegFleetConq() 
    {
        Business_Plan_Detail__c ObjBPD = new Business_Plan_Detail__c();
        ObjBPD.RecordTypeId=Schema.SObjectType.Business_Plan_Detail__c.getRecordTypeInfosByName().get('Regional Fleet Conquests').getRecordTypeId();
        ObjBPD.Business_Plan__c=BPId;
        Lst_BPD_RegFleetConquests.add(ObjBPD);
        return null;
    }

    public PageReference CalcReRender()
    {
        upsert Lst_Dealer_Performance_Category;
        return null;
    }
    public PageReference saveDealerPerfRecord(){
        System.debug(Apexpages.currentPage().getParameters().get('selectedDealerPerfId'));
        upsert Lst_Dealer_Performance_Category;
        Lst_Dealer_Performance_Category = [select Id,name,Business_Plan__c, Previous_Year_Purchases__c, Target_Growth__c,Objective_s__c,  Total_YTD_Purchases__c, YTD__c from Dealer_Performance_Category__c where Business_Plan__c=:BPId ORDER by CreatedDate];
        return null;
    }

}