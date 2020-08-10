({
    
    doInit: function(component, event, helper) {
        debugger;
        
       
        helper.openModel(component, event, helper);
        helper.getpicklistvalue(component, event, helper, 'Case', 'Status', 'v.statusPLVals');
        helper.getpicklistvalue(component, event, helper, 'Case', 'Priority', 'v.prioritylist');
        helper.getpicklistvalue(component, event, helper, 'Case', 'Request_Type__c', 'v.apcreasonlist');
        helper.getprioritypicklistvalue(component, event, helper,  'v.prioritylist');
        helper.getoriginpicklistvalue(component, event, helper,  'v.originlist');
        
    },
    
    closeModal: function(component, event, helper) {
        component.set('v.isOpen',false);
        helper.closenewcasetab(component, event, helper);
    },
    
    keyPressLogic: function(component, event, helper){
        var partnumber = component.get("v.caseobj.Part_No__c");
        partnumber = partnumber.toUpperCase();
        
        if(partnumber.length > 0){
            component.set("v.ispartnumbersearchdisabled", false);
        }else{
            component.set("v.ispartnumbersearchdisabled", true);
        }
        
        component.set("v.caseobj.Part_No__c", partnumber);
        if(partnumber=="" || partnumber=='undefined')
        {
            component.set("v.isPartFound", false);
            component.set("v.errorfound", false);
            component.set("v.errormessage", "");   
            component.set("v.issubmitactive", false);
            helper.resetdatabucket1(component, event, helper);
            helper.resetadditionaldata(component, event, helper);
            helper.resetData(component, event, helper);
        }
        if (event.keyCode === 13) {
            component.set("v.isPartFound", false);      
            component.set("v.IsSpinner", true);
            helper.getResponse(component, event, helper); 
            component.set("v.errorfound", false);
            component.set("v.errormessage", ""); 
        }
        
    }, 
    
    getInput: function(component, event, helper) { 
        component.set("v.isPartFound", false);      
        component.set("v.errorfound", false);
        component.set("v.errormessage", "");   
        component.set("v.IsSpinner", true);
        helper.getResponse(component, event, helper);
         
    },
    
    onapcreasonchange : function(component, event, helper){
        debugger;
        component.set("v.APCreasonchanged", true);
        var selectedAPCReason = component.get("v.APCreasonselected");        
        var selectedDealerCode = component.get("v.selectedDealerCode");
        
        component.set("v.issubmitactive", false);
        component.set("v.isgoclicked", false);
        component.set("v.caseobj.Part_No__c", '');
        component.set("v.isPartFound", false);
        component.set("v.Part_Number__c", '');
        component.set("v.additionalRecipientList", '');
        component.set("v.recordsfound", false);
        component.set("v.isIRC1", false);      
        component.set("v.errorfound", "false");
        component.set("v.errormessage", "");   
        component.set("v.ispartnumbersearchdisabled", true);  
        component.set("v.itsbucket1", false);  
        component.set("v.bucket3sap", false);
        component.set("v.bucket3return", false);
        component.set("v.bucket3returnadditional", false); 


        helper.resetdatabucket1(component, event, helper);
        helper.resetadditionaldata(component, event, helper);
        helper.resetcoreinquirydata(component, event, helper); 
        helper.resetData(component, event, helper);
        
        if((selectedDealerCode == undefined || selectedDealerCode == null) && selectedAPCReason != '--select--')
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error!",
                message:'Account cannot be blank',
                type: "error"});
            toastEvent.fire();
            
            component.set("v.APCreasonselected", "--select--");
            component.set("v.caseobj.Part_No__c", '');
            
        } else
        {    
            var formcomponent = component.find("formbucket1");
            if(component.get("v.APCreasonselected") == '--select--')
            {
                component.set("v.caseobj.Request_Type__c", '--select--');
            }
            else if(component.get("v.APCreasonselected") == 'Material Load')
            {
                component.set("v.caseobj.Request_Type__c", 'Material Load');
               // component.set("v.itsbucket1", true);      
                
            } else if(component.get("v.APCreasonselected") == 'Lead Time')
            {
                component.set("v.caseobj.Request_Type__c", 'Lead Time');
                component.set("v.itsbucket1", true);      
                
            } else if(component.get("v.APCreasonselected") == 'PDC Stock Check')
            {
                component.set("v.caseobj.Request_Type__c", 'PDC Stock Check');
                component.set("v.itsbucket1", true); 
                
            } else if(component.get("v.APCreasonselected") == 'Weights & Dimensions')
            {
                component.set("v.caseobj.Request_Type__c", 'Weights & Dimensions');
                component.set("v.itsbucket1", true);    
                component.set("v.weightsorpacksizeorreactivation", true);

            } else if(component.get("v.APCreasonselected") == 'Pack Size')
            {
                component.set("v.caseobj.Request_Type__c", 'Pack Size');
                component.set("v.itsbucket1", true);  
                component.set("v.weightsorpacksizeorreactivation", true); 

            } else if(component.get("v.APCreasonselected") == 'Reactivation')
            {
                component.set("v.caseobj.Request_Type__c", 'Reactivation');
                component.set("v.itsbucket1", true);    
                component.set("v.weightsorpacksizeorreactivation", true); 

            } else if(component.get("v.APCreasonselected") == 'Order Status')
            {
                component.set("v.caseobj.Request_Type__c", 'Order Status');
            } else if(component.get("v.APCreasonselected") == 'Pricing Discrepancy')
            {
                component.set("v.caseobj.Request_Type__c", 'Pricing Discrepancy');
                 component.set("v.bucket3sap", true);
                
            } else if(component.get("v.APCreasonselected") == 'Invoice Needed')
            {
                component.set("v.caseobj.Request_Type__c", 'Invoice Needed');
                component.set("v.bucket3sap", true);
                
            } else if(component.get("v.APCreasonselected") == 'Freight Charge Inquiry')
            {
                component.set("v.caseobj.Request_Type__c", 'Freight Charge Inquiry');
                component.set("v.bucket3sap", true); 
                
            } else if(component.get("v.APCreasonselected") == 'Excess/Special Credit')
            {
                component.set("v.caseobj.Request_Type__c", 'Excess/Special Credit');
                component.set("v.bucket3returnadditional", true); 

            } else if(component.get("v.APCreasonselected") == 'Excess/Special Other')
            {
                component.set("v.caseobj.Request_Type__c", 'Excess/Special Other');
                component.set("v.bucket3return", true);

            } else if(component.get("v.APCreasonselected") == 'Credit/Debit Request')
            {
                component.set("v.caseobj.Request_Type__c", 'Credit/Debit Request');
                
            } else if(component.get("v.APCreasonselected") == 'Core Inquiry')
            {
                component.set("v.caseobj.Request_Type__c", 'Core Inquiry');
            } else if(component.get("v.APCreasonselected") == 'TBB')
            {
                component.set("v.caseobj.Request_Type__c", 'TBB');
            } else if(component.get("v.APCreasonselected") == 'PDC Return')
            {
                component.set("v.caseobj.Request_Type__c", 'PDC Return');
                component.set("v.bucket3return", true);
                
            } else if(component.get("v.APCreasonselected") == 'Vendor Return')
            {
                component.set("v.caseobj.Request_Type__c", 'Vendor Return');
                component.set("v.bucket3return", true);

            } else if(component.get("v.APCreasonselected") == 'Excess/Special Allowance')
            {
                component.set("v.caseobj.Request_Type__c", 'Excess/Special Allowance');
                component.set("v.bucket3return", true);

            } else if(component.get("v.APCreasonselected") == 'Excess/Special Approval Status')
            {
                component.set("v.caseobj.Request_Type__c", 'Excess/Special Approval Status');
                component.set("v.bucket3returnadditional", true); 
                
            } else if(component.get("v.APCreasonselected") == 'Excess/Special Shipping')
            {
                component.set("v.caseobj.Request_Type__c", 'Excess/Special Shipping');
                component.set("v.bucket3returnadditional", true); 
                
            } else if(component.get("v.APCreasonselected") == 'Price Request')
            {
                component.set("v.caseobj.Request_Type__c", 'Price Request');
                component.set("v.itsbucket1", true);    
                
            } else if(component.get("v.APCreasonselected") == 'Packaging Deficiency')
            {
                component.set("v.caseobj.Request_Type__c", 'Packaging Deficiency');
                component.set("v.bucket3sap", true);
                
            } else
            {
                component.set("v.APCreasonchanged", false);
            }
        }
    },
    
    requesttypechange: function(component, event, helper){        
        component.set("v.requestNumber", '');
        //component.set("v.issubmitrequestclicked", false);
    },
    
    requestReceivedOrderFromParagon : function(component, event, helper){       
        $A.util.removeClass(component.find("spinner2"), "slds-hide");
        component.set("v.issendclicked", true);
        $A.util.addClass(component.find("spinner2"), "slds-hide");
    },
    
    handleContactsListEvent : function(component, event, helper) {
        var result_lst = event.getParam("contactList");
        var result_lstadditonal = event.getParam("contactdealerlist");
        var accountDelaerCode = event.getParam("accountDealerCode"); 
        component.set("v.contactNameslist", result_lst);
        component.set("v.selectedDealerCode",accountDelaerCode );
        component.set("v.additionaldealercontactslist", result_lstadditonal);
         if(result_lst.length >0){
             component.set("v.caseobj.ContactId", result_lst[0].value); }
        else{
            component.set("v.caseobj.ContactId", '');
        }
    },
    
    handleCaseClearEvent :  function(component, event, helper) {
        var result_clear = event.getParam("clear");
        if(result_clear === 'true'){
            
            component.set("v.APCreasonselected", "--select--");
            component.set("v.contactNameslist", null);
            component.set("v.selectedDealerCode", null);
            component.set("v.requestType",null);
            component.set("v.requestNumber",null);
            component.set("v.issubmitactive", false);
        }
    },
    
    handleaccountlookupevent : function(component, event, helper) {
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        console.log('selectedAccountGetFromEvent : Parent :' + selectedAccountGetFromEvent.Id);
        component.set("v.caseobj.AccountId", selectedAccountGetFromEvent.Id);        
    },
    
    submitclicked: function(component, event, helper){
        debugger;
        component.set("v.IsSpinner", true);
        if( 
            component.get("v.caseobj.Request_Type__c") == 'Material Load' ||
            component.get("v.caseobj.Request_Type__c") == 'Lead Time' ||
            component.get("v.caseobj.Request_Type__c") == 'PDC Stock Check' ||
            component.get("v.caseobj.Request_Type__c") == 'Price Request' ||
            component.get("v.caseobj.Request_Type__c") == 'Pack Size' ||
            component.get("v.caseobj.Request_Type__c") == 'Weights & Dimensions' ||
            component.get("v.caseobj.Request_Type__c") == 'Reactivation' )
        {
            helper.checkbucket1optionalfieldsvalidity(component, event, helper);
        } 
        else if (component.get("v.caseobj.Request_Type__c") == 'Pricing Discrepancy' ||
                 component.get("v.caseobj.Request_Type__c") == 'Invoice Needed'||
                 component.get("v.caseobj.Request_Type__c") == 'Freight Charge Inquiry' ||
                 component.get("v.caseobj.Request_Type__c") == 'Excess/Special Credit'||
                 component.get("v.caseobj.Request_Type__c") == 'Excess/Special Other'||
                 component.get("v.caseobj.Request_Type__c") == 'Credit/Debit Request'||
                 component.get("v.caseobj.Request_Type__c") == 'Core Inquiry'||
                 component.get("v.caseobj.Request_Type__c") == 'PDC Return'||
                 component.get("v.caseobj.Request_Type__c") == 'Vendor Return'||
                 component.get("v.caseobj.Request_Type__c") == 'Excess/Special Allowance'||
                 component.get("v.caseobj.Request_Type__c") == 'Excess/Special Approval Status'||
                 component.get("v.caseobj.Request_Type__c") == 'Excess/Special Shipping'||
                 component.get("v.caseobj.Request_Type__c") == 'Packaging Deficiency' ) {   
            
            helper.checkbucket3optionalfieldsvalidity(component, event, helper);
        }else if(component.get("v.caseobj.Request_Type__c") == 'TBB'){
            
            helper.checktbboptionalfieldsvalidity(component, event, helper);        
        }         
            else{
                helper.createcaseandorderrecord(component, event, helper); 
            }
        
    }
    
})