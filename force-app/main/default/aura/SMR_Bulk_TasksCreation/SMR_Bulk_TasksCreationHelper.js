({    
    //get and set the SMR tasks record typeID
    getRecordTypes : function(component,event,helper){
        //Call Apex class to get the tasks record typeID
        var action = component.get("c.Get_SMRTaskRecordTypeID");
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var taskrecordTypeID = response.getReturnValue();
                //set the task Record TypeID  
                component.set("v.SMRtaskrecordTypeId", taskrecordTypeID);
            }
            else{
                component.find('notifLib').showToast({
                            "variant": "error",
                            "message": 'Temporary Error: There is a problem getting the Record TypeID'
                        });
            }
        });
        $A.enqueueAction(action); 
    },
    
    //populate the existing tasks list if there are any for the selected case otherwise add the 5 new tasks rows
    populateExistingTaskList : function(component,event,helper){
        component.set("v.taskList", []);
        
        //Call fetchTasksList Apex class
        var action = component.get("c.fetchTasksList");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var listOfTask = response.getReturnValue();
                var SMRExistingRecordCount = listOfTask.length;
                component.set("v.SMRExistingRecordCount", SMRExistingRecordCount);

                if(SMRExistingRecordCount > 0)
                {
                    var taskList = component.get("v.taskList");
                    for (var i = 0; i < listOfTask.length; i++) {
                        taskList.push({'sobjectType': 'Task', 'Subject': '', 
                            'OwnerId': '', 'ActivityDate': '', 'Task_Completion__c': '', 'Status': '', 'Priority': '', 'Description': '',
                                       'WhatId': '', 'RecordTypeId': '', 'Contact__c': '', });
                        
                        taskList[i].Id = listOfTask[i].Id;
                        taskList[i].Subject = listOfTask[i].Subject;
                        taskList[i].ActivityDate = listOfTask[i].ActivityDate;
                        
                        var caseOwner = component.get("v.caserecord.Owner");
                        if(listOfTask[i].Owner != "" && listOfTask[i].Owner != undefined)
                        	taskList[i].OwnerId = listOfTask[i].Owner;
                        else
                            taskList[i].OwnerId = caseOwner;
                                                
                        taskList[i].Contact__c = listOfTask[i].Contact__r;
                        
                        if(listOfTask[i].Task_Completion__c != undefined)
                            taskList[i].Task_Completion__c = listOfTask[i].Task_Completion__c;
                        
                        taskList[i].Status = listOfTask[i].Status;                    
                        taskList[i].Priority = listOfTask[i].Priority;
                    
                        taskList[i].Description = listOfTask[i].Description;
                    }
                    component.set("v.taskList", taskList);
                }
                else
                {
                    helper.addTaskRecord(component, event, helper);
                }
            }
            else{
                component.find('notifLib').showToast({
                            "variant": "error",
                            "message": 'Temporary Error: There is a problem getting the existing tasks list'
                        });
            }
        });
        $A.enqueueAction(action); 
    },
    
    //add 5 new tasks rows
    addTaskRecord: function(component, event, helper) {
        //get the taskList/CaseNumber/owner from component  
		var taskList = component.get("v.taskList");
        var CaseNumber = component.get("v.CaseNumber");
        var caseOwner = component.get("v.caserecord.Owner");
              
        for (var i = 0; i < 5; i++) {
            //Add New Task Record
            taskList.push({
                'sobjectType': 'Task',
                'Subject': '',
               
                'OwnerId': caseOwner,
                'ActivityDate': '',
                'Task_Completion__c': '',
                'Status': '',
                'Priority': '',
                'Description': 'PROBLEM:\nCAUSE:\nCORRECTIVE ACTION:',
                'WhatId': '',
                'RecordTypeId': '',
                'Contact__c': '',
            });
            

        }
        component.set("v.taskList", taskList);
        
        if(caseOwner == null || caseOwner == '' || caseOwner == undefined)
        {
            helper.populateExistingTaskList(component, event, helper);
        }
    },
    
    //delete the selected task from salesforce database
    deleteTaskRecord: function(component, event, index) {
        //get the task List from component  
		var taskList = component.get("v.taskList");
        var taskId = taskList[index].Id;
        
        if(taskId != "" && taskId != undefined)
        {
            //Call the deleteTasks Apex class and pass taskid parameter
            var action = component.get("c.deleteTasks");
            action.setParams({
                "ID": taskId
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    taskList.splice(index, 1);
                    component.set("v.taskList", taskList);
                    component.find('notifLib').showToast({
                            "variant": "Success",
                            "message": 'Task record(s) deleted successfully'
                        });
                }
                else{
                     component.find('notifLib').showToast({
                            "variant": "error",
                            "message": 'Task record(s) deletion Failed'
                        });
                  
                }
            }); 
            $A.enqueueAction(action);
        }
        else
        {
            taskList.splice(index, 1);
            component.set("v.taskList", taskList);
        }
    },
    
    //prepopulated Priority and AssignedTo task records
    setPrePopulatedTaskRecord: function(component, event) {
        for (var i = 0; i < 5; i++) {
            var taskList = component.get("v.taskList");
            var caseOwner = component.get("v.caserecord.Owner");
            component.set("v.caseOwner", caseOwner);
            component.set("v.taskList", taskList);
        }
    },
     
    //validate all the manadatory task records
    validateTaskList: function(component, event) {
        var isValid = true;
        var taskList = component.get("v.taskList");
        var errorMessage = '';
        
        for (var i = 0; i < taskList.length; i++) {
            
            if (taskList[i].Subject == '' && (taskList[i].ActivityDate == '' || taskList[i].ActivityDate == undefined) && taskList[i].OwnerId == undefined)
            {
                
            }
            else if (taskList[i].Subject == '' && (taskList[i].ActivityDate == '' || taskList[i].ActivityDate == undefined) && taskList[i].OwnerId != undefined)
            {
                
            }
            else
            {
                if (taskList[i].Subject == '') {
                    isValid = false;
                    errorMessage = errorMessage + 'Subject cannot be blank on row. ' + (i + 1) + '\n';
                }
                
                if (taskList[i].ActivityDate == '' || taskList[i].ActivityDate == undefined) {
                    isValid = false;
                    errorMessage = errorMessage + 'Due Date cannot be blank on row. ' + (i + 1) + '\n';
                }
                
                if(taskList[i].OwnerId == undefined)
                {
                    isValid = false;
                    errorMessage = errorMessage + 'Assigned To cannot be blank/invalid on row. ' + (i + 1) + '\n';
                }
                
                if(taskList[i].OwnerId != undefined)
                {
                    if (taskList[i].OwnerId.Name == '' || taskList[i].OwnerId.Name == undefined) {
                        isValid = false;
                        errorMessage = errorMessage + 'Assigned To cannot be blank/invalid on row. ' + (i + 1) + '\n';
                    }
                }
            }
        }
        
        if(errorMessage != "" && errorMessage != undefined)
        {
        	  component.find('notifLib').showToast({
                            "variant": "error",
                            "message": errorMessage
                        });
        }
        
        return isValid;
    },
     
    //Call the saveTasks Apex class to save/update the added/modified tasks
    saveTaskList: function(component, event, helper) {
        
        var recordId = component.get("v.recordId");
        var SMRtaskrecordType = component.get("v.SMRtaskrecordTypeId");
        var taskList = component.get("v.taskList");
        
        for (var i = (taskList.length - 1); i >= 0; i--) {
            
            if (taskList[i].Subject == '' && (taskList[i].ActivityDate == '' || taskList[i].ActivityDate == undefined) && taskList[i].OwnerId == undefined)
            {
                taskList.splice(i, 1);
            }
            else if (taskList[i].Subject == '' && (taskList[i].ActivityDate == '' || taskList[i].ActivityDate == undefined) && taskList[i].OwnerId != undefined)
            {
                taskList.splice(i, 1);
            }
        }
        
        if(taskList.length <= 0)
        {
            component.find('notifLib').showToast({
                            "variant": "info",
                            "message": 'No task record(s) to save'
                        });
        	return;
        }
        
        for (var i = 0; i < taskList.length; i++) {
            
            if(taskList[i].Task_Completion__c == "" || taskList[i].Task_Completion__c == undefined)
            	taskList[i].Task_Completion__c = '0%';
            if(taskList[i].Status == "" || taskList[i].Status == undefined)
            	taskList[i].Status = 'Not Started';
            if(taskList[i].Priority == "" || taskList[i].Priority == undefined)
            	taskList[i].Priority = 'Normal';
            
            if(taskList[i].Task_Completion__c.indexOf('%') == -1)
            	taskList[i].Task_Completion__c = taskList[i].Task_Completion__c + '%';
            
            taskList[i].WhatId = recordId;
            taskList[i].RecordTypeId = SMRtaskrecordType;
            if(taskList[i].Contact__c != undefined && taskList[i].Contact__c != "")
            	taskList[i].Contact__c = taskList[i].Contact__c.Id;
            
            if(taskList[i].OwnerId != undefined && taskList[i].OwnerId != "")
            	taskList[i].OwnerId = taskList[i].OwnerId.Id;
        }

        //Call Apex class and pass task list parameters
        var action = component.get("c.saveTasks");
        action.setParams({
            "tskList": component.get("v.taskList")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                  component.find('notifLib').showToast({
                            "variant": "success",
                            "message": 'Task record(s) inserted/updated successfully'
                        });
            }
            else{
                 component.find('notifLib').showToast({
                            "variant": "error",
                            "message": 'Task record(s) Failed' + '\n' + 'You do not have the level of access necessary to perform the operation you requested. Please contact the owner of the record or your administrator if access is necessary'
                        });
                
                console.log("Errors", response.getError());
            }
        }); 
        $A.enqueueAction(action);
    },
    
})