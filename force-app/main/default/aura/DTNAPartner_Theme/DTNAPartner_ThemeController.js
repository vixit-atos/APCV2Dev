({
	handleClick: function (component, event, helper) {
        
        var navEvt = $A.get("e.force:navigateToURL");
        var DTNAPartnerHomeURL = $A.get("$Label.c.DTNAPartnerHome");
        navEvt.setParams({
            "url": DTNAPartnerHomeURL
        });
        navEvt.fire();
        
    }
})