({
    init : function(component, event, helper) {
        var today = $A.localizationService.formatDate(new Date(), "MM/DD/YYYY");        
        component.set("v.today" , today);
        var usersrvc = component.find("userservice");
        usersrvc.getusername(function(result) {
            component.set("v.Name", result);
            component.set("v.notesplaceholder", result + ' on ' + today);
            
        });
        
        
        
        
    },
    
    addNotes : function(component, event, helper) {
        component.set("v.addnotesclicked" , true)	
    },
    saveNotes : function(component, event, helper) {
        var notesarray = JSON.parse(JSON.stringify(component.get("v.noteslist")));
        var noteobj = JSON.parse(JSON.stringify(component.get("v.noteitem")));
        notesarray.push(noteobj);
        component.set("v.noteslist" ,notesarray );
        component.set("v.noteitem.Body" ,'' );
        component.set("v.addnotesclicked" , false)
    }
})