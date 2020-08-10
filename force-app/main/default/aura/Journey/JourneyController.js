({
    init : function (cmp, event, helper) { try {
        console.time('Total time')
        console.time('init apex call')
        const action = cmp.get('c.getInitData')
        action.setParams({
            'transitionGroup': cmp.get('v.transitionGroup'),
            'sobjId': cmp.get('v.recordId'),
            'fieldName': cmp.get('v.field')
        })
        action.setCallback(this, function(response) { try {
            console.timeEnd('init apex call')
            console.time('init callback')
            if (response.getState() !== 'SUCCESS') {
                console.error('Server response state for init is '+ response.getState())
                cmp.set('v.initStatus','Error')
                return
            }
            const res = response.getReturnValue()
            if (res.startsWith('Error')) {
                console.error('Apex '+res)
                cmp.set('v.initStatus','Error')
                return
            }
            const {transitions, history, warnings, currentUserName} = JSON.parse(res)
            //console.log('transitions '+JSON.stringify(transitions))
            console.log('history '+JSON.stringify(history))
            console.log('warnings '+JSON.stringify(warnings))
            const states = {} //store all the transitions and colors
            const colors = {} //store unique colors to create custom class names for dynamic css
            for (const t of transitions) {
                const {color, fields, values, currentState, nextState} = t //destructure object into vars
                const state = states[currentState] || {transitionTo:{}}
                state.transitionTo[nextState] = {color, fields, values, 'name':nextState}
                state.name = currentState
                states[currentState] = state
                colors[color] = true
                // const nextState = states[t.nextState] || {transitionTo:{}}
                // states[t.nextState] = nextState
            }
            cmp.set('v.states',states)
            helper.addDynamicCss(Object.keys(colors))
            // console.log('states '+JSON.stringify(states))
            const pathObjs = []
            let prevObj = history.shift() //first obj is when the object was created, not a field value change
            prevObj.dateObj = new Date(prevObj.CreatedDate)
            for (const h of history) {
                //using OldValue because otherwise there is no way to get the value when sobj was created
                //since we're using OldValue, the relevent data belongs to the previous history obj
                h.dateObj = new Date(h.CreatedDate)
                const dateTime = prevObj.dateObj.toLocaleString()
                const duration = helper.msToDHMS(h.dateObj - prevObj.dateObj)
                pathObjs.push({'val':h.OldValue, 'user':prevObj.CreatedBy.Name, 'index':pathObjs.length, dateTime, duration})
                prevObj = h
            }
            // console.log('pathObjs '+JSON.stringify(pathObjs))
            cmp.set('v.lastHistoryObj',prevObj) //allows the current value to get data from the last history obj
            cmp.set('v.currentUserName',currentUserName)
            cmp.set('v.pathObjs',pathObjs)
            cmp.set('v.initStatus','Finished')

            console.timeEnd('init callback')
        } catch(e) { 
            console.error('init apex callback: '+e)
            cmp.set('v.initStatus','Error')
        }})
        $A.enqueueAction(action)
        cmp.set('v.randomNum',Math.random())
    } catch(e) { 
        console.error('init: '+e) 
        cmp.set('v.initStatus','Error')
    }},

    handleRecordUpdated : function (cmp, event, helper) { try {
        console.time('handleRecordUpdated')
        const eventParams = event.getParams();
        if (eventParams.changeType === "LOADED") { //LDS finished loading
            const interval = setInterval(function() { try {
                //if init not finished, check again in 0.1 seconds
                const initStatus = cmp.get('v.initStatus')
                if (initStatus === 'Finished') {
                    clearInterval(interval) //init finished, stop checking
                    const sobj = cmp.get('v.sobj')
                    // console.log('sobj '+JSON.stringify(sobj))
                    const fieldVal = sobj[cmp.get('v.field')]
                    if (fieldVal !== undefined) helper.setCurrentState(cmp, fieldVal)
                    else console.error('Field is undefined. Cannot load current value')
                } else if (initStatus === 'Error') {
                    clearInterval(interval) //stop running interval
                } else { //initStatus is 'Running'
                    console.log('Waiting for init to finish')
                }
            } catch(e) { console.error('interval in handleRecordUpdated: '+e) }}, 100)
        } else if (eventParams.changeType === "CHANGED") {
            if (cmp.get('v.saving')) { // finished saving, stop spinner
                cmp.set('v.saving', false)
            } else { //sobj changed from an external source
                const relevantChange = eventParams.changedFields[cmp.get('v.field')]
                if (relevantChange !== undefined) {
                    console.time('Total time')
                    const stateName = relevantChange.value
                    helper.setCurrentState(cmp, stateName)
                }
            }
        } else if (eventParams.changeType === 'ERROR') {
            console.error('LDS: '+cmp.get('v.recordError'))
        }
        console.timeEnd('handleRecordUpdated')
    } catch(e) { console.error('handleRecordUpdated: '+e) }},

    transitionClicked : function (cmp, event, helper) { try {
        console.time('Total time')
        console.time('transitionClicked')
        const button = event.currentTarget
        cmp.set('v.selectedName', button.id)
        helper.changeSelectedButton(cmp, button)
        helper.tryToSave(cmp)
        console.timeEnd('transitionClicked')
    } catch(e) { console.error('transitionClicked: '+e) }},

    saveClicked : function (cmp, event, helper) { try {
        console.time('Total time')
        helper.tryToSave(cmp)
    } catch(e) { console.error('save: '+e) }},

    cancelClicked : function (cmp, event, helper) { try {
        const selectedStr = 'selected'+cmp.get('v.randomNum')
        const selectedElems = document.getElementsByClassName(selectedStr)
        for (const selected of selectedElems)
            $A.util.removeClass(selected, selectedStr)
        const currentFields = cmp.get('v.currentFields')
        for (const field of currentFields)
            field.userInput = null
        cmp.set('v.currentFields', [])
    } catch(e) { console.error('pathElemClicked: '+e) }},

    undoClicked : function (cmp, event, helper) { try {
        const sobj = cmp.get('v.sobj')
        const undoStack = cmp.get('v.undoStack') || []
        const prevState = undoStack.pop()
        cmp.set('v.undoStack', undoStack)
        if (prevState) {
            for (const field of Object.keys(prevState.fields))
                sobj[field] = prevState.fields[field]
            helper.saveSobj(cmp, prevState.name)
        }
    } catch(e) { console.error('undoClicked: '+e) }},

    pathHover : function (cmp, event, helper) { try {
        const pathObjs = cmp.get('v.pathObjs')
        const obj = pathObjs[event.currentTarget.id] //use index to get obj from list
        let duration = obj.duration //if there is no duration, it should be the current value. Calculate time to now
        if (!duration) duration = helper.msToDHMS(new Date() - new Date(obj.dateTime))
        const text = obj.val+'\n'+obj.user+'\n'+obj.dateTime+'\n'+duration
        const tooltip = cmp.find('tooltip')
        tooltip.set('v.text',text)
        tooltip.showAtMouse(event.clientX,event.clientY)
    } catch(e) { console.error('pathHover: '+e) }},

    pathLeave : function (cmp, event, helper) { try {
        const tooltip = cmp.find('tooltip')
        tooltip.hide()
    } catch(e) { console.error('pathLeave: '+e) }},
    
})