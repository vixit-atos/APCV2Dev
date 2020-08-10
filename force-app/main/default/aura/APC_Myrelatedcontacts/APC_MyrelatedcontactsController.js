({
    doinit : function(component, event, helper) {
        component.set('v.columns', [            
            {label: 'Account Name', fieldName: 'accountname', type: 'text'},
            {label: 'Account Code', fieldName: 'DealerCode', type: 'text'},
            {label: 'First Name', fieldName: 'firstname', type: 'text'}, 
            {label: 'Last Name', fieldName: 'lastname', type: 'text'},
            {label: 'Email', fieldName: 'email', type: 'text'}            
        ]);
        helper.getvisiblecontactsofloggeduser(component, event, helper);
    },
    createnewcontactrecord:  function (component, event, helper) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Contact"
        });
        createRecordEvent.fire();
    }
})