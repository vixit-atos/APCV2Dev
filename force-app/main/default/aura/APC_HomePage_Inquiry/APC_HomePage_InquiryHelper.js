({  
    getloggedusercontactid :function (component, event, helper){
        var action = component.get("c.getloggedusercontactid");
        action.setCallback(this, function(response){   
            var state = response.getState();            
            if(state=='SUCCESS'){                
                component.set("v.caseobj.ContactId", response.getReturnValue());
            }
            else{
                console.log('Error'+ response.getError());
            }
        });
        $A.enqueueAction(action);
        
    },
    getloggeduseraccountid :function (component, event, helper){
        var action = component.get("c.getloggeduseraccountid");
        action.setCallback(this, function(response){   
            var state = response.getState();            
            if(state=='SUCCESS'){                
                component.set("v.caseobj.AccountId", response.getReturnValue());
                
            }
            else{
                console.log('Error'+ response.getError());
            }
        });
        $A.enqueueAction(action);
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
    createcaseandorderrecord : function(component, event, helper){
  
        var partnumber = component.get("v.caseobj.Part_No__c");
        partnumber = partnumber.trim();
        component.set("v.caseobj.Part_No__c", partnumber); 
        
        var additionalcontacts = [];
        additionalcontacts = typeof(component.get("v.additionaldealercontactsselected") != 'undefined') ? component.get("v.additionaldealercontactsselected"): '';
        if(additionalcontacts != null && additionalcontacts != ''){
            component.set("v.caseobj.Additional_Contacts__c", additionalcontacts.join(";"));
        }       
        
        if(component.get("v.caseobj.SAP_Order_Number__c") != '' &&  component.get("v.whichbucket") == "tile1")
        {
            helper.findduplicatecasebucket1(component, event, helper);
        } else if (component.get("v.whichbucket") == "tile2")
        {
            component.set("v.caseobj.Request_Type__c", 'Order Status'); // Change to remove order object from bucket 2 
            helper.createlistofcases(component, event, helper);
        } else if (component.get("v.whichbucket") == "tile3")        {           
            
            helper.sortordersfrombucket3andproceed(component, event, helper);            
        } else if (component.get("v.whichbucket") == "tbb")        {           
            
            helper.createcaserecord(component, event, helper);            
        }else
        {
            helper.findduplicatecasebucket1(component, event, helper);
        }
        
    },
    createcaserecord : function(component, event, helper){      
        
        //console.log('Description: ' + component.get("v.caseobj.Description"));
        console.log('Additional recipient: ' + component.get("v.additionalRecipientList2"));
        console.log('Additional recipient: ' + JSON.stringify(component.get("v.additionalRecipientList2")));
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
        
        action.setParams({
            'c' : component.get("v.caseobj"),
            'additionalrecipientlist': additionalrecipient,
            'recordtypename': component.get("v.recordtypename"),
            'dealercode':component.get("v.selectedDealerCode"),
            'isexternal':true
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
                        title: "Error!",
                        message:(' Case  '+ error.caserecord.CaseNumber +' already exists for the request'),
                        "duration": 60000,
                        type: "error"});
                }else{
                     toastEvent.setParams({
                        title: "Error!",
                        message: error.message,
                        "duration": 60000,
                        type: "error"});
                }    
                    toastEvent.fire();                               
                component.set("v.IsSpinner", false);  
            }else{
                console.log(response.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
        
    },       
    errormessagerecursive : function (obj) {
        for(var k in obj) {
            if(obj[k] instanceof Object) {
                errormessagerecursive(obj[k]);
            } else {
                console.log(obj[k]);
            };
        }
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
    uploadfiletoRecord : function(component, event, helper, caseid) {
        const params = {
            files: component.get("v.files"),
            recordId: caseid
        };
        
        var action = component.get('c.createDocumentLinks');
        action.setParams({
            params: params
        });
        //alert("params@@@@"+JSON.stringify(params));
        action.setCallback(this,function(response){
            var state = response.getState();
            //alert("state@@@@12333"+state);
            if(state=='SUCCESS'){
                console.log( response.getReturnValue());    
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Success!",
                    message:'Case has been successfully created',
                    "duration": 60000,
                    type: "success"});
                toastEvent.fire();
                //alert('Case has been successfully created '); 
                
                component.find("navService").navigate({    
                    type: "standard__namedPage",
                    attributes: {
                        "pageName": "apc-home"    
                    }
                });
                //component.getEvent("uploadToRecordDone").fire();
            } else {
                helper.apexCallbackElse(component,event,helper,response);
            }
        });
        $A.enqueueAction(action);
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
                    message:'Case '+component.get("v.caseobj.CaseNumber") +' is successfully created',
                    "duration": 50000,
                    type: "success"});
                toastEvent.fire();                
                
                component.find("navService").navigate({    
                    type: "standard__namedPage",
                    attributes: {
                        "pageName": "apc-home"    
                    }
                });
                
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
                // Order Object Free COde 04/07/2020
                helper.createcaserecord(component, event, helper);
               
            }
            else if (state=='ERROR')
            {     
                component.set("v.IsSpinner", false); 
                var errors = res.getError();
                var error = JSON.parse(errors[0].message);
                if(error.code === 1){
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Warning!",
                        "message": ' Case '+ error.caserecord.CaseNumber +' already exists for the request ',
                        "duration": 60000,
                        "type": 'warning'
                    });
                    toastEvent.fire();                    
                }      
            } else{
                
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
        var vinnumber = component.find("APC_Ordercomponent_New").find("formmaterialload").find("vinnumber");
        if(!vinnumber.get("v.validity").valid){
            vinnumber.reportValidity();
            component.set("v.IsSpinner", false);
        }else{
            helper.createcaseandorderrecord(component, event, helper); 
        }
    },
    checkoptionalfieldvalidforpricerequest: function (component, event, helper){   
        
        var allfieldvalid = true;
        var sapnum = component.find("APC_Ordercomponent_New").find("formpricerequest").find("sapnum");
        if(!sapnum.get("v.validity").valid){
            sapnum.reportValidity();
            allfieldvalid = sapnum.get("v.validity").valid;
            component.set("v.IsSpinner", false);
        }
        var nsnnum = component.find("APC_Ordercomponent_New").find("formpricerequest").find("nsnnum");
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
        
        var allValid = component.find("APC_OrderComponent_Received").find("formbucket3firstthreeoptions").find("pricediscrepencybucket3").reduce(function (validFields, inputCmp) {
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
        
        var invoicetrackingnumber = component.find("APC_OrderComponent_Received").find("formbucket3firstthreeoptions").find("invoicetrackingnumber");
        if(!invoicetrackingnumber.get("v.validity").valid){
            invoicetrackingnumber.reportValidity();                
            component.set("v.IsSpinner", false);
        }else{
            helper.createcaseandorderrecord(component, event, helper);            
        }
    },
    checkoptionalfieldvalidforreturnexcessspecialshipping : function(component, event, helper){
        
        var returnweight = component.find("APC_OrderComponent_Received").find("formbucket3firstthreeoptions").find("returnweight");
        if(!returnweight.get("v.validity").valid){
            returnweight.reportValidity();                
            component.set("v.IsSpinner", false);
        }else{
            helper.createcaseandorderrecord(component, event, helper);            
        }
    },
    checkoptionalfieldvalidforcoreinquiry : function(component, event, helper){
        
        var allValid = component.find("APC_OrderComponent_Received").find("formbucket3coreinquiry").find("coreinquiryfields").reduce(function (validFields, inputCmp) {
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
            debugger;
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
        console.log('contactlist : ' + component.get("v.caseobj.Additional_Contacts__c"));
        console.log('caseobjlist : ' + JSON.stringify(component.get("v.caseobjlist")));
        console.log('orderlinenumberdocumentidsmapobj : ' + JSON.stringify(orderlinenumberdocumentidsmapobj));
        console.log('additionalrecipientlist : ' + additionalrecipient);
        console.log('dealercode : ' + component.get("v.selectedDealerCode"));
        console.log();
        
        
        
        var action = component.get("c.createlistofcasesexternal_withoutorder");        
        action.setParams({ 
            'caseobjlist' : component.get("v.caseobjlist"),
            'contactlist' : component.get("v.caseobj.Additional_Contacts__c"),
            'orderlinenumberdocumentidsmapobj': JSON.stringify(orderlinenumberdocumentidsmapobj),
            'additionalrecipientlist': additionalrecipient,
            'dealercode':component.get("v.selectedDealerCode"),
            'isexternal':true
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
                component.find("navService").navigate({    
                    type: "standard__namedPage",
                    attributes: {
                        "pageName": "apc-home"    
                    }
                });
            }
            else if (state=='ERROR'){                               
                var errors = res.getError();
                var error = JSON.parse(errors[0].message);
                var toastEvent = $A.get("e.force:showToast");
                var caserecord = error.caserecord;
                if(typeof(caserecord) != 'undefined')
                {
                     toastEvent.setParams({
                        title: "Error!",
                        message:(' Case  '+ error.caserecord.CaseNumber +' already exists for the request'),
                        "duration": 60000,
                        type: "error"});
                }else{
                     toastEvent.setParams({
                        title: "Error!",
                        message: error.message,
                        "duration": 60000,
                        type: "error"});
                }
                    toastEvent.fire();                               
                component.set("v.IsSpinner", false);  
            }
            else 
            {
                console.log(response.getError()[0].message);
            }
        });
        $A.enqueueAction(action);        
        
    },
    getpartvalidate : function(component, event, helper){           
        var partnumber = component.get("v.caseobj.Part_No__c");
        partnumber = partnumber.trim().toUpperCase();
        component.set("v.caseobj.Part_No__c", partnumber);        
        
        var action = component.get("c.getpartvalidate");   
        action.setParams({
            "partnumber": partnumber                     
        });
        action.setCallback(this, function(response) {    
            $A.util.addClass(component.find("spinner2"), "slds-hide");
            debugger;
            var state = response.getState();
                                                                
            if (component.isValid() && state === "SUCCESS") 
            {
                console.log(JSON.stringify(response.getReturnValue()));
                var result = response.getReturnValue();  
                if(result.message === "Part is Valid"){                   
                    component.set("v.isPartFound","true");  
                    
                } else if (result.message === "Part is Invalid")
                {                    
                    component.set("v.errorfound", "true");
            		component.set("v.errormessage", "Part Number is Invalid");
                }               
            } 
        });    
        $A.enqueueAction(action);  
    }
})