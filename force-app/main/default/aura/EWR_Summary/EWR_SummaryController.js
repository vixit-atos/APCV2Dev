({
    initializeComponent : function(cmp, event, helper){
        //Gathers Detail info if not a child
        if(cmp.get("v.recordId")){
            helper.getDetailInformation(cmp);
        }
    },
    
    getRecord : function(cmp, event, helper) {
        var tempRec = cmp.find("displayrecord"); 
        tempRec.set("v.recordId", cmp.get("v.remoteRecordId"));
        helper.getDetailInformation(cmp);//Gathers detail information after parent passes the child information
        tempRec.reloadRecord();
    },
    
    toggle: function (cmp, event, helper) {
		var details = cmp.find("ewrDetails");
        var buttonstate = cmp.get('v.buttonstate');
        cmp.set('v.buttonstate', !buttonstate);
        $A.util.toggleClass(details, "slds-hide");
    },
    
    redirectToEWR: function (component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.recordId")
        });
        navEvt.fire();
    }
})