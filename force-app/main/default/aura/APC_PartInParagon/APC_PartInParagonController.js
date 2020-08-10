({
    onSingleSelectItemChange:function(component, event, helper) {
        var SelectedReasonValue = component.find("selectItemreason").get("v.value");
        //alert("SelectedReasonValue"+SelectedReasonValue);
        if(SelectedReasonValue!='undefined'){            
            component.set('v.SelectedReasonValue',SelectedReasonValue);             
        }
    },
    handleKeyup :function(component, event, helper) {
        
    },
    /*getInput: function(component, event, helper) {
        	 var order =component.find("order");        
        	 var Ordernumber = order.get("v.value");
        	 alert("Ordernumber values are from"+Ordernumber);
        	 helper.getResponse(component, order,Ordernumber);
    },*/
    SaveRecord : function(component,event,helper){
        let partnumber = component.get("v.partnumber");
        let condition = "Part_No__c='" + partnumber +"' AND APC_Reason__c='Material Load'";
        helper.fetchCasesFromTypeNumber(component, event, helper, condition);
    },
    goToCaseOrCreate : function(component, event, helper){
        let caseModal = component.get("v.caseModal");                        
        if(!caseModal.isResolved) {
            component.find("navService").navigate({
                "type": "standard__recordPage",
                "attributes": {
                    "recordId": caseModal.caseId,
                    "objectApiName": "Case",
                    "actionName": "view"
                }
            });
        } else {
            component.set("v.caseModal.show", false);
            helper.SaveRecord(component,event,helper);
        }
    },
    closeModal : function(component, event, helper){
        let caseModal = component.get("v.caseModal");
        component.set("v.caseModal.show", false);
        if(caseModal.hasOwnProperty("noFunction")) caseModal.noFunction();
    },
    homePage :function(component,event,helper){
        /*var navEvt = $A.get('e.force:refreshView');
        navEvt.fire();*/
        component.find("navService").navigate({    
            type: "standard__namedPage",
            attributes: {
                "pageName": "home"    
            }});
    },
    backHomePage :function(component,event,helper){
        /*var navEvt = $A.get('e.force:refreshView');
        navEvt.fire();*/
         component.find("navService").navigate({    
             type: "standard__namedPage",
             attributes: {
                 "pageName": "home"    
             }});
     },
    initHandler : function(component, event, helper) {
        var code = component.get('v.dealerCode');
        console.log('Dealer Code:'+ code);
        //helper.getContacts(component, event, helper);
    },
    
})