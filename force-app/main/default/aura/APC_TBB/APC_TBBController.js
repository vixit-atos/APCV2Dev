({
    initHandler : function(component, event, helper) {        
        helper.getDCodes(component, event, helper);
        helper.getyearslist(component, event, helper);
        helper.getpicklistvalue(component, event, helper, 'Case', 'TBB_Part_Inquiry__c', 'v.partinquiryreasonList');
        helper.getdependentpicklistvalue(component, event, helper, 'Case', 'Request_Type__c','TBB','Type_of_Request__c','v.typeofreasonlist');

        component.set("v.caseobj.Request_Type__c", 'TBB');
    },
    setDealerCode: function(component, event, helper){
        var dealercodeselected = component.get("v.selectedDealerCode");
        if(dealercodeselected.Id != ''){
            component.set("v.isdealercodeselected", true);
        }else{
            component.set("v.isdealercodeselected", false);
        } 
        helper.resetdata(component, event, helper);
        component.set("v.dispVinModRsn", false);
        helper.getdealercontactsvisible(component, event, helper);
        helper.ontypeofreasonchange(component, event, helper);  
    },    
    keyPressLogic: function(component, event, helper){
        var reqno = component.get("v.caseobj.Body_Number__c");        
        
        if(reqno.length > 0){
            component.set("v.ispartnumbersearchdisabled", false);
        }else{
            // Added By Chandrika 03/5/2020 for TBB Validity Check
            component.set("v.typeofreasonChanged", false);
            component.set("v.isIARC", false);
            component.set("v.issubmitactive", false);
            component.set("v.dispVinModRsn", false);
            component.set("v.ispartnumbersearchdisabled", true);
            
            component.set("v.isgoclicked", false);
            helper.resetdata(component, event, helper);
        }
        if (event.keyCode === 13) {
        }
    },    
    handleBodyNumberKeyup  : function(component, event, helper) {
        let typeName = event.currentTarget.dataset.typename;
        let typeValue = component.get("v.BodyNumber");
        helper.fetchCasesFromTypeNumber(component, event, helper, typeName, typeValue);
    },
    
    ontypeofreasonchange: function(component, event, helper){
        helper.checkvalidity(component, event, helper);
        helper.resetadditionaldata(component, event, helper); 
        //helper.ontypeofreasonchange(component, event, helper);      
    },    
    // Chandrika added on 15Nov19
    getbodynumber: function(component, event, helper){ 
        
        // Added By Chandrika 03/5/2020 for TBB Validity Check
        helper.checkvalidity(component, event, helper);
        /*
        var bdNum = component.get("v.caseobj.Body_Number__c");
        if( bdNum != '' && bdNum != null)
        {
             component.set("v.dispVinModRsn", true);
        }
            */
    },
    onpartinquirychange: function(component, event, helper){
        
        if(component.get("v.partinquiryselected") == 'Part Lookup')
        {
            component.set("v.issubmitactive", true);
            component.set("v.caseobj.TBB_Part_Inquiry__c",'Part Lookup');
            component.set("v.isreasonpartinquiry", true);
        } else  if(component.get("v.partinquiryselected") == 'Technical Assistance')
        {
            component.set("v.issubmitactive", true);            
            component.set("v.caseobj.TBB_Part_Inquiry__c", 'Technical Assistance');
            component.set("v.isreasonpartinquiry", true);
        } else
        {
            component.set("v.issubmitactive", false);
            component.set("v.isreasonpartinquiry", false);
        }
    },
    onpartnumberchange: function(component, event, helper){
        helper.checkfieldformaterialload(component, event, helper);
    },
    onpartdescriptionchange: function(component, event, helper){
        helper.checkfieldformaterialload(component, event, helper);
    },
    modelyearchange: function(component, event, helper){
        component.set("v.caseobj.Model_Year__c",event.getSource().get("v.value"));       
    }
})