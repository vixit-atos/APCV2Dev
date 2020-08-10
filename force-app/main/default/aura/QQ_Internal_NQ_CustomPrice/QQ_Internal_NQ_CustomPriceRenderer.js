({
    afterRender: function(component, helper) {
        this.superAfterRender();
        var svg = component.find("svg_content");
        var value = svg.getElement().innerText;
        value = value.replace("<![CDATA[", "").replace("]]>", "");
        svg.getElement().innerHTML = value;         
    }
})