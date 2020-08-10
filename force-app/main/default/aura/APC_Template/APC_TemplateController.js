({
    doInit : function(component, event, helper) {
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
        var action = component.get("c.fetchTitles");
        action.setParams({
            'theGroup' : controllerValueKey,
            'isadmin' : component.get("v.isadminuser")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS" ){
                var result = response.getReturnValue();
                component.set("v.bDisabledDependentFld" , true);
                component.set("v.titlelistvalues", result);
                component.set("v.objDetail.Title_1__c", "");
                
            }else{
                console.error("fail:" + response.getError()[0].message); 
            }
            
        });
        $A.enqueueAction(action);
        component.set("v.textTemplate","");
        component.set("v.objDetail.Description__c","");
        component.set("v.objDetail.IsActive__c",false);
    },
    
    onTitleChange: function(component, event, helper) {    
        var selectedValue = event.getSource().get("v.value");
        helper.fetchTemplate(component,component.get("v.objDetail.Group_Assigned__c" ),selectedValue);
    },
    
    createTemplate : function(component, event, helper){
        var params = event.getParam( 'arguments' ) || event.getParams();
        component.set('v.isOpenTemplate',params.createTemplate);
    },
    
    submitclicked: function(component, event, helper){
        component.set("v.IsSpinner", true);
        helper.savetemplate(component, event, helper,"save");        
    },
    
    closeModal :function(component, event, helper) {        
        component.set('v.isOpenTemplate',false);
        component.set("v.isbucketclicked", false);
        component.set("v.objDetail.Group_Assigned__c","");
        component.set("v.objDetail.Title_1__c","");
        component.set("v.objDetail.Description__c","");
        component.set("v.objDetail.IsActive__c",false);
        component.set("v.textTemplate","");
        component.set("v.isbucketclicked", false);
        component.set("v.isNew", true);
        component.set("v.issubmitactive", false);
    },  
    
    onCheck: function(component, event, helper) {
        var checkCmp = cmp.find("checkbox");
        resultCmp = cmp.find("checkResult");
        resultCmp.set("v.value", ""+checkCmp.get("v.value"));
    },
    
    openModal : function(component,event,helper)
    {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
        "entityApiName": "Template__c"
    });
    createRecordEvent.fire();
    },
    
    openModal1 : function(component,event,helper)
    {
        component.set("v.isbucketclicked", true);
        component.set("v.isNew", false);
        
    },
    
    onDescriptionChange : function(component,event,helper)
    {
        component.set("v.issubmitactive", true);
        component.set("v.issavebuttonactive",true);
    },
    
    onTemplateChange : function(component,event,helper)
    {
        component.set("v.issubmitactive", true);
        component.set("v.issavebuttonactive",true);
    },
    
    onIsactiveChange : function(component,event,helper)
    {
        component.set("v.issubmitactive", true);
        component.set("v.issavebuttonactive",true);
    },
    
    onNewtemplateChange: function(component,event,helper){
        var groupassigned = component.get("v.objDetail.Group_Assigned__c");
        var title = component.get("v.objDetail.Title_1__c");
        var description = component.get("v.objDetail.Description__c");
        var template = component.get("v.objDetail.Template__c");
        if(groupassigned!=null && groupassigned!=undefined && groupassigned!="" &&
           title!=null && title!=undefined && title!="" &&
           template!=null && template!=undefined && template!=""){
            component.set("v.issubmitactive", true);
        }
    },
    
    onIsactiveChangeForNew : function(component,event,helper)
    {
        component.set("v.objDetail.IsActive__c", true);
    },
    
})