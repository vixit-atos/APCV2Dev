({
    doInit: function(component, event, helper) {
        component.set("v.globalid",component.getGlobalId());
        var ListColumnSrvc = component.find("ListColumnservice");
        ListColumnSrvc.getListColumn(component.get("v.Static_resource_list") , function(result) {
            component.set("v.ListColumn", result);
            var fieldNames = [];
            component.get("v.ListColumn").forEach(function(item) {
                fieldNames.push(item.label);
            });
            component.set("v.FieldNames",fieldNames);
            var ListDataSrvc = component.find("ListDataservice");            
            ListDataSrvc.getListData(component.get("v.Stagefilter") , component.get("v.Statusfilter"), component.get("v.domain") , component.get("v.source") , function(result) {
                component.set("v.quotes", result);
                component.set("v.searchedquotes", result);
                helper.Paging(component,component.get("v.quotes"),0,component.get("v.pagesize"));
                
            });
            
        });
    },
    handlesearch : function(component, event, helper) {
        var quotes = component.get("v.quotes");
        var ListColumn = component.get("v.ListColumn");
        var searchval = event.getSource().get("v.value");
        var fieldtosearch = event.getSource().get("v.name");
        var targetpage = component.get('v.currentPage');
        var searchedquotes = [];        
        var fieldNames = [];
        ListColumn.forEach(function(item) {
            fieldNames.push(item.Field);
        });
        for (var i=0; i<quotes.length; i++) {            
            var Searchexpr = true;
            ListColumn.forEach(function(item) {
                if(item.Search != null && quotes[i][item.Field] != null){
                    var fieldvalue = quotes[i][item.Field].toLowerCase();
                    var searchval = item.Search.toLowerCase();
                    var showrecordflag = fieldvalue.includes(searchval);
                    Searchexpr = Searchexpr && showrecordflag;
                }
            });
            if(Searchexpr){
                searchedquotes.push(quotes[i]);
            }
        }
        component.set("v.searchedquotes",searchedquotes);
        helper.Paging(component,searchedquotes,0,component.get("v.pagesize"));
    },
    handlesort : function(component, event, helper) {
        
        var ListColumn = component.get("v.ListColumn"); 
        var fieldtosort = event.getSource().get("v.alternativeText");
        var fieldNames = [];
        var sortededquotes = component.get("v.searchedquotes");
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
        
        helper.Paging(component,component.get("v.searchedquotes"),startrow,endrow);
    },
    goPrevPage : function(component, event, helper) {
        var currentpage = component.get('v.currentPage');
        var targetpage = currentpage - 1;
        var startrow = component.get("v.pagesize")*(targetpage - 1) ;
        var endrow = component.get("v.pagesize")*(currentpage - 1);
        
        component.set('v.currentPage',targetpage);
        helper.Paging(component,component.get("v.searchedquotes"),startrow,endrow);
        
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
        helper.Paging(component,component.get("v.searchedquotes"),startrow,endrow);        
    },
    handleArchiveClick : function(component, event, helper) {
        var ListDataSrvc = component.find("ListDataservice");
        ListDataSrvc.getListData(component.get("v.Stagefilter") , component.get("v.Statusfilter"), component.get("v.domain") , component.get("v.source") , function(result) {         
            component.set("v.quotes", result);
            component.set("v.searchedquotes", result);
            helper.Paging(component,component.get("v.quotes"),0,component.get("v.pagesize"));
        });
    },
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
    },
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hide loading spinner    
        component.set("v.Spinner", false);
    },
    QuoteSubmitSaved : function(component,event,helper){
           
        alert('Quote Submitted');
    }
})