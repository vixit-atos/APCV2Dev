({
    fetchPicklistValues: function(component,objDetails,controllerField, dependentField) {
        // call the server side function  
        var action = component.get("c.getDependentMap");
        // pass paramerters [object definition , contrller field name ,dependent field name] -
        // to server side function 
        action.setParams({
            'objDetail' : objDetails,
            'contrfieldApiName': controllerField,
            'depfieldApiName': dependentField 
        });
        //set callback   
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                //store the return response from server (map<string,List<string>>)  
                var StoreResponse = response.getReturnValue();
                
                // once set #StoreResponse to depnedentFieldMap attribute 
                component.set("v.depnedentFieldMap",StoreResponse);
                
                // create a empty array for store map keys(@@--->which is controller picklist values) 
                var listOfkeys = []; // for store all map keys (controller picklist values)
                var ControllerField = []; // for store controller picklist value to set on lightning:select. 
                
                // play a for loop on Return map 
                // and fill the all map key on listOfkeys variable.
                for (var singlekey in StoreResponse) {
                    listOfkeys.push(singlekey);
                }
                
                //set the controller field value for lightning:select
                if (listOfkeys != undefined && listOfkeys.length > 0) {
                    ControllerField.push('-- select --');
                }
                
                for (var i = 0; i < listOfkeys.length; i++) {
                    ControllerField.push(listOfkeys[i]);
                }  
                // set the ControllerField variable values to country(controller picklist field)
                component.set("v.listControllingValues", ControllerField);
            }else{
                alert('Something went wrong..');
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchProfileInfo: function(component, ListOfDependentFields) {
        var action = component.get("c.getProfileInfo");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS" && component.isValid()){
                var result = response.getReturnValue();
                component.set("v.profileName", result);
                
            }else{
                console.error("fail:" + response.getError()[0].message); 
            }
        });
        $A.enqueueAction(action);
        
    },
    
    fetchRoleInfo: function(component, ListOfDependentFields) {
        var action = component.get("c.getRoleInfo");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS" && component.isValid()){
                var result = response.getReturnValue();
                if(result == 'crm admin' || result == 'apc supervisor'){
                    component.set("v.isadminuser", true); 
                }else{
                    component.set("v.isadminuser", false);
                }
                component.set("v.roleName", result);
                
            }else{
                console.error("fail:" + response.getError()[0].message); 
            }
        });
        $A.enqueueAction(action);
        
    },
    
    fetchDepValues: function(component, ListOfDependentFields) {
        // create a empty array var for store dependent picklist values for controller field  
        var dependentFields = [];
        dependentFields.push('-- select --');
        for (var i = 0; i < ListOfDependentFields.length; i++) {
            dependentFields.push(ListOfDependentFields[i]);
        }
        // set the dependentFields variable values to store(dependent picklist field) on lightning:select
        component.set("v.listDependingValues", dependentFields);
        component.set("v.textTemplate","");
        component.set("v.objDetail.Description__c","");
        component.set("v.objDetail.IsActive__c",false);
        
    },
    fetchTemplate:function(component,group,title)
    {
        var action = component.get("c.fetchTemplate");
        action.setParams({
            'theGroup' : group,
            'theTitle': title 
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var StoreResponse = response.getReturnValue();
                component.set("v.textTemplate",StoreResponse.Template__c);  
                component.set("v.objDetail.Description__c",StoreResponse.Description__c); 
                component.set("v.objDetail.IsActive__c",StoreResponse.IsActive__c);
            }else{
                
                component.set("v.textTemplate","");
                component.set("v.objDetail.Description__c","");
                component.set("v.objDetail.IsActive__c",false);
            }
        });
        $A.enqueueAction(action);
    },
    
    savetemplate:function(component, event, helper, actionname){
        var groupassigned = component.get("v.objDetail.Group_Assigned__c");
        var title = component.get("v.objDetail.Title_1__c");
        var description = component.get("v.objDetail.Description__c");
        var isactive = false;
        var isactive = component.get("v.objDetail.IsActive__c");
        var isnew = component.get("v.isNew");
        var templatedata;
        if(isnew){
        	templatedata = component.get("v.objDetail.Template__c");
            }
        else{
            templatedata = component.get("v.textTemplate");
        }
        var action = component.get("c.saveTemplate");
        action.setParams({
            'templateid' : title,
            'groupassigned': groupassigned,
            'title': title,
            'description': description,
            'isactive': isactive,
            'templatedata': templatedata,
            'isnew': isnew
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var StoreResponse = response.getReturnValue();
                if(StoreResponse != 'success'){
                    alert('Error :'+StoreResponse);
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: "Success!",
                        message:'Template is saved successfully',
                        type: "success"});
                    toastEvent.fire();
                    if(actionname == "save")
                    {
                        component.set('v.isOpenTemplate',false);
                        component.set("v.isbucketclicked", false);
                        component.set("v.objDetail.Group_Assigned__c","");
                        component.set("v.objDetail.Title_1__c","");
                        component.set("v.objDetail.Description__c","");
                        component.set("v.objDetail.IsActive__c",false);
                        component.set("v.textTemplate"," ");
                        component.set("v.isbucketclicked", false);
                        component.set("v.isNew", true);
        				component.set("v.issubmitactive", false);
                    }else{
                        component.set("v.objDetail.Group_Assigned__c","");
                        component.set("v.objDetail.Title_1__c","");
                        component.set("v.objDetail.Description__c","");
                        component.set("v.objDetail.IsActive__c",false);
                        component.set("v.textTemplate","");
                        component.set("v.isbucketclicked", true);
                        component.set("v.isNew", true); 
                    }
                }
            }else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Error!",
                    message:'Could not save the template',
                    type: "error"});
                toastEvent.fire();
                component.set("v.textTemplate", "");
            }
        });
        $A.enqueueAction(action);        
    },
    
})