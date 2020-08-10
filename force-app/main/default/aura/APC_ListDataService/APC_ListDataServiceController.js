({
    getListData : function(component, event, helper) {
        
        var params = event.getParam('arguments');
        var callback;
        var stagefilter;
        var statusfilter;
        var domain;
        var source;
        var methodname;
        if (params) {
            callback = params.callback;
            stagefilter = params.Stagefilter;
            statusfilter = params.Statusfilter;
            domain = params.domain;
            source = params.source;
            methodname = params.methodname;
           
        }
        
        // debugger;
        var action = component.get('c.' + methodname);
        
        //action.setStorable();
        action.setParams({
            "stagefilter" : stagefilter,
            "statusfilter" : statusfilter,
            "domain" : domain,
            "source" : source
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                
                if (callback) callback(response.getReturnValue()); 
                
            }
        });
        $A.enqueueAction(action);
    },
    getAllDataExistingOrder: function(component, event, helper){       
        var params = event.getParam('arguments');
        var callback;
        var RequestNumber;
        var RequestType;
        var APC_Source;
        var soldToParty;
        var isexternal;
        var methodname;
        
        if (params) {
            callback = params.callback;
            RequestNumber = params.RequestNumber;
            RequestType = params.RequestType;
            APC_Source = params.APC_Source;
            soldToParty = params.soldToParty;
            isexternal = params.isexternal;
            methodname = params.methodname;            
        }        
       // soldToParty=soldToParty.length===5 ? soldToParty : ("F"+soldToParty);
        var action = component.get('c.' + methodname);
        if(RequestType == 'orderNumber' ){
            action.setParams({
                "orderNumber" : RequestNumber ,
                "customerPoNo" : '',
                "soldToParty" : soldToParty,
                "APC_Source" : 'Existing Order',
                "isexternal": isexternal
            });
        }
        else if (RequestType == 'SAP_Order_Number__c' || RequestType == 'Return_Number__c' || RequestType == 'Credit_Debit__c' ){
            action.setParams({
                "typeName":RequestType ,
                "typeValue" : RequestNumber ,                
                "soldToParty" : soldToParty,
                "APC_Source" : 'Received Order',
                "isexternal": isexternal
            });
        }
        else {
            action.setParams({
                "orderNumber" : '' ,
                "customerPoNo" : RequestNumber,
                "soldToParty" : soldToParty,
                "APC_Source" : 'Existing Order',
                "isexternal": isexternal
            });
        }         
        action.setCallback(this, function(response) {
             
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                
                if (callback) callback(response.getReturnValue()); 
                
            } else{
                debugger;
                let errors = response.getError();
                component.set("v.IsSpinner", false);
                component.set("v.errorfound", true);
                component.set("v.errormessage", errors[0].message);     
                component.set("v.issubmitrequestclicked", false);
            }
        });
        $A.enqueueAction(action);
    }
})