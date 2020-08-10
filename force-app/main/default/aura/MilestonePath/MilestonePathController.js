({
    init : function(cmp, event, helper) { try {
        const action = cmp.get("c.fetchMilestones")
        action.setParams({ OppId: cmp.get("v.recordId") }) 
        action.setCallback(this, function(res) { try {
            helper.setMilestones(cmp,res.getReturnValue())
        } catch(e) { console.error('init apex callback: '+e) }})
        $A.enqueueAction(action)
    } catch(e) { console.error('init: '+e) }},
})