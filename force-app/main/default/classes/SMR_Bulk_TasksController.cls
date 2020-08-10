public with sharing class SMR_Bulk_TasksController {
    //Save/Update the tasks list
	@AuraEnabled
    public static void saveTasks(List<Task> tskList) {
        upsert tskList;
    }
    
    //Delete the selected task ID
    @AuraEnabled
    public static void deleteTasks(String ID) {
        Task tasksDel = [SELECT CreatedById FROM Task WHERE Id = :ID]; 
        delete tasksDel;
    }
    
    //Fetch record type id for SMR Task record type
    @AuraEnabled
    public static String Get_SMRTaskRecordTypeID() {
        return Schema.SObjectType.Task.getRecordTypeInfosByName().get('SMR Task').getRecordTypeId();
    }
    
    //Fetch existing tasks list for the user and their subordinates excluding Completed status records
    @AuraEnabled
    public static List <task> fetchTasksList(String recordId) {
        string roleId=userinfo.getUserRoleId();
        string userId=userinfo.getUserId();
        Set<ID> subordinateUserIds = RoleUtils.getRoleSubordinateUsers(roleId);
        system.debug('subordinateUserIds' + subordinateUserIds);
        List <Task> lstOfTask = [select Id, Subject, Contact__r.Name, Task_Completion__c, Status, Priority, WhatId, ActivityDate, Owner.Name,
                                 Description from Task 
                                 WHERE WhatId = :recordId AND Status != :'Completed' AND (OwnerId IN :subordinateUserIds OR OwnerId = :userId) ORDER BY Id];
        
        return lstOfTask;
    }
}