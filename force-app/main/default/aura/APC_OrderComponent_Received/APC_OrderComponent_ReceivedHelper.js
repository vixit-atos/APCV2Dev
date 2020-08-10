({
    requestReceivedOrderFromParagon : function(component,event,helper) {
        $A.util.removeClass(component.find("spinner2"), "slds-hide");
        let selectedDealerCode=component.get('v.selectedDealerCode');
        let typeName = component.get("v.selectedOption");
        selectedDealerCode=selectedDealerCode.length===5 ? selectedDealerCode : ("F"+selectedDealerCode);
        
        component.set("v.orderRecordsInAllPages", []);
        component.set("v.allOrderRecordsLength", 0);
        
        
        var action = component.get('c.getReceivedOrderFromParagon');               
        action.setParams({
            params: {
                typeValue: component.get("v.partnumber"),
                soldToParty: selectedDealerCode,
                typeName: typeName,
                APC_Source: 'Received Order'
            }
        });
        action.setCallback(this,function(response){
            
            $A.util.addClass(component.find("spinner2"), "slds-show");
            var state = response.getState();
            if(state=='SUCCESS'){
                let returnMap = response.getReturnValue();
                component.set("v.returnMap", returnMap);                       
                if(typeName==='Return_Number__c' || typeName==='Credit_Debit__c')
                {
                    if(returnMap.hasOwnProperty('cases')) {                               
                        let caseModal = {
                            show: true,
                            caseId: returnMap.cases[0].Id
                        };
                        component.set("v.caseModal", caseModal);
                    } else {
                        helper.processParagonResponse(component, event, helper, returnMap,typeName);
                    }
                } else if(typeName==='SAP_Order_Number__c') 
                {
                    helper.processParagonResponse(component, event, helper, returnMap,typeName);
                }
            } else {
                helper.apexCallbackElse(component, event, helper, response);
            }
        });
        $A.enqueueAction(action);
    },
    processParagonResponse: function(component, event, helper, returnMap,typeName) {
        
        let paragonResponse = returnMap.paragonResponse;
        let resultJson = JSON.parse(paragonResponse);        
        
        console.log("Result data => ",resultJson);
        console.log("Result data paragonResponse => ",paragonResponse);
        
        let SalesOrderResponse = resultJson.SalesOrderResponse;
        if(SalesOrderResponse.ReturnCode==="00"){
            const items = SalesOrderResponse.SalesOrderItem;
            //component.set("v.isOrderFound", true);
            //const OrderLineNumber = SalesOrderResponse.SalesOrderItem.OrderLineNumber;            
            const itemsArray = Array.isArray(items) ? items : ([items]);
            
            let casesMap = {};
            if(returnMap.hasOwnProperty("cases")){
                let cases = returnMap.cases;                
                cases.forEach(function(cs){
                    casesMap[cs.Part_No__c] = cs;
                });
            }
            
            itemsArray.forEach(function(elem) {                
                Object.assign(elem, SalesOrderResponse.SalesOrderHeader);                
                if(returnMap.hasOwnProperty("cases")) 
                    if(typeName==='Return_Number__c' || typeName==='Credit_Debit_Number__c') {
                        elem.case = casesMap.hasOwnProperty(elem.Part_No__c) ? casesMap[elem.Part_No__c] : null;
                    }else if(typeName==='SAP_Order_Number__c'){
                        elem.case = casesMap.hasOwnProperty(elem.Material) ? casesMap[elem.Material] : null;
                    }
            });          
            
        } else {
            helper.showToast(component,"ERROR",SalesOrderResponse.ReturnMessage,"error","paragonValueInput");
        }
    },
    getDCodes : function(component, event, helper) {
        console.log('inside getDealerCodes Method');
        var action = component.get('c.getDealerCodes_as_account'); 
        
        action.setCallback(this,function(res){
            var state = res.getState();           
            if(state=='SUCCESS'){
                console.log( res.getReturnValue()); 
                component.set("v.selectedDealerCode", res.getReturnValue()[0].Id);
                component.set("v.dealerCodePickListValues", res.getReturnValue());               
            }
        });        
        $A.enqueueAction(action);        
    },
    apexCallbackElse : function(component,event,helper,response){
        let state = response.getState();
        if (state === "INCOMPLETE") {
            helper.showToast(component,"INCOMPLETE!","INCOMPLETE","warning","paragonValueInput");
        }
        else if (state === "ERROR") {
            let errors = response.getError();
            if (errors) {
                if (errors[0] && errors[0].message) {
                    helper.showToast(component,"ERROR!","Error message: " + errors[0].message,"error","paragonValueInput");
                }
            } else {
                console.log("Unknown error");
                helper.showToast(component,"ERROR!","Unknown error","error","paragonValueInput");
            }
        }
    },
    checkcomponentvalidity : function (component,event,helper,componentchanged){       
            component.find(componentchanged).forEach(function (inputCmp) {
            inputCmp.showHelpMessageIfInvalid();            
            });                
    },
    resetdata: function(component, event, helper){
        component.set("v.caseobj.Part_No__c",''); //chandrika added part number for reset logic
        component.set("v.caseobj.Core_Part_Num__c",'');
        component.set("v.caseobj.RPA__c",'');
        component.set("v.caseobj.Core_Program__c",'');
        component.set("v.caseobj.Core_Group__c",'');
        component.set("v.caseobj.Core_Invoice__c",'');
        component.set("v.caseobj.Description",'');
        
        //added on 4/13/2020 by chandrika to add reset logic
        helper.resetadditionaldata(component, event, helper);
        helper.resetattachments(component, event, helper);    
    },
    
    //added on 4/13/2020 by chandrika to add reset logic
    resetadditionaldata: function(component, event, helper){
        component.set("v.additionalRecipient", '');
        var emptyarray = [];       
        component.set("v.additionalRecipientList2",emptyarray);
    },
    
    //added on 4/13/2020 by chandrika to add reset logic
    resetattachments: function(component, event, helper){
        component.set("v.files", '');
        component.set("v.pillsoffiles", '');
        var emptyarray = [];      
        component.set("v.pillsoffiles", emptyarray);
    },
                
    getdealercontactsvisible: function(component, event, helper){
         var action = component.get('c.getDealerContactsSelectedAccount');  
         action.setParams({           
            'dealercode': component.get("v.selectedDealerCode")
        });
        action.setCallback(this,function(response){
            var state = response.getState();           
            if(state=='SUCCESS'){
                debugger;
                console.log( 'additionaldealercontactslistvisible: ' + response.getReturnValue()); 
                var dealercontactpicklist = [];
                var picklistresponse = response.getReturnValue();
                picklistresponse.forEach(function(elem){                                                        
                    var optionlabel = '';
                    optionlabel += elem.FirstName ? elem.FirstName + ' ' : '';
                    optionlabel += elem.LastName ? elem.LastName : '';
                    optionlabel += ' ('+ elem.Email +' )';
                    var option = {
                        'label':optionlabel,
                        'value':elem.Email
                    }
                    dealercontactpicklist.push(option);
                });

                component.set("v.additionaldealercontactslistvisible", dealercontactpicklist);                
            }
        });        
        $A.enqueueAction(action);    
    }
})