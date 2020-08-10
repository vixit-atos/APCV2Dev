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
            console.log("success") ;
            var result = response.getReturnValue();
            console.log(result);
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
            debugger;
          var state = response.getState();
          if(state == "SUCCESS" && component.isValid()){
            console.log("success") ;
            var result = response.getReturnValue();
            console.log(result);
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
                alert('Could not fetch template');
                component.set("v.textTemplate","");
                component.set("v.objDetail.Description__c","");
                component.set("v.objDetail.IsActive__c",false);
            }
        });
        $A.enqueueAction(action);
    },
    
    savetemplate:function(component, event, helper){
    },
        
        
        
        
        
        
    copyTextHelper : function(component,event,text) {
        // Create an hidden input
        var hiddenInput = document.createElement("input");
        // passed text into the input
        console.log(text);
        hiddenInput.setAttribute("value", text);
        // Append the hiddenInput input to the body
        document.body.appendChild(hiddenInput);
        // select the content
        hiddenInput.select();
        // Execute the copy command
        document.execCommand("copy");
        // Remove the input from the body after copy text
        document.body.removeChild(hiddenInput); 
        // store target button label value
        var orignalLabel = event.getSource().get("v.label");
        // change button icon after copy text
        event.getSource().set("v.iconName" , 'utility:check');
        // change button label with 'copied' after copy text 
        event.getSource().set("v.label" , 'copied');
        
        // set timeout to reset icon and label value after 5000 milliseconds 
        setTimeout(function(){ 
            event.getSource().set("v.iconName" , 'utility:copy_to_clipboard'); 
            event.getSource().set("v.label" , orignalLabel);
        }, 5000);
        
    },
    getInnerText : function(html) {
    html = html.replace(/\n/g, "");
    html = html.replace(/\t/g, "");

    //keep html brakes and tabs
    html = html.replace(/<\/td>/g, "\t");
    html = html.replace(/<\/table>/g, "\n");
    html = html.replace(/<\/tr>/g, "\n");
    html = html.replace(/<\/p>/g, "\n");
    html = html.replace(/<\/div>/g, "\n");
    html = html.replace(/<\/h>/g, "\n");
    html = html.replace(/<br>/g, "\n"); html = html.replace(/<br( )*\/>/g, "\n");

    //parse html into text
    var dom = (new DOMParser()).parseFromString('<!doctype html><body>' + html, 'text/html');
    return dom.body.textContent;
}
    
    
})