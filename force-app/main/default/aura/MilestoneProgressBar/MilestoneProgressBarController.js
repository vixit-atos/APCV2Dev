({
    init: function(cmp, event, helper) { try {
        const m = cmp.get('v.milestone')
        cmp.set('v.labels', [m.first.label, m.second.label, m.third.label])
        helper.setFormattedDates(cmp, m)
        helper.setProgressColor(cmp, m.cls)
        helper.calculateProgress(cmp, m)
    } catch(e) { console.error('init: '+e) }},
})