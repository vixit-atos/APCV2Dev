({
	removeobjectpropertyval : function(array,fieldname,fieldvalue) {
        var updatedarray = array.filter(function(item){
            return item[fieldname] != fieldvalue; 
        });
        //alert(JSON.stringify())
        return updatedarray;  
	}
})