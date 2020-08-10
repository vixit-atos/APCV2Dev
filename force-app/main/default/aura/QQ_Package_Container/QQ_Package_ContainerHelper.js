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
    filterlineitemlist : function(objectarray , fieldname , fieldvalue) {
        return objectarray.filter(function(item){ return item[fieldname] === fieldvalue;});  
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
    },
    checklineitemadded : function (array, fieldname , fieldvalue){
        var obj = array.find(function (obj) { return obj[fieldname] === fieldvalue; });
        return obj ? true : false
    },
    getofferservice :function(offermasterid , component){
        var offerservice = component.find("QueryOfferService_Srvc");
        offerservice.getofferservicedata(offermasterid , function(result){
            component.set("v.servicelisttable" , result);
        } );
    }   
})