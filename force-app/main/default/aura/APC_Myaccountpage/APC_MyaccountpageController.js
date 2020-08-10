({
	doinit : function(component, event, helper) {
        debugger;
        component.set('v.columns', [            
            {label: 'Account name', fieldName: 'name', type: 'text'},
            {label: 'Account Code', fieldName: 'DealerCode', type: 'text'}            
        ]);
        helper.getprimaryaccountinfo(component, event, helper);
		helper.getvisibleaccountsofloggeduser(component, event, helper);
	}
})