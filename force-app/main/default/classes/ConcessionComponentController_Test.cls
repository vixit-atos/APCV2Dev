@isTest
public class ConcessionComponentController_Test
{
    static testMethod void ConcessionComponentController_Test()
    {
      ConcessionComponentController testObj = new ConcessionComponentController();
      system.debug(testObj.getExpiredConcessions());
      system.debug(testObj.getConcessionsForExpiry());
    }
}