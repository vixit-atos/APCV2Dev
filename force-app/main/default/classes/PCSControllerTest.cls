@isTest public class PCSControllerTest{
    
    static testmethod void testBasicJobProcess(){
        //Not Really sure what to assert here, DataGenerator is launched from this which is tested seperately
        PCSController pcs = new PCSController();
        test.startTest();
        pcs.generate();
        test.stopTest();
        pcs.getProgress();
    }
}