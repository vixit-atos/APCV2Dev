/* navTo DTNA Connect */
({
    handleClick: function (component, event, helper) {
        var navEvt = $A.get("e.force:navigateToURL");
        navEvt.setParams({
            "url": 'https://login-dtna.prd.freightliner.com/siteminderagent/forms/FTLloginPWC.fcc?'
        });
        navEvt.fire();
    }
})