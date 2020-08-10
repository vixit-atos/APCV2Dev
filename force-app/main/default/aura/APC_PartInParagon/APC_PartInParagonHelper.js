({
    getResponse: function(component, order,Ordernumber) {
        // create a server side action. 
        //alert("getResponse Helper class calling"+Ordernumber);
        var action = component.get("c.getpartvalidate");
        var isValid        = true;
        // set the url parameter for getpartvalidate method (to use as endPoint) 
        action.setParams({
            "partnumber": Ordernumber
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                // set the response(return String) to response attribute.      
                //alert("respose value as"+response.getReturnValue()+'Ordernumber'+Ordernumber.length);
                var result = response.getReturnValue();				         
                console.log('result ---->' + JSON.stringify(result));
                component.set("v.response", result.message);
                var lastresponse=component.get('v.response');
                component.set("v.isActive", result.isActive);
                component.set("v.partdescription", result.partdescription);
                component.set("v.plannercode", result.plannercode);
                component.set("v.vendor", result.vendor);
                component.set("v.VMRSCode", result.VMRSCode);
                component.set("v.Volume", result.Volume);
                component.set("v.UnitofMeasure", result.UnitofMeasure);
                component.set("v.Length", result.Length);
                component.set("v.Width", result.Width);
                component.set("v.height", result.height);
                component.set("v.volunit", result.volunit);
                component.set("v.GrossWeight", result.GrossWeight);
                component.set("v.WeightUnit", result.WeightUnit);
                component.set("v.USPDCPackSize", result.USPDCPackSize);
                component.set("v.USDSPackSize", result.USDSPackSize);
                component.set("v.CAPDCPackSize", result.CAPDCPackSize);
                component.set("v.CADSPackSize", result.CADSPackSize);
                console.log("lastresponse@@@"+lastresponse+'state'+state);                
                if(lastresponse=='Part is Invalid'){
                    order.set("v.errors", [{message:"Part is Invalid"}]);
                    isValid=false;
                }else if(isValid){
                    //alert('else if condition'+isValid);
                    order.set("v.errors", '');
                }              
            }else if(state = "ERROR"){
                errorMsg = response.getError()[0];
                let toastParams = {
                    title: "Error",
                    message: errorMsg, // Default error message
                    type: "error"
                };
                let toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams(toastParams);
                toastEvent.fire();
            }
        });
        
        $A.enqueueAction(action);
        
    },
    getContacts :function(component,event,helper){
        var code = component.get('v.dealerCode');
        console.log('getting contacts for:'+code);
        var action = component.get('c.getDealerContacts'); 
        action.setParams({
            'dealerCode' : code
        });
        
        action.setCallback(this,function(res){
            var state = res.getState();
            //alert("state"+state);
            if(state=='SUCCESS'){
                console.log( res.getReturnValue());    
                component.set("v.contactsPicklistValues", res.getReturnValue());
            }
        });
        
        $A.enqueueAction(action);
    },
    SaveRecord : function(component,event,helper){
        var partnum =component.find("partnum");
        partnum.showHelpMessageIfInvalid(); 
        var venname =component.find("venname");
        venname.showHelpMessageIfInvalid();   
        var selectItem1 =component.find("selectItemreason");
        selectItem1.showHelpMessageIfInvalid();   
        var Ordernumber = component.get("v.partnumber");
        var isValid        = true;        
        var ItemReason=component.get('v.SelectedReasonValue');
        var dealerContact = component.get('v.dealerContact');
        //alert("ItemReason"+ItemReason);
        if(ItemReason=="1"){
            ItemReason='Need to order';
        }else if(ItemReason=="2"){
            ItemReason='Customer quote';
        }
        var ORecord = component.get('v.RecordforSave');	        
        var CAction;                   	              
        CAction='Dealer contacts'; 
        if (partnum.get("v.validity").valid && venname.get("v.validity").valid && selectItem1.get("v.validity").valid) {
            ORecord.push({'LOC_Code__c':component.get('v.dealerCode'),'Able_to_find_the_part_in_Paragon__c':'No','Part_No__c':component.get('v.partnumber'),'Vendor_Name__c':component.get('v.vendorname'),'VIN__c':component.get('v.vinnumber'),'Reactivation_Reason__c':ItemReason,'Additional_Information__c':component.get('v.addinfo'),'Additional_Recipients__c':component.get('v.additionalRecipient'),'APC_Reason__c':'Material Load'});
            component.set('v.RecordforSave',ORecord);
        }
        //alert('SaveRecord function executing'+JSON.stringify(component.get("v.RecordforSave")));
        console.log(JSON.stringify(component.get('v.RecordforSave')));
        var rec = component.get('v.RecordforSave');
        var action = component.get('c.submitOrderRecords'); 
        //alert('SaveRecord function executing111'+JSON.stringify(component.get("c.CaseSubmitOrder")));      
        $A.util.removeClass(component.find("spinner"), "slds-hide");
        action.setParams({
            params : {},
            Odt : rec,
            ContactRole : dealerContact
        });
        
        action.setCallback(this,function(res){
            //component.set('v.IsModel',true);                                
            var state = res.getState();
            $A.util.addClass(component.find("spinner"), "slds-hide");
            //alert('state'+state);
            if(state=='SUCCESS'){
                if(component.get("v.RecordforSave").length>0){               
                    //component.set('v.IsModel',true);
                    component.find('notifLib').showNotice({
                        "variant": "success",
                        "header": "Success!",
                        "message": "Case is created successfully.",
                        closeCallback: function() {
                            component.find("navService").navigate({    
                                type: "standard__namedPage",
                                attributes: {
                                    "pageName": "home"    
                                }
                            });
                        }
                    });
                    
                }
            }
        });
        $A.enqueueAction(action);                   
    },
    fetchCasesFromTypeNumber: function(component, event, helper, conditions) {
        $A.util.removeClass(component.find("spinner"),"slds-hide");
        let localReference = helper.mainReference = new Date().getTime();
        
        var action = component.get('c.getCasesFromTypeNumber');
        action.setParams({
            conditions: conditions
        });
        action.setCallback(this,function(response){
            if(localReference===helper.mainReference) {
                $A.util.addClass(component.find("spinner"),"slds-hide");
                var state = response.getState();
                if(state=='SUCCESS'){
                    let cases = response.getReturnValue();
                    console.log("cases => ", JSON.stringify(cases));
                    if(cases && cases.length>0) {
                        let message = "";
                        let unResolvedCase = cases.find(rec=>rec.Status!=="Resolved");
                        if(unResolvedCase) {
                            message = "Case already exists. Do you want to go to case?";
                        } else {
                            message = "Case is resolved. Do you want to create new case?";
                        }
                        setTimeout(function() {
                            let caseModal = {
                                show: true,
                                message: message,
                                isResolved: unResolvedCase ? false : true,
                                caseId: unResolvedCase ? unResolvedCase.Id : "",
                                noFunction: function() {
                                    component.find("navService").navigate({    
                                        type: "comm__namedPage",
                                        attributes: {
                                            "pageName": "home"    
                                        }
                                    });
                                }
                            };
                            console.log("caseModal => ", caseModal);
                            component.set("v.caseModal", caseModal);
                        }, 0);
                    }else{                        
                        helper.SaveRecord(component,event,helper);
                    }
                } else {
                    helper.apexCallbackElse(component,event,helper,response);                    
                }
            }
        });
        
        $A.enqueueAction(action);
    },
})