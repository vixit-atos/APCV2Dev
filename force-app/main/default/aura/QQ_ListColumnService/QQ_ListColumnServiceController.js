/* auraMethodController.js */
({
    getListColumn : function(cmp, event) {
        var params = event.getParam('arguments');
        var callback;
        var staticresource;
        if (params) {
            callback = params.callback;
            staticresource = params.staticresource;
        }
        var resource = "$Resource.".concat(staticresource);
        var path = $A.get(resource);
        var req = new XMLHttpRequest();        
        req.open("GET", path);
        req.addEventListener("load", $A.getCallback(function() {
            if (callback) callback(JSON.parse(req.response));           
        }));
        req.send(null);
    }     
})