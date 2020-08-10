public class Logger {

    //overloaded static method so that creating a logger object is not required

    public static void insertLog(String category, String recordIdentifier, Exception e) {
        createAndInsert(category, recordIdentifier, e, null, null, null, null, null, null, null, false, false);
    }
    public static void insertLog(String category, String recordIdentifier, Exception e, String logMessage, Boolean async) {
        createAndInsert(category, recordIdentifier, e, null, logMessage, null, null, null, null, null, async, false);
    }
    @AuraEnabled
    public static void insertLog(String category, String recordIdentifier, String logType, String logMessage, Boolean async) {
        createAndInsert(category, recordIdentifier, null, logType, logMessage, null, null, null, null, null, async, false);
    }
    @AuraEnabled
    public static void insertLog(String category, String recordIdentifier, String logType, String logMessage,
                        String logSource, Integer lineNumber, String exceptionType, String stackTrace, String fullLog, Boolean async) {
        createAndInsert(category, recordIdentifier, null, logType, logMessage, logSource, lineNumber, exceptionType, stackTrace, fullLog, async, false);
    }

    //instance variables and methods to track multiple messages to put in Log__c
    
    public Boolean debug; //if true, run System.debug() each time addLog() is called
    public List<String> logs; //the messages from all addLog() calls

    public logger() { //no arguments constructor
        this.debug = false;
        this.logs = new List<String>();
    }
    public logger(Boolean debug, List<String> logs) { //constructor which sets instance vars
        this.debug = debug;
        if (logs == null) logs = new List<String>();
        this.logs = logs;
    }

    //message will be part of Full_Log__c when insertLog() is called
    public void addLog(String str) {
        if (debug) System.debug(str);
        logs.add(str);
    }
    //with exception we can include line number and its error message
    public void addLog(Exception e) { addLog('Line '+e.getLineNumber()+': '+e.getMessage()); }
    public void addLog(String str, Exception e) { addLog(str+' | Line '+e.getLineNumber()+': '+e.getMessage()); }
    
    //concatenates all logs, separated by newlines, to put into Full_Log__c
    public void commitLog(String category, String recordIdentifier, Exception e) {
        createAndInsert(category, recordIdentifier, e, null, null, null, null, null, null, String.join(logs,'\n'), false, false);
    }
    public void commitLog(String category, String recordIdentifier, Exception e, String logMessage, Boolean async) {
        createAndInsert(category, recordIdentifier, e, null, logMessage, null, null, null, null, String.join(logs,'\n'), async, false);
    }
    public void commitLog(String category, String recordIdentifier, String logType, String logMessage, Boolean async) {
        createAndInsert(category, recordIdentifier, null, logType, logMessage, null, null, null, null, String.join(logs,'\n'), async, false);
    }
    public void commitLog(String category, String recordIdentifier, String logType, String logMessage,
                        String logSource, Integer lineNumber, String exceptionType, String stackTrace, String fullLog, Boolean async) {
        fullLog = String.join(logs,'\n') + '\n' + fullLog;
        createAndInsert(category, recordIdentifier, null, logType, logMessage, logSource, lineNumber, exceptionType, stackTrace, fullLog, async, false);
    }
    
    //private helper methods

    private class LoggerException extends Exception {} //so we can throw custom exception if we expect insert to fail in async call
    private static void createAndInsert(String category, String recordIdentifier, Exception e, String logType, String logMessage,
                String logSource, Integer lineNumber, String exceptionType, String stackTrace, String fullLog, Boolean async, Boolean recursed) {
        try {
            if (category == null || category == '') throw new LoggerException('Please include a category for your log');

            Sobject sobj = new Log__c();
            if (async == true) sobj = new Log_Event__e(); //== true prevents exception if async is null
            
            if (fullLog == null) fullLog = '';
            if (logType == null || logType == '') logType = 'Error';
            fullLog += shortenAndAdd(sobj, 'Category__c', category, 255); //method adds to fullLog if value is too long
            fullLog += shortenAndAdd(sobj, 'Record_Identifier__c', recordIdentifier, 255);
            fullLog += shortenAndAdd(sobj, 'Log_Type__c', logType, 50);
            if (e != null) { //get info from exception object
                stackTrace = e.getStackTraceString().left(32768);
                sobj.put('Stack_Trace__c', stackTrace); //if this is longer than 32768 we don't want to add it to fullLog
                sobj.put('Line_Number__c', e.getLineNumber()); //can't pass integer as string to shortenAndAdd. We can expect this to always be < 1000000
                fullLog += shortenAndAdd(sobj, 'Log_Source__c', stackTrace.substringBetween('.'), 255); //class name is between first two dots of stacktrace
                fullLog += shortenAndAdd(sobj, 'Exception_Type__c', e.getTypeName(), 255);
                if (logMessage == null) fullLog += shortenAndAdd(sobj, 'Log_Message__c', e.getMessage(), 255);
                else { //if no logMessage then use exception's message, otherwise put exception message into fullLog instead
                    fullLog += '\nException Message: '+e.getMessage();
                    fullLog += shortenAndAdd(sobj, 'Log_Message__c', logMessage, 255);
                }
            } else {
                if (stackTrace != null) sobj.put('Stack_Trace__c', stackTrace.left(32768)); //if this is longer than 32768 we don't want to add it to fullLog
                if (lineNumber > 0 && lineNumber < 1000000) sobj.put('Line_Number__c', lineNumber); //max length is 6
                fullLog += shortenAndAdd(sobj, 'Log_Source__c', logSource, 255);
                fullLog += shortenAndAdd(sobj, 'Log_Message__c', logMessage, 255);
                fullLog += shortenAndAdd(sobj, 'Exception_Type__c', exceptionType, 255);
            }
            sobj.put('Full_Log__c', fullLog.right(65536)); //get newest info if too long by using right instead of left

            //publishing a platform event ignores DML rollback and runs in another transaction
            if (async == true) EventBus.publish((Log_Event__e) sobj);
            else insert (Log__c) sobj;
        } catch(Exception ex) {
            if (recursed == false) { //create async log showing failure to insert log. recursed bool prevents possibility of infinite loop
                System.debug('Error inserting log: '+ex.getMessage());
                createAndInsert('Inserting Log', null, ex, null, null, null, null, null, null, null, true, true);
            } else System.debug('Cannot even insert log showing failure to insert log: '+ex.getMessage());
        }
    }

    private static String shortenAndAdd(Sobject sobj, String field, String value, Integer maxLength) {
        String str = '';
        if (value == null || value == '') return str;
        if (value.length() > maxLength) {
            str = '\n'+field+': '+value;
            value = value.abbreviate(maxLength); //Shortens to maxLength with ... at the end
        }
        sobj.put(field, value);
        return str;
    }
}