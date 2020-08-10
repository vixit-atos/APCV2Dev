({
    checkIfNotNumber : function(component, event, helper) {
        //alert('checkIfNotNumber');
        console.log("checkInfNotNumber"+JSON.stringify(component.get("v.Quantity")));
        if(isNaN(component.get("v.Quantity"))){
            component.set("v.Quantity","");
        }
    },
    /*checkIfNotSAPNumber : function(component, event, helper) {
        //alert("checkInfNotNumber"+component.get("v.Quantity"));
        if(isNaN(component.get("v.SAPNumber"))){
            component.set("v.SAPNumber","");
        }
    },
    checkIfNotNSNNumber : function(component, event, helper) {
        //alert("checkInfNotNumber"+component.get("v.Quantity"));
        if(isNaN(component.get("v.QuoteNumber"))){
            component.set("v.QuoteNumber","");
        }
    },*/
    
    handleClick  : function(component, event, helper) {	
        var selected = event.getSource().get("v.text");        		               
        //alert("selected"+selected);
        if(selected=="1"){ 
            //alert("if condition");
            //v.SAPNumber'),'NSN_Order__c':component.get('v.QuoteNumber'),'Addtional_Info__c':component.get('v.AdditionalInfo'),'Additional_Recipients__c':component.get('v.emailRecipient'),'Needs_to_Know__c':CAction,'Order_status__c':'Parts Pricing'});
            component.set('v.IsPricing','Yes'); 
            component.set('v.SAPNumber','')
            component.set('v.AdditionalInfo','');
            component.set('v.QuoteNumber','');
            component.set('v.emailRecipient','');
            
            var action = component.get('c.getDealerCodes'); 
            
            action.setCallback(this,function(res){
                var state = res.getState();
                //alert("state"+state);
                if(state=='SUCCESS'){
                    console.log( res.getReturnValue());    
                    component.set("v.dealerCodePickListValues", res.getReturnValue());
                }
            });
            
            $A.enqueueAction(action);
            //alert("You clicked: " + component.get('v.IsPricing'));
        }else if(selected=="2"){
            //alert("else if condition");               
            component.set('v.IsPricing','No');            	
            //alert("You clicked: " + component.get('v.IsPricing'));
        }
        helper.getContacts(component, event, helper);
        
    },
    StockhandleClick:function(component, event, helper) {        	  
        var LeadStock = event.getSource().get("v.value");
        var radiotext;
        if(LeadStock=='Stock'){
            radiotext=1;
        }else if(LeadStock=='Critical'){
            radiotext=2; 
        }else{
            radiotext=3;
        }        	                
        component.set('v.LeadStock',radiotext); 
        //alert("LeadStock"+component.get('v.LeadStock'));
    },  
    onSingleSelectChange: function(component, event, helper) {         
        var selectCmp1 = component.find("selectItem").get("v.value");
        //alert('selectCmp1'+selectCmp1);                  
        if(selectCmp1!='undefined'){            
            component.set('v.SelectedValue',selectCmp1);
            component.set('v.Quantity','');
            component.set('v.AdditionalInfo','');
            //alert("in else if logic"+component.get('v.SelectedValue'));
        }
        
    },   
    onSingleSelectPDCChange:function(component, event, helper) {
        var SelectedPDCValue = component.find("selectItelocation").get("v.value");
        if(SelectedPDCValue!='undefined'){            
            component.set('v.SelectedPDCValue',SelectedPDCValue);             
        }
    },
    onSingleSelectItemChange:function(component, event, helper) {
        var SelectedReasonValue = component.find("selectItemreason").get("v.value");
        var isValid        = true;          
        //alert("SelectedReasonValue"+SelectedReasonValue);
        if(SelectedReasonValue!='undefined'){            
            component.set('v.SelectedReasonValue',SelectedReasonValue);             
        }
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
        helper.getContacts(component, event, helper);
    },
    handleFilesChange : function(component, event, helper){
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName", fileName);
    },
    
    fileClick : function(component, event, helper){
        var fileName = 'No File Selected..';
        fileName = event.getSource().set("v.files",'');
        component.set("v.fileName", fileName);
    },
    
    uploadAttachment : function(component, event, helper){
        helper.uploadingSave(component, event, helper, '500M0000008wMy5IAE');
    },
    uploadFinished: function(component, event, helper) {
        //alert("uploadFinishedcalling");        
        $A.util.addClass(component.find("spinner2"), "slds-hide");        
        component.find('notifLib').showNotice({
            "variant": "success",
            "header": "Success!",
            "message": "Case is created successfully.",
            closeCallback: function() {
                //location.reload();
                component.find("navService").navigate({    
                    type: "standard__namedPage",
                    attributes: {
                        "pageName": "home"    
                    }
                });
            }
        });
    },
    handleError:function(cmp,event,helper){
        var comp = event.getSource();
        $A.util.addClass(comp, "error");   
    },
    handleClearError:function(cmp,event,helper){
        var comp = event.getSource();
        $A.util.removeClass(comp, "error");   
    },
    closeModal : function(component, event, helper){
        let caseModal = component.get("v.caseModal");
        component.set("v.caseModal.show", false);
        if(caseModal.hasOwnProperty("noFunction")) caseModal.noFunction();
    },
    getInput: function(component, event, helper) {
        let order = component.find("order");
        var Ordernumber = order.get("v.value");  
       // alert('order number is   '+ Ordernumber)
        helper.getResponse(component, order,Ordernumber);
        /*
        let orderNumber = component.find("order").get("v.value");
        let condition = "Part_No__c='" + orderNumber +"'";
        helper.fetchCasesFromTypeNumber(component, event, helper, condition);
        */
    },
    SaveRecord : function(component,event,helper) {
        let orderNumber = component.find("order").get("v.value");		
        let IsPricing = component.get("v.IsPricing");       
        if (IsPricing==="No") {
            let apcReasonCode = component.find("selectItem").get("v.value");
        	let apcReasonMap = component.get("v.apcReasonMap");
        	let apcReasonVal = apcReasonMap.hasOwnProperty(apcReasonCode) ? apcReasonMap[apcReasonCode] : null;
            let condition = "Part_No__c='" + orderNumber +"' AND APC_Reason__c='"+apcReasonVal+"'";
            helper.fetchCasesFromTypeNumber(component, event, helper, condition);
        } else if (IsPricing==="Yes") {
            let condition = "Part_No__c='" + orderNumber +"' AND APC_Reason__c='Price Request'";
            //alert('condition@@@'+condition);
            helper.fetchCasesFromTypeNumber(component, event, helper, condition);
        }
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
})