({
    searchObject : function(cmp,userInput) {
        // call the apex class method 
        const action = cmp.get('c.fetchObjectValues')
        // set param to method  
        action.setParams({
            'userInput': userInput,
            'objectName': cmp.get('v.objectAPIName'),
            'excludedItems': cmp.get('v.selectedRecords').concat(cmp.get('v.excluded')),
            'queryFields': cmp.get('v.queryFields'),
            'queryWhere': cmp.get('v.queryWhere'),
            'queryOrder': cmp.get('v.queryOrder'),
            'queryLimit': cmp.get('v.queryLimit'),
        })
        // set a callBack    
        action.setCallback(this, function(response) {
            cmp.set('v.spinner', false)
            const state = response.getState()
            if (state === 'SUCCESS') {
                const storeResponse = response.getReturnValue()
                if (storeResponse.length === 0) cmp.set('v.message', 'No results found...')
                else cmp.set('v.message', '')
                
                cmp.set('v.searchResults', storeResponse)
            }
        })
        // enqueue the Action  
        $A.enqueueAction(action)
    },
    searchField : function(cmp,userInput) {
        const strs = []
        const selectedRecords = cmp.get('v.selectedRecords') || []
        for (const o of selectedRecords)
            strs.push(o.Name)
        const excluded = cmp.get('v.excluded') || []
        for (const o of excluded) {
            if (o.Name)
                strs.push(o.Name)
            else if (typeof o === 'string')
                strs.push(o)
        }
        // call the apex class method 
        const action = cmp.get('c.fetchFieldValues')
        // set param to method
        action.setParams({
            'type': cmp.get('v.objectAPIName'),
            'fieldName': cmp.get('v.fieldName'),
            'userInput': userInput,
            'excludedItems' : strs,
        })
        // set a callBack    
        action.setCallback(this, function(response) {
            cmp.set('v.spinner', false)
            const state = response.getState()
            if (state === 'SUCCESS') {
                const storeResponse = response.getReturnValue()

                // storing the field type as the last element to allow us to dynamically set this
                // doing this on init would be more efficient but this is easier for now at least
                const picklistType = storeResponse.pop()
                if (picklistType === 'PICKLIST')
                    cmp.set('v.singleValueOnly', true)

                if (storeResponse.length === 0) cmp.set('v.message', 'No results found...')
                else cmp.set('v.message', '')

                const result = []
                for (let i=0;i<storeResponse.length;i++)
                    result.push({Name: storeResponse[i]})
                cmp.set('v.searchResults', result)
            }
        })
        $A.enqueueAction(action)
    },

    searchCustomList : function(cmp,userInput) {
        const results = []
        const excluded = {}
        for (const obj of cmp.get('v.selectedRecords')) {
            if (typeof obj === 'string')
                excluded[obj] = true
            else
                excluded[obj.Name] = true
        }
        for (const obj of cmp.get('v.excluded')) {
            if (typeof obj === 'string') excluded[obj] = true
            else excluded[obj.Name] = true
        }
        const customList = cmp.get('v.customList')
        if (customList.length === 0)
            cmp.set('v.message', 'To use a custom list, you must pass a list of strings or a list of objects that have a Name attribute into customList')

        for (let obj of customList) {
            let name
            if (typeof obj === 'string') {
                name = obj
                obj = {Name: name}
            }
            else if (obj.Name !== undefined) name = obj.Name
            else cmp.set('v.message', 'To use a custom list, you must pass a list of strings or a list of objects that have a Name attribute into customList')


            if (excluded === null || excluded[name] !== true) {
                if(name.toLowerCase().includes(userInput.toLowerCase()))
                    results.push(obj)
                else if (userInput=='')
                    results.push(obj)
            }
        }
        cmp.set('v.searchResults', results)
        if (results.length === 0) cmp.set('v.message', 'No results found...')
        cmp.set('v.spinner', false)
    },
})