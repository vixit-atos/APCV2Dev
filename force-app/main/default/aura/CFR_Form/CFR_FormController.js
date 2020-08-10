({
    initializeComponent: function (cmp, event, helper){
        const pageRef = cmp.get('v.pageReference')
        const oppId = pageRef!==null ? pageRef.state.c__oppId : cmp.get('v.recordId') || cmp.get('v.oppId') || null
        const action = cmp.get('c.getInitData')
        action.setParams({'oppId': oppId})
        action.setCallback(this, function(response) {
            if (response.getState() === 'SUCCESS') {
                const res = JSON.parse(response.getReturnValue())
                // console.log('result from getInitData '+res);
                const allFLmodelsList = []
                const allWSmodelsList = []
                const allmodelsObj = {}
                for (const model of res.models) {
                    for (const type of model.Cab_Types__c.split(';'))
                        model[type] = true
                    allmodelsObj[model.Name] = model
                    if (model.Family === 'Freightliner')
                        allFLmodelsList.push(model)
                    else if (model.Family === 'Western Star')
                        allWSmodelsList.push(model)
                }
                cmp.set('v.allmodelsObj', allmodelsObj)
                cmp.set('v.allFLmodelsList', allFLmodelsList)
                cmp.set('v.allWSmodelsList', allWSmodelsList)
                cmp.set('v.newOpp.RecordTypeId', res.recordType)

                if (res.files) {
                    const files = []
                    for (const file of res.files) {
                        const obj = {'name':file.Title+'.'+file.FileExtension, 'documentId':file.Id}
                        files.push(obj)
                    }
                    cmp.set('v.uploadedFiles', files)
                }

                if (res.opp) {
                    cmp.set('v.oppId', res.opp.Id)
                    helper.notesInit(cmp, res.notes)
                    helper.oppInit(cmp, res)
                }
            } else console.error('Server response state is '+ response.getState())
        })
        $A.enqueueAction(action)
    },
    
    submit: function (cmp, event, helper){
        if (!helper.hasAllRequiredFields(cmp, 'Submitted')) return
        const msgToAskUser = 'Are you sure?\nThis finalizes the CFR and you will no longer be able to change it.\n'
        const userConfirmed = confirm(msgToAskUser)
        if (!userConfirmed) return
        const callback = (opp) => {
            helper.navigateAway(cmp)
            cmp.set('v.oppId', null)
        }
        cmp.set('v.submitting', true)
        helper.updateCFR(cmp,'Submitted', callback)
    },


    save: function (cmp, event, helper){
        let stage
        let selector = cmp.find('stageSelector')
        if (selector) stage = selector.get('v.value')
        if (!stage) stage = cmp.get('v.newOpp.StageName') || 'New';
        if (!helper.hasAllRequiredFields(cmp, stage)) return
        const callback = (opp) => {
            helper.fireToast('success','Request Saved','Your request has been saved successfully')
            const action = cmp.get('c.initializeComponent')
            $A.enqueueAction(action)
        }
        cmp.set('v.saving', true)
        helper.updateCFR(cmp, stage, callback)
    },

    cancel: function (cmp, event, helper){
        helper.navigateAway(cmp)
    },

    viewCalculatedValues: function(cmp, event, helper) {
        const opp = cmp.get('v.newOpp')
        helper.addGeneratedValues(cmp,opp)
        console.log('opp.Published_Customer_Specific__c '+opp.Published_Customer_Specific__c)
        console.log('opp.Top_5_Issue__c '+opp.Top_5_Issue__c)
        console.log('opp.Upfit_Fuel_Savings__c '+opp.Upfit_Fuel_Savings__c)
        console.log('opp.Orders_in_Backlog_Urgent_Timing__c '+opp.Orders_in_Backlog_Urgent_Timing__c)
        console.log('opp.Regulation_Blackout__c '+opp.Regulation_Blackout__c)
        console.log('opp.Multiple_Segments_Impacted__c '+opp.Multiple_Segments_Impacted__c)
        console.log('opp.Construction_Impact__c '+opp.Construction_Impact__c)
        console.log('opp.High_Volume__c '+opp.High_Volume__c)
        console.log('opp.Top_Customer_New_Customer__c '+opp.Top_Customer_New_Customer__c)
        console.log('opp.Priority__c '+opp.Priority__c)
        console.log('--------------------------------------')
    },

    handleUploadFinished: function (cmp, event, helper) {
        const newFiles = event.getParam('files')
        const uploadedFiles = cmp.get('v.uploadedFiles')
        uploadedFiles.push(...newFiles)
        cmp.set('v.uploadedFiles',uploadedFiles)
        helper.fireToast('success','File(s) Uploaded','Your file(s) have been added to the CFR. You do NOT have to hit save for this to take effect.')
    },

    setPrimaryCustomer: function(cmp, event, helper) {
        cmp.set('v.primaryCustomer', cmp.get('v.primCustList')[0])
    },

    removeFile: function(cmp, event, helper) {
        const [fileId,index] = event.getParam('name').split(';')
        const action = cmp.get('c.deleteFile')
        action.setParams({'fileId': fileId})
        action.setCallback(this, function(response) {
            if (response.getState() === 'SUCCESS') {
                const res = response.getReturnValue()
                if (res!=='Deleted') {
                    helper.fireToast('error','Error','CFR could not be deleted: '+res)
                    return
                }
                helper.fireToast('success','Success','File was deleted')
                const uploadedFiles = cmp.get('v.uploadedFiles')
                uploadedFiles.splice(index,1)
                cmp.set('v.uploadedFiles',uploadedFiles)
            } else {
                console.error('Server response state is '+ response.getState())
                helper.fireToast('error','Error','CFR could not be deleted')
            }
        })
        $A.enqueueAction(action)
    },

    stageChanged : function (cmp, event, helper) {
        const selector = cmp.find('substatusSelector')
        const val = (selector) ? selector.get('v.value') : ''
        helper.setSelector(cmp, 'substatus', val, helper.getSubstatusOptions(cmp))
    },
})