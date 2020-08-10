({
	 onGroup: function(cmp, evt) {
		 var selected = evt.getSource().get("v.text");               
         if(selected=="1"){
              cmp.set('v.value','Yes');               
         }else if(selected=="2"){              
              cmp.set('v.value','No');              
         }
              
    },
    
    initHandler : function(component, event, helper) {
    	helper.getDCodes(component, event, helper);
        //helper.setDCode(component, event, helper);
    },
    setDealerCode : function(component, event, helper) {
    	helper.setDCode(component, event, helper);
    },
    
})