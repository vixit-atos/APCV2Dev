trigger GroupMembernameupdate on Private_Ownership__c(before insert,before update,After Insert) {
    
    if(Trigger.isBefore){
        if(Trigger.isInsert || Trigger.IsUpdate)
        CreatingPrivateOwnerHandler.UpdatinPrivateownerGroupName(Trigger.new);
        
       
       } 
        
        
        
    if(Trigger.isAfter && Trigger.isInsert){
    CreatingPrivateOwnerHandler.CreatingSTC_OwnerRecords(Trigger.new);
    }
    }