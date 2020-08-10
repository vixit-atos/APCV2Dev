({
    getuniquelabelvalue : function(objectarray , fieldname) {
        var uniqueobject  = objectarray.map(function(item){ return item[fieldname]}).
        filter(function(value, index, self){ return self.indexOf(value) === index});
        /*if(fieldname != "Name"){
            uniqueobject.sort(function(a,b) {return (a > b) ? 1 : -1 })
        }*/
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
    mandatorycheck: function(component) {
        var quoteitem = component.get("v.quoteitem");
        var mandatoryfield = ['A85_Code__c', 'Duration_Final__c'];
        var mandatoryfieldpopulated = true;
        mandatoryfield.forEach(function(item) {
            if (quoteitem[item] == '' || quoteitem[item] == undefined) {
                mandatoryfieldpopulated = false;
            }
        });
        
        component.set("v.qq_cvg_completed", mandatoryfieldpopulated)
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
    }
})