({
    selectRecord : function(cmp, event, helper){
        const getSelectRecord = cmp.get('v.oRecord')
        const compEvent = cmp.getEvent('oSelectedRecordEvent')
        compEvent.setParams({'recordByEvent' : getSelectRecord })
        compEvent.fire()
    },
})