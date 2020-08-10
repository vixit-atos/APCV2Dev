({
    fireToast : function(type, title, message) {
        const toast = $A.get('e.force:showToast')
        toast.setParams({
            title : title,
            message: message,
            type: type
        })
        toast.fire()
        return
    },

    hasAllRequiredFields : function(cmp, stage) {
        const MAX_NUMBER = 9999999999999990;
        let missingFields = 'The following fields must be not be blank: '
        let hasAll = true
        function notThere(name) {
            hasAll = false
            missingFields += name+', '
        }
        function checkSelector(auraId, name) {
            if (!cmp.find(auraId).get('v.value')) notThere(name)
        }
        function checkValue(attName, name) {
            if (!cmp.get('v.'+attName)) notThere(name)
        }
        function checkMultiselect(attName, name) {
            if (cmp.get('v.'+attName).length < 1) notThere(name)
        }
        function checkNotPastDate(attName, name) { // both dates are strings in the form yyyy-mm-dd
            if (cmp.get('v.'+attName) < new Date().toISOString().slice(0,10)) notThere(name+' cannot be before today')
        }
        if (cmp.get('v.cfrName').length > 110) {
            this.fireToast('error','Error','CFR name cannot be more than 110 characters')
            return false
        }
        
        //Currency Block to prevent exception
        if (cmp.get('v.currentlyPaying') != null && cmp.get('v.currentlyPaying') > MAX_NUMBER){
            this.fireToast('error','Error','Currently Paying cannot be greater than ' + MAX_NUMBER);
            return false;
        }
        if (cmp.get('v.willingToPay') != null && cmp.get('v.willingToPay') > MAX_NUMBER){
            this.fireToast('error','Error','Willing To Pay cannot be greater than ' + MAX_NUMBER);
            return false;
        }
        
        checkValue('cfrName', 'CFR Name') //all CFRs must have a name to even save
        
        const models = Object.values(cmp.get('v.matrixDataObj'))
        for (const model of models) { //prevent empty rows in volume matrix
            if (model.types === undefined || Object.values(model.types).every(x => (x === null || x === '' || x === '0'))) {
                notThere('All Impacted Models must have some value in the volume matrix')
                break
            }
        }

        if (stage === 'New') { //only when user hits save on a form that has never been submitted
            if (cmp.get('v.newOpp.CloseDate')) checkNotPastDate('newOpp.CloseDate', 'When needed')
        } else {
            checkSelector('top5Selector', 'Top 5')
            checkSelector('upfitFuelSavingsSelector', 'Upfit Fuel Savings')
            checkSelector('ordersInBacklogUrgentTimingSelector', 'Orders in Backlog / Urgent Timing')
            checkSelector('regulationBlackoutSelector', 'Regulation Blackout')

            checkValue('attemptingToSolve', 'Attempting to Solve')
            checkValue('primaryCustomer', 'Primary Customer')

            checkMultiselect('segmentList', 'Segment')
            checkMultiselect('applicationList', 'Application')

            if (cmp.find('substatusSelector')) checkSelector('substatusSelector', 'Substatus')
            
            if (models.length === 0) notThere('Models Impacted') //require at least one row in the volume matrix to submit
        } 
        if (!hasAll) this.fireToast('error','Missing Fields',missingFields.slice(0,-2))
        return hasAll
    },

    constructionImpact : function(cmp) {
        const segList = cmp.get('v.segmentList')
        for (const seg of segList)
            if (seg.Name.toLowerCase().includes('construction'))
                return true
        return false
    },

    multipleSegments : function(cmp) {
        return cmp.get('v.segmentList').length > 1
    },

    highVolume : function(cmp) {
        const additCust = cmp.get('v.additionalCustomers')
        const data = cmp.find('volumeMatrix').get('v.dataObj')
        if (data==='{}') return false
        let highwayVol = 0
        let vocationalVol = 0
        for (const model of Object.values(data)) {
            if (model.types === undefined) continue
            if (model.Name.includes('P3') || model.Name.includes('P4') || model.Name.includes('5700'))
                for (const val of Object.values(model.types))
                    highwayVol += parseInt(val) || 0
            else
                for (const val of Object.values(model.types))
                    vocationalVol += parseInt(val) || 0
        }
        if (highwayVol>=2000 && additCust.length>0) return true
        if (highwayVol>=500 && additCust.length===0) return true
        if (vocationalVol>=200 && additCust.length>0) return true
        if (vocationalVol>=50 && additCust.length===0) return true
        return false
    },

    topOrNewCustomer : function(cmp) {
        const cust = cmp.get('v.primaryCustomer')
        if (!cust) return false
        const created = new Date(cust.CreatedDate)
        const weekAgo = new Date()
        weekAgo.setDate(weekAgo.getDate() - 7)
        if (cust.Top_Customer__c || created > weekAgo) return true
        else return false
    },

    addGeneratedValues : function(cmp, opp) {
        opp.Published_Customer_Specific__c = (cmp.get('v.additionalCustomers').length > 0) //true only if there are additional customers
        opp.Top_5_Issue__c = cmp.find('top5Selector').get('v.value')
        opp.Upfit_Fuel_Savings__c = cmp.find('upfitFuelSavingsSelector').get('v.value')
        opp.Orders_in_Backlog_Urgent_Timing__c = cmp.find('ordersInBacklogUrgentTimingSelector').get('v.value')
        opp.Regulation_Blackout__c = cmp.find('regulationBlackoutSelector').get('v.value')
        opp.Multiple_Segments_Impacted__c = this.multipleSegments(cmp)
        opp.Construction_Impact__c = this.constructionImpact(cmp)
        opp.High_Volume__c = this.highVolume(cmp)
        opp.Top_Customer_New_Customer__c = this.topOrNewCustomer(cmp)

        let priority = 0
        if (opp.Published_Customer_Specific__c) priority++
        if (opp.Top_5_Issue__c === 'true') priority++
        if (opp.Upfit_Fuel_Savings__c === 'true') priority++
        if (opp.Orders_in_Backlog_Urgent_Timing__c === 'true') priority++
        if (opp.Regulation_Blackout__c === 'true') priority++
        if (opp.Multiple_Segments_Impacted__c) priority++
        if (opp.Construction_Impact__c) priority++
        if (opp.High_Volume__c) priority++
        if (opp.Top_Customer_New_Customer__c) priority++

        if (priority>7)         opp.Priority__c = 'Code Red'
        else if (priority>5)    opp.Priority__c = 'High'
        else if (priority>3)    opp.Priority__c = 'Medium'
        else if (priority>1)    opp.Priority__c = 'Low'
        else                    opp.Priority__c = 'Needs Review'
    },

    prepareOpportunity : function(cmp, stageName) {
        const newOpp = cmp.get('v.newOpp')

        newOpp.StageName = stageName
        newOpp.Estimated_Volume__c = cmp.find('volumeMatrix').get('v.volume')
        newOpp.Models__c = Object.keys(cmp.get('v.matrixDataObj')).join('; ') //list of model names
        this.addGeneratedValues(cmp, newOpp)

        newOpp.Currently_Paying__c = cmp.get('v.currentlyPaying')
        newOpp.Willing_To_Pay__c = cmp.get('v.willingToPay')

        newOpp.Where_Installed__c = cmp.find('whereInstalledSelector').get('v.value')
        const substatusSelector = cmp.find('substatusSelector')
        if (substatusSelector) newOpp.Substatus__c = substatusSelector.get('v.value')

        const primaryCustomer = cmp.get('v.primaryCustomer')
        newOpp.AccountId = (primaryCustomer) ? primaryCustomer.Id : null
        //populate fields from multiselect picklists
        const picklists = {
            'segmentList':      'Segment__c',
            'bodyTypeList':     'Body_Type__c',
            'applicationList':  'Application__c',
            'trailerTypeList':  'Trailer_Type__c',
        }
        for (const field of Object.keys(picklists)) {
            const selected = cmp.get('v.'+field)
            const names = selected.map(x => x.Name)
            const fieldName = picklists[field]
            newOpp[fieldName] = names.join(';')
        }

        newOpp.Name = cmp.get('v.oppName') || null

        if (!newOpp.CloseDate) {
            const date = new Date()
            date.setMonth(date.getMonth()+6) //six months from creation
            newOpp.CloseDate = date
        }
        
		/*Removed Per Ticket # 109629
        //if CFR hasn't been submitted before or if the date is blank for some reason, make it next wednesday
        if (cmp.get('v.isNew') || !newOpp.Request_Review_Date__c) {
            
            const d = new Date()
            d.setHours(0,0,0,0)
            d.setDate(d.getDate() + (1 + 7 - d.getDay()) % 7 + 2) //next wednesday
            newOpp.Request_Review_Date__c = d
            d.setDate(d.getDate() + 7) //a week later
            newOpp.Next_Review_Date__c = d
            
        }
		*/	
        if (cmp.get('v.submitting')) {
            const d = new Date()
            d.setHours(0,0,0,0)
            newOpp.Submitted_Date__c = d
        }

        const oppId = cmp.get('v.oppId')
        if (oppId) newOpp.Id = oppId
        return newOpp
    },

    prettifyVolumeMatrix : function(cmp) {
        const data = cmp.find('volumeMatrix').get('v.dataObj')
        if (data==='{}') return undefined
        let str = ''
        for (const obj of Object.values(data)) {
            if (obj.types === undefined) continue
            str += '--- ' + obj.Name + ' ---' + '\n'
            for (const type of Object.keys(obj.types)) {
                const val = obj.types[type]
                if (val === '' || val === '0') continue
                str += type + ': ' + val + '\n'
            }
            str += '\n'
        }
        if (str==='') return undefined
        return str
    },
    
    updateCFR : function(cmp, stageName, callback) {
        const preparedOpp = this.prepareOpportunity(cmp, stageName)

        const [newOppAccs, oppAccsToDelete] = this.getOppAccs(cmp)
        const [notesToUpsert, notesToDelete] = this.getNoteList(cmp)

        const action = cmp.get('c.submitRequest')
        action.setParams({'opp': preparedOpp, 'cfrName':cmp.get('v.cfrName'),
        newOppAccs, oppAccsToDelete, notesToUpsert, notesToDelete })
        
        action.setCallback(this, this.cfrUpdateFinished(cmp, callback, preparedOpp))
        console.log('About to Submit Request')
        $A.enqueueAction(action)
    },

    cfrUpdateFinished : function(cmp, callback, preparedOpp) {
        //closure allows us to pass cmp in from updateCFR and pass in
        return (response) => { //response from where the action finishes
            const state = response.getState()
            if (state === 'SUCCESS') {
                const res = JSON.parse(response.getReturnValue())
                if (res.err) {
                    this.fireToast('error','Error',res.err)
                } else {
                    cmp.set('v.oppId',res.id)
                    cmp.find('volumeMatrix').updateMatrix() //update oppLineItems in database
                    callback(preparedOpp)
                }
            } else this.fireToast('error','Error','There was a problem')
            // console.log('submitting: '+cmp.get('v.submitting'))
            // console.log('saving: '+cmp.get('v.saving'))
            cmp.set('v.submitting', false)
            cmp.set('v.saving', false)
        }
    },

    getOppAccs : function(cmp) {
        const primaryCustomer = cmp.get('v.primaryCustomer')
        const oppAccByAccName = cmp.get('v.oppAccByAccName') || {}
        const newOppAccs = [], toDelete = [], notChanged = {}
        if (primaryCustomer) {
            const oppAcc = oppAccByAccName[primaryCustomer.Name]
            if (oppAcc) notChanged[oppAcc.Id] = true
            else        newOppAccs.push({'Name':primaryCustomer.Name.slice(0,80),'Account__c':primaryCustomer.Id, 'Primary_Customer__c':true})
        }
        for (const acc of cmp.get('v.additionalCustomers')) {
            const oppAcc = oppAccByAccName[acc.Name]
            if (oppAcc) notChanged[oppAcc.Id] = true
            else        newOppAccs.push({'Name':acc.Name.slice(0,80),'Account__c':acc.Id}) //first 80 char for name to prevent exceding its max len
        }
        for (const oppAcc of Object.values(oppAccByAccName)) {
            if (!notChanged[oppAcc.Id]) toDelete.push(oppAcc)
        }
        console.log('newOppAccs '+JSON.stringify(newOppAccs))
        console.log('toDelete '+JSON.stringify(toDelete))
        return [newOppAccs, toDelete]
    },

    getNoteList : function(cmp) {
        const notes = cmp.get('v.notes') || {}
        const map = {
            'What it is attempting to solve':       cmp.get('v.attemptingToSolve'),
            'Why current offerings do not suffice': cmp.get('v.whyNotSuffice'),
            'What other OEMs are offering':         cmp.get('v.otherOEMsOffering'),
            'Q-Spec / Serial Numbers':              cmp.get('v.qSpecSerial'),
            'Additional Information':               cmp.get('v.additionalInfo'),
        }
        const toUpsert = [], toDelete = []
        for (const title of Object.keys(map)) {
            const note = notes[title] || {'Title':title}
            const body = map[title]
            if (body) {
                if (body !== note.Body) {
                    note.Body = body
                    toUpsert.push(note)
                }
            } else {
                if (note.Id)
                    toDelete.push(note)
            }
        }
        console.log('notes to upsert '+JSON.stringify(toUpsert))
        console.log('notes to delete '+JSON.stringify(toDelete))
        return [toUpsert, toDelete]
    },

    setSelector : function(cmp, attName, val, options) {
        const selector = cmp.find(attName+'Selector')
        if (!selector) return
        for (const option of options) {
            if (option.value === val) {
                option.selected = true
                selector.set('v.value', ''+val)
            } else option.selected = false
        }
        cmp.set('v.'+attName+'Options',options)
    },
    
    getSubstatusOptions : function (cmp) {
        const selector = cmp.find('stageSelector')
        if (!selector) return
        const stage = selector.get('v.value') //cmp.get('v.newOpp.StageName')
        const options = []
        const add = (str) => options.push({'label':str, 'value':str})
        if (stage === 'Approved') {
            add('')
            add('A1 - Approve for specific order only')
            add('A2 - Approve as minor project for specified availability and timing (Up to 300 engineering hours, limited tooling and/or testing)')
        } else if (stage === 'Rejected') {
            add('')
            add('U1 - Not approved, no monitoring or follow-up required')
            add('U2 - Not approved, monitor requests for later review')
            add('U3 - Not approved, not minor, referred to Product Strategy for consideration')
            add('U4 - Alternative solution recommended')
        }
        return options
    },

    oppInit : function(cmp, res) {
        const opp = res.opp
        cmp.find('volumeMatrix').initialize()
        
        cmp.set('v.newOpp.CloseDate', opp.CloseDate)
        cmp.set('v.currentlyPaying', opp.Currently_Paying__c)
        cmp.set('v.willingToPay', opp.Willing_To_Pay__c)
        cmp.set('v.newOpp.StageName',opp.StageName)
        cmp.set('v.isNew', opp.StageName==='New')
        cmp.set('v.newOpp.Request_Review_Date__c', opp.Request_Review_Date__c)
        cmp.set('v.oppName',opp.Name)
        const matched = opp.Name.match(/.*?: (.*)/) //find the first colon and select everything after it
        if (matched) cmp.set('v.cfrName', matched[1])

        this.setSelector(cmp, 'top5', opp.Top_5_Issue__c.toString(), cmp.get('v.top5Options'))
        this.setSelector(cmp, 'upfitFuelSavings', opp.Upfit_Fuel_Savings__c.toString(), cmp.get('v.upfitFuelSavingsOptions'))
        this.setSelector(cmp, 'ordersInBacklogUrgentTiming', opp.Orders_in_Backlog_Urgent_Timing__c.toString(), cmp.get('v.ordersInBacklogUrgentTimingOptions'))
        this.setSelector(cmp, 'regulationBlackout', opp.Regulation_Blackout__c.toString(), cmp.get('v.regulationBlackoutOptions'))
        this.setSelector(cmp, 'whereInstalled', opp.Where_Installed__c, cmp.get('v.whereInstalledOptions'))
        this.setSelector(cmp, 'stage', opp.StageName, cmp.get('v.stageOptions'))
        this.setSelector(cmp, 'substatus', opp.Substatus__c, this.getSubstatusOptions(cmp))
        
        this.setPicklists(cmp, opp)
        this.setDataFromOppAccs(cmp, res.oppAccs)
    },

    setDataFromOppAccs : function (cmp, oppAccs) {
        const oppAccByAccName = {}
        const additionalCustomers = []
        for (const oppAcc of oppAccs) {
            if (oppAcc.Primary_Customer__c)
                cmp.set('v.primCustList',[{'Name':oppAcc.Account_Name__c, 'Id':oppAcc.Account__c, 'CreatedDate':new Date(oppAcc.Account__r.CreatedDate), 'Top_Customer__c':oppAcc.Account__r.Top_Customer__c}])
            else
                additionalCustomers.push({'Name':oppAcc.Account_Name__c, 'Id':oppAcc.Account__c, 'CreatedDate':new Date(oppAcc.Account__r.CreatedDate), 'Top_Customer__c':oppAcc.Account__r.Top_Customer__c})
                
            delete oppAcc.attributes
            delete oppAcc.Account__r
            oppAccByAccName[oppAcc.Account_Name__c] = oppAcc;
        }
        cmp.set('v.oppAccByAccName',oppAccByAccName)
        cmp.set('v.additionalCustomers', additionalCustomers)
    },

    setPicklists : function (cmp, opp) {
        const picklists = {
            'segmentList':          'Segment__c',
            'bodyTypeList':         'Body_Type__c',
            'applicationList':      'Application__c',
            'trailerTypeList':      'Trailer_Type__c',
        }
        //initialize multivalue picklists except customers
        for (const field of Object.keys(picklists)) {
            const values = opp[picklists[field]]
            if (!values) continue
            cmp.set('v.'+field, values.split(';').map(x => {return {Name:x}}))
        }
    },
    
    notesInit : function(cmp, notes) {
        const oppId = cmp.get('v.oppId')
        const notesObj = {
            'What it is attempting to solve':{'ParentId':oppId, 'Title':'What it is attempting to solve'},
            'Why current offerings do not suffice':{'ParentId':oppId, 'Title':'Why current offerings do not suffice'},
            'What other OEMs are offering':{'ParentId':oppId, 'Title':'What other OEMs are offering'},
            'Where it is being installed':{'ParentId':oppId, 'Title':'Where it is being installed'},
            'Q-Spec / Serial Numbers':{'ParentId':oppId, 'Title':'Q-Spec / Serial Numbers'},
            'Additional Information':{'ParentId':oppId, 'Title':'Additional Information'},
        }
        for (const note of notes) {
            delete note.attributes //Apex doesn't like sobjects that have an attributes prop
            notesObj[note.Title] = note
        }
        cmp.set('v.notes',notesObj)

        cmp.set('v.attemptingToSolve', notesObj['What it is attempting to solve'].Body)
        cmp.set('v.whyNotSuffice', notesObj['Why current offerings do not suffice'].Body)
        cmp.set('v.otherOEMsOffering', notesObj['What other OEMs are offering'].Body)
        cmp.set('v.qSpecSerial', notesObj['Q-Spec / Serial Numbers'].Body)
        cmp.set('v.additionalInfo', notesObj['Additional Information'].Body)
    },

    navigateAway : function(cmp) {
        if($A.get('$Browser.isPhone')) {
            const homeEvent = $A.get('e.force:navigateToObjectHome')
            homeEvent.setParams({ 'scope': 'Opportunity' })
            homeEvent.fire()
        } else { //for desktop, close a tab if it opens new tabs, otherwise navigate to Manage My CFRs lightning page
            const navigate = () => {
                const urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({ "url": "/lightning/n/Manage_My_CFRs" })
                urlEvent.fire()
                $A.get('e.force:refreshView').fire()
            }
            const workspaceAPI = cmp.find("workspace")
            workspaceAPI.getFocusedTabInfo().then(function(response) {
                    const focusedTabId = response.tabId
                    console.log('focusedTabId: '+focusedTabId)
                    if (focusedTabId === undefined)
                        navigate()
                    else
                        workspaceAPI.closeTab({tabId: focusedTabId})
            }).catch(function(error) {
                console.log('Failed to get focused tab info')
                navigate()
            })
        }
    },
})