/**
 * @File Name          : APC_Forms2Helper.js
 * @Description        : 
 * @Author             : VIXIT BHARDWAJ - ATOS SYNTEL INC
 * @Group              : 
 * @Last Modified By   : VIXIT BHARDWAJ - ATOS SYNTEL INC
 * @Last Modified On   : 4/23/2020, 4:10:11 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    4/23/2020   VIXIT BHARDWAJ - ATOS SYNTEL INC     Initial Version
**/
({
    //For-bucket3: To set partnumber label, static resource list, and requesttypeAPI name for list
    setBucket3Values : function(component){
        debugger;
        var apcreason = component.get('v.isbucket3'); 
        var apcReasonSelected = component.get('v.APCreasonselected'); 
        var partnumberlabel = '';
        var liststaticHeader = '';
        var requesttype_API = 'SAP_Order_Number__c';
        
        if(apcreason) { 
            if (  apcReasonSelected == 'Pricing Discrepancy' ||  apcReasonSelected == 'Invoice Needed' ||  apcReasonSelected == 'Freight Charge Inquiry' || apcReasonSelected == 'Packaging Deficiency' ){
                partnumberlabel = 'SAP Order Number';
                liststaticHeader = 'APC_List_Received_SAPnum';
                requesttype_API = 'SAP_Order_Number__c';
                
            } else if( apcReasonSelected == 'Excess/Special Credit' ||  apcReasonSelected == 'Excess/Special Approval Status' ||  apcReasonSelected == 'Excess/Special Shipping' || apcReasonSelected == 'PDC Return'
                      ||  apcReasonSelected == 'Vendor Return' || apcReasonSelected == 'Excess/Special Allowance'  || apcReasonSelected == 'Excess/Special Other'){
                partnumberlabel = 'Return Order Number';
                liststaticHeader = 'APC_List_Received_Returnnum';
                requesttype_API = 'Return_Number__c';
                
            } else if(apcReasonSelected == 'Credit/Debit Request'){
                partnumberlabel =  'Credit Debit Number';
                liststaticHeader = 'APC_List_Received_Crdbnum';
                requesttype_API = 'Credit_Debit__c';
            }
        }
        
        component.set('v.partNumberLabel',partnumberlabel);
        component.set('v.staticHeader',liststaticHeader);
        component.set('v.requestType_Field',requesttype_API);
    }, 
    getOrderRecords : function(component,event,helper){
        component.set("v.errorfound", false);
        component.set("v.errormessage", "");   
        component.set("v.issubmitrequestclicked", false);
        $A.util.removeClass(component.find("spinner"), "slds-hide");
        component.set("v.IsSpinner", true);
        component.set("v.issubmitrequestclicked", true);    
        
        helper.resetadditionaldata(component, event, helper); 
    },
    requestReceivedOrderFromParagon : function(component, event, helper){       
        component.set("v.isformsdisable", true); 
        component.set("v.errorfound", "false");
        component.set("v.errormessage", "");   
        component.set("v.APCreasonChanged", false);
        $A.util.removeClass(component.find("spinner2"), "slds-hide");
        component.set("v.isgoclicked", true);
        
        var apcReasonSelected = component.get('v.APCreasonselected'); 
        if(apcReasonSelected == 'Excess/Special Credit' ||  apcReasonSelected == 'Excess/Special Approval Status' ||  apcReasonSelected == 'Excess/Special Shipping' ){
            
            helper.resetadditionaldata1(component, event, helper);
            helper.resetData(component, event, helper); }
        
        else{
            helper.resetData(component, event, helper); 
            helper.resetadditionaldata(component, event, helper); 
        }
        
        $A.util.addClass(component.find("spinner2"), "slds-hide");
    },
    checkForRequiredFields : function (component){
        debugger;
        var isSubmitBtnDisplay = false;
        
        var actionreq = component.get("v.isactionrequest");
        
        if(component.get("v.caseobj.Request_Type__c") == 'Lead Time')
        {
            if(component.get("v.leadtimereasonselected") == 'Stock')
            {
                component.set("v.caseobj.Lead_Time_Reason__c", 'Stock')
            } else if(component.get("v.leadtimereasonselected") == 'Critical')
            {
                component.set("v.caseobj.Lead_Time_Reason__c", 'Critical')
            } else if (component.get("v.leadtimereasonselected") == 'Direct Ship')
            {
                component.set("v.caseobj.Lead_Time_Reason__c", 'Direct Ship')
            } else
            {
                component.set("v.caseobj.Lead_Time_Reason__c", '')
            }
            
            var leadtimeReasonVal = component.get("v.leadtimereasonselected");
            var qtyVal = component.get("v.caseobj.Quantity__c");
            if( qtyVal!="undefined" && qtyVal!="" && qtyVal!=null)
            {
                isSubmitBtnDisplay = true;
            }  
            if(this.isActReqValid == true && leadtimeReasonVal!=null && leadtimeReasonVal!="undefined" && leadtimeReasonVal!=""
               && qtyVal!="undefined" && qtyVal!="" && qtyVal!=null)
            {
                isSubmitBtnDisplay = true;
            }
            
        }else if (component.get("v.caseobj.Request_Type__c") == 'PDC Stock Check')
        {
            if(component.get("v.caseobj.PDC_Location__c") != null && component.get("v.caseobj.PDC_Location__c") != "undefined" &&
               component.get("v.caseobj.PDC_Location__c") != "" ){
                isSubmitBtnDisplay = true;
            }
        }else if (component.get("v.caseobj.Request_Type__c") == 'Weights & Dimensions') {
            
            isSubmitBtnDisplay = true;
            
        } else if (component.get("v.caseobj.Request_Type__c") == 'Reactivation'){
            
            if(component.get("v.caseobj.Reason__c") != null && component.get("v.caseobj.Reason__c") != "undefined" &&
               component.get("v.caseobj.Reason__c") != "" ){
                
                isSubmitBtnDisplay = true;
            }
        } else if (component.get("v.caseobj.Request_Type__c") == 'Pack Size') {
            if(component.get("v.caseobj.Quantity__c") != null && component.get("v.caseobj.Quantity__c") != "undefined" &&
               component.get("v.caseobj.Quantity__c") != "" )
            {
                isSubmitBtnDisplay = true;
            }
        }
            else
            {
                
            }
        component.set("v.issubmitactive", isSubmitBtnDisplay);
    }, 
    oncreditreasonchange: function(component, event, helper){
        var flag = this.nocaseselectedforalert(component, event, helper);       
        if(!flag)
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Warning!",
                message:'Please select an Item',
                type: "warning"});
            toastEvent.fire();
            
            //alert('Please select an Item');
            component.set("v.isIRC1", false);
            component.set("v.creditdebitreasonselected", false);
        } else
        {
            component.set("v.isIRC1", true);
             if(component.get("v.creditdebitreasonselected") =='Pricing Discrepancy')
            {
                component.set("v.caseobj.Type_of_Request__c",'Pricing Discrepancy');
            }else if(component.get("v.creditdebitreasonselected") =='Freight charges')
            {
                component.set("v.caseobj.Type_of_Request__c",'Freight charges');
            }else if(component.get("v.creditdebitreasonselected") =='Shipped Short')
            {
                component.set("v.caseobj.Type_of_Request__c",'Shipped Short');
            }else if(component.get("v.creditdebitreasonselected") =='Other')
            {
                component.set("v.caseobj.Type_of_Request__c",'Other');
            }else 
            {
                component.set("v.caseobj.Type_of_Request__c",'');
                component.set("v.isIRC1", false); 
                component.set("v.issubmitactive", false);
            }        
            helper.bucket3subitactiverules(component, event, helper);        
            this.resetData(component, event, helper);        
            this.resetadditionaldata(component, event, helper);
        }
    },
    ontypeofreturnchange: function(component, event, helper){
        var flag = this.nocaseselectedforalert(component, event, helper);       
        if(!flag)
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Warning!",
                message:'Please select an Item',
                type: "warning"});
            toastEvent.fire();
            
            component.set("v.isIRC1", false);
            component.set("v.creditdebitreasonselected", false);
            component.set("v.istypeofreturnselected", false);
            component.set("v.typeofreturnselected", null);
        } else {
            component.set("v.istypeofreturnselected", true);
            component.set("v.isIRC1", true);
            component.set("v.caseobj.Type_of_Return__c", component.get("v.typeofreturnselected"));
            helper.bucket3subitactiverules(component, event, helper);
        }
    },
    nocaseselectedforalert : function(component, event, helper){        
        var cases = component.get("v.cases");
        var flag = false;
        cases.forEach(function(elem)
                      {
                          if(elem.isselected == true)
                          {
                              flag = true;
                          }   
                      });  
        return flag;
    },
    bucket3subitactiverules : function(component, event, helper){
        
        if(component.get("v.caseobj.Request_Type__c") == 'Pricing Discrepancy')
        {
            helper.checkfieldsforpricediscrepancy(component, event, helper);
        } else if(component.get("v.caseobj.Request_Type__c") == 'Invoice Needed')
        {
            helper.checkfieldsforinvoiceneeded(component, event, helper);
        } else if(component.get("v.caseobj.Request_Type__c") == 'Freight Charge Inquiry')
        {
            helper.checkfieldsforfreightchargeinquiry(component, event, helper);
        }else if(component.get("v.caseobj.Request_Type__c") == 'Packaging Deficiency')
        {
            helper.checkfieldforpackagingdeficiency(component, event, helper);
        }else if(component.get("v.caseobj.Request_Type__c") == 'Core Inquiry')
        {
            component.set("v.caseobj.Type_of_Request__c", component.get("v.typeofrequestlistselected"));// Set Type of Request 
            helper.checkfieldforcoreinquiry(component, event, helper);
        }else if(component.get("v.caseobj.Request_Type__c") == 'Credit/Debit Request')
        {            
            helper.checkfieldforcreditdebitrequest(component, event, helper);
        }else if(component.get("v.caseobj.Request_Type__c") == 'Excess/Special Approval Status')
        {            
            helper.checkfieldforexcessspecialapprovalstatus(component, event, helper);
        }else if(component.get("v.caseobj.Request_Type__c") == 'Excess/Special Credit')
        {            
            helper.checkfieldforexcessspecialcredit(component, event, helper);
        }else if(component.get("v.caseobj.Request_Type__c") == 'Excess/Special Shipping')
        {            
            helper.checkfieldforexcessspecialshipping(component, event, helper);
        }else if(
            component.get("v.caseobj.Request_Type__c") == 'PDC Return' ||
            component.get("v.caseobj.Request_Type__c") == 'Vendor Return' ||           
            component.get("v.caseobj.Request_Type__c") == 'Excess/Special Other' ||
            component.get("v.caseobj.Request_Type__c") == 'Excess/Special Allowance' 
        )
        {
            helper.checkfieldforpdcreturn(component, event, helper);
        }else
        {
            component.set("v.issubmitactive", false);
        }
    },
    ontypeofrequestchange: function(component, event, helper){
        component.set("v.caseobj.Order_Status__c", 'Core Inquiry');
        helper.resetcoreinquirydata(component, event, helper);
    },
    
    checkfieldforcoreinquiry: function(component, event, helper){
        component.set("v.issubmitactive", true);        
    },
    checkfieldsforpricediscrepancy :  function(component, event, helper){
        if(component.get("v.caseobj.Request_Type__c") == 'Pricing Discrepancy')
        {
            if(component.get("v.caseobj.Disputing_Price__c") != '' && component.get("v.caseobj.Disputing_Price__c") != 0 &&
               component.get("v.caseobj.Disputing_Price__c") != undefined)
            {
                helper.nocaseselected(component, event, helper);
            } else
            {
                component.set("v.issubmitactive", false);
            }
        }else
        {
            component.set("v.issubmitactive", false);
        }
    },
    checkfieldsforinvoiceneeded : function(component, event, helper){
        if(component.get("v.caseobj.Request_Type__c") == 'Invoice Needed')
        {
            if(component.get("v.caseobj.Invoice_Needed_For__c") != '' && component.get("v.caseobj.Invoice_Needed_For__c") != 0 &&
               component.get("v.caseobj.Invoice_Needed_For__c") != undefined)
            {
                if(component.get("v.caseobj.Part_Received_date__c") != '' && component.get("v.caseobj.Part_Received_date__c") != 0 &&
                   component.get("v.caseobj.Part_Received_date__c") != undefined)
                {
                    helper.nocaseselected(component, event, helper);
                }else
                {
                    component.set("v.issubmitactive", false);
                }
            }else 
            {
                component.set("v.issubmitactive", false);
            }
        }
    },
    checkfieldsforfreightchargeinquiry: function(component, event, helper){
        if(component.get("v.caseobj.Request_Type__c") == 'Freight Charge Inquiry')
        {
            if(component.get("v.caseobj.Quantity__c") != '' && component.get("v.caseobj.Quantity__c") != 0 &&
               component.get("v.caseobj.Quantity__c") != undefined)
            {
                if(component.get("v.caseobj.Ship_Method__c") != '' && component.get("v.caseobj.Ship_Method__c") != 0 &&
                   component.get("v.caseobj.Ship_Method__c") != undefined)
                {
                    helper.nocaseselected(component, event, helper);
                }else
                {
                    component.set("v.issubmitactive", false);
                }
            }else 
            {
                component.set("v.issubmitactive", false);
            }
        }
    },
    checkfieldforpackagingdeficiency: function(component, event, helper){
        if(component.get("v.caseobj.Request_Type__c") == 'Packaging Deficiency')
        {
            if(component.get("v.caseobj.Problem_Description__c") != '' && component.get("v.caseobj.Problem_Description__c") != 0 &&
               component.get("v.caseobj.Problem_Description__c") != undefined)
            {
                if(component.get("v.caseobj.Requested_Change__c") != '' && component.get("v.caseobj.Requested_Change__c") != 0 &&
                   component.get("v.caseobj.Requested_Change__c") != undefined)
                {
                    if(component.get("v.caseobj.Shipped_From__c") != '' && component.get("v.caseobj.Shipped_From__c") != 0 &&
                       component.get("v.caseobj.Shipped_From__c") != undefined)
                    {
                        if(component.get("v.caseobj.Current_Location_of_Part__c") != '' && component.get("v.caseobj.Current_Location_of_Part__c") != 0 &&
                           component.get("v.caseobj.Current_Location_of_Part__c") != undefined)
                        {
                            if(component.get("v.caseobj.Date_Received__c") != '' && component.get("v.caseobj.Date_Received__c") != 0 &&
                               component.get("v.caseobj.Date_Received__c") != undefined)
                            {
                                if(component.get("v.caseobj.Packaged_By__c") != '' && component.get("v.caseobj.Packaged_By__c") != 0 &&
                                   component.get("v.caseobj.Packaged_By__c") != undefined)
                                {
                                    if(component.get("v.caseobj.Is_Part_Damaged__c") != '' && component.get("v.caseobj.Is_Part_Damaged__c") != 0 &&
                                       component.get("v.caseobj.Is_Part_Damaged__c") != undefined)
                                    {
                                        if(component.get("v.caseobj.Is_Part_Packaged__c") != '' && component.get("v.caseobj.Is_Part_Packaged__c") != 0 &&
                                           component.get("v.caseobj.Is_Part_Packaged__c") != undefined)
                                        {
                                            helper.nocaseselected(component, event, helper);
                                        }else
                                        {
                                            component.set("v.issubmitactive", false);
                                        }
                                    }else
                                    {
                                        component.set("v.issubmitactive", false);
                                    }
                                }else
                                {
                                    component.set("v.issubmitactive", false);
                                }
                                
                            }else
                            {
                                component.set("v.issubmitactive", false);
                            }
                        }else
                        {
                            component.set("v.issubmitactive", false);
                        }
                    }else
                    {
                        component.set("v.issubmitactive", false);
                    }                    
                    
                }else
                {
                    component.set("v.issubmitactive", false);
                }
            }else 
            {
                component.set("v.issubmitactive", false);
            }
        }
    },
    checkfieldforexcessspecialcredit: function(component, event, helper){    
        if(   
            component.get("v.caseobj.Request_Type__c") != '' && component.get("v.caseobj.Request_Type__c") != 0 &&
            component.get("v.caseobj.Request_Type__c") != undefined 
        )
        {
            if(   
                component.get("v.typeofreturnselected") != '' && component.get("v.typeofreturnselected") != 0 &&
                component.get("v.typeofreturnselected") != undefined 
            )
            {
                if( component.get("v.caseobj.Credit_Type__c") != '' && component.get("v.caseobj.Credit_Type__c") != 0 &&
                   component.get("v.caseobj.Credit_Type__c") != undefined )
                {
                    if( component.get("v.caseobj.Return_Reason__c") != '' && component.get("v.caseobj.Return_Reason__c") != 0 &&
                       component.get("v.caseobj.Return_Reason__c") != undefined )
                    {                         
                        helper.nocaseselected(component, event, helper);
                    }else
                    {
                        component.set("v.issubmitactive", false);
                    }
                    
                }else
                {
                    component.set("v.issubmitactive", false);
                }
            }else
            {
                component.set("v.issubmitactive", false);
            }
            
        }else
        {
            component.set("v.issubmitactive", false);
        }
    },
    checkfieldforpdcreturn: function(component, event, helper){
        if( 
            component.get("v.caseobj.Request_Type__c") == 'PDC Return' ||
            component.get("v.caseobj.Request_Type__c") == 'Vendor Return' ||           
            component.get("v.caseobj.Request_Type__c") == 'Excess/Special Other' ||
            component.get("v.caseobj.Request_Type__c") == 'Excess/Special Allowance'
        )
        {
            helper.nocaseselected(component, event, helper);
        }else
        {
            component.set("v.issubmitactive", false);
        }
    },
    checkfieldforcreditdebitrequest: function(component, event, helper){
        if(component.get("v.creditdebitreasonselected") != '' && component.get("v.creditdebitreasonselected") != 0 &&
           component.get("v.creditdebitreasonselected") != undefined)
        {
            helper.nocaseselected(component, event, helper);
        }else
        {
            component.set("v.issubmitactive", false);
        }               
    },
    checkfieldforexcessspecialapprovalstatus: function(component, event, helper){    
        if(   
            component.get("v.caseobj.Request_Type__c") != '' && component.get("v.caseobj.Request_Type__c") != 0 &&
            component.get("v.caseobj.Request_Type__c") != undefined 
        )
        {
            if(   
                component.get("v.typeofreturnselected") != '' && component.get("v.typeofreturnselected") != 0 &&
                component.get("v.typeofreturnselected") != undefined 
            )
            {
                if( component.get("v.caseobj.Ship_Date__c") != '' && component.get("v.caseobj.Ship_Date__c") != 0 &&
                   component.get("v.caseobj.Ship_Date__c") != undefined )
                {
                    helper.nocaseselected(component, event, helper);
                }else
                {
                    component.set("v.issubmitactive", false);
                }
            }else
            {
                component.set("v.issubmitactive", false);
            }
            
        }else
        {
            component.set("v.issubmitactive", false);
        }
    },
    checkfieldforexcessspecialshipping: function(component, event, helper){
        if(component.get("v.caseobj.Number_of_Pallets__c") != '' && component.get("v.caseobj.Number_of_Pallets__c") != 0 &&
           component.get("v.caseobj.Number_of_Pallets__c") != undefined )
        {
            helper.nocaseselected(component, event, helper);
        } else
        {
            component.set("v.issubmitactive", false);
        }
    },
    
    nocaseselected : function(component, event, helper){   
        debugger;
        var cases = component.get("v.cases");
        var flag = false;
        cases.forEach(function(elem)
                      {
                          if(elem.isselected == true)
                          {
                              flag = true;
                          }                       
                      });    
        component.set("v.issubmitactive", flag);  
       
    },
    handleDeleteFiles : function(component, event, helper, delFiles) {
        let fileIds = [];
        let files = component.get("v.files");
        let newFiles = [];
        delFiles.forEach(function(file){
            fileIds.push(file.Id);
        });
        files.forEach(function(file,ind){
            if(fileIds.indexOf(file.Id)===-1){
                newFiles.push(file);
            }
        });
        
        $A.util.removeClass(component.find("spinner"), "slds-hide");
        let action = component.get('c.deleteFiles');
        action.setParams({
            params: {
                fileIds: fileIds
            }
        });
        action.setCallback(this,function(response){
            $A.util.addClass(component.find("spinner"), "slds-hide");
            let state = response.getState();
            if(state=='SUCCESS' && response.getReturnValue()){
                helper.fetchDocuments(component, event, helper, newFiles);
            } else {
                helper.apexCallbackElse(component,event,helper,response);
            }
        });
        $A.enqueueAction(action);
    },
    fetchDocuments : function(component, event, helper, newFiles) {
        let docIds = [];
        newFiles.forEach(function(file){
            docIds.push(file.Id)
        });
        $A.util.removeClass(component.find("spinner"), "slds-hide");
        let action = component.get('c.getDocuments');
        action.setParams({
            params: {
                docIds: docIds
            }
        });
        action.setCallback(this,function(response){
            $A.util.addClass(component.find("spinner"), "slds-hide");
            let state = response.getState();
            if(state=='SUCCESS' && response.getReturnValue()){
                component.set("v.files", response.getReturnValue());
            } else {
                helper.apexCallbackElse(component,event,helper,response);
            }
        });
        $A.enqueueAction(action);
    },
    fetchFilesInfo : function(component, event, helper) {
        
        const params = {
            files: event.getParam("files")
        };
        console.log("params => ", JSON.stringify(params));
        
        let action = component.get('c.getFilesInfo');
        action.setParams({
            params: params
        });
        action.setCallback(this,function(response){
            let state = response.getState();
            if(state=='SUCCESS'){
                component.set("v.files", response.getReturnValue());
            } else {
                helper.apexCallbackElse(component,event,helper,response);
            }
        });
        $A.enqueueAction(action);
    },
    apexCallbackElse : function(component,event,helper,response){
        let state = response.getState();
        if (state === "INCOMPLETE") {
            helper.showToast(component,"INCOMPLETE!","INCOMPLETE","warning");
        }
        else if (state === "ERROR") {
            let errors = response.getError();
            if (errors) {
                if (errors[0] && errors[0].message) {
                    helper.showToast(component,"ERROR!","Error message: " + errors[0].message,"error");
                }
            } else {
                console.log("Unknown error");
                helper.showToast(component,"ERROR!","Unknown error","error");
            }
        }
    },
    showToast : function(component,title,msg,variant){
        component.find('notifLib').showToast({
            title: title,
            message: msg,
            variant: variant
        });
    },
    issubmitactive : function(component, event, helper){        
        if(component.get("v.caseobj.Request_Type__c") == 'Price Request'){
            
            if(component.get("v.caseobj.Reason__c") != null && component.get("v.caseobj.Reason__c") != "undefined" &&
               component.get("v.caseobj.Reason__c") != "" ){
                component.set("v.issubmitactive", true);
            }else{
                component.set("v.issubmitactive", false); }
            
        }else if(component.get("v.caseobj.Request_Type__c") == 'Material Load'){
            helper.checkForValidReason(component, event, helper);
            
            var partnumvalidity = component.find("partnum").get("v.validity");
            
            if(partnumvalidity.valid){   
                helper.checkForValidVendorName(component, event, helper);
            }else{
                component.set("v.issubmitactive", false);
            } 
        }
    }, 
    checkForValidVendorName : function(component, event, helper){      
        
        var validity =component.find("venname").checkValidity();
        var value = component.find("venname").get("v.value");
        
        if(validity && typeof(value) != 'undefined'){   
            helper.checkForValidReason(component, event, helper);            
        }else{
            component.set("v.issubmitactive", false);
        }   
        
    },  
    checkForValidReason : function(component, event, helper){
        var casereason = component.find("selectItemreasonIRC").get("v.validity");
        if(casereason.valid){
            component.set("v.issubmitactive", true);
        }else{
            component.set("v.issubmitactive", false);
        }
    },    
    onvinnumberchange : function(component, event, helper){
        var vinnumbervalidity = component.find("vinnumber").get("v.validity");
        if(vinnumbervalidity.valid){            
            //component.set("v.caseobj.VIN__c", component.get("v.vinnumber"));         
        }  
        
    },
    
    getadditionalrecipient: function (component, event, helper){
        var action = component.get('c.getadditionalrecipient');
        var caseRecordId = component.get('v.recordId');
        
        action.setParams({
            'caseid' : caseRecordId
        });
        
        action.setCallback(this,function(res){
            var state = res.getState();
            
            if(state=='SUCCESS'){
                console.log( res.getReturnValue());
                var listofEvent = [];
                listofEvent = res.getReturnValue();
                if(typeof listofEvent != 'undefined' && listofEvent !== "")
                {
                    var emailList = [];
                    
                    listofEvent.forEach(function(event){
                        
                        var recipientpill = {
                            "label": event.Subject,
                            "name": event.Subject
                        };
                        emailList.push(recipientpill);
                    });
                    component.set("v.additionalRecipientList", emailList);
                }
                
            }else
            {
                
                console.log(state);
            }
        });
        
        $A.enqueueAction(action);
    },
    checkforvalidrecipient: function(component, event, helper, componentchanged){    
        var value = "";
        value = event.getParam("value");
        if(
            (value.indexOf("@") != -1)  &&
            (value.indexOf(".") != -1)  &&
            (value.indexOf("@.") == -1) &&
            (value.indexOf(" ") == -1)  &&
            (value.indexOf(";") == -1)  &&
            (value.indexOf(",") == -1)     
        )
        {
            component.set("v.isvalidrecipient", true);         
        }else{
            component.set("v.isvalidrecipient", false);
        }  
    },    
    handleaddrecipient: function(component, event, helper) {     
        var additionalrecipientemail = component.get("v.additionalRecipient");
        var existingList = [];
        if(component.get("v.isvalidrecipient") == true)
        {
            if(typeof additionalrecipientemail!= 'undefined' && additionalrecipientemail !== "")
            {   
                
                var isExists = false;
                existingList = component.get("v.additionalRecipientList2");
                for(var index=0;index<existingList.length;index++){
                    if(existingList[index].label == additionalrecipientemail)
                    {
                        isExists = true;
                        break;
                    }
                }
                if(isExists == true){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: "Warning!",
                        message:'This recipient already exists',
                        type: "warning"});
                    toastEvent.fire();
                    component.set("v.additionalRecipient", "");
                }
                else{
                    var recipientpill = {
                        "label": additionalrecipientemail,
                        "name": additionalrecipientemail
                    };            
                    var emailList2 = component.get("v.additionalRecipientList2");
                    emailList2.push(recipientpill);
                    component.set("v.isvalidrecipient", false);
                    component.set("v.additionalRecipientList2", emailList2);
                    component.set("v.additionalRecipient", "");
                }
                
            }else 
            {
                
            }
        }
    },
    handleremoverecipient: function(component, event, helper) {     
        var name = event.getParam("item").name;
        var recipientlist = component.get("v.additionalRecipientList");
        var additionalrecipientemail;
        for(var index=0;index<recipientlist.length;index++){
            if(recipientlist[index].label == name)
            {
                additionalrecipientemail = recipientlist[index].label;
                break;
            }
        }
        
        if(typeof additionalrecipientemail!= 'undefined' && additionalrecipientemail !== ""){   
            var recipientpill = {
                "label": additionalrecipientemail,
                "name": additionalrecipientemail
            };   
            var action = component.get('c.removeAdditionalRecipientsData');
            var additionalrecipientlist = JSON.stringify(recipientpill);
            var caseRecordId = component.get('v.recordId');
            
            action.setParams({
                'caseid' : caseRecordId,
                'additionalrecipientlist' : additionalrecipientlist
            });
            
            action.setCallback(this,function(res){
                var state = res.getState();
                if(state=='SUCCESS'){
                    console.log("response::"+res.getReturnValue()); 
                    var isExisting = res.getReturnValue();
                    if(isExisting == true){
                        component.set("v.additionalRecipientList", helper.removeByKeylabel(component.get("v.additionalRecipientList"),name));
                        
                    }else {
                    }
                }
            });
            $A.enqueueAction(action);
        }else {
            
        }   
    },
    saveCaseAdditionalContactsData : function(component, event, helper) {
        var action = component.get('c.saveCaseAdditionalContactsData');
        var caseRecordId = component.get('v.recordId');
        var additionalContacts = component.get('v.selecteddealercontacts');
        
        action.setParams({
            'caseid' : caseRecordId,
            'additionalContacts' : additionalContacts
        });
        
        action.setCallback(this,function(res){
            var state = res.getState();
            if(state=='SUCCESS'){
                console.log( res.getReturnValue());    
                component.set("v.caseobj", res.getReturnValue());
            }
        });
        
        $A.enqueueAction(action);
    },
    removeByKeylabel : function (array, value)    {
        array.some(function(item, index) {
            if(array[index].label === value)
            {
                array.splice(index, 1);
                return true; // stops the loop
            }
            return false;
        });
        return array;
    } ,
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
    resetadditionaldata1: function(component, event, helper){
        component.set("v.isIRC1",false);
    },
    resetcoreinquirydata: function(component, event, helper){
        component.set("v.isIRC1",false);
        component.set("v.caseobj.Part_No__c",'');
        component.set("v.caseobj.Core_Part_Num__c",'');
        component.set("v.caseobj.RPA__c",'');
        component.set("v.caseobj.Core_Program__c",'');
        component.set("v.caseobj.Core_Group__c",'');
        component.set("v.caseobj.Core_Invoice__c",'');
        component.set("v.caseobj.Description",'');
        var emptyarray = [];       
        component.set("v.additionalRecipientList2",emptyarray);       
        component.set("v.isIRC1",true);
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
        component.set("v.caseobj.Number_of_Pallets__c", null);
        component.set("v.typeofreturnselected", null);
        component.set("v.caseobj.Weight__c", null);  
       //component.set("v.caseobj.SAP_Order_Number__c", '');
        var emptyarray = [];
        component.set("v.additionalRecipientList", emptyarray);
        component.set("v.typeofreturnselected", null);
        component.set("v.istypeofreturnselected", null);
    },
    reseterror: function (component, event, helper){
        component.set("v.errorfound", "false");
        component.set("v.errormessage", "");   
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
    getdependentpicklistvalue: function(component, event, helper, objectName, parentField, parentFieldvalue,childField,attributename){
        debugger;
        var action = component.get('c.getdependentPicklistvalues'); 
        action.setParams({
            'objectName' : objectName,
            'parentField':parentField,
            'parentFieldvalue':parentFieldvalue,
            'childField':childField
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
    }
})