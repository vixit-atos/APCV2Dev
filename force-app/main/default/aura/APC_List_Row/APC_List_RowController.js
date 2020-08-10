({  
    doInit: function(component, event, helper) {        
        component.set("v.globalid",component.getGlobalId());
        var obj = component.get("v.record");
        
        var field = component.get("v.fieldname");  
        var record = [];
        
        field.forEach(function(item) {            
            var data = {};
            data.id =  obj['OrderLineNumber'];           
            data.label = item.label;
            if(item.Field == 'CaseNumber')
            {
                if(obj["Id"] != null )
                {
                   
                    data.value = obj[item.Field];                    
                    component.set("v.caseid", obj["Id"]);
                    component.set("v.iscolumndisabled", true);
                } else if (obj["case"] != null)
                {
                    data.value = obj["case"].CaseNumber;                    
                    component.set("v.caseid", obj["case"].Id);
                    component.set("v.iscolumndisabled", true);
                }else
                {
                    data.value = obj[item.Field];
                }
            } else if (item.label =='Select All' || item.label =='Select')
            {
                data.value = obj[item.Field];
                //  component.set("v.isrowselected", obj[item.Field]);
            } else if (item.label =='Action')
            {
                if(item.status == 'Confirmed')
                {
                    component.set("v.iscolumndisabled", true);
                }else
                { debugger;
                    if(obj["case"] != null && obj["case"].Action__c != null && obj["case"].Action__c != 'undefined' )
                    {
                        component.set("v.actionselected", obj["case"].Action__c);
                        component.set("v.isnoactionselected", false);
                        component.set("v.iscolumndisabled", true);
                        //data.value= obj["case"].Action__c ;
                    } else if(obj["case"] == null && component.get("v.record.actionselected") !== undefined && component.get("v.record.actionselected") !== '')
                    {
                        component.set("v.actionselected", component.get("v.record.actionselected"));
                        component.set("v.isnoactionselected", false);
                        component.set("v.iscolumndisabled", false);
                    } else if(obj['Actions'] != null && obj['Actions'] != 'undefined' && component.get("v.record.actionselected") == '')
                    {
                        component.set("v.isnoactionselected", true);
                    } else
                    {
                        data.value = '';
                        
                    }
                }
                
            } else if (item.Field == 'actionrequested')
            {
                if(obj[item.Field] == 'Excess/Special Allowance'){
                    data.value = 'Excess/Special Allowance';
                }
                else {
                     data.value = obj[item.Field];
                }
            }  else
            {
                data.value = obj[item.Field];
            }
            // Added 01/02/2020 by Sumit Datta
            var docIds = obj['documentids'];
            if(typeof(docIds)!='undefined' && docIds.length > 0 && item.label =='Attachments')
            {
                debugger;
                helper.fetchfilesinfo (component, event, helper,docIds);
            }
            
            record.push(data);
        });
        
        component.set("v.orderobj.EffectiveDate",$A.localizationService.formatDate(new Date(), "YYYY-MM-DD"));
        component.set("v.recorddata",record); 
        //alert(component.get("v.recorddata.id"))
    },
    actionchange : function(component, event, helper){ 
        debugger;
        if(event.getSource().get("v.value") == '')
        {
             component.set("v.isnoactionselected", true);
        }else
        {
            component.set("v.isnoactionselected", false);
        }
       
        component.set("v.record.actionselected", event.getSource().get("v.value"));        
        //helper.actionchange(component, event, helper);        
        helper.isactionselected(component, event, helper);
    },
    rowselected : function (component, event, helper){  
        debugger;       
        helper.isrowselected(component, event, helper);
    },
    handledownloadclick:  function (component, event, helper){  
        debugger;
        component.set("v.isdownloadclicked", true);       
    },
    closemodal:  function (component, event, helper){  
        component.set("v.isdownloadclicked", false);       
    },
    removeallattachments:  function (component, event, helper){  
        helper.handledeletefilesonclosemodal(component, event, helper);
               
    },
    casenumberclicked:function (component, event, helper){
        debugger;
        component.find("navService").navigate({    
            type: "standard__recordPage",
            attributes: {
                recordId: component.get("v.caseid"),
                objectApiName: 'Case',
                actionName: 'view'  
            }
        });
    }
})