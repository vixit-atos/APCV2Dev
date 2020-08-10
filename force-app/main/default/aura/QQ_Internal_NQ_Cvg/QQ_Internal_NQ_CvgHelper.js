({
    getuniquelabelvalue : function(objectarray, fieldname) 
    {        
        var uniqueobject  = objectarray.map(function(item){ return item[fieldname]}).
        filter(function(value, index, self){ return self.indexOf(value) === index});
        
        if(fieldname != "Name"){
          uniqueobject.sort(function(a, b) {return (a > b) ? 1 : -1 })
        }
                    
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
    
    filterlineitemlist : function(objectarray, fieldname, fieldvalue) 
    {
         return objectarray.filter(function(item){ return item[fieldname] === fieldvalue;});  
    }, 
    
    mandatorycheck: function(component) 
    {
        var quoteitem = component.get("v.quoteitem");
        var mandatoryfield = ["A85_Code__c", "Duration_Final__c"];
        var mandatoryfieldpopulated = true;        
        
        mandatoryfield.forEach(function(item) {
            if (quoteitem[item] == "" || quoteitem[item] == undefined) {
                mandatoryfieldpopulated = false;
            }
        });
        
        component.set("v.qq_cvg_completed", mandatoryfieldpopulated)
    }, 
    
    autohandlechange : function(index, lineitems, component)
    {
        var fielditem = component.get("v.detroit_fieldorder")[index];
        var uniqueoption = this.getuniquelabelvalue(lineitems, fielditem["name"]);
        component.set(fielditem["options"], uniqueoption);
        var fieldorderarray = component.get("v.detroit_fieldorder");
        fieldorderarray.forEach(function(item, indx){
            if(indx > index)  {
                component.set(item["options"], []); 
                component.set("v.quoteitem." + item["setfieldname"], ""); 
            }
        });
        
        if(uniqueoption.length == 0){
            this.autohandlechange(index + 1, lineitems, component ); 
        }
        if(uniqueoption.length == 1){
            component.set(fielditem["filterdlineitems"], lineitems);
            component.set("v.quoteitem." + fielditem["setfieldname"], uniqueoption[0].value); 
            if(index === fieldorderarray.length - 1){
              component.set("v.quoteitem.Price__c", lineitems[0].Price);
              component.set("v.quoteitem.Master_Coverage__c", lineitems[0].Id);
              component.set("v.quoteitem.Databook_Code__c", lineitems[0].Name);
              component.set("v.quoteitem.Months__c", lineitems[0].Months__c);
              component.set("v.quoteitem.Miles__c", lineitems[0].Miles__c); }
            this.autohandlechange(index + 1, lineitems, component );   
        }
        if(uniqueoption.length > 1){
           component.set(fielditem["filterdlineitems"], lineitems); 
        }                  
    }
})