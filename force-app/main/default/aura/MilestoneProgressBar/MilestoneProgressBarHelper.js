({
    setFormattedDates : function(cmp, milestone) { try {
        const formattedDates = []
        for (const str of ['first','second','third']) {
            const d = new Date(milestone[str].date)
            if (d.toString() !== 'Invalid Date') {
                const yr = d.getFullYear().toString()
                formattedDates.push((d.getMonth()+1)+'/'+(d.getUTCDate())+'/'+yr.substring(2, 4))
            } else formattedDates.push('None')
        }
        cmp.set('v.formattedDates',formattedDates)
    } catch(e) { console.error('setFormattedDates: '+e) }},

    calculateProgress: function (cmp, milestone) { try {
        if (milestone.cls === 'milestone-is-invalid') return //don't calculate progress for grayed out progress bar
        
        const firstDateMs = new Date(milestone.first.date).getTime()
        const secondDateMs = new Date(milestone.second.date).getTime()
        const thirdDateMs = new Date(milestone.third.date).getTime()
        const dayInMs = 1000*60*60*24
        const firstSecondDaysDiff = (secondDateMs-firstDateMs)/dayInMs
        const firstThirdDaysDiff = (thirdDateMs-firstDateMs)/dayInMs
        const progress = (firstSecondDaysDiff*100)/firstThirdDaysDiff
        cmp.set('v.progress', progress)
        // console.log(firstDateMs,secondDateMs,thirdDateMs)
        // console.log('firstSecondDaysDiff '+firstSecondDaysDiff)
        // console.log('firstThirdDaysDiff '+firstThirdDaysDiff)
        // console.log('progress '+progress)
    } catch(e) { console.error('calculateProgress: '+e) }},

    setProgressColor: function(cmp, cls) {
        setTimeout(() => {  try { //need to let DOM update first
            $A.util.addClass(cmp.find('progressBar'), cls)
        } catch(e) { console.error('setProgressColor: '+e) } }, 0)
    },

})