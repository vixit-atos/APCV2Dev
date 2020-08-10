({
	handleCheck : function(component, event, helper) {
        var recordid = event.getParam("recordid");
        var checkvalue = event.getParam("checkvalue");
        var checkedlist = component.get("v.QQCheckedlist");
        checkvalue ? checkedlist.push(recordid) : checkedlist =  checkedlist.filter(function(item) { return item !== recordid;});
        checkedlist.length > 0 ?  component.set("v.enableArchive" , false) : component.set("v.enableArchive" , true);
        component.set("v.QQCheckedlist", checkedlist);        
    },
    
    archive : function(component, event, helper) {
        var ListArchiveSrvc = component.find("ListArchiveService"); 
        ListArchiveSrvc.archiveListData(component.get("v.QQCheckedlist"), function(result) {
            var archiveappEvent = $A.get("e.c:QQ_archiveclickevent");
            archiveappEvent.fire();
        });
        component.set("v.enableArchive" , true);
        component.set("v.QQCheckedlist", []) ;
    },
    newQuickQuote : function(component, event, helper) {
        component.set("v.openpopup" , true);
    }
})