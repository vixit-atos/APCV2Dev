({
    //Initialize record type id and populate the tasks list if any
    doInit: function (component, event, helper) {
        //set the Cuurent user id to variable LoggedInUserID
        component.set("v.LoggedInUserID" , $A.get("$SObjectType.CurrentUser.Id"));
        component.set("v.showspinner" , true);
        helper.getRecordTypes(component,event,helper);
        //fetch the tasks for a given case
        helper.populateExistingTaskList(component,event,helper);  
        // Make Spinner attribute False to hide loading spinner 
		component.find('recordLoader').reloadRecord(true , function(){component.set("v.showspinner" , false)}); 
    },
   
    //set the current logged in userID
    doneRendering: function(component, event, helper) {
        if(!component.get("v.isDoneRendering")){
            //set the logged in userID
            component.set("v.LoggedInUserID" , $A.get("$SObjectType.CurrentUser.Id"));
          	component.set("v.isDoneRendering", true);
        }
    },
    
    //open the task in new window for the selected task link
    navigateToRecord: function(component, event, helper) {
        if(event.target.dataset.index != undefined)
        {
            var sObectEvent = $A.get("e.force:navigateToSObject");
            sObectEvent .setParams({
                "recordId": event.target.dataset.index  ,
                "slideDevName": "detail"
            });
            sObectEvent.fire();
        }
      },
    
    //add 5 new tasks rows
    addRow: function(component, event, helper) {
        component.set("v.showspinner" , true);
        helper.addTaskRecord(component, event, helper);
        component.find('recordLoader').reloadRecord(true , function(){component.set("v.showspinner" , false)}); 
    },
     
	//remove the selected tasks rows
    removeRow: function(component, event, helper) {
        //Get the task list
		var taskList = component.get("v.taskList");
        //Get the target object
        var selectedItem = event.currentTarget;
        //Get the selected item index
        var index = selectedItem.dataset.record;
        var taskId = taskList[index].Id;

        if(taskId != "" && taskId != undefined)
        {
            if(confirm("Are you sure you want to delete this task?")){   
                //delete the tasks records from salesforce database
                helper.deleteTaskRecord(component, event, index);
            }
        }
        else
        {
            //delete the tasks records from UI
            helper.deleteTaskRecord(component, event, index);
        }
    },
     
    //save the tasks list and then populate the existing tasks list for that case
    save: function(component, event, helper) {
        component.set("v.showspinner" , true);
        if (helper.validateTaskList(component, event)) {
            helper.saveTaskList(component, event);
            helper.populateExistingTaskList(component, event, helper);
        }
        component.find('recordLoader').reloadRecord(true , function(){component.set("v.showspinner" , false)}); 
    },
    
    //clear and pre populate the existing tasks list for that case
    cancel: function(component, event, helper) {
        component.set("v.showspinner" , true);
        helper.populateExistingTaskList(component, event, helper);
        component.find('recordLoader').reloadRecord(true , function(){component.set("v.showspinner" , false)}); 
    },
    
    selectRecord : function(component, event, helper){      
        // get the selected record from list  
        var getSelectRecord = component.get("v.oRecord");
        // call the event   
        var compEvent = component.getEvent("oSelectedRecordEvent");
        // set the Selected sObject Record to the event attribute.  
        compEvent.setParams({"recordByEvent" : getSelectRecord });  
        // fire the event  
        compEvent.fire();
    },
     //refreshes the view
    refresh: function(component, event, helper) {
       console.log('refresh---' + event.getParams().type);
       if(event.getParams().type == "SUCCESS")
       {
            component.set("v.showspinner" , true);
            helper.populateExistingTaskList(component, event, helper);
            component.find('recordLoader').reloadRecord(true , function(){component.set("v.showspinner" , false)});        
       }
    
    },

})