@isTest(SeeAllData=true)

public class Calendarsalesforce1vfpage_Contler_Test{
    public string calname ='West Parts Master Calendar';
 static testMethod void testmethod1 (){
             Event e = new Event(
                
                Subject = 'Sample Task',
                StartDateTime = Datetime.now(),
                EndDateTime = Datetime.now(),
                
                OwnerId = '0230W000004Sc28');
                 insert e;
List<Event> EvList = [Select id,startDateTime from Event limit 100];
  PageReference tpageRef = Page.calendar_salesforce1;
  Test.setCurrentPage(tpageRef);

  ApexPages.currentPage().getParameters().put('Cal','West Parts Master Calendar');
  ApexPages.currentPage().getParameters().put('CalId','023d0000004R3jA');
Calendarsalesforce1vfpage_Controller cont = new Calendarsalesforce1vfpage_Controller();
cont.pageload();
cont.toggleMyEvents();
 
 }
    static testMethod void testmethod2 (){
                Event e = new Event(
                
                Subject = 'Sample Task1',
                StartDateTime = Datetime.now(),
                EndDateTime = Datetime.now(),
                
                OwnerId ='0230W000004Sc28' );
                insert e;
     List<Event> EvList = [Select id,startDateTime,ActivityDateTime,OwnerId,Owner.name,EndDateTime from Event limit 10]; 
        Event ev= new Event();
        ev.startDateTime=EvList[0].startDateTime;
        ev.ActivityDateTime=EvList[0].ActivityDateTime;
        ev.OwnerId=EvList[0].OwnerId;
        ev.EndDateTime=EvList[0].EndDateTime;
       PageReference tpageRef1= Page.EventEditPage; 
       tpageRef1.getParameters().put('CalId',EvList[0].OwnerId);
        tpageRef1.getParameters().put('CalName',EvList[0].Owner.name);
        tpageRef1.getParameters().put('StartDate',String.valueOf(EvList[0].startDateTime));
        tpageRef1.getParameters().put('EndDate',String.valueOf(EvList[0].EndDateTime));
        Test.setCurrentPage(tpageRef1);
        
        ApexPages.StandardController sc= new ApexPages.StandardController(ev);
        EventEditPageControllerextension evcont =new EventEditPageControllerextension(sc);
        
        evcont.save();
        evcont.cancel();
        
    }

}