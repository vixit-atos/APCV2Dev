({
    listChange : function(cmp, event, helper) {
        const selectedFLmodels = cmp.get('v.selectedFLmodels')
        const selectedWSmodels = cmp.get('v.selectedWSmodels')
        const selectedOthers = cmp.get('v.selectedOthers')
        const allmodelsObj = cmp.get('v.allmodelsObj')
        const prevDataObj = cmp.get('v.dataObj')
        const dataObj = {}
        const dataList = []

        for (const model of [...selectedFLmodels, ...selectedWSmodels, ...selectedOthers]) {
            const prev = prevDataObj[model.Name]
            dataObj[model.Name] = prev!==undefined ? prev : allmodelsObj[model.Name]
        }
        for (const model of Object.values(dataObj))
            dataList.push(model)

        cmp.set('v.dataList',dataList)
        cmp.set('v.dataObj',dataObj)

        let volume = 0
        for (const model of Object.values(dataObj)) {
            if (model.types === undefined) continue
            for (const type of (Object.values(model.types)))
                volume += parseInt(type) || 0
        }
        cmp.set('v.volume',volume)
    },

    numberChange : function(cmp, event, helper) {
        const dataObj = cmp.get('v.dataObj')
        const [model, type] = event.getSource().get("v.name").split(';')
        const val = event.getSource().get("v.value")
        dataObj[model].types[type] = val
        cmp.set('v.dataObj',dataObj)

        let volume = 0
        for (const model of Object.values(dataObj)) {
            if (model.types === undefined) continue
            for (const type of (Object.values(model.types)))
                volume += parseInt(type) || 0
        }
        cmp.set('v.volume',volume)
    },

    initialize : function(cmp, event, helper) {
        cmp.set('v.dataObj',{})
        const oppId = cmp.get('v.recordId')
        if (!oppId) return

        const action = cmp.get('c.getModels')
        action.setParams({oppId})
        action.setCallback(this, function(response) {
            if (response.getState() === 'SUCCESS') {
                const res = JSON.parse(response.getReturnValue())
                const allmodelsObj = {}
                for (const model of res.models) {
                    for (const type of model.Cab_Types__c.split(';'))
                        model[type] = true
                    allmodelsObj[model.Name] = model
                }
                cmp.set('v.allmodelsObj', allmodelsObj)
                
                const dataObj = {}
                const selectedFLmodels = [], selectedWSmodels = [], selectedOthers = []
                for (const p of res.products) {
                    const name = p.Product2.Name
                    const obj = allmodelsObj[name]
                    obj.Family = p.Product2.Family
                    if (!obj.types) obj.types = {}
                    if (p.Cab_Type__c) obj.types[p.Cab_Type__c] = p.Quantity.toString()
        
                    if (obj.Family === 'Freightliner' && dataObj[name] === undefined)
                        selectedFLmodels.push(obj)
                    else if (obj.Family === 'Western Star' && dataObj[name] === undefined)
                        selectedWSmodels.push(obj)
                    else selectedOthers.push(obj)
        
                    dataObj[name] = obj
                }
                // console.log('dataObj '+JSON.stringify(dataObj))
                // console.log('res.products '+JSON.stringify(res.products))
                // console.log('res.models '+JSON.stringify(res.models))
                // console.log('selectedFLmodels '+JSON.stringify(selectedFLmodels))
                // console.log('selectedWSmodels '+JSON.stringify(selectedWSmodels))
                // console.log('selectedOthers '+JSON.stringify(selectedOthers))
                cmp.set('v.dataObj',dataObj)
                cmp.set('v.selectedFLmodels',selectedFLmodels)
                cmp.set('v.selectedWSmodels',selectedWSmodels)
                cmp.set('v.selectedOthers',selectedOthers)
            } else console.log('Server response state is '+ response.getState())
        })
        $A.enqueueAction(action)
    },

    updateMatrix : function(cmp, event, helper) {
        const dataObj = cmp.get('v.dataObj')
        const models = {}
        for (const model of Object.values(dataObj))
            if (model.types)
                models[model.Id] = model.types
        const action = cmp.get('c.updateModels')
        console.log('MODELS ARE : ' + JSON.stringify(models));
        action.setParams({models, 'oppId': cmp.get('v.recordId')})
        action.setCallback(this, function(response) {
            const toast = $A.get('e.force:showToast')
            let params = {}
            if (response.getState() === 'SUCCESS') {
                const err = response.getReturnValue()
                if (!err) params = { title : 'Success', message: 'Matrix successfully updated', type: 'success' }
                else params = { title : 'Error', message: 'Failed to update models impacted: '+err, type: 'error' }
            } else   params = { title : 'Error', message: 'Failed to reach the server', type: 'error' }
            toast.setParams(params)
            if (cmp.get('v.onRecordPage')) toast.fire()
            if (params.title === 'Error') console.error(params.message)
        })
        $A.enqueueAction(action)
    },
})