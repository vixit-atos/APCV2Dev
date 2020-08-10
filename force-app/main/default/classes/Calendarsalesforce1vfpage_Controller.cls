public class Calendarsalesforce1vfpage_Controller 
{ 
    public Boolean includeMyEvents {get;set;}
    public String CalId{get;set;}
    public String CalName{get;set;}
    public list<calEvent> events {get;set;}
    
    public string CalGroup;
    
    //The calendar plugin is expecting dates is a certain format. We can use this string to get it formated correctly
    
    String dtFormat = 'EEE, d MMM yyyy HH:mm:ss z';
    
    
    
    //constructor
    public String CalName1 {get;set;}
    public Calendarsalesforce1vfpage_Controller() 
    {
        CalId = '';
        CalName='';
        
        CalName1 = ApexPages.currentPage().getParameters().get('Cal');
        CalId = ApexPages.currentPage().getParameters().get('CalId');
        //if(CalName1==null)
       // CalName1='Parts Master Calendar';
        //  if(CalName1.contains('%2F') || CalName1.contains('+'))
        // CalName1 = CalName1.remove('%2F').remove('+');
        if(CalName1!=null)
            CalName = CalName1.Trim().replaceAll(' ','+');
        //if(CalName1!=null)
        //CalId =String.valueOf([select OwnerId from Event where owner.Name =:CalName1][0].OwnerId);
        includeMyEvents = true;
        
    }
    
    
    
    public PageReference pageLoad() {
        
        events = new list<calEvent>();
        
        
        //Get my Events if we have selected the correct calendar
        
        if(includeMyEvents){
            
            for(Event evnt: [select Id, Subject, isAllDayEvent, StartDateTime, EndDateTime from Event where owner.Name =:CalName1 ORDER BY EndDateTime DESC Limit 1000]){
                
               // DateTime startDT = evnt.StartDateTime;
                
               // DateTime endDT = evnt.EndDateTime;
                
                calEvent myEvent = new calEvent();
                
                
                if(evnt.Subject <> null)
                    myEvent.title = evnt.Subject.escapeJava();
                else
                    myEvent.title = evnt.Subject;
                
                myEvent.allDay = evnt.isAllDayEvent;
                if(evnt.isAllDayEvent)
                {
                myEvent.startString = String.valueOfGMT(evnt.StartDateTime);
                myEvent.endString = String.valueOfGMT(evnt.EndDateTime);
                                
                }
                else
                {
                myEvent.startString = evnt.StartDateTime.format('yyyy-MM-dd HH:mm:ss+00:00');
                myEvent.endString =  evnt.EndDateTime.format('yyyy-MM-dd HH:mm:ss+00:00');
                
                }
                myEvent.url = '/' + evnt.Id;
                
                myEvent.className = 'event-personal';
                
                events.add(myEvent);
                
            }
            
        }
        
        return null;
        
    }
    
    
    
    public PageReference toggleMyEvents() {
        
        if(includeMyEvents){
            
            includeMyEvents = false;
            
        }
        
        else{
            
            includeMyEvents = true;
            
        }
        
        pageload();
        
        return null;
        
    }
    
    
    
    
    
    //Class to hold calendar event data
    
    public class calEvent{
        
        public String title {get;set;}
        
        public Boolean allDay {get;set;}
        
        public String startString {get;set;}
        
        public String endString {get;set;}
        
        public String url {get;set;}
        
        public String className {get;set;}
        
    }
    
}