({
    getuniquelabelvalue : function(objectarray , fieldname) {
        var uniqueobject  = objectarray.map(function(item){ return item[fieldname]}).
        filter(function(value, index, self){ return self.indexOf(value) === index});
        var reA = /[^a-zA-Z]/g;
        var reN = /[^0-9]/g;
       
            uniqueobject.sort(function(a,b) {var aA = a.replace(reA, "");
                                             var bA = b.replace(reA, "");
                                             if (aA === bA) {
                                                 var aN = parseInt(a.replace(reN, ""), 10);
                                                 var bN = parseInt(b.replace(reN, ""), 10);
                                                 return aN === bN ? 0 : aN > bN ? 1 : -1;
                                             } else {
                                                 return aA > bA ? 1 : -1;
                                             } })
        
        var labelvaluelist = [];
        uniqueobject.forEach(function(item) {
            if(item){
                var uniqueitem = {};
                uniqueitem.label=item;
                uniqueitem.value=item;
                labelvaluelist.push(uniqueitem);}
        });
        return labelvaluelist;
    },
	 filterlist_twofields : function(objectarray , fieldname1 , fieldvalue1 , fieldname2 , fieldvalue2) {
        
        return objectarray.filter(function(item){ return (item[fieldname1] === fieldvalue1 && item[fieldname2] === fieldvalue2);});  
    },
    removeByKey : function (array, params){
        array.some(function(item, index) {
            if(array[index][params.key] === params.value){
                // found it!
                array.splice(index, 1);
                return true; // stops the loop
            }
            return false;
        });
        return array;
    }
    
})