({
    handleRecordChanged: function(cmp, event, helper) {
        try {
            const opp = cmp.get('v.opp')
            // console.log('opp '+JSON.stringify(opp))
            // console.log('can edit '+opp.User_Can_Edit_Submitted_CFR__c)
            if (opp.StageName === 'New' || opp.User_Can_Edit_Submitted_CFR__c) {
                event.preventDefault()
                const navService = cmp.find("navService")
                const pageReference = {
                    type: 'standard__component',
                    attributes: { componentName: 'c__CFR_Form', },
                    state: { "c__oppId": cmp.get('v.recordId') }
                }
                navService.navigate(pageReference)
                $A.get("e.force:closeQuickAction").fire()
            } else {
                const toast = $A.get('e.force:showToast')
                toast.setParams({
                    title : 'Error',
                    message: 'You cannot edit this CFR',
                    type: 'error'
                })
                toast.fire()
                $A.get("e.force:closeQuickAction").fire()
            }
        } catch(e) {
            console.error(e)
            const toast = $A.get('e.force:showToast')
                toast.setParams({
                    title : 'Error',
                    message: 'You can\'t edit this CFR',
                    type: 'error'
                })
                toast.fire()
                $A.get("e.force:closeQuickAction").fire()
        }
    },
})