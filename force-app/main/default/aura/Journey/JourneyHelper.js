({
    setCurrentState : function(cmp, stateName) { try {
        console.time('setCurrentState')
        const pathObjs = cmp.get('v.pathObjs')
        const lastObj = pathObjs[pathObjs.length-1]
        const lastHistoryObj = cmp.get('v.lastHistoryObj')
        if (lastHistoryObj) { //first call since init. Use user and date from last field history record
            cmp.set('v.lastHistoryObj',null)
            const date = new Date(lastHistoryObj.CreatedDate)
            const dateTime = date.toLocaleString()
            pathObjs.push({'val':stateName, 'user':lastHistoryObj.CreatedBy.Name, 'index':pathObjs.length, dateTime})
            if (lastObj) lastObj.duration = this.msToDHMS(date - new Date(lastObj.dateTime))
        } else { //update after init. Use current user and time
            const today = new Date()
            const dateTime = today.toLocaleString()
            pathObjs.push({'val':stateName, 'user':cmp.get('v.currentUserName'), 'index':pathObjs.length, dateTime})
            if (lastObj) lastObj.duration = this.msToDHMS(today - new Date(lastObj.dateTime))
        }
        cmp.set('v.pathObjs',pathObjs)

        const currentTransitions = []
        const states = cmp.get('v.states')
        const state = states[stateName]
        if (state)
            for (const transition of Object.values(state.transitionTo))
                currentTransitions.push(transition)
        cmp.set('v.currentTransitions',currentTransitions)
        cmp.set('v.currentState',state)
        this.colorPath(cmp, state)
        console.timeEnd('setCurrentState')
    } catch(e) { console.error('setCurrentState: '+e) }},
        
    colorPath : function(cmp, currentState) {
        setTimeout(() => { try { //need to let DOM update first
            console.time('colorPath')
            const states = cmp.get('v.states')
            const pathItemClassName = 'journeyPathItem' + cmp.get('v.randomNum')
            const pathItems = document.getElementsByClassName(pathItemClassName)
            // console.log('pathItems.length :', pathItems.length)
            let prevName = 'not undefined or null in case those are values in the mtd'
            for (const item of pathItems) {
                const name = item.id
                const state = states[prevName]
                if (state) {
                    const transition = state.transitionTo[name]
                    if (transition) {
                        const color = transition.color
                        if (color) {
                            //replace , and ( with - then remove chars: ) # and space for valid classname. Supports hex, rgb, and colorname
                            const withoutSpecialChars = color.replace(/[,\(]/g,'-').replace(/[\)# ]/g,'')
                            item.className = 'color-'+withoutSpecialChars+' slds-path__item '+pathItemClassName
                        } else item.className = 'grayJourneyPath slds-path__item '+pathItemClassName
                    } else item.className = 'grayJourneyPath slds-path__item '+pathItemClassName
                } else item.className = 'grayJourneyPath slds-path__item '+pathItemClassName
                prevName = name
            }

            if (currentState) {
                const buttonClassName = 'journeyTransition' + cmp.get('v.randomNum')
                const transitionButtons = document.getElementsByClassName(buttonClassName)
                for (const item of transitionButtons) {
                    const transition = currentState.transitionTo[item.id]
                    if (transition) {
                        const color = transition.color
                        if (color) {
                            item.style.backgroundColor = color
                        }
                    }
                }
            }
            
            console.timeEnd('colorPath')
            this.scrollRight(cmp)
        } catch(e) { console.error('colorPath: '+e) }}, 0) // setTimeout pushes to end of queue even if delay is 0ms
    },

    scrollRight : function(cmp) { try {
        console.time('scrollRight')
        const scroller = document.getElementById('scroller'+cmp.get('v.randomNum'))
        scroller.scrollLeft += scroller.scrollWidth
        console.timeEnd('scrollRight')
        console.timeEnd('Total time')
    } catch(e) { console.error('scrollRight: '+e) }},

    saveSobj : function (cmp, stateName) { try {
        console.time('saveSobj LDS save')
        const helper = this //reference to this changes inside callback
        cmp.set('v.saving', true)
        cmp.set('v.sobj.'+cmp.get('v.field'), stateName)
        cmp.find('recordHandler').saveRecord($A.getCallback(function(saveResult) { try {
            console.timeEnd('saveSobj LDS save')
            console.time('saveSobj callback')
            const resultsToast = $A.get('e.force:showToast')
            let params = { 'title': 'Error', 'type': 'error' }
            if (saveResult.state === 'SUCCESS' || saveResult.state === 'DRAFT') {
                params = { 'title': 'Saved', 'type': 'success', 'message': 'The record was updated.' }
                helper.setCurrentState(cmp, stateName)
            } else {
                cmp.set('v.saving', false)
                if (saveResult.state === 'INCOMPLETE')
                    params.message = 'User is offline, device doesn\'t support drafts.'
                else if (saveResult.state === 'ERROR')
                    params.message = 'Problem saving record, error: '+JSON.stringify(saveResult.error)
                else
                    params.message = 'Unknown problem, state: '+saveResult.state+', error: '+JSON.stringify(saveResult.error)
            }
            resultsToast.setParams(params)
            resultsToast.fire()
            console.timeEnd('saveSobj callback')
        } catch(e) { console.error('callback from LDS: '+e) }}))
    } catch(e) { console.error('saveSobj: '+e) }},

    addDynamicCss : function (colors) { try {
        console.time('addDynamicCss')
        // console.log('colors '+colors)
        for (const sheet of document.styleSheets) {
            if (sheet.cssRules[0] && sheet.cssRules[0].cssText.includes('.cJourney')) {
                for (const color of colors) {
                    //replace , and ( with - then remove chars: ) # and space for valid classname. Supports hex, rgb, and colorname
                    const withoutSpecialChars = color.replace(/[,\(]/g,'-').replace(/[\)# ]/g,'')
                    const selector = '.cJourney .color-'+withoutSpecialChars
                    try { sheet.insertRule(selector+', '+selector+':before, '+selector+':after { background-color:'+color+'; }') }
                    catch(e) { console.error('Failed to insert rule '+e)}
                }
                break
            }
        }
        // const sheets = []
        // for (const sheet of document.styleSheets) {
        //     const rules = []
        //     for (const rule of sheet.cssRules)
        //         rules.push(rule.cssText)
        //     sheets.push(rules)
        // }
        // console.log(sheets[21])
        console.timeEnd('addDynamicCss')
    } catch(e) { console.error('addDynamicCss: '+e) }},

    addFieldsToSobj : function (currentTransition, sobj) { try {
        const missing = [], previous = {}
        for (const field of currentTransition.fields) {
            previous[field.name] = sobj[field.name]
            if (field.userInput) sobj[field.name] = field.userInput
            else missing.push(field.label)
            field.userInput = null
        }
        return [missing, previous]
    } catch(e) { console.error('addFieldsToSobj: '+e) }},

    fireToast : function(type, title, message) { try {
        const toast = $A.get('e.force:showToast')
        toast.setParams({
            type: type,
            title : title,
            message: message
        })
        toast.fire()
        return
    } catch(e) { console.error('fireToast: '+e) }},

    changeSelectedButton : function (cmp, button) { try {
        const selectedStr = 'selected'+cmp.get('v.randomNum')
        const selectedElems = document.getElementsByClassName(selectedStr)
        for (const selected of selectedElems)
            $A.util.removeClass(selected, selectedStr)
        $A.util.addClass(button, selectedStr)
    } catch(e) { console.error('changeSelectedButton: '+e) }},

    tryToSave : function (cmp) { try {
        const selectedName = cmp.get('v.selectedName')
        const state = cmp.get('v.currentState')
        const currentTransition = state.transitionTo[selectedName]
        const sobj = cmp.get('v.sobj')
        const [missing, previous] = this.addFieldsToSobj(currentTransition, sobj)
        
        if (missing.length === 0) {
            cmp.set('v.sobj',sobj)
            this.saveSobj(cmp, selectedName)
            cmp.set('v.currentFields', [])
            const undoStack = cmp.get('v.undoStack') || []
            undoStack.push({'name':state.name, 'fields':previous})
            cmp.set('v.undoStack',undoStack)
        } else {
            this.fireToast('Error','','All required fields must have a value. Missing: '+missing)
            cmp.set('v.currentFields', currentTransition.fields)
            console.timeEnd('Total time')
        }
    } catch(e) { console.error('tryToSave: '+e) }},

    msToDHMS : function (timeInMs) { try { //milliseconds -> day,hour,min,sec in format 'xd xh xm xs' where x is an int
        let seconds = Math.abs(timeInMs) / 1000
        const days = Math.floor(seconds / (60*60*24))
        seconds -= days * 60*60*24
        const hours = Math.floor(seconds / (60*60)) % 24
        seconds -= hours * 60*60
        const minutes = Math.floor(seconds / 60) % 60
        seconds = Math.floor(seconds - (minutes * 60))
        return days+'d '+hours+'h '+minutes+'m '+seconds+'s'
    } catch(e) { console.error('msToDHM: '+e) }},

})