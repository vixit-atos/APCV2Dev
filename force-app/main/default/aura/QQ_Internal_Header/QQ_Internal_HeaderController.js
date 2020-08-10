({
	NavigateExQuote : function(component, event, helper) {
		var urlEvent = $A.get("e.force:navigateToURL");
        var commurl = component.get("v.geturlcomm");
        
        var url = commurl.replace('/s/login','/s/');
        //alert(url);
        urlEvent.setParams({
          "url": url
        });
        urlEvent.fire();
	},
    newQuickQuote : function(component, event, helper) {
        component.set("v.openpopup" , true);
    },
    
    openPDF : function(component, event, helper) {
        window.open('/apex/QQ_TC_PDFViewer', '_blank', 'toolbar=0, location=0, menubar=0, resizable=1, width=800, height=900');        
    },
    doInit: function(component, event, helper) {
        var geturlc = component.find("QQ_getCommunitySrvc"); 
        geturlc.geturlcommunity('EXTERNAL QUICK QUOTE', function(result) {
        component.set("v.geturlcomm", result) ;
            
            
        });
    }
                              
})