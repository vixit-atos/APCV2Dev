@IsTest
private class East_West_Reminder_EmailTEst{
 public static testMethod void testEast_West_Reminder_Email() {
 East_West_Reminder_Email EstWestRem = new East_West_Reminder_Email();
String sch = '20 30 8 10 2 ?';
String jobID = system.schedule('Merge Job', sch, EstWestRem);
}
}