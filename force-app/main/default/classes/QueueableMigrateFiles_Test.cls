@isTest public class QueueableMigrateFiles_Test {
    static testMethod void testMonthConversion(){
        test.startTest();
            system.assertEquals('Dec', QueueableMigrateFiles.convertMonth(1));
            system.assertEquals('Jan', QueueableMigrateFiles.convertMonth(2));
            system.assertEquals('Feb', QueueableMigrateFiles.convertMonth(3));
            system.assertEquals('Mar', QueueableMigrateFiles.convertMonth(4));
            system.assertEquals('Apr', QueueableMigrateFiles.convertMonth(5));
            system.assertEquals('May', QueueableMigrateFiles.convertMonth(6));
            system.assertEquals('Jun', QueueableMigrateFiles.convertMonth(7));
            system.assertEquals('Jul', QueueableMigrateFiles.convertMonth(8));
            system.assertEquals('Aug', QueueableMigrateFiles.convertMonth(9));
            system.assertEquals('Sep', QueueableMigrateFiles.convertMonth(10));
            system.assertEquals('Oct', QueueableMigrateFiles.convertMonth(11));
            system.assertEquals('Nov', QueueableMigrateFiles.convertMonth(12));
        test.stopTest();
    }
}