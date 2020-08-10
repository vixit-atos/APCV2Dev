({
	init : function(cmp, event, helper) {
        const type = cmp.get('v.type').toUpperCase()
        cmp.set('v.type',type)
        if (type === 'PICKLIST') {
            let possibleValues = cmp.get('v.possibleValues')
            if (typeof possibleValues == 'string') possibleValues = possibleValues.split(',')
            cmp.set('v.dropdownOptions', possibleValues)
        }
    },
})