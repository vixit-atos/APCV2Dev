({
    doInit : function(component, event, helper) { 
        debugger;
        component.set("v.textTemplate","");
        component.set("v.objDetail.Description__c","");
        
        // get the fields API name and pass it to helper function  
        var controllingFieldAPI = component.get("v.controllingFieldAPI");
        var dependingFieldAPI = component.get("v.dependingFieldAPI");
        var objDetails = component.get("v.objDetail");
        // call the helper function
        helper.fetchPicklistValues(component,objDetails,controllingFieldAPI, dependingFieldAPI);
        helper.fetchProfileInfo(component, event, helper);
        helper.fetchRoleInfo(component, event, helper);
    },
    
    onControllerFieldChange: function(component, event, helper) {     
        var controllerValueKey = event.getSource().get("v.value"); // get selected controller field value
        var depnedentFieldMap = component.get("v.depnedentFieldMap");
        
        if (controllerValueKey != '-- select --') {
            var ListOfDependentFields = depnedentFieldMap[controllerValueKey];
            
            if(ListOfDependentFields.length > 0){
                component.set("v.bDisabledDependentFld" , false);  
                helper.fetchDepValues(component, ListOfDependentFields);    
            }else{
                component.set("v.bDisabledDependentFld" , true); 
                component.set("v.listDependingValues", ['-- select --']);
            }  
            
        } else {
            component.set("v.listDependingValues", ['-- select --']);
            component.set("v.bDisabledDependentFld" , true);
        }
        component.set("v.objDetail.Title_c__c", "-- select --");
        component.set("v.textTemplate","");
        component.set("v.objDetail.Description__c","");
        component.set("v.objDetail.IsActive__c",false);
    },
    
    onTitleChange: function(component, event, helper) {    
        var selectedValue = event.getSource().get("v.value");
        helper.fetchTemplate(component,component.get("v.objDetail.Group_Assigned__c" ),selectedValue)
	},
    
    createTemplate : function(component, event, helper){
        var params = event.getParam( 'arguments' ) || event.getParams();
		component.set('v.isOpenTemplate',params.createTemplate);
    },
    
    submitclicked: function(component, event, helper){
        helper.savetemplate(component, event, helper);        
    },
    
    closeModal :function(component, event, helper) {        
        component.set('v.isOpenTemplate',false);
    },  
    
	 onCheck: function(component, event, helper) {
		 var checkCmp = cmp.find("checkbox");
		 resultCmp = cmp.find("checkResult");
		 resultCmp.set("v.value", ""+checkCmp.get("v.value"));
	 },
 
    copyTemplate : function(component,event,helper)
    {
         var textForCopy = component.find('templateID').get("v.value");
        textForCopy = helper.getInnerText(textForCopy);
		//component.find('templateID').select();
        // Execute the copy command
        //document.execCommand("copy");
        //alert('Copied Text:'+ textForCopy);
        helper.copyTextHelper(component,event,textForCopy);
    }
})