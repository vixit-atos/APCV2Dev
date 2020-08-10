({
	initialize : function(cmp, event, helper) {
        const action = cmp.get('c.getNotes')
        action.setParams({'sobjectId': cmp.get('v.recordId')})
        action.setCallback(this, function(response) {
            if (response.getState() === 'SUCCESS') {
                const res = response.getReturnValue()
                cmp.set('v.notes',res)
            }
        })
        $A.enqueueAction(action)
    },
    
    save : function(cmp, event, helper) {
        const action = cmp.get('c.updateNotes')
        action.setParams({'notes': cmp.get('v.notes')})
        action.setCallback(this, function(response) {
            if (response.getState() === 'SUCCESS') {
                const res = response.getReturnValue()
                const toast = $A.get('e.force:showToast')
                if (res === 'Success') {
                    toast.setParams({
                        title : 'Success',
                        message: 'Notes successfully updated',
                        type: 'success'
                    })
                } else {
                    toast.setParams({
                        title : 'Error',
                        message: res,
                        type: 'error'
                    })
                }
                toast.fire()
            }
        })
        $A.enqueueAction(action)
    },
})