({
    onblur : function(cmp,event,helper) {
        const forclose = cmp.find('searchRes')
        $A.util.addClass(forclose, 'slds-is-close')
        $A.util.removeClass(forclose, 'slds-is-open')
    },

    onfocus : function(cmp,event,helper) {
        // show the spinner, show child search result component and call helper function
        cmp.set('v.spinner', true)
        const forOpen = cmp.find('searchRes')
        $A.util.addClass(forOpen, 'slds-is-open')
        $A.util.removeClass(forOpen, 'slds-is-close')
        const userInput = cmp.get('v.userInput') || ''
        if (cmp.get('v.objectAPIName')==='Custom List')
            helper.searchCustomList(cmp,userInput)
        else if (cmp.get('v.fieldName')==='')
            helper.searchObject(cmp,userInput)
        else
            helper.searchField(cmp,userInput)
    },
    
    keyPressController : function(cmp, event, helper) {
        cmp.set('v.spinner', true)
        const userInput = cmp.get('v.userInput') 
        if(userInput.length > 0) {
            const forOpen = cmp.find('searchRes')
            $A.util.addClass(forOpen, 'slds-is-open')
            $A.util.removeClass(forOpen, 'slds-is-close')
            if (cmp.get('v.objectAPIName')==='Custom List')
                helper.searchCustomList(cmp,userInput)
            else if (cmp.get('v.fieldName')==='')
                helper.searchObject(cmp,userInput)
            else
                helper.searchField(cmp,userInput)
        }
        else{  
            cmp.set('v.searchResults', null )
            const forclose = cmp.find('searchRes')
            $A.util.addClass(forclose, 'slds-is-close')
            $A.util.removeClass(forclose, 'slds-is-open')
        }
    },
    
    removeSelected : function(cmp,event,helper) {
        const selectedPillName = event.getSource().get('v.name')
        const allPills = cmp.get('v.selectedRecords')
        for(let i = 0; i < allPills.length; i++) {
            if(allPills[i].Name === selectedPillName) {
                allPills.splice(i, 1)
                break
            }  
        }
        cmp.set('v.selectedRecords', allPills)
    },
    
    // detects oSelectedRecordEvent. fires whenever user selects any record from the result list
    handleComponentEvent : function(cmp, event, helper) {
        const selectedItems =  cmp.get('v.selectedRecords') || []
        const selectedAccountGetFromEvent = event.getParam('recordByEvent')
        selectedItems.push(selectedAccountGetFromEvent)
        cmp.set('v.selectedRecords' , selectedItems)
        const forclose = cmp.find('searchRes')
        $A.util.addClass(forclose, 'slds-is-close')
        $A.util.removeClass(forclose, 'slds-is-open')
        
    },

    toggle : function(cmp, event, helper) {
        // console.log('toggle event '+JSON.stringify(event.getParams())) //why does this keep firing twice?
        const selected = cmp.get('v.selectedRecords')
        const listLength = selected ? selected.length : 0
        const pill = cmp.find('lookup-pill')
        if(listLength === 0) { // Hide if empty
            $A.util.addClass(pill, 'slds-hide')
            $A.util.removeClass(pill, 'slds-show')
        }else{
            $A.util.addClass(pill, 'slds-show')
            $A.util.removeClass(pill, 'slds-hide')
        }
    },

    createNew : function(cmp, event, helper) {
        const resultsToast = $A.get('e.force:showToast')
        try {
            let sobj = {}
            let fields = cmp.get('v.createFields') //object or stringified object or null
            if (typeof fields === 'string') {
                fields = fields.replace(new RegExp("'","g"), '"') //JSON.parse requires " but you have to use ' in cmp files
                sobj = JSON.parse(fields)
            } else if (fields) 
                sobj = fields
            sobj.sobjectType = cmp.get('v.objectAPIName')
            sobj.Name = cmp.get('v.userInput')
            const queryFields = cmp.get('v.queryFields')
            const query = (queryFields) ? 'SELECT Name,'+queryFields+' FROM '+sobj.sobjectType+' WHERE Id = ' : ''
            const action = cmp.get('c.createSobject')
            action.setParams({ 'sobj': sobj, 'query': query })
            action.setCallback(this, function(response) {
                const state = response.getState()
                if (state === 'SUCCESS') {
                    const res = response.getReturnValue()
                    if (res.includes('Insert failed'))
                        resultsToast.setParams({ 'type': 'error', 'title': 'Error', 'message': res })
                    else {
                        resultsToast.setParams({ 'type': 'success', 'title': 'Success', 'message': 'Record successfully created' })
                        const newObj = JSON.parse(res)
                        const selected = cmp.get('v.selectedRecords')
                        selected.push(newObj)
                        cmp.set('v.selectedRecords',selected)
                        const forclose = cmp.find('searchRes')
                        $A.util.addClass(forclose, 'slds-is-close')
                        $A.util.removeClass(forclose, 'slds-is-open')
                    }
                } else resultsToast.setParams({ 'type': 'error', 'title': 'Error', 'message': 'Call to server was unsuccessful... server response state: '+state })
                resultsToast.fire()
            })
            $A.enqueueAction(action)
        } catch(err) {
            console.log('err '+err)
            resultsToast.setParams({ 'type': 'error', 'title': 'Error', 'message': err.toString() })
            resultsToast.fire()
        }
    },
})