({ 
    doInit: function(component, event, helper) {
        
        var src =  component.get("v.cmpSource");
        if(src != null && src == 'New')
        {
            component.set("v.Static_resource_list","APC_Internal_List" );
        }else if(src == 'ExistingOrder')
        {
            component.set("v.Static_resource_list","APC_List_ExistingOrder" );
        }else if(src == 'ReceivedOrder')
        {
            component.set("v.Static_resource_list","APC_List_Received_SAPnum" );
        }
        
        component.set("v.actionsMap", {
            Backorder:[{'label':"Ship Date", 'value':"Ship Date"},{'label':"Cancellation", 'value':"Cancellation"}],
            Investigation:[{'label':"Ship Date", 'value':"Ship Date"},{'label':"Cancellation", 'value':"Cancellation"}],
            "Drop Ship":[{'label':"Ship Date", 'value':"Ship Date"},{'label':"Cancellation", 'value':"Cancellation"},{'label':"Tracking Number", 'value':"Tracking Number"},{'label':"Carrier Change", 'value':"Carrier Change"}],
            "Drop Ship Invoiced":[{'label':"Tracking Number", 'value':"Tracking Number"}],
            "Direct Ship Shipped":[{'label':"Tracking Number", 'value':"Tracking Number"}],
            "Direct Ship Acknowledged":[{'label':"Ship Date", 'value':"Ship Date"},{'label':"Cancellation", 'value':"Cancellation"},{'label':"Tracking Number", 'value':"Tracking Number"}],
            "Direct Ship Transmitted":[{'label':"Ship Date", 'value':"Ship Date"},{'label':"Cancellation", 'value':"Cancellation"},{'label':"Tracking Number", 'value':"Tracking Number"}],
            "Direct Ship in Progress":[{'label':"Ship Date", 'value':"Ship Date"},{'label':"Cancellation", 'value':"Cancellation"},{'label':"Tracking Number", 'value':"Tracking Number"}],
            "Direct Ship Invoiced":[{'label':"Tracking Number", 'value':"Tracking Number"}],
            Cancelled:[{'label':"Reason why", 'value':"Reason why"}],
            Released:[{'label':"Cancellation", 'value':"Cancellation"},{'label':"Tracking Number", 'value':"Tracking Number"}],
            Shipped:[{'label':"Tracking Number", 'value':"Tracking Number"}]
        });
        
        if(component.get("v.methodname") == 'getCaseRecords')
        {
             
            component.set("v.globalid",component.getGlobalId());
            var ListColumnSrvc = component.find("ListColumnservice");        
            ListColumnSrvc.getListColumn(component.get("v.Static_resource_list"), function(result) {
                component.set("v.ListColumn", result);
                var fieldNames = [];
                component.get("v.ListColumn").forEach(function(item) {
                    fieldNames.push(item.Field);
                });
                component.set("v.FieldNames",fieldNames);
                var ListDataSrvc = component.find("ListDataservice");  
                
                ListDataSrvc.getListData(component.get("v.Stagefilter") , component.get("v.Statusfilter"), component.get("v.domain") ,
                                         component.get("v.source") , component.get("v.methodname"), function(result) {
                                            
                                             component.set("v.cases", result);                
                                             helper.Paging(component,component.get("v.cases"),0,component.get("v.pagesize"));
                                             
                                         });
                
            });
        } else if ( component.get("v.methodname") =='getAllValues') 
        {       debugger;
            component.set("v.recordsfound", false);
            component.set("v.IsSpinner", true);
            let actionsMap=component.get("v.actionsMap");
            var ListColumnSrvc = component.find("ListColumnservice");        
            ListColumnSrvc.getListColumn(component.get("v.Static_resource_list"), function(result) 
                                         {
                                             
                                             component.set("v.ListColumn", result);
                                             var fieldNames = [];
                                             component.get("v.ListColumn").forEach(function(item) {
                                                 fieldNames.push(item.Field);
                                             });
                                             component.set("v.FieldNames",fieldNames);
                                             var ListDataSrvc = component.find("ListDataservice");  
                                             
                                             ListDataSrvc.getAllDataExistingOrder(component.get("v.requestNumber") , component.get("v.requestType"), component.get("v.APC_Source") ,
                                                                                  component.get("v.soldToParty") , component.get("v.methodname"), false, function(result) 
                                                                                  {
                                                                                      
                                                                                      component.set("v.IsSpinner", false);
                                                                                      
                                                                                      let returnMap = result;
                                                                                      let paragonResponse = returnMap.paragonResponse;
                                                                                      let paragonResponseJson = JSON.parse(paragonResponse);
                                                                                      console.log("Result data => ",paragonResponseJson);
                                                                                      console.log("Result data String => ",paragonResponse);
                                                                                      
                                                                                      let SalesOrderResponse = paragonResponseJson.SalesOrderResponse;
                                                                                      component.set("v.SalesOrderResponse", SalesOrderResponse);
                                                                                      const itemheader = SalesOrderResponse.SalesOrderHeader; 
                                                                                      
                                                                                      
                                                                                      let casesMap = {};
                                                                                      let cases = returnMap.cases;
                                                                                      cases.forEach(function(cs){
                                                                                          casesMap[cs.APC_Line_Number__c] = cs;
                                                                                      });
                                                                                      
                                                                                      
                                                                                      if(SalesOrderResponse.ReturnCode==="00")
                                                                                      {
                                                                                          component.set("v.recordsfound", true);
                                                                                          const items = SalesOrderResponse.SalesOrderItem;
                                                                                          const itemsArray = Array.isArray(items) ? items : ([items]);
                                                                                          itemsArray.forEach(function(elem){
                                                                                              if(elem.hasOwnProperty("ShippingStatus") && actionsMap.hasOwnProperty(elem.ShippingStatus))
                                                                                              {
                                                                                                  elem.Actions = actionsMap[elem.ShippingStatus];
                                                                                              }
                                                                                              elem.case = casesMap.hasOwnProperty(elem.OrderLineNumber) ? casesMap[elem.OrderLineNumber] : null;
                                                                                              elem.Description = casesMap.hasOwnProperty(elem.OrderLineNumber) ? casesMap[elem.OrderLineNumber].Description : null;
                                                                                              elem.SalesOrderNumber = itemheader.SalesOrderNumber;
                                                                                              elem.isselected=false;
                                                                                              elem.CustomerPONumber = itemheader.CustomerPONumber;
                                                                                              elem.SalesOrderType = itemheader.SalesOrderType;
                                                                                              var emptyarray = [];
                                                                                              elem.documentids=emptyarray;
                                                                                          }); 
                                                                                          debugger;
                                                                                          component.set("v.cases", itemsArray);
                                                                                          helper.Paging(component,component.get("v.cases"),0,component.get("v.pagesize"));                                                             
                                                                                          
                                                                                      } 
                                                                                      else {
                                                                                          alert(SalesOrderResponse.ReturnCode + '  ' + SalesOrderResponse.ReturnMessage);
                                                                                      }
                                                                                    
                                                                                  });
                                         });
        }
            else if ( component.get("v.methodname") =='getAllValues1') {                 
                 
                component.set("v.IsSpinner", true);
                component.set("v.recordsfound", false);                
                helper.getordertypepicklistvalues(component, event, helper);                
                let actionsMap=component.get("v.actionsMap");
                var ListColumnSrvc = component.find("ListColumnservice");  
                debugger;
                ListColumnSrvc.getListColumn(component.get("v.Static_resource_list"), function(result) {
                    debugger;
                    if (typeof(result) != "undefined"){
                                                 
                                             }
                    component.set("v.ListColumn", result);
                    var fieldNames = [];
                    console.log('getAllValues1 result = ' + result);
                    component.get("v.ListColumn").forEach(function(item) {
                        fieldNames.push(item.Field);
                    });
                    component.set("v.FieldNames",fieldNames);
                    var ListDataSrvc = component.find("ListDataservice"); 
                    
                    ListDataSrvc.getAllDataExistingOrder(component.get("v.requestNumber") , component.get("v.requestType"), component.get("v.APC_Source") ,
                                                         component.get("v.soldToParty") , "getReceivedOrderFromParagon",false,
                                                         function(result) 
                                                         {                                                             
                                                             component.set("v.IsSpinner", false);
                                                             let returnMap = result;
                                                             let paragonResponse = returnMap.paragonResponse;
                                                             let paragonResponseJson = JSON.parse(paragonResponse);
                                                             console.log("Result data => ",paragonResponseJson);
                                                             console.log("Result data String => ",paragonResponse);
                                                             
                                                             let SalesOrderResponse = paragonResponseJson.SalesOrderResponse;
                                                             component.set("v.SalesOrderResponse", SalesOrderResponse);
                                                             const itemheader = SalesOrderResponse.SalesOrderHeader;
                                                             
                                                             
                                                             let Ordertypelabel="";
                                                             let OrderType = [];
                                                             let suffixvalue = "";
                                                             const ordertypelist = component.get("v.orderfromparagon");
                                                             if(component.get("v.requestType") == "SAP_Order_Number__c")
                                                             {
                                                                 suffixvalue="_01";
                                                                 Ordertypelabel="SAP Number";
                                                             } else if(component.get("v.requestType") == "Return_Number__c")
                                                             {
                                                                 suffixvalue="_02";
                                                                 Ordertypelabel="Return Order Number";
                                                             } else if (component.get("v.requestType") == "Credit_Debit__c")
                                                             {
                                                                 suffixvalue="_03";
                                                                 Ordertypelabel="Credit Debit Number";
                                                             } else 
                                                             {
                                                                 ordertypelist.forEach(function(elem)
                                                                                       {
                                                                                           if(elem.includes(suffixvalue))
                                                                                           {
                                                                                               OrderType.push(elem);
                                                                                           }
                                                                                       });
                                                             }
                                                             
                                                             ordertypelist.forEach(function(elem){
                                                                 if(elem.includes(suffixvalue)){
                                                                     OrderType.push(elem);
                                                                 }
                                                             });                                                          
                                                             
                                                             if(OrderType.includes(itemheader.SalesOrderType+suffixvalue))
                                                             {
                                                                 let casesMap = {};
                                                                 let casesmaterialmap = {};
                                                                
                                                                 if(typeof(returnMap.cases) != "undefined")
                                                                 {
                                                                     let cases = returnMap.cases;
                                                                     cases.forEach(function(cs){
                                                                         casesMap[cs.APC_Line_Number__c] = cs;
                                                                         if(cs.Multiple_Parts__c){
                                                                             let multipleparts = cs.Multiple_Parts__c.split(";"); 
                                                                             multipleparts.forEach(function(mp){
                                                                                 casesmaterialmap[mp] = cs;
                                                                             });                                                                          
                                                                         }
                                                                        
                                                                     });
                                                                     
                                                                     console.log(JSON.stringify(casesmaterialmap));
                                                                 }                                                             
                                                                 
                                                                 if(SalesOrderResponse.ReturnCode==="00")
                                                                 {
                                                                     component.set("v.recordsfound", true);
                                                                     const items = SalesOrderResponse.SalesOrderItem;
                                                                     const itemsArray = Array.isArray(items) ? items : ([items]);                                                                     
                                                                     itemsArray.forEach(function(elem){
                                                                         if(elem.hasOwnProperty("ShippingStatus") && actionsMap.hasOwnProperty(elem.ShippingStatus)){
                                                                             elem.Actions = actionsMap[elem.ShippingStatus];
                                                                         }
                                                                         if(typeof(returnMap.cases) != "undefined"){
                                                                             elem.case = casesMap.hasOwnProperty(elem.OrderLineNumber) ? casesMap[elem.OrderLineNumber] : casesmaterialmap.hasOwnProperty(elem.Material) ? casesmaterialmap[elem.Material] : null;
                                                                           
                                                                         }else
                                                                         {
                                                                             elem.case = null;
                                                                         }
                                                                         
                                                                         elem.Description = "";
                                                                         elem.SalesOrderNumber = itemheader.SalesOrderNumber;
                                                                         elem.ReturnOrderStatus = itemheader.ReturnOrderStatus;
                                                                         elem.FacingPDC = itemheader.FacingPDC;
                                                                         elem.isselected=false;
                                                                         elem.CustomerPONumber = itemheader.CustomerPONumber;
                                                                         elem.SalesOrderType = itemheader.SalesOrderType;
                                                                         
                                                                     }); 
                                                                     debugger;
                                                                   var numberofrowswithcases = 0;
                                                                      itemsArray.forEach(function(elem){  
                                                                         debugger;
                                                                         if(typeof(elem.case) !== "undefined" && elem.case !== null){
                                                                             numberofrowswithcases++;                                                                             
                                                                         }
                                                                     });
                                                                     if(numberofrowswithcases == itemsArray.length){
                                                                         component.set("v.isselectalldisable", true);
                                                                           component.set("v.isformsdisable", true);
                                                                     }else{
                                                                         component.set("v.isselectalldisable", false);
                                                                     }
                                                                     component.set("v.cases", itemsArray);
                                                                     debugger;
                                                                     helper.Paging(component,component.get("v.cases"),0,component.get("v.pagesize"));                                                             
                                                                     
                                                                 } else 
                                                                 {
                                                                 }
                                                                
                                                             }else
                                                             {
                                                                 component.set("v.errorfound", true);
                                                                 component.set("v.errormessage", component.get("v.requestNumber") + ' is not a valid ' + Ordertypelabel);                                                              
                                                             }
                                                         });
                });
   }
    },   
    rowselectedaction: function(component, event, helper){
        debugger;
        var rowid = event.getParam("rowid");
        var isselected = event.getParam("isselected");  
        var actionselected = event.getParam("actionselected");
        var documentids = event.getParam("documentids");
        var records = component.get("v.cases"); 
        var whichrequestype = component.get("v.Static_resource_list");
    
        if(whichrequestype == 'APC_List_Received_SAPnum')
        {
            if(isselected)
            {
                records.forEach(function(elem){
                    if(elem.OrderLineNumber == rowid)
                    {                    
                    }else
                    {
                        elem.isdisabled = true;
                    }  
                }); 
            }else
            {
                records.forEach(function(elem){
                    if(elem.OrderLineNumber == rowid)
                    {                    
                    }else
                    {
                        elem.isdisabled = false;
                    }  
                }); 
            }
            
            var currentpage = parseInt(component.get("v.currentPage"));
            var startrow = (currentpage -1)*parseInt(component.get("v.pagesize"));
            helper.Paging(component,component.get("v.cases"),startrow,startrow + parseInt(component.get("v.pagesize")));
            
        } else if (whichrequestype == 'APC_List_ExistingOrder' && typeof(documentids) != 'undefined')
        {
            records.forEach(function(elem){
                if(elem.OrderLineNumber == rowid)
                {   
                    if(documentids.length > 0)
                    {
                        elem.documentids = documentids;  
                        console.log('element documentids Changed: ' +  elem.documentids);
                    }
                }
                
            });
        }else
        {
            records.forEach(function(elem){
                if(elem.OrderLineNumber == rowid)
                {
                    elem.isselected= isselected;
                    elem.actionselected = actionselected;
                    console.log('element Changed: ' + elem.isselected + ' ' + elem.actionselected);
                }                                
            });  
            
        }
        helper.checkifallrowsselected(component, event, helper);
        helper.nocaseselected(component, event, helper);
    },
    handlesearch : function(component, event, helper) {
        var cases = component.get("v.cases");
        var ListColumn = component.get("v.ListColumn");
        var searchval = event.getSource().get("v.value");
        var fieldtosearch = event.getSource().get("v.name");
        var targetpage = component.get('v.currentPage');
        var searchedquotes = [];        
        var fieldNames = [];
        ListColumn.forEach(function(item) {
            fieldNames.push(item.Field);
        });
        for (var i=0; i<cases.length; i++) {            
            var Searchexpr = true;
            ListColumn.forEach(function(item) {
                if(item.Search != null && cases[i][item.Field] != null){
                    var fieldvalue = cases[i][item.Field].toLowerCase();
                    var searchval = item.Search.toLowerCase();
                    var showrecordflag = fieldvalue.includes(searchval);
                    Searchexpr = Searchexpr && showrecordflag;
                }
            });
            if(Searchexpr){
                searchedquotes.push(cases[i]);
            }
        }
        component.set("v.searchedquotes",searchedquotes);
        helper.Paging(component,searchedquotes,0,component.get("v.pagesize"));
    },
    handlesort : function(component, event, helper) {
        
        var ListColumn = component.get("v.ListColumn"); 
        var fieldtosort = event.getSource().get("v.alternativeText");
        var fieldNames = [];
        var sortededquotes = component.get("v.cases");
        ListColumn.forEach(function(item) {
            fieldNames.push(item.Field);
        });
        
        var uniquesortvalue  = sortededquotes.map(function(item){ return item[fieldtosort]}).
        filter(function(value, index, self){ return self.indexOf(value) === index});
        
        if(uniquesortvalue.length > 1){
            if(component.get("v.sort") == "ASC"){
                sortededquotes.sort(function(a,b) {
                    return (a[fieldtosort] > b[fieldtosort]) ? 1 : ((b[fieldtosort] > a[fieldtosort]) ? -1 : 0);
                })
                component.set("v.sort", "DESC");}
            else {
                sortededquotes.sort(function(a,b) {return (a[fieldtosort] < b[fieldtosort]) ? 1 : ((b[fieldtosort] < a[fieldtosort]) ? -1 : 0);})
                component.set("v.sort", "ASC");
            }  }
        
        helper.Paging(component,sortededquotes,0,component.get("v.pagesize"));
    },
    goNextPage : function(component, event, helper) {        
        var currentpage = component.get('v.currentPage');
        var targetpage = currentpage + 1;
        component.set('v.currentPage',targetpage);
        var startrow = component.get("v.pagesize")*(currentpage) ;
        var endrow = component.get("v.pagesize")*(targetpage); 
        
        helper.Paging(component,component.get("v.cases"),startrow,endrow);
    },
    goPrevPage : function(component, event, helper) {
        var currentpage = component.get('v.currentPage');
        var targetpage = currentpage - 1;
        var startrow = component.get("v.pagesize")*(targetpage - 1) ;
        var endrow = component.get("v.pagesize")*(currentpage - 1);
        
        component.set('v.currentPage',targetpage);
        helper.Paging(component,component.get("v.cases"),startrow,endrow);
        
    },
    gotoPage : function(component, event, helper) {        
        var targetpage = event.getSource().get("v.label");
        if(targetpage == "...")
        {
            targetpage = component.get('v.pagecounter').indexOf(targetpage) + 1;
            component.set('v.currentPage',targetpage );
        }
        else
        {
            component.set('v.currentPage',targetpage );
        }
        var startrow = component.get("v.pagesize")*(targetpage -1) ;
        var endrow = component.get("v.pagesize")*(targetpage );               
        helper.Paging(component,component.get("v.cases"),startrow,endrow);        
    },
    onallselected: function(component, event, helper){               
        var caselist = component.get("v.cases");
        caselist.forEach(function(elem){
            if(typeof(event.getParams().checked) != "undefined"){
                elem.isselected = event.getParams().checked;
            }                 
        });
        helper.nocaseselected(component, event, helper);
        helper.Paging(component,component.get("v.cases"),0,component.get("v.pagesize"));
    }    
})