({
	gotoURL : function (component) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/QUOTE_HISTORY"
        });
        urlEvent.fire();
    }
})