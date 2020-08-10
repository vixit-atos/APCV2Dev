public class Note_Viewer_Controller {

    @AuraEnabled
    public static List<Note> getNotes(Id sobjectId) {
        List<Note> notes = [SELECT Title,Body,ParentId FROM Note WHERE ParentId = :sobjectId];
        return notes;
    }

    @AuraEnabled
    public static String updateNotes(List<Note> notes) {
        try {
            update notes;
            return 'Success';    
        }
        catch(Exception e) { return e.getMessage(); }
    }
}