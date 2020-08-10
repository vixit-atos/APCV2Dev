@isTest
public class TaskTriggerActionsEXtTest {
    static testMethod void taskTriggerActMethod(){
        /*Account newAcc = new Account();
            newAcc.Name = 'Test Acc';
        insert newAcc;
        
        Task_Closure_Email_Template__c tskEmailCustSetng = new Task_Closure_Email_Template__c(name='National', Object_Type__c='Opportunity', Email_Template__c='TWS_TC_Task_CompletedVFTemplate');
        insert tskEmailCustSetng;
        Task_Group_Closure_Types_List__c tskgrpcls = new Task_Group_Closure_Types_List__c(name='Controlling Group Review - TWS', StageUpdate__c='Controlling Review');
        insert tskgrpcls;
        
        contact cont = new contact();
        cont.LastName = 'test';
        cont.email = 'test@gmtestail.com';
        insert cont ; 
        
        Opportunity newOpp = new Opportunity();
            newOpp.Name = 'Test Opp';
            newOpp.AccountId = newAcc.Id;
            newOpp.StageName = 'Ready for Submission';
            newOpp.RecordTypeId = '0121D0000000s2O';
            newOpp.CloseDate = System.today()+45;
        insert newOpp;
        
        
        Task t1 = new Task();
            t1.Subject = 'Test task1';
            t1.Status = 'New';
            t1.Priority = 'Normal';
            t1.WhatId = newOpp.Id;
       // insert t1;
        */
        
        
            Task_Closure_Email_Template__c tskEmailCustSetng = new Task_Closure_Email_Template__c(name='TWS_TC_Deal', Object_Type__c='Opportunity', Email_Template__c='TWS_TC_Task_CompletedVFTemplate');
            insert tskEmailCustSetng;
            Task_Group_Closure_Types_List__c tskgrpcls = new Task_Group_Closure_Types_List__c(name='Controlling Group Review - TWS', StageUpdate__c='Controlling Review');
            insert tskgrpcls;
            
            User NAEuser =[select id,name,email from  User where  SalesUserRole__c='NAE' Limit 1];
            
            Account a = new Account (Name = 'a1');
            
            insert a;
            Contact ca = new Contact(
                
                
                FirstName = 'cFN1',
                LastName = 'cLN1',
                AccountId = a.Id,
                Email = 'test@gmtestail.com'
            );
            
            insert ca;
            
            Id domesticRecordTypeId = TWSConstants.getOpportunityRecordTypeMap().get('TWS_TC_Deal');
            
            Opportunity o = new Opportunity(Name = 'o1',DTR_Requested_to_Quote_Residual__c = true, VEH_MAKE__c = 'FTL', Account = a,RecordTypeId = domesticRecordTypeId, StageName = 'Initial Notification', CloseDate = Date.Today(),Owner=NAEuser);
            insert o;
            
            Task  t = new Task(
                ActivityDate = Date.today().addDays(7),
                Subject = 'Sample Task',
                WhatId = o.Id,
                OwnerId = UserInfo.getUserId(),
                Status = 'Pending Controlling review',
            	Type = 'Controlling Group Review - TWS');
            insert t;
            task objtask=[select id,Subject,status,type from Task where id=:t.id]; 
            system.debug('objtask11111111111'+objtask);
            //edit a task
            objtask.Subject = 'Edited Sample Task';
            objtask.Status='Completed';
            objtask.Type='Controlling Group Review - TWS';
        Task  t1 = new Task(
                ActivityDate = Date.today().addDays(7),
                Subject = 'Sample Task',
                WhatId = o.Id,
                OwnerId = UserInfo.getUserId(),
                Status = 'Completed');
                
        List<Task> tskList = new List<Task>();
        tskList.add(t);
        tskList.add(t1);
        tskList.add(objtask);
        //TaskTriggerActionsEXt tta = new TaskTriggerActionsEXt();
        //TaskTriggerActionsEXt.updateoppstage(tskList);
        //update newOpp;
        
    }

}