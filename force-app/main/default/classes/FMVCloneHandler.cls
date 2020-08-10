public with sharing class FMVCloneHandler 
{
    public void OnBeforeInsert(List<ASP_QQ_Switch__c> newSwitch)
    {
        /* Duplicate Prevention - Start */
        Set<Date> setDate = new Set<Date>();
        Map<Date, ASP_QQ_Switch__c> mapNameWiseSwitch = new Map<Date, ASP_QQ_Switch__c>();  
        for(ASP_QQ_Switch__c obj: newSwitch) {
            setDate.add(obj.FMV_Date__c);
        }
        List<ASP_QQ_Switch__c> lstSwitch = [SELECT Id, FMV_Date__c, Expiration_Date__c, Active__c FROM ASP_QQ_Switch__c where FMV_Date__c  in : setDate];
        for(ASP_QQ_Switch__c obj: lstSwitch) {
            mapNameWiseSwitch.put(obj.FMV_Date__c ,obj);
        }
        for(ASP_QQ_Switch__c obj : newSwitch){
            if(mapNameWiseSwitch.containsKey(obj.FMV_Date__c)) {
                obj.FMV_Date__c.addError('Date already Exist');
            } 
        }
        /* Duplicate Prevention - Ends */
        
    }
    
    public void OnAfterInsert(List<ASP_QQ_Switch__c> newSwitch)
    {
        List<ASP_QQ_Duration_Master__c> lstToBeUpdated = new List<ASP_QQ_Duration_Master__c>();
        List<ASP_QQ_Duration_Master__c> lstToBeInserted = new List<ASP_QQ_Duration_Master__c>();
        List<ASP_QQ_Duration_Master__c> lstExisting = [SELECT Id, Name, Active__c, Usage__c, Cost__c, Coverage__c, Coverage_Type__c, Databook_Code__c, Deductible__c, Engine_Component__c, FMV_Date__c, Group__c, Miles__c, Months__c, Option__c, Price__c, Pricing_Types__c, Publication_Status__c, Standalone_Package__c, Truck_Coverage_Package__c, Level__c FROM ASP_QQ_Duration_Master__c where Active__c =: TRUE];
        
        for(ASP_QQ_Switch__c objSW: newSwitch){
            if(objSW.Active__c == TRUE){
                for(ASP_QQ_Duration_Master__c objExist: lstExisting){
                    ASP_QQ_Duration_Master__c objNew = new ASP_QQ_Duration_Master__c();
					objNew.Name = objExist.Name;
					objNew.Active__c = objExist.Active__c;
					objNew.Usage__c = objExist.Usage__c;
					objNew.Cost__c = objExist.Cost__c;
					objNew.Coverage__c = objExist.Coverage__c;
					objNew.Coverage_Type__c = objExist.Coverage_Type__c;
					objNew.Databook_Code__c = objExist.Databook_Code__c;
					objNew.Deductible__c = objExist.Deductible__c;
					objNew.Engine_Component__c = objExist.Engine_Component__c;
					objNew.FMV_Date__c = objSW.FMV_Date__c;
					objNew.Group__c = objExist.Group__c;
					//objNew.Kms__c = objExist.Kms__c;
					objNew.Miles__c = objExist.Miles__c;
					objNew.Months__c = objExist.Months__c;
					objNew.Option__c = objExist.Option__c;
					objNew.Price__c = objExist.Price__c;
					objNew.Pricing_Types__c = objExist.Pricing_Types__c;
					objNew.Publication_Status__c = objExist.Publication_Status__c;
					objNew.Standalone_Package__c = objExist.Standalone_Package__c;
					objNew.Truck_Coverage_Package__c	 = objExist.Truck_Coverage_Package__c	;
					//objNew.Unique_Record_Name__c = objExist.Unique_Record_Name__c;
					objNew.Level__c = objExist.Level__c;
					

                    lstToBeInserted.add(objNew);
                    objExist.Active__c = FALSE;
                    lstToBeUpdated.add(objExist);
                    
                }
            } else if(objSW.Active__c == FALSE){
                for(ASP_QQ_Duration_Master__c objExist: lstExisting){
                    if (objSW.FMV_Date__c == objExist.FMV_Date__c){
                        objExist.Active__c = FALSE;
                        lstToBeUpdated.add(objExist);
                    }
                }
            }
        }
        
        //insert lstToBeInserted;    
        try {
            insert lstToBeInserted;
        } catch (system.Dmlexception e) {
            system.debug (e);
        }
        
        //insert lstToBeUpdated;    
        try {
            update lstToBeUpdated;
        } catch (system.Dmlexception e) {
            system.debug (e);
        }
    } 
    public void OnBeforeUpdate( List<ASP_QQ_Switch__c> newSwitch, List<ASP_QQ_Switch__c> oldSwitch, Map<ID, ASP_QQ_Switch__c> newSwitchMap , Map<ID, ASP_QQ_Switch__c> oldSwitchMap )
    {
        
    }
    public void OnAfterUpdate( List<ASP_QQ_Switch__c> newSwitch, List<ASP_QQ_Switch__c> oldSwitch, Map<ID, ASP_QQ_Switch__c> newSwitchMap , Map<ID, ASP_QQ_Switch__c> oldSwitchMap )
    {
        List<ASP_QQ_Duration_Master__c> lstToBeUpdated = new List<ASP_QQ_Duration_Master__c>();
        List<ASP_QQ_Duration_Master__c> lstToBeInserted = new List<ASP_QQ_Duration_Master__c>();
        List<ASP_QQ_Duration_Master__c> lstExisting = [SELECT Id, Name, Active__c, FMV_Date__c FROM ASP_QQ_Duration_Master__c];
        
        
        for(ASP_QQ_Switch__c objSW: newSwitch) {
			if(oldSwitchMap.get(objSW.Id).FMV_Date__c == newSwitchMap.get(objSW.Id).FMV_Date__c && 
				oldSwitchMap.get(objSW.Id).Active__c == newSwitchMap.get(objSW.Id).Active__c
			){
			/* Expiration Date can be changed multiple times in a year */
			} else{
			
			
				if(objSW.Active__c == TRUE) { 
					if(oldSwitchMap.get(objSW.Id).FMV_Date__c == newSwitchMap.get(objSW.Id).FMV_Date__c) {
						for(ASP_QQ_Duration_Master__c objExist: lstExisting) {
							if (objSW.FMV_Date__c == objExist.FMV_Date__c) {
								objExist.Active__c = TRUE;
							} 
							lstToBeUpdated.add(objExist);
						}
					}                
					if(oldSwitchMap.get(objSW.Id).FMV_Date__c != newSwitchMap.get(objSW.Id).FMV_Date__c) {
						for(ASP_QQ_Duration_Master__c objExist: lstExisting) {
							if(objExist.Active__c == TRUE) {
								ASP_QQ_Duration_Master__c objNew = new ASP_QQ_Duration_Master__c();
								objNew.Name = objExist.Name;
								objNew.Active__c = objExist.Active__c;
								objNew.FMV_Date__c = objSW.FMV_Date__c;
								lstToBeInserted.add(objNew);					
							}
							objExist.Active__c = FALSE;
							lstToBeUpdated.add(objExist);
						}
					}
				} else if(objSW.Active__c == FALSE){
					if(oldSwitchMap.get(objSW.Id).FMV_Date__c == newSwitchMap.get(objSW.Id).FMV_Date__c) {
						for(ASP_QQ_Duration_Master__c objExist: lstExisting) {
							if (objSW.FMV_Date__c == objExist.FMV_Date__c) {
								objExist.Active__c = FALSE;
								lstToBeUpdated.add(objExist);
							}
						}
					}
				}
			}
        }
        
        //insert lstToBeInserted;    
        try {
            insert lstToBeInserted;
        } catch (system.Dmlexception e) {
            system.debug (e);
        }
        
        //insert lstToBeUpdated;    
        try {
            update lstToBeUpdated;
        } catch (system.Dmlexception e) {
            system.debug (e);
        }
        
    }
}