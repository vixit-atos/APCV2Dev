({
    getDCodes : function(component, event, helper) {       
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
    ontypeofreasonchange: function(component, event, helper){
        helper.resetdatatypeofreason(component, event, helper);
        component.set("v.isreasonpartinquiry", false);
        if(component.get("v.typeofreasonselected") == 'General Inquiry')
        {
            component.set("v.caseobj.Type_of_Reason__c", 'General Inquiry');
            component.set("v.issubmitactive", true);
            component.set("v.isreasonpartinquiry", true);
            
        }else if(component.get("v.typeofreasonselected") == 'Part Inquiry')
        {
            component.set("v.caseobj.Type_of_Reason__c", 'Part Inquiry');
            component.set("v.isreasonpartinquiry", false);
            component.set("v.issubmitactive", false);
        }else if(component.get("v.typeofreasonselected") == 'Material Load')
        {
            component.set("v.caseobj.Type_of_Reason__c", 'Material Load');
            component.set("v.issubmitactive", false);
            component.set("v.isreasonpartinquiry", true);
        }else
        {
            component.set("v.issubmitactive", false);            
        }
        
        if(component.get("v.typeofreasonselected") == ''){
            component.set("v.typeofreasonChanged", false);
        }else{
            component.set("v.typeofreasonChanged", true);
        }
    },
    checkfieldformaterialload: function(component, event, helper){
        if(component.get("v.caseobj.Part_No__c") != '' )
        {
            if(component.get("v.caseobj.Part_Description__c") != '')
            {
                component.set("v.issubmitactive", true);
            }else
            {
                component.set("v.issubmitactive", false);
            }
        }else
        {
            component.set("v.issubmitactive", false);
        }
    },
    getyearslist: function(component, event, helper){
        var d = new Date();
        var n = d.getFullYear();
        var yearlist = [];
        for(var i = n; i > n-100; i-- )
        {
            yearlist.push(i);
        }
        component.set("v.modelyearlist", yearlist);
    },
    resetdata: function(component, event, helper){
        component.set("v.caseobj.Body_Number__c", '');
        component.set("v.caseobj.VIN__c", '');
        component.set("v.caseobj.Model_Year__c", '');
        component.set("v.typeofreasonselected", '');
    },
    resetadditionaldata: function(component, event, helper){
        component.set("v.caseobj.Description", '');
        component.set("v.additionalRecipient", '');
        component.set("v.additionalRecipientList", '');
        component.set("v.files", '') 
        component.set("v.pillsoffiles", '')
        var emptyarray = [];       
        component.set("v.additionalRecipientList2",emptyarray);
        component.set("v.additionalRecipientList",emptyarray); 
        component.set("v.additionalRecipient", emptyarray);
        component.set("v.pillsoffiles", emptyarray);
    },
    resetdatatypeofreason: function(component, event, helper){       
        component.set("v.caseobj.Part_No__c",'');
        component.set("v.caseobj.Part_Description__c",'');
        component.set("v.caseobj.TBB_Part_Inquiry__c", '');
        component.set("v.partinquiryselected", '');
        component.set("v.caseobj.Description", '');
    },
    checkforduplicate: function(component, event, helper){
        var action = component.get('c.findduplicatecaseforTBB');   
        action.setParams({
            'bodynumbertbb' : component.get("v.caseobj.Body_Number__c"),
            'dealercode': component.get("v.selectedDealerCode")
        });
        action.setCallback(this,function(res){
            
            var state = res.getState();           
            if(state=='SUCCESS'){
                var bdNum = component.get("v.caseobj.Body_Number__c");
                if( bdNum != '' && bdNum != null)
                {
                    component.set("v.dispVinModRsn", true);
                }               
            }
            else if (state=='ERROR'){                               
                var errors = res.getError();
                var error = JSON.parse(errors[0].message);
                if(error.code === 1){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: "Warning!",
                        message:(' Case  '+ error.caserecord.CaseNumber +' already exists for the request'),
                        "duration": 60000,
                        type: "warning"});
                    toastEvent.fire();
                    //alert(' case  '+ error.caserecord.CaseNumber +' already exists for the request');
                }                
            }
                else{
                    
                }
        });        
        $A.enqueueAction(action);  
    },
    checkvalidity : function(component, event, helper){
        var bodynum = component.find("bodynum");
        if(!bodynum.get("v.validity").valid){
            bodynum.reportValidity();                
             
            var toastEvent = $A.get("e.force:showToast");
                     toastEvent.setParams({
                         title: "Warning!",
                         message:'Please enter a valid Body Number',
                         type: "warning"});
                     toastEvent.fire();    
            
            component.set("v.typeofreasonChanged", false);
            component.set("v.isIARC", false);
            component.set("v.issubmitactive", false);
            component.set("v.dispVinModRsn", false);
            component.set("v.ispartnumbersearchdisabled", true);
             component.set("v.typeofreasonselected", '');
        }else{
            var reqno = component.get("v.caseobj.Body_Number__c");        
            if(reqno.length > 0){
                this.ontypeofreasonchange(component, event, helper);  
                //this.checkforduplicate(component, event, helper);  
            }
        }
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
    getpicklistvalue: function(component, event, helper, objectName, field_apiname, attributename){
        debugger;
        var action = component.get('c.getPicklistvalues'); 
        action.setParams({
            'objectName' : objectName,
            'field_apiname':field_apiname
        });
        action.setCallback(this,function(res){            
            var state = res.getState();
            //alert("state"+state);
            if(state=='SUCCESS'){
                console.log( res.getReturnValue()); 
                component.set(attributename, res.getReturnValue());               
            }
        });
        
        $A.enqueueAction(action);
    },
     getdependentpicklistvalue: function(component, event, helper, objectName, parentField, parentFieldvalue,childField,attributename){
        debugger;
        var action = component.get('c.getdependentPicklistvalues'); 
        action.setParams({
            'objectName' : objectName,
            'parentField':parentField,
            'parentFieldvalue':parentFieldvalue,
            'childField':childField
        });
        action.setCallback(this,function(res){            
            var state = res.getState();
            //alert("state"+state);
            if(state=='SUCCESS'){
                console.log( res.getReturnValue()); 
                component.set(attributename, res.getReturnValue());               
            }
        });
        
        $A.enqueueAction(action);
    }
    
})