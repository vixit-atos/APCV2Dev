({
    doInit: function(component, event, helper){        
        helper.getDCodes(component, event, helper);        
        component.set("v.Request_Type__c", 'Order Status');
       // component.set("v.RecordTypeId", '012L0000000p27pIAA');
        component.set("v.caseobj.APC_Source__c", 'Existing Order');        
        
        component.set("v.soldToParty", "");
        component.set("v.actionsMap", {
            Backorder:["Ship Date","Cancellation"],
            Investigation:["Ship Date","Cancellation"],
            "Drop Ship":["Ship Date","Cancellation","Tracking Number","Carrier Change"],
            "Direct Ship Transmitted":["Ship Date","Cancellation","Tracking Number"],
            Cancelled:["Reason why"],
            Released:["Cancellation","Tracking Number"],
            Shipped:["Tracking Number"]
        });        
        let requestTypeList = [
            {
            label:"SAP Order Number",
            value:"orderNumber"
        },{
            label:"Customer PO Number",
            value:"customerPoNo"
        }];        
        component.set("v.requestTypeList", requestTypeList);
        
    },    
    getOrderRecords : function(component,event,helper){
        $A.util.removeClass(component.find("spinner"), "slds-hide");
        component.set("v.issubmitactive", false);
        component.set("v.issubmitrequestclicked", false);
        component.set("v.issubmitrequestclicked", true);   
        
        helper.resetadditionaldata(component, event, helper);      //added on 4/13/2020 by chandrika to add reset logic        
    },
    resetData : function(component,event,helper){
        var reqno = component.get("v.requestNumber");
        //alert(reqno);             
         if(reqno.length > 0){
            component.set("v.ispartnumbersearchdisabled", false);
        }else{
            component.set("v.ispartnumbersearchdisabled", true);
            component.set("v.issubmitrequestclicked", false);
        }
    },
    handleKeyup : function(component,event,helper){
        helper.showToast(component,"","","","requestNumberId");
        if(event.keyCode === 13) {
            component.set("v.issubmitrequestclicked", true);  
        }
    },
    requesttypechange: function(component, event, helper){        
        
        component.set("v.requestNumber", '');
        component.set("v.issubmitrequestclicked", false);

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
        component.set("v.requestNumber", '');
        component.set("v.issubmitrequestclicked", false);
        helper.getdealercontactsvisible(component, event, helper);
    }   
})