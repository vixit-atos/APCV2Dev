({
    getDCodes : function(component, event, helper) {
        debugger;        
        var action = component.get('c.getDealerCodes_as_account'); 
        
        action.setCallback(this,function(res){debugger;
            var state = res.getState();           
            if(state=='SUCCESS'){
                console.log( res.getReturnValue()); 
                component.set("v.selectedDealerCode", res.getReturnValue()[0].Id);
                component.set("v.dealerCodePickListValues", res.getReturnValue());
            }
        });        
        $A.enqueueAction(action);
        
    },    
    getResponse : function(component, event, helper){   
        component.set("v.isPartFound",false);
        helper.resetdatabucket1firstchoice(component, event, helper);
        $A.util.removeClass(component.find("spinner2"), "slds-hide");
        var partnumber = component.get("v.caseobj.Part_No__c");
        partnumber = partnumber.trim().toUpperCase();
        component.set("v.caseobj.Part_No__c", partnumber);
        
        var isValid = true;
        if(!partnumber){
            $A.util.addClass(component.find("spinner2"), "slds-hide");            
            component.find("partnum").showHelpMessageIfInvalid();            
            isValid = false;
        }
        
        var action = component.get("c.getpartvalidate");   
        action.setParams({
            "partnumber": partnumber                     
        });
        action.setCallback(this, function(response) {    
            $A.util.addClass(component.find("spinner2"), "slds-hide");
            debugger;
            var state = response.getState();
                                                                
            if (component.isValid() && state === "SUCCESS") 
            {
                console.log(JSON.stringify(response.getReturnValue()));
                var result = response.getReturnValue();  
                if(result.message === "Part is Valid"){                   
                    component.set("v.isPartFound","true");       
                    component.set("v.caseobj.Planner_Code__c", result.plannercode);
                    component.set("v.caseobj.Vendor__c", result.vendor);    
                    
                } else if (result.message === "Part is Invalid")
                {
                    component.set("v.isPartFound","false"); 
                    component.set("v.errorfound", "true");
            		component.set("v.errormessage", "Part Number is Invalid");
                }               
            } 
        });    
        $A.enqueueAction(action);  
    },
    resetadditionaldata: function(component, event, helper){
        component.set("v.caseobj.Description", '');
        component.set("v.additionalRecipient", '');
        component.set("v.additionaldealercontactselected", '');

        var emptyarray = [];       
        component.set("v.additionalRecipientList2",emptyarray); //added by chandrika on 4/13/2020
        component.set("v.additionaldealercontactselected", emptyarray);
    },
    resetdatabucket1: function(component, event, helper){
        component.set("v.caseobj.Quantity__c",'');
        component.set("v.caseobj.PDC_Location__c",'');
        component.set("v.caseobj.Lead_Time_Reason__c", '');                
    },
    resetdatabucket1firstchoice: function(component, event, helper){
        
        component.set("v.pricingReqSlctd", '');
    },
    resetdatamaterialload: function(component, event, helper){
        
        component.set("v.caseobj.Part_No__c", '');
        component.set("v.caseobj.Vendor__c", '');
        component.set("v.caseobj.VIN__c", '');
        component.set("v.caseobj.Reason__c", '');
        component.set("v.caseobj.Supplier__c", '');
    },
    resetpricingrequestdata: function(component, event, helper){      
         component.set("v.caseobj.SAP_Order_Number__c", '');       
        component.set("v.caseobj.Reason__c", '');        
        component.set("v.caseobj.NSN_Number__c", ''); 
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
 				console.log( 'dealercontactpicklist: ' + dealercontactpicklist); 
                component.set("v.additionaldealercontactslistvisible", dealercontactpicklist);                
            }
        });        
        $A.enqueueAction(action);    
    }
    
})