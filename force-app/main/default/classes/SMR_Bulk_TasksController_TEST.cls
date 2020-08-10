@IsTest
public class SMR_Bulk_TasksController_TEST {

     @isTest  static void upsertTaskList() 
     { 
         Try{
                 system.debug('-Inside upsertTaskList Test--');
                 //Retrieve SMR task record type from Task object
                 RecordType smrRecType = [select Id from RecordType where sObjectType='Task' AND DeveloperName='SMR_Task' LIMIT 1];
                 //Retrieve SMR case record type from Case object
                 RecordType caseRecType = [select Id from RecordType where sObjectType='Case' AND DeveloperName='SMR_Case' LIMIT 1];
                 //Fetch record type id for SMR task record type
                 Id recordtypeId = SMR_Bulk_TasksController.Get_SMRTaskRecordTypeID();
                 //Retrieve SMR account record type from Account object
                 RecordType ar = [select Id from RecordType where sObjectType='Account' AND DeveloperName='Supplier' LIMIT 1];
                 Account a = new Account(
                     Name = 'smra1',  RecordTypeId=ar.Id
                 );
                 //insert account records
                 insert a;
             
                 //initialize case object data
                  Case cs = new Case();
                    cs.Description='Test Case SMR';
                    cs.Subject='New Test Case SMR';
                    cs.Type='Other Request';
                    cs.OwnerId=  UserInfo.getUserId();
                    cs.RecordTypeId=caseRecType.Id;
                    cs.Priority='Medium';
                    cs.Origin='Email';
                    cs.Status = 'In Progress';
                    cs.AccountId=a.Id;
                   //insert Case records
                   insert cs;
                 
                 //initialize the contact object data
                  Contact ca = new Contact();
                    ca.FirstName = 'smrFN1';
                    ca.LastName = 'smrLN1';
                    ca.phone ='1234567891';
                    ca.Email = 'smrtest@gmtestail.com';
                   ca.AccountId=a.Id;
                 //upsert the contact data
                 upsert ca;
              
                 //Fetch existing tasks list for the user and their subordinates excluding Completed status records based on SMR task typeID
                 List<Task> tsks = SMR_Bulk_TasksController.fetchTasksList(cs.Id);
            
                //initialize Task object data
                Task t = new Task(
                        ActivityDate = Date.today().addDays(7),
                        Subject = 'Sample Task00',
                        RecordTypeId = smrRecType.Id,
                        whatId = cs.Id,
                        Contact__c = ca.Id,
                        OwnerId = UserInfo.getUserId(),
                        Status = 'In Progress');
                
                //initialize Task object data
                Task t1 = new Task(
                        ActivityDate = Date.today().addDays(7),
                        Subject = 'Sample Task11',
                        whatId = cs.Id,
                        RecordTypeId = smrRecType.Id,
                        Contact__c = ca.Id,
                        OwnerId = UserInfo.getUserId(),
                        Status = 'Not Started');
             
                //Add task object data to List
                tsks.add(t);
                tsks.add(t1);
           
             Try{
                 	//Save/Update the tasks list
                 	SMR_Bulk_TasksController.saveTasks(tsks);  
                 }
             	Catch(Exception e){
                  system.debug('exception '+e.getMessage());
           		}
             
           		Try{
                     //initialize Task object data
                     Task t3 = new Task(
                         ActivityDate = Date.today().addDays(7),
                         Subject = 'Sample Task10',
                         RecordTypeId=smrRecType.Id,
                         WhatId = cs.id,
                         OwnerId = UserInfo.getUserId(),
                         Status = 'In Progress');
                     tsks.add(t3);
                     
                     //insert tasks list
                     insert tsks;
                     task objtask2 = [select id,Subject from Task where id=:t3.id]; 
                     
                     //Delete the selected task ID
                     SMR_Bulk_TasksController.deleteTasks(t3.id);
                    }
             	Catch(Exception e){
                  system.debug('exception '+e.getMessage());
           		}
         }
         Catch(Exception e)
         {
             system.debug('exception '+e.getMessage());
         }
    }
}