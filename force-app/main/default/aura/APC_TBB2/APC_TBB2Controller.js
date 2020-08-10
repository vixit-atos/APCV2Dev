({
    initHandler : function(component, event, helper) {        
        helper.getDCodes(component, event, helper);
        helper.getyearslist(component, event, helper);
        /*let typeofreasonlist = [{ 
            label:"General Info",
            value:"1"
        },{ 
            label:"Part Inquiry",
            value:"2"
        },{ 
            label:"Material Load",
            value:"3"
        }];
        
        let partinquiryreasonList = [{ 
            label:"Part Lookup",
            value:"1"
        },{ 
            label:"Technical Assistance",
            value:"2"
        }]; */
        
        helper.getpicklistvalue(component, event, helper, 'Case', 'TBB_Part_Inquiry__c', 'v.partinquiryreasonList');
        helper.getdependentpicklistvalue(component, event, helper, 'Case', 'Request_Type__c','TBB','Type_of_Request__c','v.typeofreasonlist');
        component.set("v.caseobj.Request_Type__c", 'TBB');
    },
    setDealerCode: function(component, event, helper){
        helper.resetdata(component, event, helper);
        component.set("v.dispVinModRsn", false);
        helper.ontypeofreasonchange(component, event, helper);  
    }, 
    
    keyPressLogic: function(component, event, helper){
        if (event.keyCode === 13) 
        {
             helper.resetform(component, event, helper);
            
            var bdNum = component.get("v.caseobj.Body_Number__c");
            if(bdNum=="" || bdNum=='undefined') {
                component.set("v.typeofreasonChanged", false);
                component.set("v.isIARC", false);
                component.set("v.issubmitactive", false);
                component.set("v.ispartnumbersearchdisabled", true);
                
                helper.checkvalidity(component, event, helper);
            } else{
                helper.checkvalidity(component, event, helper);
            }
        }
    },
    
    handleBodyNumberKeyup  : function(component, event, helper) {
        let typeName = event.currentTarget.dataset.typename;
        let typeValue = component.get("v.BodyNumber");
        helper.fetchCasesFromTypeNumber(component, event, helper, typeName, typeValue);
    },
    ontypeofreasonchange: function(component, event, helper){
        component.set("v.typeofreasonChanged", false);
        component.set("v.isIARC", false);
        helper.checkvalidity(component, event, helper);
        helper.resetadditionaldata(component, event, helper);      
        //helper.ontypeofreasonchange(component, event, helper);      
    },
    getbodynumber: function(component, event, helper){ 
        helper.resetform(component, event, helper);
        var bdNum = component.get("v.caseobj.Body_Number__c");
        if(bdNum=="" || bdNum=='undefined')
        {
            component.set("v.typeofreasonChanged", false);
            component.set("v.isIARC", false);
            component.set("v.issubmitactive", false);
            component.set("v.dispVinModRsn", false);
            
            helper.checkvalidity(component, event, helper);
        }    
        else{
            helper.checkvalidity(component, event, helper);
        }
    },
    onpartinquirychange: function(component, event, helper){
        component.set("v.isIARC", true);
        
        if(component.get("v.partinquiryselected") == 'Part Lookup')
        {
            component.set("v.issubmitactive", true);
            component.set("v.caseobj.TBB_Part_Inquiry__c",'Part Lookup');
            component.set("v.isIARC", true);
            
        } else  if(component.get("v.partinquiryselected") == 'Technical Assistance')
        {
            component.set("v.issubmitactive", true);
            component.set("v.caseobj.TBB_Part_Inquiry__c", 'Technical Assistance');
            component.set("v.isIARC", true);
        } else
        {
            component.set("v.issubmitactive", false);
        }
    },
    resetfield : function(component,event,helper){
        var reqno = component.get("v.caseobj.Body_Number__c");   
        if(reqno.length > 0){
            component.set("v.ispartnumbersearchdisabled", false);
        }
        else if(reqno=="" || reqno=='undefined')
        {
            component.set("v.ispartnumbersearchdisabled", true);
            component.set("v.dispVinModRsn", false);
            component.set("v.typeofreasonChanged", false);
            component.set("v.isIARC", false);
            component.set("v.issubmitactive", false);
            
            helper.resetdata(component, event, helper);
        } 
    },
    onpartnumberchange: function(component, event, helper){
        helper.checkfieldformaterialload(component, event, helper);
    },
    modelyearchange: function(component, event, helper){
        component.set("v.caseobj.Model_Year__c",event.getSource().get("v.value"));       
    },
    onpartdescriptionchange: function(component, event, helper){
        helper.checkfieldformaterialload(component, event, helper);
    }
})