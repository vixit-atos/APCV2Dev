({
    init: function (cmp, event, helper) {
        
        cmp.set('v.columns', [
            {label: 'CaseN Number', fieldName: 'CaseNumber', type: 'text' ,editable: true},
            {label: 'Subject', fieldName: 'AnnualRevenue', type: 'text' ,editable: true},
            {label: 'Origin', fieldName: 'Origin', type: 'text' ,editable: true},
            {label: 'Status', fieldName: 'Status', type: 'text' ,editable: true},
            {label: 'Type', fieldName: 'Type', type: 'text' ,editable: true},
            {label: 'Priority', fieldName: 'Priority', type: 'text' ,editable: true},
            {label: 'ClosedDate', fieldName: 'ClosedDate', type: 'Date' ,editable: true}
        ]);
        helper.fetchData(cmp,event, helper);
    },
    
    
    handleSaveEdition: function (cmp, event, helper) {
        var draftValues = event.getParam('draftValues');
        console.log(draftValues);
        var action = cmp.get("c.updatecase");
        action.setParams({"cs" : draftValues});
        action.setCallback(this, function(response) {
            var state = response.getState();
            $A.get('e.force:refreshView').fire();
            
        });
        $A.enqueueAction(action);
        
    },
})