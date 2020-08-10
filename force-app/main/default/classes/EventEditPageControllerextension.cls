public class EventEditPageControllerextension{
    
    public ApexPages.StandardController controller;
    public string myTime{get;set;}
    public String CalName;
    public Date StartDate{get;set;}
    public Date EndDate{get;set;}
    public Time StartTime{get;set;}
    public Time EndTime{get;set;}
    public Event Ev;
    public Boolean message{get;set;}
    
    public EventEditPageControllerextension(ApexPages.StandardController controller){
        Integer Dt,Mon,Year,hh,min,ss;
        Ev= (Event)controller.getRecord();
        message = False;
        //DateTime StartDate,EndDate;
        if(ApexPages.currentPage().getParameters().get('CalId')!=null)
            Ev.OwnerId=ApexPages.currentPage().getParameters().get('CalId');
        if(ApexPages.currentPage().getParameters().get('CalName')!=null)
            CalName=ApexPages.currentPage().getParameters().get('CalName');
        
        if(ApexPages.currentPage().getParameters().get('StartDate')!=null){
            //Ev.StartDateTime = DateTime.valueOf(ApexPages.currentPage().getParameters().get('StartDate'));//,'yyyy-MM-dd HH:mm:ss');
            DateTime Startdt = DateTime.valueOfGmt(ApexPages.currentPage().getParameters().get('StartDate'));
            System.debug(Startdt);
            Dt = Integer.valueOf(String.valueof(Startdt.dayGmt()).length()==1?'0'+String.valueOf(Startdt .dayGmt()):String.valueOf(Startdt.dayGmt()));
            Mon= Integer.valueOf(String.valueof(Startdt.monthGmt()).length()==1?'0'+String.valueof(Startdt.monthGmt()):String.valueof(Startdt.monthGmt()));
            Year= Integer.valueOf(String.valueof(Startdt.year()));
            StartDate = date.newinstance(Year,mon,Dt);
            StartTime  = Time.newInstance(Startdt.hourGmt(), Startdt.minuteGmt(), Startdt.secondGmt(), Startdt.millisecondGmt());
            
            }
            
            
        System.debug(ApexPages.currentPage().getParameters().get('EndDate'));
        if(ApexPages.currentPage().getParameters().get('EndDate')!=null){
            System.debug(DateTime.valueOfGmt(ApexPages.currentPage().getParameters().get('EndDate')));


            DateTime Enddt = DateTime.valueOfGmt(ApexPages.currentPage().getParameters().get('EndDate'));
            System.debug(Enddt);
            Dt = Integer.valueOf(String.valueof(Enddt.dayGmt()).length()==1?'0'+String.valueOf(Enddt.dayGmt()):String.valueOf(Enddt.dayGmt()));
            Mon= Integer.valueOf(String.valueof(Enddt.monthgmt()).length()==1?'0'+String.valueof(Enddt.monthGmt()):String.valueof(Enddt.monthGmt()));
            Year= Integer.valueOf(String.valueof(Enddt.year()));
            EndDate = date.newinstance(Year,mon,Dt);
            EndTime = Time.newInstance(Enddt.hourGmt(), Enddt.minuteGmt(), Enddt.secondGmt(), Enddt.millisecondGmt());

            }
    }
    public pagereference save(){
       DateTime StDt = DateTime.newInstance(StartDate, StartTime);
        DateTime EnDt = DateTime.newInstance(EndDate , EndTime);
        
        Ev.StartDateTime = StDt ;//StDt.addhours(StDt.hour()).addminutes(StDt.minute());//+' '+StartTime);
        Ev.EndDateTime = EnDt ;//EndDate.addhours(EnDt.hour()).addminutes(EnDt.minute());//(DateTime.valueOfGmt(EndDate+' '+EndTime);
        try {
        
                Insert Ev;
                PageReference pageRef = new PageReference('/apex/calendar_salesforce1?Cal='+CalName+'&CalId='+Ev.OwnerId);
                pageRef.setRedirect(True);
                return pageRef;
             }
          catch(Exception e)
        {
             message= true;
             //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Warning,'Error is '+e+' Please contact your administrator');
             //ApexPages.addMessage(myMsg);
             return null;
        }
       // Insert this.Ev;
        //PageReference pageRef = new PageReference('/apex/calendar_salesforce1?Cal='+CalName);
        //pageRef.setRedirect(True);
        //return pageRef;
    }
    public pagereference cancel(){
        PageReference pageRef = new PageReference('/apex/calendar_salesforce1?Cal='+CalName+'&CalId='+Ev.OwnerId);
        pageRef.setRedirect(True);
        return pageRef;
    }
    
    
    
    
}