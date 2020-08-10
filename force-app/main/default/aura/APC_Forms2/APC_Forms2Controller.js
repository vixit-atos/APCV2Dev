({
    initHandler : function(component, event, helper) {
        component.set("v.contactsPicklistValues", '');
        helper.setBucket3Values(component);
        
        let requestTypeList = [
            {
                label:"SAP Order Number",
                value:"orderNumber"
            },{
                label:"Customer PO Number",
                value:"customerPoNo"
            }];        
        component.set("v.requestTypeList", requestTypeList);
        helper.getpicklistvalue(component, event, helper, 'Case', 'Ship_Method__c', 'v.shipcarrierbyOptions');
        helper.getpicklistvalue(component, event, helper, 'Case', 'Is_Part_Damaged__c', 'v.ispartdamagelist');
        helper.getpicklistvalue(component, event, helper, 'Case', 'Packaged_By__c', 'v.packagedbylist');
        helper.getpicklistvalue(component, event, helper, 'Case', 'Type_of_Return__c', 'v.typeofreturnlist');
        helper.getpicklistvalue(component, event, helper, 'Case', 'Credit_Type__c', 'v.credittypelist');
        helper.getpicklistvalue(component, event, helper, 'Case', 'PDC_Location__c', 'v.pdclocationList');
        helper.getpicklistvalue(component, event, helper, 'Case', 'Reason_Return_Number__c', 'v.returnreasonlist');
        helper.getpicklistvalue(component, event, helper, 'Case', 'Invoice_Needed_For__c', 'v.invoiceneededreasonlist');
        helper.getpicklistvalue(component, event, helper, 'Case', 'Lead_Time_Reason__c', 'v.leadtimereasonList');
        helper.getdependentpicklistvalue(component, event, helper, 'Case', 'Request_Type__c','Credit/Debit Request','Type_of_Request__c','v.creditdebitreasonlist');
        helper.getdependentpicklistvalue(component, event, helper, 'Case', 'Request_Type__c','Core Inquiry','Type_of_Request__c','v.typeofrequestlist');
        helper.getdependentpicklistvalue(component, event, helper, 'Case', 'Request_Type__c','Reactivation','Type_of_Request__c','v.saporderreasonlist');
    },
    
    onIRCreasonchange:function(component, event, helper) {    
        helper.issubmitactive(component, event, helper);
    },
    onrecipientchange: function(component, event, helper){
        var componentchanged = event.getSource().getLocalId();
        helper.checkforvalidrecipient(component, event, helper, componentchanged);
    },
    requesttypechange: function(component, event, helper){   
        component.set("v.ispartnumbersearchdisabled", true);
        component.set("v.requestNumber", '');
        component.set("v.issubmitactive", false);
        component.set("v.issubmitrequestclicked", false);
        component.set("v.recordsfound",false);
        component.set("v.errorfound", "false");
        component.set("v.errormessage", "");   
        
        helper.resetadditionaldata(component, event, helper);
    },
    validatepartnumber : function(component, event, helper){ 
        var partnumber = component.get("v.caseobj.Part_No__c");
        partnumber = partnumber.toUpperCase();
        component.set("v.caseobj.Part_No__c", partnumber);
        helper.issubmitactive(component, event, helper); 
    },
    resetData : function(component,event,helper){
        var reqno = component.get("v.requestNumber");
        
        if(reqno.length > 0){
            component.set("v.ispartnumbersearchdisabled", false);
        }else{
            component.set("v.ispartnumbersearchdisabled", true);
            //else if(reqno=="" || reqno=='undefined')
            component.set("v.issubmitrequestclicked", false);
            component.set("v.issubmitactive", false);
            component.set("v.recordsfound", false);
            component.set("v.errorfound", false);
            component.set("v.errormessage", "");   
        }        	
    },
    
    resetfeild : function(component,event,helper){
        var reqno = component.get("v.caseobj.SAP_Order_Number__c"); 
        
        if(reqno.length > 0){  
            component.set("v.ispartnumbersearchdisabled", false);
        }
        //if(reqno=="" || reqno=='undefined')
        else{
            component.set("v.ispartnumbersearchdisabled", true);
            component.set("v.isgoclicked", false);
            component.set("v.issubmitactive", false);
            component.set("v.errorfound", false);
            component.set("v.errormessage", "");   
        }
    },
    keyPressLogic: function(component, event, helper){    
        if (event.keyCode === 13){
            component.set("v.isgoclicked", false);
            helper.requestReceivedOrderFromParagon(component, event, helper);}
    },
    requestReceivedOrderFromParagon: function(component, event, helper){
         component.set("v.isgoclicked", false);
        helper.requestReceivedOrderFromParagon(component, event, helper);
    },
    
    onpdclocationchange : function(component, event, helper){
        helper.checkForRequiredFields(component, event, helper); 
        component.set("v.isIARC", true);
    },
    handleaddrecipient: function(component, event, helper) {
        helper.handleaddrecipient(component, event, helper);       
    },
    handlerecipientremove: function(component, event, helper){                
        var name2 = event.getParam("item").name;        
        component.set("v.additionalRecipientList2", helper.removeByKeylabel(component.get("v.additionalRecipientList2"),name2));       
    },
    handleSaveAdditionalContactsData : function(component, event, helper){
        helper.saveCaseAdditionalContactsData(component, event, helper);
    },

    rowselectedaction: function(component, event, helper){
        
        var rowid = event.getParam("rowid");
        var isselected = event.getParam("isselected");       
        var records = component.get("v.cases"); 
        records.forEach(function(elem){
            if(elem.OrderLineNumber == rowid)
            {
                elem.isselected= isselected;
            }
        });        
        helper.nocaseselected(component, event, helper);
        
    },
    additionaldealercontactselected: function(component, event, helper){         
        component.set("v.additionaldealercontactsselected", event.getParam("value"));
        
    },
    //handleKeyup :function(component, event, helper) {
        
    //},
    handleUploadFinished: function (component, event, helper) {
     
        alert(component.get("v.files"));
        helper.fetchFilesInfo(component, event, helper);
    }, 
    checkForValidVendorName : function(component, event, helper){
        helper.checkForValidVendorName(component, event, helper);
    },
    
    //for 2nd bucket order number input fields
    onkeypress: function(component,event,helper){
        if (event.keyCode === 13) {
            component.set("v.recordsfound", false);
            helper.getOrderRecords(component, event, helper); }
    },
    //for 2nd bucket order number input fields
    getOrderRecords: function(component,event,helper){
         component.set("v.recordsfound", false);
        helper.getOrderRecords(component, event, helper); 
    },
    
    onleadtimereasonchanged:function (component, event, helper){
        component.set("v.isleadtimereasonselected", true);
        component.set("v.isIARC", true);
        helper.checkForRequiredFields(component);
        
    },  
    oncreditreasonchange:function (component, event, helper){
        //helper.resetadditionaldata(component, event, helper);
        helper.oncreditreasonchange(component, event, helper);
    },  
    QuantityChange : function(component, event, helper){
        helper.checkForRequiredFields(component);
    },
    onshipdatechange: function(component, event, helper){        
        helper.bucket3subitactiverules(component, event, helper);
    },
    ReasonChange : function(component, event, helper){
        helper.checkForRequiredFields(component);
    },
    onpricedisputedchange: function(component, event, helper){
        helper.bucket3subitactiverules(component, event, helper);
    },
    ondatereceivedchange: function(component, event, helper){
        helper.bucket3subitactiverules(component, event, helper);
    },
    oninvoiceneededforchange: function(component, event, helper){
        helper.bucket3subitactiverules(component, event, helper);
    },
    onshipmethodchange: function(component, event, helper){
        helper.bucket3subitactiverules(component, event, helper);
    },
    onproblemdescriptionchange: function(component, event, helper){
        helper.bucket3subitactiverules(component, event, helper);
    },
    onrequestedchangechange: function(component, event, helper){
        helper.bucket3subitactiverules(component, event, helper);
    },
    onshippedfromchange: function(component, event, helper){
        helper.bucket3subitactiverules(component, event, helper);
    },
    oncurrentlocationofpartchange: function(component, event, helper){
        helper.bucket3subitactiverules(component, event, helper);
    },
    onpackagedbychange: function(component, event, helper){
        helper.bucket3subitactiverules(component, event, helper);
    },
    onispartdamagedchange: function(component, event, helper){
        helper.bucket3subitactiverules(component, event, helper);
    },
    onispartpackagedchange: function(component, event, helper){
        helper.bucket3subitactiverules(component, event, helper);
    },
    onvinnumberchange : function(component, event, helper){
        helper.onvinnumberchange(component, event, helper);
    },
    ontypeofrequestchange: function(component, event, helper){
      
        component.set("v.caseobj.Action__c",event.getSource().get("v.value"));
        helper.ontypeofrequestchange(component, event, helper);
        helper.bucket3subitactiverules(component, event, helper);
    },
    onnoofpalletschange: function(component, event, helper){
        helper.bucket3subitactiverules(component, event, helper);
    },
    oncredittypechange: function(component, event, helper){   
        component.set("v.caseobj.Credit_Type__c", component.get("v.credittypeselected"));
        helper.bucket3subitactiverules(component, event, helper);
    },
    onreturnreasonchange: function(component, event, helper){        
        helper.bucket3subitactiverules(component, event, helper);
    },
    ontypeofreturnchange: function(component, event, helper){
        //component.set("v.istypeofreturnselected", true);
        //component.set("v.isIRC1", true);
        //component.set("v.caseobj.Type_of_Return__c", component.get("v.typeofreturnselected"));
        helper.ontypeofreturnchange(component, event, helper);
    }
})