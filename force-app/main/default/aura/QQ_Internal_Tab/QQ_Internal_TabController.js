({   
    doInit : function(component,event,helper){
        var ListColumnSrvc = component.find("ListColumnservice");
        ListColumnSrvc.getListColumn(component.get("v.Static_resource_list") , function(result) {
            component.set("v.ListColumn", result);
            var fieldNames = [];
            component.get("v.ListColumn").forEach(function(item) {
                fieldNames.push(item.label);
            });
            component.set("v.FieldNames",fieldNames);
        });
        
        var ListDataSrvc = component.find("ListDataservice");
        ListDataSrvc.getListData('Pending', 'Pending' , component.get("v.domain") , component.get("v.source") , function(result) {
            var quotes = result;
            var StatusLst = component.get("v.Pendingtab");
            var tabcount =[];  
            
            StatusLst.forEach(function(item){
                var tabcountobj = {};   
                tabcountobj.stagefilter = item.stagefilter;
                tabcountobj.statusfilter = item.statusfilter;
                tabcountobj.tabname = item.tabname;
                tabcountobj.count = item.statusfilter=="Pending" ?  quotes.length : quotes.filter(function(quote){return quote.Status.includes(item.statusfilter);}).length;      
              //tabcountobj.count = item.filter=="Pending" ?  quotes.length : quotes.filter(quote => quote.Status__c.includes(item.filter)).length;
                
                tabcount.push(tabcountobj);
                
            });
            component.set("v.Pendingtabwithcount",tabcount)
            component.set("v.quotes",quotes)
        });
        
    }  
    
})