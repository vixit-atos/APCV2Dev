public with sharing class APC_utilityclass {
    @InvocableMethod(label='Get list of Additional Contacts Email Address' description='Returns the list of Additional Contacts Email Address corresponding to the case' category='case')
    public static List<list<String>> getadditionaldealercontacts(List<String> additionaldealercontacts) {
        system.debug('additionaldealercontacts: ' + additionaldealercontacts);
        list<List<string>> additionalContactslistcollection = new list<List<string>> ();
        List<String> additionaldealercontactlist = new List<String>();
        for(string contactsemail:additionaldealercontacts){
            if(contactsemail.contains(';')){
                additionaldealercontactlist=contactsemail.split(';');
            }else{
                additionaldealercontactlist.add(contactsemail);
            }
        }        
        additionalContactslistcollection.add(additionaldealercontactlist);
        system.debug('additionalContactslistcollection' + additionalContactslistcollection );
        return additionalContactslistcollection;
    }
}