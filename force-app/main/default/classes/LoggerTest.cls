@isTest
public class LoggerTest {
    //if verbose is true, all Log__c fields are System.debugged for all logs
    //if you want to only see them in one test you can set it false here and set LoggerTest.verbose = true in that test
    //you can also manually call debugLog in the test
    static private Boolean verbose = true;

    //////////////////////////////////
    ///////// HELPER METHODS /////////
    //////////////////////////////////

    private static List<Log__c> getLogs(Integer numLogs) {
        List<Log__c> logs = [SELECT Record_Identifier__c,Log_Type__c,Log_Message__c,Exception_Type__c,Log_Source__c,Line_Number__c,
                                            Full_Log__c,Stack_Trace__c,Category__c,CreatedBy.Name FROM Log__c ORDER BY Category__c];
        System.assertEquals(numLogs,logs.size());
        if (LoggerTest.verbose) for (Log__c log : logs) debugLog(log);
        return logs;
    }

    private static void debugLog(Log__c log) {
        System.debug('------------------------------------------------');
        System.debug('CreatedBy.Name: '+log.CreatedBy.Name);
        System.debug('Category__c: '+log.Category__c);
        System.debug('Record_Identifier__c: '+log.Record_Identifier__c);
        System.debug('Log_Type__c: '+log.Log_Type__c);
        System.debug('Log_Message__c: '+log.Log_Message__c);
        System.debug('Exception_Type__c: '+log.Exception_Type__c);
        System.debug('Log_Source__c: '+log.Log_Source__c);
        System.debug('Line_Number__c: '+log.Line_Number__c);
        System.debug('Stack_Trace__c: \n'+log.Stack_Trace__c);
        System.debug('Full_Log__c: \n'+log.Full_Log__c);
    }

    private static void checkFullLog(Log__c log, List<String> regex) {
        if (regex == null) {
            System.assertEquals(null, log.Full_Log__c, log.Category__c+' Full_Log__c should be null but is not');
            return;
        }
        List<String> strs = log.Full_Log__c.split('\n');
        System.assertEquals(strs.size(), regex.size(), log.Category__c+' checkfullLog was passed '+regex.size()+
                                            ' regex strs but there are '+strs.size()+' lines in fullLog');
        Integer i = 0;
        for(String str : strs) {
            Matcher pm = Pattern.compile(regex[i++]).matcher(str);
            System.assert(pm.matches(),log.Category__c+' Should match: '+regex[i-1]+' - but is: '+str);
        }
    }

    private static void checkStackTrace(Log__c log, String startsWith) {
        if (startsWith == null) {
            System.assertEquals(null, log.Stack_Trace__c, log.Category__c+' Stack_Trace__c should be null but is not');
        } else {
            System.assertNotEquals(null, log.Stack_Trace__c, log.Category__c+' Stack_Trace__c should not be null but is');
            System.assert(log.Stack_Trace__c.startsWith(startsWith), log.Category__c+' Stack_Trace__c should start with '+startsWith+' but is '+log.Stack_Trace__c);
        }
    }

    private static void checkLogFields(Log__c log, String cat, String recId, String logType, String logMsg, String logSrc, String excType, Boolean nullLineNum) {
        System.assertEquals(cat, log.Category__c, log.Category__c+' has wrong Category__c');
        System.assertEquals(recId, log.Record_Identifier__c, log.Category__c+' has wrong Record_Identifier__c');
        System.assertEquals(logType, log.Log_Type__c, log.Category__c+' has wrong Log_Type__c');
        if (logMsg == null) System.assertEquals(null, log.Log_Message__c, log.Category__c+' should have null Log_Message__c');
        else {
            System.assertNotEquals(null, log.Log_Message__c, log.Category__c+' should not have null Log_Message__c');
            System.assert(log.Log_Message__c.contains(logMsg), log.Category__c+' has wrong Log_Message__c');
        }
        System.assertEquals(logSrc, log.Log_Source__c, log.Category__c+' has wrong Log_Source__c');
        System.assertEquals(excType, log.Exception_Type__c, log.Category__c+' has wrong Exception_Type__c');
        System.assertEquals(nullLineNum, log.Line_Number__c==null, log.Category__c+' Line_Number__c is wrong');
    }

    //////////////////////////////////
    ////////// ACTUAL TESTS //////////
    //////////////////////////////////

    @isTest
    static void allInstanceMethods() {
        System.debug('~~~~~~~~~~~~~~Running allInstanceMethods()~~~~~~~~~~~~~~');
        Logger logger = new Logger();
        logger.addLog('Just string');
        try {
            update new Account();
        } catch(Exception e) {
            logger.addLog(e);
            logger.addLog('Both string and exception',e);
            logger.commitLog('cat 1', null, e);
            logger.commitLog('cat 2', null, e, 'Log message', false);
            logger.commitLog('cat 3', null, 'type', 'message', false);
            logger.commitLog('cat 4', null, 'type', 'message', 'source', 10, 'exctype', 'stacktrace', 'fullLog', false);
        }
        List<Log__c> logs = getLogs(4); //ordered by Category__c
        Log__c log1 = logs[0], log2 = logs[1], log3 = logs[2], log4 = logs[3];
        checkLogFields(log1, 'cat 1', null, 'Error', 'MISSING_ARGUMENT', 'LoggerTest', 'System.DmlException', false);
        checkLogFields(log2, 'cat 2', null, 'Error', 'Log message', 'LoggerTest', 'System.DmlException', false);
        checkLogFields(log3, 'cat 3', null, 'type', 'message', null, null, true);
        checkLogFields(log4, 'cat 4', null, 'type', 'message', 'source', 'exctype', false);
        List<String> fullLogRegex = new List<String>{'Just string','Line.*Update failed.*', 'Both string and exception \\| Line.*Update failed.*'};
        checkFullLog(log1, fullLogRegex);
        fullLogRegex.add('Exception Message: Update failed.*');
        checkFullLog(log2, fullLogRegex);
        fullLogRegex.remove(fullLogRegex.size()-1);
        checkFullLog(log3, fullLogRegex);
        fullLogRegex.add('fullLog');
        checkFullLog(log4, fullLogRegex);
        checkStackTrace(log1,'Class.LoggerTest.allInstanceMethods');
        checkStackTrace(log2,'Class.LoggerTest.allInstanceMethods');
        checkStackTrace(log3, null);
        checkStackTrace(log4, 'stacktrace');
    }

    @isTest
    static void allStaticMethods() {
        System.debug('~~~~~~~~~~~~~~Running allStaticMethods()~~~~~~~~~~~~~~');
        try {
            update new Account();
        } catch(Exception e) {
            Logger.insertLog('cat 1', null, e);
            Logger.insertLog('cat 2', null, e, 'Log message', false);
            Logger.insertLog('cat 3', null, 'type', 'message', false);
            Logger.insertLog('cat 4', null, 'type', 'message', 'source', 10, 'exctype', 'stacktrace', 'fullLog', false);
        }
        List<Log__c> logs = getLogs(4); //ordered by Category__c
        Log__c log1 = logs[0], log2 = logs[1], log3 = logs[2], log4 = logs[3];
        checkLogFields(log1, 'cat 1', null, 'Error', 'MISSING_ARGUMENT', 'LoggerTest', 'System.DmlException', false);
        checkLogFields(log2, 'cat 2', null, 'Error', 'Log message', 'LoggerTest', 'System.DmlException', false);
        checkLogFields(log3, 'cat 3', null, 'type', 'message', null, null, true);
        checkLogFields(log4, 'cat 4', null, 'type', 'message', 'source', 'exctype', false);
        System.assertEquals(null, log1.Full_Log__c, log1.Category__c+' Full_Log__c should be null');
        checkFullLog(log2, new List<String>{'Exception Message: Update failed.*'});
        System.assertEquals(null, log3.Full_Log__c, log3.Category__c+' Full_Log__c should be null');
        checkFullLog(log4, new List<String>{'fullLog'});
        checkStackTrace(log1, 'Class.LoggerTest.allStaticMethods');
        checkStackTrace(log2, 'Class.LoggerTest.allStaticMethods');
        checkStackTrace(log3, null);
        checkStackTrace(log4, 'stacktrace');
    }
    @isTest
    static void longFields() {
        System.debug('~~~~~~~~~~~~~~Running longFields()~~~~~~~~~~~~~~');
        String longStr = 'abcdefghijklmnopqrstuvwxyz'.repeat(10); //260 chars
        //category, recordIdentifier, logType, logMessage, logSource, lineNumber, exceptionType, stackTrace, fullLog, async
        Logger.insertLog(longStr, longStr, longStr, longStr, longStr, 1000000, longStr, longStr, longStr, false);
        Log__c log = getLogs(1)[0];
        String abbr = longStr.abbreviate(255);
        List<String> shortenedFields = new List<String>{'Category__c','Record_Identifier__c','Log_Type__c', 
                                                        'Log_Source__c','Log_Message__c','Exception_Type__c'};
        for (String field : shortenedFields) {
            String val = (String) log.get(field);
            System.assert(val.endsWith('...'), field+' does not end with ...  '+val);
        }
        System.assertEquals(null, log.Line_Number__c, 'Line number should be null');
        checkFullLog(log, new List<String> {longStr,'Category__c: '+longStr,'Record_Identifier__c: '+longStr,'Log_Type__c: '+longStr, 
                                                'Log_Source__c: '+longStr,'Log_Message__c: '+longStr,'Exception_Type__c: '+longStr});
        checkStackTrace(log, longStr);
    }

    @isTest
    static void passingNullAndEmptyStrings() {
        System.debug('~~~~~~~~~~~~~~Running passingNullAndEmptyStrings()~~~~~~~~~~~~~~');
        Test.startTest();
        Logger.insertLog(null, null, null, null, null, null, null, null, null, null); //category can't be null so there is a "log insertion failure"
        Logger.insertLog('', '', '', '', '', 0, '', '', '', false); //category can't be '' so there is a "log insertion failure"
        Logger.insertLog('all nulls', null, null, null, null, null, null, null, null, null);
        Logger.insertLog('all empty strings', '', '', '', '', 0, '', '', '', false);
        Test.stopTest(); //the log insertion failure log is async
        List<Log__c> logs = getLogs(4); //ordered by Category__c
        Log__c allEmptyStrings = logs[0], allNulls = logs[1], failedToInsert1 = logs[2], failedToInsert2 = logs[3];
        checkLogFields(allEmptyStrings, 'all empty strings', null, 'Error', null, null, null, true);
        checkLogFields(allNulls, 'all nulls', null, 'Error', null, null, null, true);
        checkLogFields(failedToInsert1, 'Inserting Log', null, 'Error', 'Please include a category for your log', null, 'Logger.LoggerException', false);
        checkLogFields(failedToInsert2, 'Inserting Log', null, 'Error', 'Please include a category for your log', null, 'Logger.LoggerException', false);
        checkStackTrace(allEmptyStrings, null);
        checkStackTrace(allNulls, null);
        checkStackTrace(failedToInsert1, '()'); //why do custom exceptions make the stacktrace ()? Who knows
        checkStackTrace(failedToInsert2, '()');
    }
    
    @isTest
    static void invalidLineNumber() {
        System.debug('~~~~~~~~~~~~~~Running invalidLineNumber()~~~~~~~~~~~~~~');
        Logger.insertLog('large', null, null, null, null, 1000000, null, null, null, null);
        Logger.insertLog('negative', null, null, null, null, -1, null, null, null, null);
        Logger.insertLog('normal', null, null, null, null, 42, null, null, null, null);
        List<Log__c> logs = getLogs(3); //ordered by Category__c
        Log__c large = logs[0], negative = logs[1], normal = logs[2];
        System.assertEquals(null,large.Line_Number__c);
        System.assertEquals(null,negative.Line_Number__c);
        System.assertEquals(42,normal.Line_Number__c);
    }

    @isTest
    static void multipleLoggers() {
        System.debug('~~~~~~~~~~~~~~Running multipleLoggers()~~~~~~~~~~~~~~');
        Logger logger1 = new Logger();
        Logger logger2 = new Logger();
        logger1.addLog('a message 1');
        logger2.addLog('a message 2');
        logger1.addLog('another message 1');
        logger2.addLog('another message 2');
        logger1.commitLog('cat 1', null, 'test type', 'msg', false);
        logger2.commitLog('cat 2', null, 'test type', 'msg', false);
        List<Log__c> logs = getLogs(2); //ordered by Category__c
        Log__c log1 = logs[0], log2 = logs[1];
        checkLogFields(log1, 'cat 1', null, 'test type', 'msg', null, null, true);
        checkLogFields(log2, 'cat 2', null, 'test type', 'msg', null, null, true);
        checkFullLog(log1, new List<String> {'a message 1', 'another message 1'});
        checkFullLog(log2, new List<String> {'a message 2', 'another message 2'});
        checkStackTrace(log1, null);
        checkStackTrace(log2, null);
    }

    @isTest
    static void constructorWithParams() {
        System.debug('~~~~~~~~~~~~~~Running constructorWithParams()~~~~~~~~~~~~~~');
        Logger logger1 = new Logger(true, null); //logger's debug is true, should system.debug for each log
        //no way to test what is put into the debug log in an Apex test 
        System.debug('Note that this test must be checked manually');
        System.debug('-----VERIFY THAT THE BELOW LINE IS ~NOT~ JUST DASHES-----');
        logger1.addLog('This should be in the debug log!');
        System.debug('----------------------------------------------------');
        Logger logger2 = new Logger(false, new List<String> {'Message 1', 'Message 2'});
        System.debug('-----VERIFY THAT THE BELOW LINE ~IS~ JUST DASHES-----');
        logger2.addLog('This should NOT be in the debug log');
        System.debug('----------------------------------------------------');
        logger1.commitLog('cat 1', null, 'type', 'message', false);
        logger2.commitLog('cat 2', null, 'type', 'message', false);
        List<Log__c> logs = getLogs(2);
        Log__c log1 = logs[0], log2 = logs[1];
        checkLogFields(log1, 'cat 1', null, 'type', 'message', null, null, true);
        checkLogFields(log2, 'cat 2', null, 'type', 'message', null, null, true);
        checkFullLog(log1, new List<String> {'This should be in the debug log!'});
        checkFullLog(log2, new List<String> {'Message 1', 'Message 2','This should NOT be in the debug log'});
        checkStackTrace(log1, null);
        checkStackTrace(log2, null);
    }

    @isTest
    static void async() {
        System.debug('~~~~~~~~~~~~~~Running async()~~~~~~~~~~~~~~');
        Test.startTest();
        Logger.insertLog('async', null, 'type', 'msg', true);
        Logger.insertLog('sync', null, 'type', 'msg', false);
        List<Log__c> logs = getLogs(1); //sync one inserted but async one not inserted until after stopTest()
        Test.stopTest();
        logs = getLogs(2);
    }

    @isTest
    static void dmlRollback() {
        System.debug('~~~~~~~~~~~~~~Running dmlRollback()~~~~~~~~~~~~~~');
        Test.startTest();
        Savepoint sp = Database.setSavepoint();
        Logger.insertLog('sync', null, 'Info', 'The rollback will remove this log', false);
        Logger.insertLog('async', null, 'Info', 'Because this fires a platform event it will still be inserted', true);
        List<Log__c> logs = getLogs(1);
        checkLogFields(logs[0], 'sync', null, 'Info', 'The rollback will remove this log', null, null, true);
        Database.rollback(sp);
        logs = getLogs(0);
        Test.stopTest();
        logs = getLogs(1);
        checkLogFields(logs[0], 'async', null, 'Info', 'Because this fires a platform event it will still be inserted', null, null, true);
    }
    
    private class LoggerTestException extends Exception {}

    @isTest
    static void withCustomException() {
        System.debug('~~~~~~~~~~~~~~Running withCustomException()~~~~~~~~~~~~~~');
        try {
            throw new LoggerTestException('Test Custom Exception');
        } catch(Exception e) {
            Logger.insertLog('cat',null, e);
        }
        Log__c log = getLogs(1)[0];
        //unfortunately the stacktrace and the source is blank when you use a custom exception
        checkLogFields(log, 'cat', null, 'Error', 'Test Custom Exception', null, 'LoggerTest.LoggerTestException', false);
        checkStackTrace(log, '()'); //why do custom exceptions cause stacktrace to be ()? ¯\_(ツ)_/¯
    }
}