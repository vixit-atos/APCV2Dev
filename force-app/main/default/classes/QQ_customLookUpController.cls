public without sharing class QQ_customLookUpController {
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName) {
        String qq_flag = 'A'; 
        String searchKey = '%' + searchKeyWord + '%';  
        List < sObject > returnList = new List < sObject > ();
              // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5  
        RecordType[] Rec = [Select Id from recordtype where name like 'Prospect/Customer']; 
        Id recordtypeid = Rec[0].Id;
        Id dealerid = QQ_customLookUpController.finddealerAccountid();
        //system.debug('dealer1' + dealerid);
        String sQuery;
        if(dealerid != null){
         //   system.debug('dealer2' + dealerid);
            List <Id> relationidlst = new List<Id>();
          List<Account_Relationship__c> accntrelationship_list =[Select Related_Account__c from Account_Relationship__c where Parent_Account__c=:dealerid];
          //system.debug(accntrelationship_list);
            for (Account_Relationship__c sObj: accntrelationship_list)
          {
              //system.debug(sobj.Related_Account__c);
              relationidlst.add(sobj.Related_Account__c);
          }
            
          sQuery  =  'select id, Name from ' +ObjectName + ' where Name LIKE: searchKey AND recordtypeid =: recordtypeid and Id in :relationidlst AND APL_Flag__c= :qq_flag order by createdDate DESC limit 5';
        
        }
        else{
        sQuery =  'select id, Name from ' +ObjectName + ' where Name LIKE: searchKey AND recordtypeid =: recordtypeid AND APL_Flag__c= :qq_flag order by createdDate DESC limit 5';
        }
        system.debug(sQuery);
        List < sObject > lstOfRecords = Database.query(sQuery); 
        system.debug(lstOfRecords);
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);}
        return returnList;
    }
    @AuraEnabled
    public static Account createQQCustomer(String customername ) {
        Id new_existing_customerId;
        Id dealerId;
        Account newqqcustomer = new Account();
        User usr = [SELECT ContactId FROM User where Id= :UserInfo.getUserID()];
        //system.debug(usr.size());
        if(usr.ContactId != null  && !Test.isRunningTest())
        {
          Contact dealer = [Select AccountId from Contact where Id = :usr.ContactId];  
          dealerId = dealer.AccountId;
        }
        if(Test.isRunningTest()){
            Account acc = new Account();
            acc.Name='Test createQQCustomer';
            insert acc;
            dealerId = acc.Id;   
        }
        //
        RecordType[] Rec = [Select Id from recordtype where name like 'Prospect/Customer'];   
        List <Account> customer = [Select Id,Name from Account where name= :customername AND recordtypeid = :Rec[0].Id ];
        if(customer.size() == 0){
            newqqcustomer.Name = customername;
            newqqcustomer.recordtypeid = Rec[0].Id;
            newqqcustomer.APL_Flag__c = 'A';
            insert(newqqcustomer); 
            new_existing_customerId = newqqcustomer.Id;
        }else{
            new_existing_customerId = customer[0].Id;
            newqqcustomer = customer[0];
        }
      // system.debug(dealerId);
        if(dealerId != null)
        {
            List <Account_Relationship__c> dealercustomer_relationship = [Select Id from Account_Relationship__c where Parent_Account__c=:dealerId AND Related_Account__c =:new_existing_customerId];
             if(dealercustomer_relationship.size() == 0)
            {
                Account_Relationship__c dealercustomer = new Account_Relationship__c();
                dealercustomer.Parent_Account__c = dealerId;
                dealercustomer.Related_Account__c = new_existing_customerId; 
               // dealercustomer.Relationship_Type__c = 'Prospect/Client';
                insert dealercustomer;
            }
        }
        return newqqcustomer; 
    }
    public static Id finddealerAccountid() {
        Id dealerId;
        List<User> usr = [SELECT ContactId FROM User where Id= :UserInfo.getUserID()];
        //system.debug(usr.size());
        if(usr[0].ContactId != null  && !Test.isRunningTest())
        {
          Contact dealer = [Select AccountId from Contact where Id =:usr[0].ContactId];  
          dealerId = dealer.AccountId ;
          return dealerId;  
        }else{
        return null;
        }
    }
}