({
    initHandler : function(component, event, helper) {        
        helper.getDCodes(component, event, helper);
        let findParagonList_lcl = [
            {
            label:"Yes",
            value:"yes"
        },{
            label:"No",
            value:"no"
        }];        
         component.set("v.findParagonList", findParagonList_lcl);
         component.set("v.pricingReqList", findParagonList_lcl); 
         //component.set("v.caseobj.RecordTypeId", '012L0000000p27pIAA');
         component.set("v.caseobj.APC_Source__c", 'New Order');
    },    
       
    getInput: function(component, event, helper) { 
        component.set("v.errorfound", "false");
        component.set("v.errormessage", "");         
        helper.getResponse(component, event, helper); 
        helper.resetpricingrequestdata(component, event, helper); //added by Chandrika on 4/14/2020
        
    },      
    keyPressLogic: function(component, event, helper){
        debugger;
        helper.resetpricingrequestdata(component, event, helper); //added by Chandrika on 4/14/2020
        
        //this.resetPricingReqData(component, event, helper);
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
            component.set("v.issubmitactive", false);
        }
        //debugger;
        if (event.keyCode === 13) {
            helper.getResponse(component, event, helper); 
            if(component.get("v.isPartFound") == true ){
                component.set("v.issubmitactive", true);
            }else{
                component.set("v.issubmitactive", false);
            }
            
            component.set("v.errorfound", "false");
            component.set("v.errormessage", ""); 
        }
    },    
    resetPricingReqData : function(component,event,helper){
        var reqno = component.get("v.caseobj.Part_No__c");
        console.log('reqno:'+reqno);
        if(reqno=="" || reqno=='undefined')
        {
            component.set("v.isPartFound", false);
        }
     },    
    onpricingrequestchange : function(component, event, helper) {
        component.set("v.ispricingrequest", event.getSource().getLocalId());       
    },
    disableSubmitButton : function(component, event, helper){
        debugger;        
        helper.resetdatabucket1firstchoice(component, event, helper);
        helper.resetdatabucket1(component, event, helper);
        helper.resetadditionaldata(component, event, helper);
        
        if(component.get("v.findParagonBool") == 'no'){              
            component.set("v.caseobj.Request_Type__c", 'Material Load');  
            component.set("v.caseobj.Part_No__c", '');
            component.set("v.isPartFound", false);
            component.set("v.testbool", false);
        }
        else if (component.get("v.findParagonBool") == 'yes'){            
            component.set("v.caseobj.Request_Type__c", 'Price Request');            
            component.set("v.testbool", true);
            helper.resetdatamaterialload(component, event, helper);
        }
        else{            
            component.set("v.caseobj.Request_Type__c", '');
        }        
        component.set("v.issubmitactive", false);
    },
    disableSubmitButton1 : function(component, event, helper){
        helper.resetdatabucket1(component, event, helper);
        helper.resetadditionaldata(component, event, helper);
        if(component.get("v.pricingReqSlctd") == 'yes')
        {
            component.set("v.caseobj.Request_Type__c", 'Price Request');
        }else
        {
             helper.resetpricingrequestdata(component, event, helper);
            
        }
        component.set("v.issubmitactive",false);
    },
    setDealerCode: function(component, event, helper){
           var dealercodeselected = component.get("v.selectedDealerCode");
        if(dealercodeselected.Id != ''){
            component.set("v.isdealercodeselected", true);
            component.set("v.caseobj.AccountId", dealercodeselected.Id);
        }else{
            component.set("v.isdealercodeselected", false);
            component.set("v.caseobj.AccountId", '');
        } 
        component.set("v.testbool", null);
        component.set("v.findParagonBool", null);
        helper.getdealercontactsvisible(component, event, helper);
        //component.set("v.caseobj.Part_No__c", null);
    }
})