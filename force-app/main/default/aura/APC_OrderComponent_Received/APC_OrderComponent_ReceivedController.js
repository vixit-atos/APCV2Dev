({
    initHandler : function(component, event, helper) {
        helper.getDCodes(component, event, helper);        
    },    
    dispPartNo : function(component, event, helper) {
        
        component.set("v.recordsfound", false);
        component.set("v.partnumber", false);
        component.set("v.isgoclicked", false);
        component.set("v.IsSpinner", false);
        component.set("v.issubmitactive", false);
        component.set("v.ispartnumbersearchdisabled", true);
        var selected = event.getSource().get("v.value");    
        
        if( selected != '4')
        {
            helper.resetdata(component, event, helper);
            component.set('v.dispPartTxtBox','Yes');               
        }else
        {            
            component.set('v.dispPartTxtBox','No');            
        }
        
        if(component.get("v.selectedOption") == 'SAP_Order_Number__c')
        {
            //component.set("v.caseobj.Type_of_Request__c", );
        }else if (component.get("v.selectedOption") == 'Return_Number__c')
        {
            //component.set("v.caseobj.Type_of_Request__c", );
        }else if (component.get("v.selectedOption") == 'Credit_Debit__c')
        {
            component.set("v.caseobj.Request_Type__c", 'Credit/Debit Request');
            
        }else if (component.get("v.selectedOption") == '4')
        {
            component.set("v.caseobj.Request_Type__c", 'Core Inquiry');
        }else
        {
            //component.set("v.caseobj.Type_of_Request__c", );
        }
    },
    requestReceivedOrderFromParagon : function(component, event, helper){ 
        component.set("v.isgoclicked", false);
        var componentname = '';
        if(component.get("v.selectedOption")== 'SAP_Order_Number__c')
        {
            componentname='partnum1';
        } else if(component.get("v.selectedOption")== 'Return_Number__c')
        {
            componentname='partnum2';
        } else if(component.get("v.selectedOption")== 'Credit_Debit__c')
        {
            componentname='partnum3';
        } 
  		
        if(component.find(componentname).get("v.validity").valid && component.get("v.partnumber") != '' && component.get("v.partnumber") != 'undefined')
        {
            component.set("v.isgoclicked", true);
        }else
        {
            component.find(componentname).showHelpMessageIfInvalid();
        }
         
    },    
    setDealerCode : function(component, event, helper){  
          var dealercodeselected = component.get("v.selectedDealerCode");
        if(dealercodeselected.Id != ''){
            component.set("v.isdealercodeselected", true);
            component.set("v.caseobj.AccountId", dealercodeselected.Id);
        }else{
            component.set("v.isdealercodeselected", false);
            component.set("v.caseobj.AccountId", '');
        } 
            
        component.set("v.recordsfound", false);
        component.set("v.partnumber", false);
        component.set("v.isgoclicked", false);
        component.set("v.dispPartTxtBox", '');
        component.set("v.selectedOption", '');
        helper.getdealercontactsvisible(component, event, helper);
    },    
    resetData : function(component,event,helper){
        var reqno = component.get("v.partnumber");        
        
         if(reqno.length > 0){
            component.set("v.ispartnumbersearchdisabled", false);
        }else{
            component.set("v.ispartnumbersearchdisabled", true);
            component.set("v.isgoclicked", false);
        }
        var componentchanged = event.getSource().getLocalId();
        helper.checkcomponentvalidity(component,event,helper, componentchanged);
        	
    },    
    keyPressLogic: function(component, event, helper){
        
        if (event.keyCode === 13) {           
            component.set("v.isgoclicked", true);   
        }
    }    
})