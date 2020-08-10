@isTest
private class UpdatingAcRecordsTest{
    
    @isTest static void UpdateAccRecmethod(){
        
        list<User> userlist = [Select id,name from User limit 10];
        
        Account acc = new Account();
        acc.name='Test';
        acc.Private_Ownership_List1_Name__c = userlist[0].name;
        acc.Private_Ownership_List2_Name__c = userlist[2].name;
        acc.Private_Ownership_List3_Name__c= userlist[3].name;
        acc.Private_Ownership_List4_Name__c= userlist[5].name;
        acc.Private_Ownership_List5_Name__c= userlist[5].name;
        
        Insert acc;
        
        database.executebatch(new UpdatingAcRecords(),200);
    }
    
    @isTest static void UpdateAccRecmethod1(){
        
        
        Test.startTest();
        
        Account acc;
        for(User u: [select id,UserRole.name,Name,UserRoleid from user where (isactive = true and Userrole.name like 'STC%') order by userrole.name limit 10 Offset 30]){
            
            if(String.ValueOf(u.UserRole.name).Contains('STC Charlotte') || String.ValueOf(u.UserRole.name).Contains('STC Cleveland') || String.ValueOf(u.UserRole.name).Contains('STC Kansas City') || String.ValueOf(u.UserRole.name).Contains('STC Louisville') || String.ValueOf(u.UserRole.name).Contains('STC New England') || String.ValueOf(u.UserRole.name).Contains('STC Tampa'))  
            {System.runas(u){
                acc = new Account();
                acc.name='Test';
                acc.Private_Ownership_List1_Name__c = u.name;
                System.debug(u.userrole.name);
                Database.Insert(acc,false);
                
            }
             
            }
        }
        
        database.executebatch(new UpdatingAcRecords(),20);
        Test.StopTest();
    }
    
    @isTest static void UpdateAccRecmethod2(){
        
        
        Test.startTest();
        
        Account acc;
        for(User u: [select id,UserRole.name,Name,UserRoleid from user where isactive = true and Userrole.name like 'STC%' order by userrole.name limit 10 Offset 20]){
            
            if(String.ValueOf(u.UserRole.name).Contains('STC Charlotte') || String.ValueOf(u.UserRole.name).Contains('STC Cleveland') || String.ValueOf(u.UserRole.name).Contains('STC Kansas City') || String.ValueOf(u.UserRole.name).Contains('STC Louisville') || String.ValueOf(u.UserRole.name).Contains('STC New England') || String.ValueOf(u.UserRole.name).Contains('STC Tampa'))  
            {System.runas(u){
                acc = new Account();
                acc.name='Test';
                acc.Private_Ownership_List1_Name__c = u.name;
                System.debug(u.userrole.name);
                Database.Insert(acc,false);
                
            }
             
            }
        }
        
        database.executebatch(new UpdatingAcRecords(),20);
        Test.StopTest();
    }
    
    @isTest static void UpdateAccRecmethod4(){
        
        
        Test.startTest();
        
        Account acc;
        
        for(User u: [select id,UserRole.name,Name,UserRoleid from user where isactive = true and Userrole.name like 'STC%' order by userrole.name limit 10 Offset 10]){
            
            if(String.ValueOf(u.UserRole.name).Contains('STC Charlotte') || String.ValueOf(u.UserRole.name).Contains('STC Cleveland') || String.ValueOf(u.UserRole.name).Contains('STC Kansas City') || String.ValueOf(u.UserRole.name).Contains('STC Louisville') || String.ValueOf(u.UserRole.name).Contains('STC New England') || String.ValueOf(u.UserRole.name).Contains('STC Tampa'))  
            {System.runas(u){
                acc = new Account();
                acc.name='Test';
                acc.Private_Ownership_List1_Name__c = u.name;
                System.debug(u.userrole.name);
                Database.Insert(acc,false);
                
            }
             
            }
        }
        database.executebatch(new UpdatingAcRecords(),20);
        Test.StopTest();
    }
    
    @isTest static void UpdateAccRecmethod5(){
        
        
        Test.startTest();
        
        Account acc;
        for(User u: [select id,UserRole.name,Name,UserRoleid from user where isactive = true and Userrole.name like 'STC%'order by userrole.name limit 10 Offset 0]){
            
            if(String.ValueOf(u.UserRole.name).Contains('STC Charlotte') || String.ValueOf(u.UserRole.name).Contains('STC Cleveland') || String.ValueOf(u.UserRole.name).Contains('STC Kansas City') || String.ValueOf(u.UserRole.name).Contains('STC Louisville') || String.ValueOf(u.UserRole.name).Contains('STC New England') || String.ValueOf(u.UserRole.name).Contains('STC Tampa'))  
            {System.runas(u){
                acc = new Account();
                acc.name='Test';
                acc.Private_Ownership_List1_Name__c = u.name;
                System.debug(u.userrole.name);
                Database.Insert(acc,false);
                
            }
             
            }
        }
        database.executebatch(new UpdatingAcRecords(),20);
        Test.StopTest();
    }
    
    
    
    
    
}