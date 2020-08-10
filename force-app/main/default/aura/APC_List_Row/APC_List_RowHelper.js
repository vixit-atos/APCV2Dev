({
    actionchange : function(component, event, helper){
        
        if(component.get("v.actionselected") != '' )
        {   debugger;
            var Trackingnumber ='' ;
         	var Delivery='';
         	var OriginalDelivery = '';
            component.set("v.isrowselected", true);
            component.set("v.orderobj.AccountId", component.get("v.accountid"));
            component.set("v.orderobj.CUSTNAME__c", component.get("v.actionselected")); 
            component.set("v.orderobj.Line_Number__c", component.get("v.recorddata")[0].id.toString());
            component.set("v.orderobj.Order_Number__c", component.get("v.recorddata")[1].value.toString());
            component.set("v.orderobj.Part_Number__c", component.get("v.recorddata")[3].value);
            component.set("v.orderobj.PDC_Location__c", component.get("v.recorddata")[4].value);            
            component.set("v.orderobj.Status", component.get("v.recorddata")[5].value);   
         
         if(component.get("v.recorddata")[6].value)
         {
             OriginalDelivery  = String.valueOf(component.get("v.recorddata")[6].value);
         }else 
         {
             OriginalDelivery = '';
         }
            component.set("v.orderobj.Original_Delivery__c", OriginalDelivery);
            
            
            component.set("v.orderobj.Shipping_Condition__c", component.get("v.recorddata")[9].value);            
            component.set("v.orderobj.Description", component.get("v.additionalinfo"));            
            
            if(component.get("v.recorddata")[8].value)
            {
                Trackingnumber  = String.valueOf(component.get("v.recorddata")[8].value);
            } else 
            {
                Trackingnumber='';                
            }
            component.set("v.orderobj.Tracking_Number__c", Trackingnumber);
            
          if(component.get("v.recorddata")[7].value)
            {
                Delivery  = String.valueOf(component.get("v.recorddata")[8].value);
            } else 
            {
                Delivery='';
               
            }
            component.set("v.orderobj.Delivery__c", Delivery);
            
            let items = [];
            items=component.get("v.orderobjlist");
            items.push(component.get("v.orderobj"));
            component.set("v.orderobjlist", items);           
            if(items.length > 0)
            {
                component.set("v.issubmitactive", true);
            }            
        }else
        {            
            debugger;
            component.set("v.isrowselected", false);            
            let itempop = component.get("v.orderobj");
            let index = 0;
            let items = [];
            items=component.get("v.orderobjlist");
            items.forEach(function(item){               
                if(item.Line_Number__c == itempop.Line_Number__c)
                {
                    //alert(items.indexOf(itempop));
                    //index = items.indexOf(item);
                    items.splice(items.indexOf(itempop),1);
                }
            });           
           /* alert('Add info : ' + component.get("v.additionalinfo"));
            alert('Description : ' + component.get("v.orderobj.Description"));
            alert(JSON.stringify(items));*/
            component.set("v.orderobj.Description",'');
            if(items.length == 0)
            {
                component.set("v.issubmitactive", false); 
            }   
        }
    },
    isrowselected : function(component, event, helper){        
        var compevent = component.getEvent("rowcheckevent");
        compevent.setParams({"rowid":component.get("v.record.OrderLineNumber"), 
                             "isselected":component.get("v.record.isselected")
                            });
        compevent.fire();
    },
    isactionselected : function(component, event, helper){    
       
        var compevent = component.getEvent("rowcheckevent");
        compevent.setParams({"rowid":component.get("v.record.OrderLineNumber"), 
                             "actionselected": component.get("v.record.actionselected"),
                             "isselected": component.get("v.record.actionselected") != '' ? true: false
                            });
        compevent.fire();
    },
    rowselected : function(component, event, helper){
        component.set("v.isrowselected",component.find("rowSelected").get("v.checked"));
        debugger;
        if(component.find("rowSelected").get("v.checked"))
        {   
            var Trackingnumber ='' ;
            var Delivery='';
            component.set("v.isrowselected", true);
            component.set("v.orderobj.AccountId", component.get("v.accountid"));
            component.set("v.orderobj.CUSTNAME__c", component.get("v.actionselected")); 
            component.set("v.orderobj.Line_Number__c", component.get("v.recorddata")[0].id.toString());
            component.set("v.orderobj.Order_Number__c", component.get("v.recorddata")[1].value.toString());
            component.set("v.orderobj.Part_Number__c", component.get("v.recorddata")[3].value);
            component.set("v.orderobj.PDC_Location__c", component.get("v.recorddata")[4].value);            
            component.set("v.orderobj.Status", component.get("v.recorddata")[5].value);     
            component.set("v.orderobj.Original_Delivery__c", component.get("v.recorddata")[6].value.toString());
           // component.set("v.orderobj.Delivery__c", component.get("v.recorddata")[7].value.toString());
            
            component.set("v.orderobj.Shipping_Condition__c", component.get("v.recorddata")[9].value);            
            component.set("v.orderobj.Description", component.get("v.additionalinfo"));            
            
            if(component.get("v.recorddata")[8].value)
            {
                Trackingnumber  = String.valueOf(component.get("v.recorddata")[8].value);
            } else 
            {
                Trackingnumber='';                
            }
            component.set("v.orderobj.Tracking_Number__c", Trackingnumber);
            
            if(component.get("v.recorddata")[7].value)
            {
                Delivery  = String.valueOf(component.get("v.recorddata")[8].value);
            } else 
            {
                Delivery='';
               
            }
            component.set("v.orderobj.Delivery__c", Delivery);
            
           
            let items = [];
            items=component.get("v.orderobjlist");
            items.push(component.get("v.orderobj"));
            component.set("v.orderobjlist", items);           
             /*if(items.length > 0)
            {
                component.set("v.issubmitactive", true);                
            } */           
        }else
        {   
            component.set("v.isrowselected", false);            
            let itempop = component.get("v.orderobj");
            let index = 0;
            let items = [];
            items=component.get("v.orderobjlist");
            items.forEach(function(item){               
                if(item.Line_Number__c == itempop.Line_Number__c)
                {                    
                    items.splice(items.indexOf(itempop),1);
                }
            });           
           
            component.set("v.orderobj.Description",'');
            if(items.length == 0)
            {
                component.set("v.issubmitactive", false); 
            }   
        }
    },
    handledeletefilesonclosemodal: function(component, event, helper){
        debugger;
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
                var emptyarray = [];
                component.set("v.pillsoffiles", emptyarray);
        		//component.set("v.isdownloadclicked", false);
                //helper.fetchDocuments(component, event, helper, newFiles);
            } else {
               alert('Not Able to delete files');
                
            }
        });
        $A.enqueueAction(action);
    },
    fetchfilesinfo : function(component, event, helper,docIds){  
        debugger;
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
                debugger;
                component.set("v.files", response.getReturnValue());
                var pillsoffiles = [];                
                if(component.get("v.pillsoffiles").length >0)
                {
                    pillsoffiles = component.get("v.pillsoffiles");
                }
                var files = response.getReturnValue();
                files.forEach(function(elem){
                    var pill = {
                        "label":elem.Title, 
                        "name":elem.Title,
                        "type": 'icon',
                        "iconName": 'doctype:attachment',
                        "file":elem
                    };
                    pillsoffiles.push(pill);                    
                });
                 component.set("v.pillsoffiles", pillsoffiles);
                
            } else {
                helper.apexCallbackElse(component,event,helper,response);
            }
        });
        $A.enqueueAction(action);
    }
})