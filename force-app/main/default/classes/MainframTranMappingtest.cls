@isTest public class MainframTranMappingtest {
    @isTest static void mainframeResponseTest(){
        
/*     string transName = 'cscnrcu';
     string function = 'Inq';
     string datatype = 'Text';
     string strDate = '2018-10-01'; */
     list <string> concData = new list<string> ();
     
        for(Integer i=0;i<53;i++) {
        concData.add ('Conci');
              
        }
        for(Integer i=53;i<56;i++) {
        concData.add ('25.0');     
        }
        for(Integer i=56;i<58;i++) {
        concData.add ('25.0');     
        }  
        
        for(Integer i=58;i<79;i++) {
        concData.add ('10');     
        }  
        
        for(Integer i=79;i<80;i++) {
        concData.add ('011018');     
        }  
        
        test.startTest();     
        MainframeTranMapping  mf = new MainframeTranMapping ();
        Map<String, object> sample = mf.mainframeResponse(ConcData,'CSCNRCU','inq','concession__C');
        test.stopTest();
     }
    
}