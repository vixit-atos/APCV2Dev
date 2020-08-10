({
    showAtMouse : function(cmp, event, helper) {
        const {xPosition,yPosition} = event.getParam('arguments')
        const tooltipElem = cmp.find('tooltip').getElement()
        tooltipElem.style.left = (xPosition+20)+'px'
        tooltipElem.style.top = (yPosition-20)+'px'
    },

    hide : function(cmp, event, helper) {
        const tooltipElem = cmp.find('tooltip').getElement()
        tooltipElem.style.left = '-9999px'
    },
  })