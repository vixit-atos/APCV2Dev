({
	setMilestones : function(cmp, milestones) { try {
        //create map of milestones
		const msMap = {}
        for (const entry of milestones)
            msMap[entry.Name] = entry
        milestones = [] //reset to empty list to fill
        //for each milestones type, if we got one then sort, add the class for style, and push to list
        for (const str of ['Pact Approval','Design Release','Final Packet','Changeover']) {
            if (msMap[str])  {
                const m = this.sortDates(msMap[str])
                this.getClassName(m)
                milestones.push(m)
            }
        }
        cmp.set("v.milestones",milestones)
        // console.log('milestones: '+JSON.stringify(milestones))
    } catch(e) { console.error('setMilestones: '+e) }},

    sortDates: function(milestone) { try {
        let actualLabel = 'Actual'
        let actualDate = milestone.Actual_Date__c
        if (!actualDate) { //set to today if milestone has no actual date
            const tzoffset = new Date().getTimezoneOffset() * 60000; //timezone offset in milliseconds
            const today = new Date(Date.now() - tzoffset) //today in local time to prevent timezone issues
            actualDate = today.toISOString().substring(0, 10) //string that matches other data
            actualLabel = 'Today'
        }
        const arr = [{'date':milestone.Kickoff_Date__c, 'label':'Original'},
                    {'date':actualDate, 'label':actualLabel},
                    {'date':milestone.Deadline__c, 'label':'Planned'}]
        arr.sort((a,b) => { //sort oldest to newest
            if (a.date < b.date) return -1
            else if(a.date > b.date) return 1
            else return 0
        })
        const [first, second, third] = arr //use destructuring to put array elements into variables
        return {first, second, third, 'name':milestone.Name} //put variables into object to return
    } catch(e) { console.error('sortDates: '+e) }},
    
    getClassName : function(m) { try {
        if (!m.first.date || !m.second.date || !m.third.date || m.first.label !== 'Original') {
            m.cls = 'milestone-is-invalid' //gray - Original isn't first or there is a blank date
        } else if (m.second.label === 'Today') {
            m.cls = 'milestone-is-early' //blue - Not finished and still have time
        } else if (m.second.label === 'Actual') {
            m.cls = 'milestone-was-early' //green - Finished on time
        } else if (m.third.label === 'Today') {
            m.cls = 'milestone-is-late' //red - Not finished and past due date
        } else if (m.third.label === 'Actual') {
            m.cls = 'milestone-was-late' //orange - Finished past due date (not a standard salesforce class)
        }
    } catch(e) { console.error('getClassName: '+e) }},
})