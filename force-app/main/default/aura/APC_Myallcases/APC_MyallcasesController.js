({
	 doinit : function(component, event, helper) {
        component.set('v.columns', [            
            {label: 'Case', fieldName: 'accountname', type: 'text'},
            {label: 'Owner Name', fieldName: 'DealerCode', type: 'text'},
            {label: 'Contact Name', fieldName: 'firstname', type: 'text'}, 
            {label: 'Status', fieldName: 'lastname', type: 'text'},
            {label: 'Request Type', fieldName: 'email', type: 'text'},
            {label: 'Part Number', fieldName: 'email', type: 'text'},
            {label: 'Created on', fieldName: 'email', type: 'text'}            
        ]);
        
    }
})