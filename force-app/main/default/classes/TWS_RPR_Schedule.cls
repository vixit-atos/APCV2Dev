global class TWS_RPR_Schedule implements Schedulable {
	global void execute(SchedulableContext sc) {
		new TWS_RPR_Automation().setRPR();
	}
}