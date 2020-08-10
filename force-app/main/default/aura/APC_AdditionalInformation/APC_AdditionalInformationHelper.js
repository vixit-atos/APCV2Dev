({
    removeByKey : function (array, value)    { 
        array.some(function(item, index) {
            if(array[index] === value)
            {
                array.splice(index, 1);
                return true; // stops the loop
            }
            return false;
        });
        return array;
    },
    
    getContacts :function(component,event,helper){
        var action = component.get('c.getContacts'); 
        var caseRecordId = component.get('v.recordId');        
        action.setParams({
            'caseid' : caseRecordId
        });
        action.setCallback(this,function(res){
            var state = res.getState();
            if(state=='SUCCESS'){
                
                var selecteddealercontacts = component.get("v.caseobj.Additional_Contacts__c");

                if(selecteddealercontacts!=undefined && selecteddealercontacts!=null){
                    var selecteddealercontactsarr = selecteddealercontacts.split(';');
                    component.set('v.selecteddealercontacts', selecteddealercontactsarr);
                }
                
                var dealercontactpicklist = [];
                debugger;
                var picklistresponse = res.getReturnValue();
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
                
                component.set("v.additionaldealercontactslist", dealercontactpicklist);
            }
        });
        
        $A.enqueueAction(action);
    },
    
    getCase :function(component,event,helper){
        var caseRecordId = component.get('v.recordId');
        if(caseRecordId.startsWith("500")){
            var action = component.get('c.getCase');
            action.setParams({
                'caseid' : caseRecordId
            });
               
            action.setCallback(this,function(res){
                var state = res.getState();
                if(state=='SUCCESS'){
                    component.set("v.caseobj", res.getReturnValue());
                    helper.getuitheme(component, event, helper);
                    helper.getadditionalrecipient(component, event, helper);
                }
            });
            
            $A.enqueueAction(action);
        }
    },
    
    getadditionalrecipient: function (component, event, helper){
        var action = component.get('c.getadditionalrecipientContentNotes');
        var caseRecordId = component.get('v.recordId');
        
        action.setParams({
            'caseid' : caseRecordId
        });
        
        action.setCallback(this,function(res){
            var state = res.getState();
            if(state=='SUCCESS'){
                debugger;
                var listofEvent = [];
                listofEvent = res.getReturnValue();
                if(typeof listofEvent != 'undefined' && listofEvent !== "")
                {
                    var emailList = [];
                    listofEvent.forEach(function(event){
                        var recipientpill = {
                            "label": event.Title,
                            "name": event.Title
                        };
                        emailList.push(recipientpill);
                    });
                    component.set("v.additionalRecipientList", emailList);
                }
                
            }else
            {
               console.log(state);
            }
        });
        
        $A.enqueueAction(action);
        
    },
    
    checkforvalidrecipient: function(component, event, helper, componentchanged){ 
        var value = "";
        value = event.getParam("value");
        if(
            (value.indexOf("@") != -1)  &&
            (value.indexOf(".") != -1)  && 
            (value.indexOf("@.") == -1) &&
            (value.indexOf(" ") == -1)  &&
            (value.indexOf(";") == -1)  &&
            (value.indexOf(". ") == -1) &&
            (value.indexOf(",") == -1)     
        )
        {
            component.set("v.isvalidrecipient", true);         
        }else{
            component.set("v.isvalidrecipient", false);
        }  
        
    },    
    
    handleaddrecipient: function(component, event, helper) {
        var additionalrecipientemail = component.get("v.additionalRecipient");
        if(typeof additionalrecipientemail!= 'undefined' && additionalrecipientemail !== ""){   
            
            //checking for current recipient with existing data
            var isExists = false;
            var existingList = component.get("v.additionalRecipientList");
            for(var index=0;index<existingList.length;index++){
                if(existingList[index].label == additionalrecipientemail)
                {
                    isExists = true;
                    break;
                }
            }
            
            if( isExists == true){
                
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: "Warning!",
                        message:'This recipient already exists',
                        type: "Warning"});
                    toastEvent.fire();
                    component.set("v.additionalRecipient", "");
                }
                
            }else{
                var recipientpill = {
                    "label": additionalrecipientemail,
                    "name": additionalrecipientemail
                };   
                var action = component.get('c.saveAdditionalRecipientsDataContentNote');
                var additionalrecipientlist = JSON.stringify(recipientpill);
                var caseRecordId = component.get('v.recordId');
                action.setParams({
                    'caseid' : caseRecordId,
                    'additionalrecipientlist' : additionalrecipientlist
                    
                });
                
                action.setCallback(this,function(res){
                    var state = res.getState();
                    if(state=='SUCCESS'){
                        var isExisting = res.getReturnValue();
                        if(isExisting == false){
                            var emailList = component.get("v.additionalRecipientList");
                            emailList.push(recipientpill);
                            component.set("v.additionalRecipientList", emailList);
                            component.set("v.additionalRecipient", "");
                        }
                    }
                });
                
                $A.enqueueAction(action);
            }
        }else {
            
        }   
        
    },
    
    handleremoverecipient: function(component, event, helper) {
        var name = event.getParam("item").name;
        var recipientlist = component.get("v.additionalRecipientList");
        var additionalrecipientemail;
        for(var index=0;index<recipientlist.length;index++){
            if(recipientlist[index].label == name)
            {
                additionalrecipientemail = recipientlist[index].label;
                break;
            }
        }
        
        if(typeof additionalrecipientemail!= 'undefined' && additionalrecipientemail !== ""){   
            var recipientpill = {
                "label": additionalrecipientemail,
                "name": additionalrecipientemail
                
            };   
            var action = component.get('c.removeAdditionalRecipientsDataContentNote');
            var additionalrecipientlist = JSON.stringify(recipientpill);
            var caseRecordId = component.get('v.recordId');
            action.setParams({
                'caseid' : caseRecordId,
                'additionalrecipientlist' : additionalrecipientlist
                
            });
            
            action.setCallback(this,function(res){
                var state = res.getState();
                if(state=='SUCCESS'){
                    var isExisting = res.getReturnValue();
                    if(isExisting == true){
                        component.set("v.additionalRecipientList", helper.removeByKeylabel(component.get("v.additionalRecipientList"),name));
                    }else {
                        
                    }
                }
            });
            
            $A.enqueueAction(action);
            
        }else {
            
        }   
        
    },
    
    removeByKeylabel : function (array, value)    {
        array.some(function(item, index) {
            if(array[index].label === value)
            {
                array.splice(index, 1);
                return true; // stops the loop
            }
            return false;
        });
        return array;
    } ,
    
    saveCaseAdditionalContactsData : function(component, event, helper) {
        var action = component.get('c.saveCaseAdditionalContactsData');
        var caseRecordId = component.get('v.recordId');
        var additionalContacts = component.get('v.selecteddealercontacts');
        
        action.setParams({
            'caseid' : caseRecordId,
            'additionalContacts' : additionalContacts
        });
        
        action.setCallback(this,function(res){
            var state = res.getState();
            if(state=='SUCCESS'){
                component.set("v.caseobj", res.getReturnValue());
            }
        });
        
        $A.enqueueAction(action);
    },
    
    getuitheme: function(component, event, helper){
        var action = component.get("c.getUIThemeDescription");
        action.setCallback(this, function(a) {
            component.set('v.themedisplayed',a.getReturnValue());
            if(a.getReturnValue()=='Theme3'){               
                component.set("v.isnotLEX",true);
                component.set("v.sectiontitleactioncss",'slds-button slds-section__title-action unstyled-button');
                helper.getContacts(component, event, helper);
            }else if(a.getReturnValue()=='Theme4d'){                
                component.set("v.isLEX",true);
                component.set("v.sectiontitleactioncss",'slds-button slds-section__title-action unstyled-button font1em');
                helper.getContacts(component, event, helper);
            }
            
        });
        $A.enqueueAction(action);
    }
    
})