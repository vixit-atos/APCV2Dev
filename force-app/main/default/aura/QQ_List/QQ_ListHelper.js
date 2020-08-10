({
    Paging : function(component,quotes,startrow,endrow )   {
        var totalrecords = quotes.length;
        component.set('v.recordcount',totalrecords);
        var pagesize = component.get("v.pagesize");
        var totalPages = Math.ceil(totalrecords / pagesize);
        component.set("v.totalPages", totalPages); 
        component.set("v.startrow" , totalrecords > 0 ? startrow + 1 : 0 )
        component.set("v.endrow" ,totalrecords > endrow ? endrow : totalrecords );              
        component.set("v.pagecounter" , this.Pagination(component.get("v.currentPage"),component.get("v.totalPages")));
        component.set("v.pagequotes", quotes.slice(startrow,endrow));
    }  ,
    Pagination : function(c,m){
        var current = c,
            last = m,
            delta = 1,
            left = current - delta,
            right = current + delta + 1,
            range = [],
            rangeWithDots = [],
            l = 0;
        
        for (var i = 1; i <= last; i++) {
            if (i == 1 || i == last || i >= left && i < right) {
                range.push(i);
            }
        }
        
        range.forEach(function(item){
            if (l) {
                if (item - l == 4) {
                    rangeWithDots.push(l + 1);
                } else if (item - l != 1) {
                    rangeWithDots.push('...');
                }
            }
            rangeWithDots.push(item);
            l = item;
        });
        
        return rangeWithDots;
        
    },
   
    
})