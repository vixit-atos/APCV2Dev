({
    getRecord : function(cmp, event, helper) {
        var tempRec = cmp.find("displayrecord");
        tempRec.set("v.recordId", cmp.get("v.remoteRecordId"));
        tempRec.reloadRecord();
    }
})