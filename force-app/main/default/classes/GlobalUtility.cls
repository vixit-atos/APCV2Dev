public with sharing class GlobalUtility {

public static Boolean runAfter = true;
    public static Boolean runOnceOnAfter(){
        if(runAfter){
            runAfter = false;
            return true;
        }
        else{
            return runAfter;
        }
    }

}