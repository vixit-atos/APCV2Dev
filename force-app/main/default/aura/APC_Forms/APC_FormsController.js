({
   
    initHandler : function(component, event, helper) {       
        helper.fetchUserId(component, event, helper);
        var code = component.get("v.dealerCode");
        console.log('Dealer Code:'+ code);
      
        helper.getpicklistvalue(component, event, helper, 'Case', 'Ship_Method__c', 'v.shipcarrierbyoptions');
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
        
        /*let ispartdamagelist =  [
            {
                label:"Yes",
                value:"Yes"
            },{
                label:"No",
                value:"No"
            }];
        
        let packagedbylist = [
            {
                label:"Canton",
                value:"Canton"
            },{
                label:"Logisco",
                value:"Logisco"
            },{
                label:"Vendor",
                value:"Vendor"
            },{
                label:"Portland Pkg",
                value:"Portland Pkg"
            },{
                label:"SLC",
                value:"SLC"
            },{
                label:"Other",
                value:"Other"
            }];
                    let typeofreturnlist = [
            {
                label:"    Excess Return",
                value:"Excess"  
            },{
                label:"    Special Return",
                value:"Special"
            }];
            let credittypelist =[
            {
                label:"Field Scrap",
                value:"Field Scrap"
            },{
                label:"Ship to PDC",
                value:"Ship to PDC"
            }];
                    let pdclocationList = [                                                                                  
                               {
                                   label:'FL02 Memphis',
                                   value: 'FL02'
                               },{
                                   label:'FL19 Canton',
                                   value: 'FL19'
                               }, {
                                   label:'FL20 Atlanta',
                                   value: 'FL20'
                               }, {
                                   label:'FL24 Bridgeport',
                                   value: 'FL24'
                               }, {
                                   label:'FL25 Indianapolis',
                                   value: 'FL25'
                               }, {
                                   label:'FL26 Dallas',
                                   value: 'FL26'
                               }, {
                                   label:'FL28 Des Moines',
                                   value: 'FL28'
                               }, {
                                   label:'FL43 Reno',
                                   value: 'FL43'
                               }, {
                                   label:'FL52 Calgary',
                                   value: 'FL52'
                               }
                               ]; 
                               
                let invoiceneededreasonlist = [                                                                                  
                               {
                                   label:'Credit/Debit',
                                   value: 'Credit/Debit'
                               }, {
                                   label:'Freight',
                                   value: 'Freight'
                               }, {
                                   label:'Dropship Invoice',
                                   value: 'Dropship Invoice'
                               },{
                                   label:'Other',
                                   value: 'Other'
                               }                                                                                 
                               ];
                               
                       let leadtimereasonList = [
                               {
                                   label:'Stock', 
                                   value: '1'
                               },{
                                   label:'Critical', 
                                   value: '2'
                               },{
                                   label:'Direct Ship', 
                                   value: '3'
                               }
                               ];         
            let creditdebitreasonlist = [
            {
                label:"Pricing Discrepancy",
                value:"1"
            },{
                label:"Freight Charges",
                value:"2"
            },{
                label:"Shipped Short",
                value:"3"
            },{
                label:"Other",
                value:"4"
            }];
            
             let typeofrequestlist = [
            {
                label:"Core RPA Status",
                value:"1"
            },{
                label:"Credit Inquiry",
                value:"2"
            },{
                label:"Eligibility Inquiry",
                value:"3"
            }]; 
         let saporderreasonlist = [                                                                                  
                               {
                                   label:'Pricing Discrepancy',
                                   value: '1'
                               }, {
                                   label:'Invoice Needed',
                                   value: '2'
                               }, {
                                   label:'Freight Charge Inquiry',
                                   value: '3'
                               }, {
                                   label:'Packaging Deficiency',
                                   value: '4'
                               }                                                                                 
                               ];    
            
            
        
        let returnreasonlist = [
            {
                label:"PDC Return",
                value:"1"
            },{
                label:"Vendor Return",
                value:"2"
            },{
                label:"Excess/Special Allowance",
                value:"3"
            },{
                label:"Excess/Special Approval status",
                value:"4"
            },{
                label:"Excess/Special Credit",
                value:"5"
            },{
                label:"Excess/Special Shipping",
                value:"6"  
            },{
                label:"Excess/Special Other",
                value:"7"
            }];        
       
           
      
        
    //    component.set("v.returnreasonlist", returnreasonlist);
    //    component.set("v.creditdebitreasonlist", creditdebitreasonlist);
    //    component.set("v.typeofrequestlist", typeofrequestlist);      
    //    component.set("v.saporderreasonlist", saporderreasonlist);
    //    component.set("v.shipcarrierbyoptions", shipcarrierbyOptions);
    //    component.set("v.packagedbylist", packagedbylist);
    //    component.set("v.ispartdamagelist", ispartdamagelist);       
    //    component.set("v.typeofreturnlist", typeofreturnlist);
    //    component.set("v.credittypelist", credittypelist);       
    //    component.set("v.pdclocationList", pdclocationList);        
    //    component.set("v.invoiceneededreasonlist", invoiceneededreasonlist);
    //    component.set("v.leadtimereasonList", leadtimereasonList);*/
    debugger;
    },    
    onSingleSelectItemChange:function(component, event, helper) {           
        helper.issubmitactive(component, event, helper);
    },
    //handleKeyup :function(component, event, helper) {
    //},    
    keyPressLogic: function(component, event, helper){        
        var partnumber = component.get("v.caseobj.Part_No__c");
        partnumber = partnumber.toUpperCase();
        component.set("v.caseobj.Part_No__c", partnumber);
        helper.issubmitactive(component, event, helper);
    },     
    checkForValidVendorName : function(component, event, helper){
        helper.checkForValidVendorName(component, event, helper);
    },
    handleaddrecipient: function(component, event, helper) {
        helper.handleaddrecipient(component, event, helper);       
    },
    handlerecipientremove: function(component, event, helper){                
        var name2 = event.getParam("item").name;        
        component.set("v.additionalRecipientList2", helper.removeByKeylabel(component.get("v.additionalRecipientList2"),name2));       
    },
    backHomePage :function(component,event,helper){    
        
        component.find("navService").navigate({    
            type: "standard__namedPage",
            attributes: {
                "pageName": "home"    
            }});
    },
    onactionrequiredchange: function(component, event, helper){ 
        //reset Data on Action Requested Change
        helper.resetattachments(component, event, helper);      //added on 4/13/2020 by chandrika to add reset logic    
        helper.resetdatabucket1(component, event, helper);
        helper.resetadditionaldata(component, event, helper);
        
        var code = component.get('v.dealerCode');
        console.log('Dealer Code:'+ code);
        component.set("v.isIARC", "true");
        var actReqSlctd = component.find("actionrequested").get("v.value");
        if(actReqSlctd == "1")
        {            
            component.set("v.isIARC", "false");
            component.set("v.isLeadTime", "true");
            component.set("v.ispdcstockcheck", "false");
            component.set("v.isreactivation", "false");  
            component.set("v.ispacksize", "false");
            component.set("v.caseobj.Request_Type__c",'Lead Time');
        } else if(actReqSlctd == "2")
        {            
            component.set("v.ispdcstockcheck", "true");
            component.set("v.isLeadTime", "false");
            component.set("v.isreactivation", "false");
            component.set("v.ispacksize", "false");
            component.set("v.caseobj.Request_Type__c",'PDC Stock Check');
        } else if(actReqSlctd == "3")
        {               
            component.set("v.isreactivation", "true");
            component.set("v.ispdcstockcheck", "false");
            component.set("v.isLeadTime", "false");
            component.set("v.ispacksize", "false");
            component.set("v.caseobj.Request_Type__c",'Reactivation');
        } else if(actReqSlctd == "4")
        {                    
            component.set("v.isreactivation", "false");
            component.set("v.ispdcstockcheck", "false");
            component.set("v.isLeadTime", "false");
            component.set("v.ispacksize", "false");
            component.set("v.caseobj.Request_Type__c",'Weights & Dimensions');
        } else if (actReqSlctd == "5")
        {                        
            component.set("v.ispacksize", "true");
            component.set("v.isreactivation", "false");
            component.set("v.ispdcstockcheck", "false");
            component.set("v.isLeadTime", "false");   
            component.set("v.caseobj.Request_Type__c",'Pack Size');                        
        } else
        {
            component.set("v.isIARC", "false");
            component.set("v.ispacksize", "false");
            component.set("v.isreactivation", "false");
            component.set("v.ispdcstockcheck", "false");
            component.set("v.isLeadTime", "false");
            component.set("v.caseobj.Request_Type__c",'');                    
        }
        helper.checkForActionRequested(component,actReqSlctd);        
    },
    onpdclocationchange : function(component, event, helper){
        helper.checkForRequiredFields(component, event, helper);        
    },     
    handleUploadFinished: function (component, event, helper) {
        alert(component.get("v.files"));
        helper.fetchFilesInfo(component, event, helper);
    },    
    refreshFiles : function(component, event, helper) {
        helper.fetchFilesInfo(component, event, helper);
    },
    getFilesList : function(component, event, helper) {
        return component.get("v.files");
    },
    handleDeleteFile : function(component, event, helper) {
        let file = event.getParam("detail").file;
        helper.handleDeleteFiles(component, event, helper, [file]);
    },
    uploadToRecord : function(component, event, helper) {
        const params = {
            files: component.get("v.files"),
            recordId: event.getParam('arguments').recordId
        };
        
        let action = component.get('c.createDocumentLinks');
        action.setParams({
            params: params
        });
        //alert("params@@@@"+JSON.stringify(params));
        action.setCallback(this,function(response){
            let state = response.getState();
            //alert("state@@@@12333"+state);
            if(state=='SUCCESS'){
                component.getEvent("uploadToRecordDone").fire();
            } else {
                helper.apexCallbackElse(component,event,helper,response);
            }
        });
        $A.enqueueAction(action);
    },
    onsaporderreasonchange : function (component, event, helper){
        helper.resetattachments(component, event, helper);        //added on 4/13/2020 by chandrika to add reset logic        
        helper.onorderreasonchange(component, event, helper);                
    },
    onreturnorderreasonchange: function (component, event, helper){
        helper.resetattachments(component, event, helper);      //added on 4/13/2020 by chandrika to add reset logic    
        helper.onreturnreasonchange(component, event, helper);                
    },
    oncreditreasonchange:function (component, event, helper){
        helper.resetattachments(component, event, helper);      //added on 4/13/2020 by chandrika to add reset logic    
        helper.oncreditreasonchange(component, event, helper);
    },
    issubmitactive : function(component, event, helper){        
        helper.issubmitactive(component, event, helper);
    },
    LeadTimeReasonChange : function(component, event, helper){
        component.set("v.isIARC", "true");  
        helper.checkForRequiredFields(component);
       
    },
    QuantityChange : function(component, event, helper){
        helper.checkForRequiredFields(component);
    },
    onvinnumberchange : function(component, event, helper){
        helper.onvinnumberchange(component, event, helper);
    },    
    additionaldealercontactselected: function(component, event, helper){         
        component.set("v.additionaldealercontactsselected", event.getParam("value"));
        
    },
    onpricedisputedchange: function(component, event, helper){
        helper.bucket3subitactiverules(component, event, helper);
    },
    oninvoiceneededforchange: function(component, event, helper){
        helper.bucket3subitactiverules(component, event, helper);
    },
    ondatereceivedchange: function(component, event, helper){
        helper.bucket3subitactiverules(component, event, helper);
    },
    onquantitychange: function(component, event, helper){
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
    ontypeofrequestchange: function(component, event, helper){
        component.set("v.caseobj.Action__c",event.getSource().get("v.value"));
        helper.ontypeofrequestchange(component, event, helper);
        helper.bucket3subitactiverules(component, event, helper);
    },
    ontypeofreasonchange: function(component, event, helper){
        component.set("v.caseobj.Type_of_Return__c", component.get("v.typeofreturnselected"));
        if(component.get("v.typeofreturnselected") != '' || component.get("v.typeofreturnselected") != 'undefined')
        {
            component.set("v.isIRC1", true);
            component.set("v.istypeofreturnselected", true);
        }else
        {
            component.set("v.isIRC1", false);
            component.set("v.istypeofreturnselected", false);
        }
        helper.bucket3subitactiverules(component, event, helper);
    },
    onshipdatechange: function(component, event, helper){        
        helper.bucket3subitactiverules(component, event, helper);
    },
    oncredittypechange: function(component, event, helper){   
        component.set("v.caseobj.Credit_Type__c", component.get("v.credittypeselected"));
        helper.bucket3subitactiverules(component, event, helper);
    },
    onreturnreasonchange: function(component, event, helper){        
        helper.bucket3subitactiverules(component, event, helper);
    },
    onnoofpalletschange: function(component, event, helper){        
        helper.bucket3subitactiverules(component, event, helper);
    },
    onadditionalinfochange: function(component, event, helper){
        alert(component.get("v.caseobj.Description"));
    },
    onrecipientchange: function(component, event, helper){
        var componentchanged = event.getSource().getLocalId();
        helper.checkforvalidrecipient(component, event, helper, componentchanged);
    },
})