({
	getDCodes : function(component, event, helper) {
        console.log('inside getDealerCodes Method');
         var action = component.get('c.getDealerCodes'); 
                                
                action.setCallback(this,function(res){
                    var state = res.getState();
                    //alert("state"+state);
                    if(state=='SUCCESS'){
                        console.log( res.getReturnValue()); 
                        component.set("v.selectedDealerCode", res.getReturnValue()[0]);
                        component.set("v.parentDealerCode", res.getReturnValue()[0]);
                        component.set("v.dealerCodePickListValues", res.getReturnValue());
                        console.log('inside parentDealerCode Method', component.get("v.selectedDealerCode"));
                    }
                });
                
                $A.enqueueAction(action);
        //this.setDcode(component, event, helper);
    },
    
    setDCode : function(component, event, helper) {
		var code = component.get('v.selectedDealerCode'); 
        console.log('Code : '+code);
        component.set("v.parentDealerCode", code);
        var childCmp = component.find("newOrderComp");
        console.log(childCmp);
        if (typeof childCmp !== 'undefined')
 		childCmp.refreshDealerData();
        
        var childCmp2 = component.find("partInParagonComp");
        console.log(childCmp2);
         if (typeof childCmp2 !== 'undefined')
 		childCmp2.refreshDealerData();
    }
})