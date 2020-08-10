({   
    getDCodes : function(component, event, helper) {
        console.log('inside getDealerCodes Method');
        var action = component.get('c.getDealerCodes_as_account'); 
        
        action.setCallback(this,function(res){
            var state = res.getState();
            //alert("state"+state);
            if(state=='SUCCESS'){
                console.log( res.getReturnValue()); 
                component.set("v.selectedDealerCode", res.getReturnValue()[0].Id);
                component.set("v.dealerCodePickListValues", res.getReturnValue());
            }
        });
        
        $A.enqueueAction(action);
    },    
    resetData : function(component, event, helper) {
        component.set("v.requestType", "");
		component.set("v.issubmitrequestclicked", false);
		component.set("v.recordsfound",false);
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
    },
       //added on 4/13/2020 by chandrika to add reset logic
    resetadditionaldata: function(component, event, helper){
        component.set("v.additionalRecipient", '');
        var emptyarray = [];       
        component.set("v.additionalRecipientList2",emptyarray);
    },
})