({
	 backHomePage :function(component,event,helper){        
         component.find("navService").navigate({    
             type: "standard__namedPage",
             attributes: {
                 "pageName": "apc-home"    
             }});
     }
})