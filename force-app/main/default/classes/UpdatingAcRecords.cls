global class UpdatingAcRecords implements Database.Batchable<sObject>{
    
    
    
    global Database.QueryLocator start(Database.BatchableContext BC){
       // id id1='001d0000028a5Bl';
        String query = 'Select id,name,Private_Ownership_List1__c, Private_Ownership_List1_Name__c,Private_Ownership_List2__c, Private_Ownership_List2_Name__c,Private_Ownership_List3__c, Private_Ownership_List3_Name__c,Private_Ownership_List4__c, Private_Ownership_List4_Name__c,Private_Ownership_List5__c, Private_Ownership_List5_Name__c from Account';
        
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope){
        set<String> idsset= new set<String>();
        List<Private_Ownership__c> Priownlist;
        for(Account acc: scope)
        {
            set<String> names= new set<String>();
            if(acc.Private_Ownership_List1_Name__c!=null)
                names.addall(acc.Private_Ownership_List1_Name__c.split(','));
            if(acc.Private_Ownership_List2_Name__c!=null)
                names.addall(acc.Private_Ownership_List2_Name__c.split(','));
            if(acc.Private_Ownership_List3_Name__c!=null)
                names.addall(acc.Private_Ownership_List3_Name__c.split(','));
            if(acc.Private_Ownership_List4_Name__c!=null)
                names.addall(acc.Private_Ownership_List4_Name__c.split(','));
            if(acc.Private_Ownership_List5_Name__c!=null)
                names.addall(acc.Private_Ownership_List5_Name__c.split(','));
            
            if(names!=null){
                Map<id,Private_Ownership__c > exprimap = new map<id,Private_Ownership__c>();
                
                Map<id,User> UsersMap = new Map<Id,User>([Select id,firstname,Lastname from user where name=:names]);
                if(UsersMap.keyset().size()>0){
                    Private_Ownership__c pri;
                    Priownlist = new list<Private_Ownership__c>();
                    for(User u: UsersMap.values()){
                        if(exprimap.keyset().size()>0){
                            if(exprimap.get(acc.id).Account__c!=acc.id && exprimap.get(acc.id).ownerid!=u.id){
                                pri = new Private_Ownership__c(Account__c = acc.id,name=acc.name, ownerid = u.id);
                                Priownlist.add(pri);
                            }
                        }else{
                            pri = new Private_Ownership__c(Account__c = acc.id,name= acc.name,ownerid = u.id);
                            Priownlist.add(pri);
                        }
                    }
                    
                } 
            }
        }
        if(Priownlist!=null)
            if(Priownlist.size()>0)
            insert Priownlist;
    }
    
    
    
    global void finish(Database.BatchableContext BC){
    }
}