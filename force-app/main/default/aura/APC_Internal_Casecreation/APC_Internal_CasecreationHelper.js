({
    getloggeduseraccountid :function (component, event, helper){
        var action = component.get("c.getloggeduseraccountid");
        action.setCallback(this, function(response){   
            var state = response.getState();            
            if(state=='SUCCESS'){                
                component.set("v.caseobj.AccountId", response.getReturnValue());
                //component.set("v.orderobj.AccountId", response.getReturnValue());
            }
            else{
                console.log('Error'+ response.getError());
            }
        });
        $A.enqueueAction(action);
    },
    getDCodes : function(component, event, helper) {
        var action = component.get('c.getDealerCodes'); 
        action.setCallback(this,function(res){
            var state = res.getState();           
            if(state=='SUCCESS'){
                component.set("v.dealerCodePickListValues", res.getReturnValue());               
            }
        });        
        $A.enqueueAction(action);        
    },
    requestSalesOrderFromParagon : function(component,event,helper) {
        $A.util.removeClass(component.find("spinner"), "slds-hide");    
        let orderNumber='',customerPoNo='',
            actionsMap=component.get("v.actionsMap"),
            selectedDealerCode=component.get('v.selectedDealerCode');
        selectedDealerCode=selectedDealerCode.length===5 ? selectedDealerCode : ("F"+selectedDealerCode);
        
        if(component.get("v.requestType")==='orderNumber') orderNumber = component.get('v.requestNumber');
        else customerPoNo = component.get('v.requestNumber');
        
        var action = component.get('c.getAllValues');
        action.setParams({
            params: {
                orderNumber: orderNumber,
                customerPoNo: customerPoNo,
                soldToParty: selectedDealerCode,
                APC_Source : 'Existing Order'
            }
        });
        action.setCallback(this,function(res){
            
            $A.util.addClass(component.find("spinner"), "slds-hide");
            var state = res.getState();
            if(state=='SUCCESS'){
                let returnMap = res.getReturnValue();
                let paragonResponse = returnMap.paragonResponse;
                let paragonResponseJson = JSON.parse(paragonResponse);
                let casesMap = {};
                let cases = returnMap.cases;
                cases.forEach(function(cs){
                    casesMap[cs.Line_Number__c] = cs;
                });
                
                let SalesOrderResponse = paragonResponseJson.SalesOrderResponse;
                component.set("v.SalesOrderResponse", SalesOrderResponse);
                if(SalesOrderResponse.ReturnCode==="00"){
                    const items = SalesOrderResponse.SalesOrderItem;
                    const itemsArray = Array.isArray(items) ? items : ([items]);
                    itemsArray.forEach(function(elem){
                        if(elem.hasOwnProperty("ShippingStatus") && actionsMap.hasOwnProperty(elem.ShippingStatus)){
                            elem.Actions = actionsMap[elem.ShippingStatus];
                        }
                        elem.case = casesMap.hasOwnProperty(elem.OrderLineNumber) ? casesMap[elem.OrderLineNumber] : null;
                    });
                    component.set("v.orderRecordsInAllPages", itemsArray);
                    component.set("v.allOrderRecordsLength", itemsArray.length);
                    helper.getRecordsInPage(component,event,helper);
                } else {
                    helper.showToast(component,"ERROR",SalesOrderResponse.ReturnMessage,"error","requestNumberId");
                }
            } else {
                helper.apexCallbackElse(component,event,helper,res);
            }
        });
        $A.enqueueAction(action);
        
    },
    getRecordsInPage: function (component, event, helper, lastSetOfRecords, lastNumberOfRecords) {
        if (lastSetOfRecords) {
            component.set("v.orderRecords", component.get("v.orderRecordsInAllPages").slice(lastNumberOfRecords));
        } else {
            component.set("v.orderRecords", component.get("v.orderRecordsInAllPages").slice(parseInt(component.get("v.startFromIndex")), parseInt(component.get("v.pageSize")) + parseInt(component.get("v.startFromIndex"))));
        }
    },
    apexCallbackElse : function(component,event,helper,response){
        let state = response.getState();
        if (state === "INCOMPLETE") {
            helper.showToast(component,"INCOMPLETE!","INCOMPLETE","warning","requestNumberId");
        }
        else if (state === "ERROR") {
            let errors = response.getError();
            if (errors) {
                if (errors[0] && errors[0].message) {
                    helper.showToast(component,"ERROR!","Error message: " + errors[0].message,"error","requestNumberId");
                }
            } else {
                console.log("Unknown error");
                helper.showToast(component,"ERROR!","Unknown error","error","requestNumberId");
            }
        }
    }, 
    showToast : function(component,title,msg,variant,elem){
        if(elem) {
            component.find(elem).setCustomValidity(msg);
            component.find(elem).reportValidity();
        } else {
            component.find('notifLib').showToast({
                title: title,
                message: msg,
                variant: variant
            });
        }
    },
    isNotBlank : function(checkString) {
        return (checkString != '' && checkString != null &&
                !$A.util.isEmpty(checkString) && !$A.util.isUndefined(checkString));
    },
    openModel: function(component, event, helper) {
        component.set("v.isOpen", true);
    },
    navigateToCases : function(component, helper) {
        var homeEvt = $A.get("e.force:navigateToObjectHome");
        homeEvt.setParams({
            "scope": "Case"
        });
        homeEvt.fire();
    },
    getResponse : function(component, event, helper){  
        debugger;
        $A.util.removeClass(component.find("spinner2"), "slds-hide");
        var partnumber = component.get("v.caseobj.Part_No__c");
        partnumber = partnumber.trim().toUpperCase();
        component.set("v.caseobj.Part_No__c", partnumber);
        
        var isValid = true;
        if(!partnumber){
            $A.util.addClass(component.find("spinner2"), "slds-hide");            
            component.find("partnum").showHelpMessageIfInvalid();            
            isValid = false;
        }
        
        var action = component.get("c.getpartvalidate");   
        action.setParams({
            "partnumber": partnumber                     
        });
        action.setCallback(this, function(response) {    
            $A.util.addClass(component.find("spinner2"), "slds-hide");
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") 
            {
                var result = response.getReturnValue();        
                component.set("v.response", result.message);
                if(result.message === "Part is Valid"){                   
                    component.set("v.isPartFound","true");       
                    component.set("v.caseobj.Planner_Code__c", result.plannercode);
                    component.set("v.caseobj.Vendor__c", result.vendor);    
                }
                if(component.get("v.APCreasonselected") == 'Weights & Dimensions') {
                    if(result.message === "Part is Valid"){
                        component.set("v.issubmitactive", true); 
                    } else  {
                        component.set("v.errorfound", true);
                        component.set("v.errormessage", "Part Number is Invalid");
                        component.set("v.isPartFound", false); 
                        component.set("v.issubmitactive", false); 
                        this.resetdatabucket1(component, event, helper);
                        this.resetadditionaldata(component, event, helper);
                        this.resetData(component, event, helper);
                    }
                }
                else if (result.message === "Part is Invalid")
                {
                    component.set("v.errorfound", true);
                    component.set("v.errormessage", "Part Number is Invalid");
                    component.set("v.issubmitactive", false); 
                    component.set("v.isPartFound", false); 
                    this.resetdatabucket1(component, event, helper);
                    this.resetadditionaldata(component, event, helper);
                    this.resetData(component, event, helper);
                }
            } 
            this.resetdatabucketadditional(component, event, helper);
            this.resetadditionaldata(component, event, helper);
            this.resetData(component, event, helper);
            component.set("v.IsSpinner", false);  
        });    
        $A.enqueueAction(action);  
    },
    requestReceivedOrderFromParagon : function(component,event,helper) {       
        $A.util.removeClass(component.find("spinner2"), "slds-hide");
        let typeName = component.get("v.APCreasonselected");
        
        component.set("v.orderRecordsInAllPages", []);
        component.set("v.allOrderRecordsLength", 0);
        
        var action = component.get('c.getReceivedOrderFromParagon');               
        action.setParams({
            params: {
                typeValue: component.get("v.ordernumber"),
                soldToParty: selectedDealerCode,
                typeName: typeName,
                APC_Source: 'Received Order'
            }
        });
    },
    createcaseandorderrecord : function(component, event, helper){
        debugger;
        var partnumber = component.get("v.caseobj.Part_No__c");
        partnumber = partnumber.trim();
        component.set("v.caseobj.Part_No__c", partnumber);
        debugger;
        var additionalcontacts = [];
        additionalcontacts = typeof(component.get("v.additionaldealercontactsselected") != 'undefined') ? component.get("v.additionaldealercontactsselected"): '';
        if(additionalcontacts != null && additionalcontacts != ''){
            component.set("v.caseobj.Additional_Contacts__c", additionalcontacts.join(";"));
        }      
       
        if (component.get("v.APCreasonselected")== 'Order Status')
        {
            component.set("v.caseobj.Request_Type__c", 'Order Status');
            helper.createlistofcases(component, event, helper);
        } 
        else if(component.get("v.APCreasonselected")== 'Pricing Discrepancy' ||
                component.get("v.APCreasonselected")== 'Invoice Needed' ||
                component.get("v.APCreasonselected")== 'Freight Charge Inquiry'||
                component.get("v.APCreasonselected")== 'Excess/Special Credit'||
                component.get("v.APCreasonselected")== 'Excess/Special Other'||
                component.get("v.APCreasonselected")== 'Credit/Debit Request'||
                component.get("v.APCreasonselected")== 'Core Inquiry'||
                component.get("v.APCreasonselected")== 'PDC Return'||
                component.get("v.APCreasonselected")== 'Vendor Return'||
                component.get("v.APCreasonselected")== 'Excess/Special Allowance'||
                component.get("v.APCreasonselected")== 'Excess/Special Approval Status'||
                component.get("v.APCreasonselected")== 'Excess/Special Shipping'||
                component.get("v.APCreasonselected")== 'Packaging Deficiency' )
        {
            helper.sortordersfrombucket3andproceed(component, event, helper);
        }
            else if (component.get("v.APCreasonselected")== 'TBB' )
            {
                helper.createcaserecord(component, event, helper);
            }
                else {  
                    helper.findduplicatecasebucket1(component, event, helper);
                }
    },
 
 createcaserecord : function(component, event, helper){      
        
        //console.log('Additional recipient: ' + component.get("v.additionalRecipientList2"));
        //console.log('Additional recipient: ' + JSON.stringify(component.get("v.additionalRecipientList2")));
        console.log('Part Number: ' + JSON.stringify(component.get("v.caseobj.Part_No__c")));
        
        var additionalrecipient = typeof(component.get("v.additionalRecipientList2") != 'undefined') ?  JSON.stringify(component.get("v.additionalRecipientList2")): '';
        
        if(
            component.get("v.caseobj.Request_Type__c") == 'Material Load' ||
            component.get("v.caseobj.Request_Type__c") == 'Lead Time' ||
            component.get("v.caseobj.Request_Type__c") == 'PDC Stock Check' ||
            component.get("v.caseobj.Request_Type__c") == 'Price Request' ||
            component.get("v.caseobj.Request_Type__c") == 'Pack Size' ||
            component.get("v.caseobj.Request_Type__c") == 'Weights & Dimensions' ||
            component.get("v.caseobj.Request_Type__c") == 'Reactivation' 
        )
        {            
            component.set("v.recordtypename", 'APC Order');
        }else if(component.get("v.caseobj.Request_Type__c") == 'TBB')
        {           
            component.set("v.recordtypename", 'APC TBB');            
        }
        
        var action = component.get("c.createcaserecordexternal");   
        console.log(JSON.stringify(component.get("v.caseobj")));
        debugger;
        action.setParams({
            'c' : component.get("v.caseobj"),
            'additionalrecipientlist': additionalrecipient,
            'recordtypename': component.get("v.recordtypename"),
            'dealercode':component.get("v.caseobj.AccountId"),
            'isexternal':false
        });
        action.setCallback(this, function(response){
            
            var state = response.getState();
            //alert("state"+state);
            if(state=='SUCCESS'){
                debugger;
                var caserecord = response.getReturnValue();
                component.set("v.caseobj", response.getReturnValue()); // Added 01/08/2020 By Sumit Datta 
                console.log( caserecord.Id);  
                console.log( caserecord.CaseNumber);
                console.log( caserecord);
                helper.uploadfiletoRecordfrompills(component, event, helper, caserecord.Id);    
                component.set("v.isbucketclicked", false);                
            }else if (state=='ERROR'){                               
                var errors = response.getError();
                var error = JSON.parse(errors[0].message);
                var toastEvent = $A.get("e.force:showToast");
                var caserecord = error.caserecord;
                if(typeof(caserecord) != 'undefined')
                {
                     toastEvent.setParams({
                        title: "Warning!",
                        message:(' Case  '+ error.caserecord.CaseNumber +' already exists for the request'),
                        "duration": 60000,
                        type: "warning"});
                }else{
                     toastEvent.setParams({
                        title: "Warning!",
                        message: error.message,
                        "duration": 60000,
                        type: "warning"});
                }    
                    toastEvent.fire();                               
                component.set("v.IsSpinner", false);  
            }else{
                console.log(response.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
        
    },   
    
    sortordersfrombucket3andproceed : function(component, event, helper){
        
        component.set("v.caseobj.APC_Source__c", 'Received Order');       
        component.set("v.recordtypename", 'APC Invoice');        
        if(component.get("v.caseobj.Request_Type__c") == 'Core Inquiry')      
        {
            component.set("v.recordtypename", 'APC Core');
            helper.createcaserecord(component, event, helper);
            
        }else if(component.get("v.caseobj.Request_Type__c") == 'Credit/Debit Request')      
        {
            component.set("v.recordtypename", 'APC Credit');
        }else if(
            component.get("v.caseobj.Request_Type__c") == 'PDC Return' ||
            component.get("v.caseobj.Request_Type__c") == 'Vendor Return' ||
            component.get("v.caseobj.Request_Type__c") == 'Excess/Special Approval Status' ||
            component.get("v.caseobj.Request_Type__c") == 'Excess/Special Credit' ||
            component.get("v.caseobj.Request_Type__c") == 'Excess/Special Other' ||
            component.get("v.caseobj.Request_Type__c") == 'Excess/Special Shipping' ||
            component.get("v.caseobj.Request_Type__c") == 'Excess/Special Allowance' 
        )
        {
            component.set("v.recordtypename", 'APC Return');
        }else
        {
            
        }
        
        var orders = [];
        var selectedorders = [];
        var multiplepart = '';
        orders = component.get("v.cases");
        orders.forEach(function (elem)
                       {             
                           if(elem.isselected == true)      
                           {
                               selectedorders.push(elem);                               
                           }
                       });                
        
        if(selectedorders.length>0)
        {
            selectedorders.sort(function(a,b){
                return ((a.OrderLineNumber > b.OrderLineNumber) ? 1 :-1 );
            });
            for(var i=1; i < selectedorders.length; i++){
                multiplepart += selectedorders[i].Material;
                if(i == selectedorders.length-1)
                {
                    
                }else
                {
                    multiplepart += ';';
                }
            }
            
            var order  =  selectedorders[0]; 
            console.log(JSON.stringify(order));
            
            component.set("v.caseobj.SAP_Order_Number__c", String(order.SalesOrderNumber));
            component.set("v.caseobj.APC_Line_Number__c", String(order.OrderLineNumber));
            component.set("v.caseobj.Part_No__c", order.Material);
            component.set("v.caseobj.PDC_Location__c", order.Plant);
            component.set("v.caseobj.APC_Original_Delivery__c", String(order.OriginalDelivery) != 'undefined' ? String(order.OriginalDelivery): '');
            component.set("v.caseobj.APC_Delivery__c", String(order.Delivery) != 'undefined' ? String(order.Delivery): '');
            component.set("v.caseobj.APC_Shipping_Condition__c", order.ShippingCondition != 'undefined' ? order.ShippingCondition:'');
            component.set("v.caseobj.APC_Invoice_Number__c", String(order.Invoice) != 'undefined' ? String(order.Invoice): ''); 
            component.set("v.caseobj.APC_DTNA_PO__c", String(order.PONumber) != 'undefined' ? String(order.PONumber): ''); 
            component.set("v.caseobj.APC_Tracking_Number__c", String(order.TrackingNumber) != 'undefined' ? String(order.TrackingNumber): component.get("v.caseobj.APC_Tracking_Number__c")); 
            if(component.get("v.caseobj.Request_Type__c") == 'Credit/Debit Request')
            {                
                component.set("v.caseobj.Credit_Debit__c",String(order.SalesOrderNumber));
            }else if(
                component.get("v.caseobj.Request_Type__c") == 'PDC Return'                     ||
                component.get("v.caseobj.Request_Type__c") == 'Vendor Return'                  ||
                component.get("v.caseobj.Request_Type__c") == 'Excess/Special Approval Status' ||
                component.get("v.caseobj.Request_Type__c") == 'Excess/Special Credit'          ||
                component.get("v.caseobj.Request_Type__c") == 'Excess/Special Other'           ||
                component.get("v.caseobj.Request_Type__c") == 'Excess/Special Shipping'        ||
                component.get("v.caseobj.Request_Type__c") == 'Excess/Special Allowance' 
            )
            {
                component.set("v.caseobj.Return_Status__c",order.ReturnOrderStatus);
                component.set("v.caseobj.Return_Number__c",String(order.SalesOrderNumber));
            }         
            component.set("v.caseobj.Planner_Code__c", order.PlannerCode);
            component.set("v.caseobj.Vendor__c", order.Vendor);
            component.set("v.caseobj.Multiple_Parts__c",multiplepart);
            component.set("v.caseobj.Part_No__c",order.Material);
            component.set("v.caseobj.PDC_Location__c",order.Plant);
            component.set("v.caseobj.Facing_PDC__c",String(order.FacingPDC) != 'undefined' ? String(order.FacingPDC): '');
            component.set("v.caseobj.SAP_Order_Number__c", String(order.SalesOrderNumber) != 'undefined' ? String(order.SalesOrderNumber): '');
            // invoice record type
            console.log(JSON.stringify(component.get("v.caseobj")));
            debugger;
            helper.createcaserecord(component, event, helper);
        }
    },
    
    filterlineitemlist : function(objectarray, fieldname, fieldvalue){
        return objectarray.filter(function(item){            
            if(item[fieldname] != undefined)
                return item[fieldname] === fieldvalue;
        });        
    }, 
    gotoList : function (component, event, helper) {
        var action = component.get("c.getListViews");
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var listviews = response.getReturnValue();
                console.log('listviews===->'+listviews);
                var navEvent = $A.get("e.force:navigateToList");
                navEvent.setParams({
                    "listViewId": listviews.Id,
                    "listViewName": 'null',
                    "scope": "Case"
                });
                navEvent.fire();
            }
        });
        $A.enqueueAction(action);
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
    resetdatabucket1: function(component, event, helper){
        component.set("v.caseobj.Quantity__c",'');
        component.set("v.caseobj.PDC_Location__c",'');
        component.set("v.caseobj.Lead_Time_Reason__c", '');
        component.set("v.leadtimereasonselected", '');
        component.set("v.caseobj.Reason__c", '');
        //component.set("v.orderobj.Order_Number__c", '');
        component.set("v.caseobj.NSN_Number__c", '');
        component.set("v.caseobj.Part_No__c", '');
        component.set("v.caseobj.Supplier__c", '');  
        component.set("v.caseobj.VIN__c", '');
    },
     resetdatabucketadditional: function(component, event, helper){
        component.set("v.caseobj.Quantity__c",'');
        component.set("v.caseobj.PDC_Location__c",'');
        component.set("v.caseobj.Lead_Time_Reason__c", '');
        component.set("v.leadtimereasonselected", '');
        component.set("v.caseobj.Reason__c", '');
        //component.set("v.orderobj.Order_Number__c", '');
        component.set("v.caseobj.NSN_Number__c", '');
        //component.set("v.caseobj.Part_No__c", '');
        component.set("v.caseobj.Supplier__c", '');  
        component.set("v.caseobj.VIN__c", '');
    },
    resetData : function (component, event, helper){
        component.set("v.caseobj.Credit_Request__c", null);
        component.set("v.caseobj.Comparable_Part__c", null);
        component.set("v.caseobj.Disputing_Price__c", null);
        component.set("v.caseobj.Description", null);
        component.set("v.additionalRecipient", null);
        component.set("v.additionaldealercontactsselected", null);
        component.set("v.caseobj.Invoice_Needed_For__c", "");
        component.set("v.caseobj.Part_Received_date__c", null);
        component.set("v.caseobj.APC_Tracking_Number__c", null);
        //component.set("v.v.orderobj.Tracking_Number__c", "");
        component.set("v.caseobj.Quantity__c", null);
        component.set("v.caseobj.Ship_Method__c", "");
        component.set("v.caseobj.Problem_Description__c", null);
        component.set("v.caseobj.Requested_Change__c", null);
        component.set("v.caseobj.Shipped_From__c", null);
        component.set("v.caseobj.Current_Location_of_Part__c", null);
        component.set("v.caseobj.Date_Received__c", null);
        component.set("v.caseobj.Packaged_By__c", "");
        component.set("v.caseobj.Is_Part_Damaged__c", "");
        component.set("v.caseobj.Is_Part_Packaged__c", "");
        component.set("v.caseobj.Ship_Date__c", null);
        component.set("v.credittypeselected", "");
        component.set("v.caseobj.Return_Reason__c", null);
        component.set("v.caseobj.Body_Number__c", "");
        component.set("v.caseobj.Number_of_Pallets__c", null);
        component.set("v.typeofreturnselected", null);
        component.set("v.caseobj.Weight__c", null);   
        component.set("v.caseobj.SAP_Order_Number__c", '');
        var emptyarray = [];
        component.set("v.additionalRecipientList", emptyarray);
        component.set("v.typeofreturnselected", null);
        component.set("v.istypeofreturnselected", null);
    },
    resetcoreinquirydata: function(component, event, helper){
        component.set("v.caseobj.Part_No__c",'');
        component.set("v.caseobj.Core_Part_Num__c",'');
        component.set("v.caseobj.RPA__c",'');
        component.set("v.caseobj.Core_Program__c",'');
        component.set("v.caseobj.Core_Group__c",'');
        component.set("v.caseobj.Core_Invoice__c",'');
        component.set("v.caseobj.Description",'');
        var emptyarray = [];       
        component.set("v.additionalRecipientList2",emptyarray);       
    },    
    getDealerContacts: function(component, event, helper){
        var action = component.get("c.getDealerContactsNew");
        action.setCallback(this, function(response){   
            var state = response.getState();            
            if(state=='SUCCESS')
            {
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
                
                component.set("v.additionaldealercontactslist", dealercontactpicklist);
            }
            else{
                console.log('Error'+ response.getError());
            }
        });
        $A.enqueueAction(action);
    },
    whichBucket : function(component){
        var selectedAPCReason = component.get("v.APCreasonselected");
        if(selectedAPCReason == '16' || selectedAPCReason == '17' ||   selectedAPCReason == '18' ||  selectedAPCReason == '12')
            component.set("v.isbucket3Returnorder",true);
        if(selectedAPCReason == '8' || selectedAPCReason == '9' ||   selectedAPCReason == '10' ||  selectedAPCReason == '22')
            component.set("v.isbucket3SAPorder",true);
    },
    closenewcasetab : function(component, event, helper){
        var workspaceAPI = component.find("workspace");// Added By Sumit To close the TAB
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log(error);
        });
    },
    uploadfiletoRecordfrompills : function(component, event, helper, caseid) {
        const params = {
            pillsoffiles: component.get("v.pillsoffiles"),
            recordId: caseid
        };
       
        var action = component.get('c.createDocumentLinksfrompills');
        action.setParams({
            params: params
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state=='SUCCESS'){
                console.log( response.getReturnValue()); 
                component.set("v.IsSpinner", false); 
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Success!",
                    message:'Case '+component.get("v.caseobj.CaseNumber") +' is created successfully',
                    "duration": 50000,
                    type: "success"});
                toastEvent.fire();
                helper.closenewcasetab(component, event, helper);   
                
            } else {
                helper.apexCallbackElse(component,event,helper,response);
            }
        });
        $A.enqueueAction(action);
    },
    handledeletefilesonclosemodal: function(component, event, helper){
        var pillsoffiles = component.get("v.pillsoffiles");
        
        var files = component.get("v.files");
        var fileids = [];
        pillsoffiles.forEach(function(pill){
            fileids.push(pill.file.Id);
        });
        
        var action = component.get('c.deleteFiles');
        action.setParams({
            params: {
                fileIds: fileids
            }
        });
        action.setCallback(this,function(response){
            $A.util.addClass(component.find("spinner"), "slds-hide");
            var state = response.getState();
            if(state=='SUCCESS' && response.getReturnValue()){                
            } else {
                  var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: "Warning!",
                        message:'Not Able to delete files',
                        type: "warning"});
                    toastEvent.fire();
                
                //alert('Not Able to delete files');
                
            }
        });
        $A.enqueueAction(action);
    },
    findduplicatecasebucket1: function (component, event, helper){
        var partnumber = component.get("v.caseobj.Part_No__c");
        partnumber = partnumber.trim();
        component.set("v.caseobj.Part_No__c", partnumber);  
        
        var action = component.get('c.findduplicateforbucket1');   
        action.setParams({           
            'AccountId': component.get("v.caseobj.AccountId"),
            'partnumber': component.get("v.caseobj.Part_No__c"),
            'requesttype':component.get("v.caseobj.Request_Type__c")
        });
        action.setCallback(this,function(res){
            var state = res.getState();           
            if(state=='SUCCESS'){
                //added by Chandrika on 4/8/2020
                helper.createcaserecord(component, event, helper);
            }
            else if (state=='ERROR'){     
                component.set("v.IsSpinner", false); 
                var errors = res.getError();
                var error = JSON.parse(errors[0].message);
                if(error.code === 1){
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Warning!",
                        "message":(' Case '+ error.caserecord.CaseNumber +' already exists for the request '),
                        "duration": 60000,
                        "type": "warning"
                    });
                    toastEvent.fire();
                    
                }                
                
            }
                else{
                    
                }
        });        
        $A.enqueueAction(action);  
    },
    
    checkbucket1optionalfieldsvalidity : function(component, event, helper){
        if(component.get("v.caseobj.Request_Type__c") == 'Material Load'){
           helper.checkoptionalfieldvalidformaterialload(component, event, helper);
        } else if(component.get("v.caseobj.Request_Type__c") == 'Price Request'){
           helper.checkoptionalfieldvalidforpricerequest(component, event, helper);
        } else{
            helper.createcaseandorderrecord(component, event, helper); 
        }
    },
    checkbucket3optionalfieldsvalidity : function(component, event, helper){
        if(component.get("v.caseobj.Request_Type__c") == 'Pricing Discrepancy'){
           helper.checkoptionalfieldvalidforpricingdiscrepency(component, event, helper);
        } else if(component.get("v.caseobj.Request_Type__c") == 'Invoice Needed'){
           helper.checkoptionalfieldvalidforinvoiceneeded(component, event, helper);
        }  else if(component.get("v.caseobj.Request_Type__c") == 'Excess/Special Shipping'){
           helper.checkoptionalfieldvalidforreturnexcessspecialshipping(component, event, helper);
        } else if(component.get("v.caseobj.Request_Type__c") == 'Core Inquiry'){
           helper.checkoptionalfieldvalidforcoreinquiry(component, event, helper);
        } else{
            helper.createcaseandorderrecord(component, event, helper); 
        }
    },
    checkoptionalfieldvalidformaterialload: function (component, event, helper){    
			var vinnumber = component.find("formmaterialload").find("vinnumber");
            if(!vinnumber.get("v.validity").valid){
                vinnumber.reportValidity();
                component.set("v.IsSpinner", false);
            }else{
                 helper.createcaseandorderrecord(component, event, helper); 
            }
    },
    checkoptionalfieldvalidforpricerequest: function (component, event, helper){   
        var allfieldvalid = true;
			var sapnum = component.find("formpricerequest").find("sapnum");
            if(!sapnum.get("v.validity").valid){
                sapnum.reportValidity();
                allfieldvalid = sapnum.get("v.validity").valid;
                component.set("v.IsSpinner", false);
            }
        var nsnnum = component.find("formpricerequest").find("nsnnum");
            if(!nsnnum.get("v.validity").valid){
                nsnnum.reportValidity();
                allfieldvalid = nsnnum.get("v.validity").valid;
                component.set("v.IsSpinner", false);
            }
        
        if(allfieldvalid){
            helper.createcaseandorderrecord(component, event, helper); 
        }
    },
    checkoptionalfieldvalidforpricingdiscrepency : function(component, event, helper){
        var allValid = component.find("formbucket3firstthreeoptions").find("pricediscrepencybucket3").reduce(function (validFields, inputCmp){
            inputCmp.showHelpMessageIfInvalid();
            inputCmp.reportValidity();
            return validFields && inputCmp.get('v.validity').valid;
        }, true);                                                                                                       
         if(allValid){
            helper.createcaseandorderrecord(component, event, helper); 
        }else{
            component.set("v.IsSpinner", false);            
        }
    },
    checkoptionalfieldvalidforinvoiceneeded : function(component, event, helper){
        var invoicetrackingnumber = component.find("formbucket3firstthreeoptions").find("invoicetrackingnumber");
        if(!invoicetrackingnumber.get("v.validity").valid){
                invoicetrackingnumber.reportValidity();                
                component.set("v.IsSpinner", false);
            }else{
            helper.createcaseandorderrecord(component, event, helper);            
        }
    },
    checkoptionalfieldvalidforreturnexcessspecialshipping : function(component, event, helper){
        var returnweight = component.find("formbucket3firstthreeoptions").find("returnweight");
        if(!returnweight.get("v.validity").valid){
                returnweight.reportValidity();                
                component.set("v.IsSpinner", false);
            }else{
            helper.createcaseandorderrecord(component, event, helper);            
        }
    },
    checkoptionalfieldvalidforcoreinquiry : function(component, event, helper){
        var allValid = component.find("formbucket3coreinquiry").find("coreinquiryfields").reduce(function (validFields, inputCmp){
            inputCmp.showHelpMessageIfInvalid();
            inputCmp.reportValidity();
            return validFields && inputCmp.get('v.validity').valid;
        }, true);                                                                                                       
         if(allValid){
            helper.createcaseandorderrecord(component, event, helper); 
        }else{
            component.set("v.IsSpinner", false);            
        }
    },
    checktbboptionalfieldsvalidity: function(component, event, helper){
        debugger;
        var vinnumber = component.find("tbbvalidity").find("vinnumber");
        if(!vinnumber.get("v.validity").valid){
            vinnumber.reportValidity();                
            component.set("v.IsSpinner", false);
        }else{
            helper.checkfortbbduplicate(component, event, helper);   
            //helper.createcaseandorderrecord(component, event, helper);            
        }
    },
    checkfortbbduplicate: function(component, event, helper){
        debugger;
        var action = component.get('c.findduplicatecaseforTBBserverside');   
        action.setParams({
            'bodynumbertbb' : component.get("v.caseobj.Body_Number__c"),
            'dealercode': component.get("v.selectedDealerCode"),
            'accountid':''
        });
        action.setCallback(this,function(res){
            
            var state = res.getState();           
            if(state=='SUCCESS'){
                var bdNum = component.get("v.caseobj.Body_Number__c");
                if( bdNum != '' && bdNum != null)
                {
                    helper.createcaseandorderrecord(component, event, helper); 
                    //component.set("v.dispVinModRsn", true);
                }               
            }
            else if (state=='ERROR'){                               
                var errors = res.getError();
                var error = JSON.parse(errors[0].message);
                if(error.code === 1){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: "Error!",
                        message:(' Case  '+ error.caserecord.CaseNumber +' already exists for the request'),
                        "duration": 60000,
                        type: "error"});
                    toastEvent.fire();
                    //alert(' Case  '+ error.caserecord.CaseNumber +' already exists for the request');
                }                
                component.set("v.IsSpinner", false);  
            }
                else{
                    
                }
        });        
        $A.enqueueAction(action);  
    },
     createlistofcases : function(component, event, helper){       
        var orderlinenumberdocumentidsmapobj = [];
        
        var orders = [];            
        orders = component.get("v.cases");
        var selectedorders = this.filterlineitemlist(orders, 'isselected', true);
        
        if(selectedorders.length>0)
        {
            var items=component.get("v.caseobjlist");             
            selectedorders.forEach(function (elem)
                                   {                            
                                       
                                       var item = {};
                                       item.sobjectType = 'Case';  
                                       item.SAP_Order_Number__c = String(elem.SalesOrderNumber);
                                       item.APC_Line_Number__c = String(elem.OrderLineNumber);
                                       item.Part_No__c = elem.Material;
                                       item.PDC_Location__c =  elem.Plant;
                                       item.APC_Original_Delivery__c = String(elem.OriginalDelivery) != 'undefined'? String(elem.OriginalDelivery) : '';
                                       item.APC_Delivery__c = String(elem.Delivery) != 'undefined'? String(elem.Delivery) : '';
                                       item.APC_Shipping_Condition__c = elem.ShippingCondition;
                                       item.APC_Invoice_Number__c = String(elem.Invoice);
                                       item.APC_Tracking_Number__c = String(elem.TrackingNumber) != 'undefined'? String(elem.TrackingNumber) : '';
                                       item.Description = elem.Description;
                                       item.Action__c = elem.actionselected;    
                                       item.Order_Status__c = elem.ShippingStatus; 
                                       item.APC_PO_Number__c = String(elem.CustomerPONumber) != 'undefined'? String(elem.CustomerPONumber) : '';
                                       item.APC_DTNA_PO__c = String(elem.PONumber) != 'undefined' ? String(elem.PONumber): '';
                                       item.Planner_Code__c = String(elem.PlannerCode) != 'undefined' ? String(elem.PlannerCode): '';
                                       item.Vendor__c = String(elem.Vendor) != 'undefined' ? String(elem.Vendor): '';
                                       item.AccountId = component.get("v.caseobj.AccountId");
                                       item.ContactId = component.get("v.caseobj.ContactId");
                                       items.push(item);
                                       
                                       
                                       var orderlinenumberdocumentid = {};
                                       orderlinenumberdocumentid.OrderLineNumber = String(elem.OrderLineNumber);
                                       orderlinenumberdocumentid.documentids = elem.documentids;
                                       orderlinenumberdocumentidsmapobj.push(orderlinenumberdocumentid);
                                   }); 
            component.set("v.caseobjlist", items);
        }
        debugger;
        var additionalrecipient = typeof(component.get("v.additionalRecipientList2") != 'undefined') ?  JSON.stringify(component.get("v.additionalRecipientList2")): '';
        //console.log('contactlist : ' + component.get("v.caseobj.Additional_Contacts__c"));
        console.log('caseobjlist : ' + JSON.stringify(component.get("v.caseobjlist")));
       // console.log('orderlinenumberdocumentidsmapobj : ' + JSON.stringify(orderlinenumberdocumentidsmapobj));
        console.log('additionalrecipientlist : ' + additionalrecipient);
        console.log('dealercode : ' + component.get("v.selectedDealerCode"));
        
        
        
        var action = component.get("c.createlistofcasesexternal_withoutorder");        
        action.setParams({ 
            'caseobjlist' : component.get("v.caseobjlist"),
            'contactlist' : component.get("v.caseobj.Additional_Contacts__c"),
            'orderlinenumberdocumentidsmapobj': JSON.stringify(orderlinenumberdocumentidsmapobj),
            'additionalrecipientlist': additionalrecipient,
            'dealercode':component.get("v.caseobj.AccountId"),
            'isexternal':false
        });
        action.setCallback(this, function(response){
            
            var state = response.getState();
            
            if(state=='SUCCESS'){
                
                console.log( response.getReturnValue());
                var caselistcreated = [];
                var casenumber = '';
                caselistcreated = response.getReturnValue();
                for(var i=0; i<caselistcreated.length; i++)
                {
                    if(i<caselistcreated.length-1)
                    {
                        casenumber +=  caselistcreated[i].CaseNumber + ',';
                    }else
                    {
                        casenumber +=  caselistcreated[i].CaseNumber;
                    }                        
                }
                
                component.set("v.IsSpinner", false)
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Success!",
                    message:'Case '+casenumber+' created successfully ',
                    "duration": 60000,
                    type: "success"});
                toastEvent.fire();
                
                //alert('Case '+casenumber+' created successfully ');
                component.set("v.isbucketclicked", false);
                helper.closenewcasetab(component, event, helper); 
                /*component.find("navService").navigate({    
                    type: "standard__namedPage",
                    attributes: {
                        "pageName": "apc-home"    
                    }
                }); */
            }
            else 
            {
                console.log(response.getError()[0].message);
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
        getprioritypicklistvalue: function(component, event, helper, attributename){
        debugger;
        var action = component.get('c.getPriorityPicklistValue');         
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
    getoriginpicklistvalue: function(component, event, helper, attributename){
        debugger;
        var action = component.get('c.getOriginPicklistValue');         
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