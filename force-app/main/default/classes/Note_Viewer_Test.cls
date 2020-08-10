@isTest
public class Note_Viewer_Test {
    @isTest
    static void noteViewerTest() {
        System.debug('~~~~~~~~~~~~~~Running noteViewerTest()~~~~~~~~~~~~~~');
        Account acc = new Account(Name='acc');
        insert acc;
        Note note = new Note(Title='title',Body='body',ParentId=acc.Id);
        Note note2 = new Note(Title='title2',Body='body2',ParentId=acc.Id);
        insert new List<Note> {note,note2};
        List<Note> notes = Note_Viewer_Controller.getNotes(acc.Id);
        System.assertEquals(2,notes.size());
        for (Note n : notes) {
            System.assert(n.Title.startsWith('title'));
            n.Title = 'new title';
        }
        String result = Note_Viewer_Controller.updateNotes(notes);
        System.assertEquals('Success', result);
        notes[0].Title = 'a'.repeat(1000); //longer than field's max length
        result = Note_Viewer_Controller.updateNotes(notes);
        System.assert(result.startsWith('Update failed'), result);
    }
}