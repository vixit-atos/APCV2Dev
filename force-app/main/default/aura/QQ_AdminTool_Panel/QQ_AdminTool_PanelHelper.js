({
    openStandard : function(component, event, recordTypeID) 
    {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": 'Administrative_Tool__c',
            "recordTypeId": recordTypeID,
            "defaultFieldValues": {
                'Active__c' : true
            }
        });
        createRecordEvent.fire();
    }
})