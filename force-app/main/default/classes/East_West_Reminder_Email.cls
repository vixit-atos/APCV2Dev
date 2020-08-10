global class East_West_Reminder_Email implements Schedulable{

global void execute(SchedulableContext SC) {
     Sendemailfleetregion(); 
   }

public void Sendemailfleetregion(){
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
mail.setToAddresses(getEmailAddresses());
//list<String> addlist = new 
//mail.setToAddresses(new LIst<String>{'chirakala.jayasurya@hotmail.com','tamy.paulus@daimler.com'});
mail.setSubject('REG: Reminder to input your Region Review in Salesforce');
mail.setPlainTextBody('Hi,'+'\n'+'This is an automated reminder to input your region review in Salesforce for this month. The region reports are due by the 4th of every month, and will be published as final on the 5th of every month.');
Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
}
 
private List<String> getEmailAddresses() {
List<String> idList = new List<String>();
List<String> mailToAddresses= new List<String>();


User[] usr = [SELECT email FROM user WHERE userrole.name = 'Eastern District Parts Manager' or Userrole.name = 'Western District Parts Manager'];
for(User u : usr) {
mailToAddresses.add(u.email);
}
System.debug(mailToAddresses);

return mailToAddresses;
} 

}