({
    Paging : function(component,cases,startrow,endrow )   {
        var totalrecords = cases.length;
        component.set('v.recordcount',totalrecords);
        var pagesize = component.get("v.pagesize");
        var totalPages = Math.ceil(totalrecords / pagesize);
        component.set("v.totalPages", totalPages); 
        component.set("v.startrow" , totalrecords > 0 ? startrow + 1 : 0 )
        component.set("v.endrow" ,totalrecords > endrow ? endrow : totalrecords );              
        component.set("v.pagecounter" , this.Pagination(component.get("v.currentPage"),component.get("v.totalPages")));
        component.set("v.pagequotes", cases.slice(startrow,endrow));
    }  ,
    Pagination : function(c,m){
        var current = c,
            last = m,
            delta = 1,
            left = current - delta,
            right = current + delta + 1,
            range = [],
            rangeWithDots = [],
            l = 0;
        
        for (var i = 1; i <= last; i++) {
            if (i == 1 || i == last || i >= left && i < right) {
                range.push(i);
            }
        }
        
        range.forEach(function(item){
            if (l) {
                if (item - l == 4) {
                    rangeWithDots.push(l + 1);
                } else if (item - l != 1) {
                    rangeWithDots.push('...');
                }
            }
            rangeWithDots.push(item);
            l = item;
        });
        
        return rangeWithDots;
        
    },
    getordertypepicklistvalues: function(component, event, helper){
        
        var ordertypepicklistcontroller = component.get("c.getPickListValuesIntoList");
        ordertypepicklistcontroller.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                var list = response.getReturnValue();
                component.set("v.orderfromparagon", list);
            }
            else if(state === 'ERROR'){
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Error!",
                    message:'ERROR OCCURED.',
                    type: "error"});
                toastEvent.fire();
                
                //alert('ERROR OCCURED.');
            }
        })
        $A.enqueueAction(ordertypepicklistcontroller);
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
                              component.set("v.isformsdisable", false);
                              //helper.resetData(component, event, helper);
                              //helper.resetadditionaldata(component, event, helper);
                          }else
                          {
                         
                          }
                      });
        if(component.get("v.Static_resource_list") == 'APC_List_ExistingOrder')
        {
            component.set("v.issubmitactive", flag);
        } else
        {
            if(flag)
            {
                helper.bucket3subitactiverules(component, event, helper);
            }else
            {
                component.set("v.issubmitactive", flag);
                component.set("v.isformsdisable", true); 
                helper.resetData(component, event, helper);
                helper.resetadditionaldata(component, event, helper);

            }  
        }
        
    },
    checkfieldsforpricediscrepancy :  function(component, event, helper){
       
        if(component.get("v.caseobj.Request_Type__c") == 'Pricing Discrepancy')
        {
            if(component.get("v.caseobj.Disputing_Price__c") != '' && component.get("v.caseobj.Disputing_Price__c") != 0 
               && component.get("v.caseobj.Disputing_Price__c") != undefined)
            {
                component.set("v.issubmitactive", true);
            } else
            {
                component.set("v.issubmitactive", false);
            }
        }
        else
        {
            component.set("v.issubmitactive", false);
        }
    },
    bucket3subitactiverules : function(component, event, helper){
        debugger;
       
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
                    component.set("v.issubmitactive", true);
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
                    component.set("v.issubmitactive", true);
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
                                            component.set("v.issubmitactive", true 	);
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
                    
                    //  helper.nocaseselected(component, event, helper);
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
    checkfieldforpdcreturn: function(component, event, helper){
        debugger;
        if(
            component.get("v.caseobj.Request_Type__c") == 'PDC Return' ||
            component.get("v.caseobj.Request_Type__c") == 'Vendor Return' ||           
            component.get("v.caseobj.Request_Type__c") == 'Excess/Special Other' ||
            component.get("v.caseobj.Request_Type__c") == 'Excess/Special Allowance'
        )
        {
            component.set("v.issubmitactive", true 	);  
        }else
        {
            component.set("v.issubmitactive", false);
        }  
    },
    checkfieldforcreditdebitrequest: function(component, event, helper){     
        if(component.get("v.caseobj.Type_of_Request__c") != '' && component.get("v.caseobj.Type_of_Request__c") != 0 &&
           component.get("v.caseobj.Type_of_Request__c") != undefined)
        {
            component.set("v.issubmitactive", true 	);  
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
                component.get("v.caseobj.Type_of_Return__c") != '' && component.get("v.caseobj.Type_of_Return__c") != 0 &&
                component.get("v.caseobj.Type_of_Return__c") != undefined 
            )
            {
                if( component.get("v.caseobj.Ship_Date__c") != '' && component.get("v.caseobj.Ship_Date__c") != 0 &&
                   component.get("v.caseobj.Ship_Date__c") != undefined )
                {
                    component.set("v.issubmitactive", true);
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
    checkfieldforexcessspecialcredit: function(component, event, helper){   
        if(   
            component.get("v.caseobj.Request_Type__c") != '' && component.get("v.caseobj.Request_Type__c") != 0 &&
            component.get("v.caseobj.Request_Type__c") != undefined 
        )
        {
            if(   
                component.get("v.caseobj.Type_of_Return__c") != '' && component.get("v.caseobj.Type_of_Return__c") != 0 &&
                component.get("v.caseobj.Type_of_Return__c") != undefined 
            )
            {
                if( component.get("v.caseobj.Credit_Type__c") != '' && component.get("v.caseobj.Credit_Type__c") != 0 &&
                   component.get("v.caseobj.Credit_Type__c") != undefined )
                {
                    if( component.get("v.caseobj.Return_Reason__c") != '' && component.get("v.caseobj.Return_Reason__c") != 0 &&
                       component.get("v.caseobj.Return_Reason__c") != undefined )
                    {                         
                        component.set("v.issubmitactive", true);
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
    checkfieldforexcessspecialshipping: function(component, event, helper){
        if(component.get("v.caseobj.Number_of_Pallets__c") != '' && component.get("v.caseobj.Number_of_Pallets__c") != 0 &&
           component.get("v.caseobj.Number_of_Pallets__c") != undefined )
        {
            component.set("v.issubmitactive", true);
        } else
        {
            component.set("v.issubmitactive", false);
        }
    },
    checkifallrowsselected: function(component, event, helper){
        debugger;
        var itemsarray = [];
        var numberofselectedrows = 0;
        var numberofrowswithcases = 0;
        itemsarray = component.get("v.cases");
        itemsarray.forEach(function(elem){  
            if( elem.isselected==false){                
            }else{
                numberofselectedrows++;                
            }
            if(typeof(elem.case) !== "undefined" && elem.case !== null)
            {
                numberofrowswithcases++; 
            }  
        });
         // Check no of selected row equals the size of array, if true then make select all green
        if(itemsarray.length == numberofselectedrows + numberofrowswithcases){
                component.set("v.isallselected", true);
            }else{
                component.set("v.isallselected", false);
            }
        
    },
    resetadditionaldata: function(component, event, helper){
        component.set("v.caseobj.Description", '');
        component.set("v.additionalRecipient", '');
        component.set("v.additionalRecipientList", '');
        component.set("v.additionalRecipientList2",'');
        component.set("v.files", '') 
        component.set("v.pillsoffiles", '')
        var emptyarray = [];       
        component.set("v.additionalRecipientList2",emptyarray);
        component.set("v.additionalRecipientList",emptyarray); 
        component.set("v.additionalRecipient", emptyarray);
        component.set("v.pillsoffiles", emptyarray);
        component.set("v.files", emptyarray) 
    },
    resetData : function (component, event, helper){
      
        component.set("v.creditdebitreasonselected", null);
        component.set("v.caseobj.Credit_Request__c", null);
        component.set("v.caseobj.Comparable_Part__c", null);
        component.set("v.caseobj.Disputing_Price__c", null);
        component.set("v.caseobj.Description", null);
        //component.set("v.additionalRecipient", null);
        component.set("v.additionaldealercontactsselected", null);
        component.set("v.caseobj.Invoice_Needed_For__c", "");
        component.set("v.caseobj.Part_Received_date__c", null);
        //component.set("v.orderobj.Tracking_Number__c", "");
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
        component.set("v.caseobj.Return_Reason__c", "");
        component.set("v.caseobj.Number_of_Pallets__c", null);
        component.set("v.typeofreturnselected", null);
        component.set("v.caseobj.Weight__c", null);        
        var emptyarray = [];
        //component.set("v.additionalRecipientList", emptyarray);
        component.set("v.typeofreturnselected", null);
        component.set("v.istypeofreturnselected", null);
    },
})