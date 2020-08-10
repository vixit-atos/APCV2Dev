public class JourneyController {

    @AuraEnabled
    public static String getInitData(Id sobjId, String transitionGroup, String fieldName) {
        try {
            InitData data = new InitData(sobjId, transitionGroup, fieldName);
            return JSON.serialize(data);
        } catch(Exception e) {
            System.debug(e);
            return 'Error: '+e.getMessage();
        }
    }
    
    private class InitData {
        List<Transition> transitions = new List<Transition>();
        List<Sobject> history;
        List<String> warnings = new List<String>();
        String currentUserName = UserInfo.getName();
        public initData(Id sobjId, String transitionGroup, String fieldName) {
            List<Journey_Transition__mdt> transitionMdts = [SELECT CurrentState__c,NextState__c,Color__c,requiredFields__c FROM Journey_Transition__mdt WHERE TransitionGroup__c =: transitionGroup];
            Schema.DescribeSObjectResult describeSobj = sobjId.getSObjectType().getDescribe();
            Map<String, Schema.SObjectField> fieldMap = describeSobj.fields.getMap();
            Set<String> dontExist = new Set<String>();
            Map<String,Map<Object,List<String>>> dependentFields = new Map<String,Map<Object,List<String>>>();
            for (Journey_Transition__mdt jt : transitionMdts) {
                List<Field> fields = new List<Field>();
                if (jt.requiredFields__c != null) {
                    for (String reqFieldName : jt.requiredFields__c.split(',')) { //for each field
                        List<String> values = new List<String>();
                        Schema.SObjectField fieldSchema = fieldMap.get(reqFieldName);
                        if (fieldSchema != null) { //field exists
                            Schema.DescribeFieldResult fieldResult = fieldSchema.getDescribe();
                            Schema.SObjectField controller = fieldResult.getController();
                            if (controller == null) { //normal picklist, just get values
                                for (Schema.PicklistEntry val : fieldResult.getPicklistValues())
                                    values.add(val.getLabel());
                            } else { //field is dependant
                                Map<Object,List<String>> dependentValues = dependentFields.get(reqFieldName);
                                if (dependentValues == null) {
                                    dependentValues = getDependentPicklistValues(fieldSchema);
                                    dependentFields.put(reqFieldName,dependentValues);
                                }
                                values = dependentValues.get(jt.NextState__c);
                            }
                            String type = String.valueOf(fieldResult.getType());
                            fields.add(new Field(reqFieldName, type, values));
                        } else dontExist.add(reqFieldName);
                    }
                }
                this.transitions.add(new Transition(jt, fields));
            }
            if (dontExist.size()>0) this.warnings.add('Fields do not exist: '+dontExist);
            
            String type = describeSobj.getName();
            String query;
            if (type.right(3) == '__c') //custom object
                query = 'SELECT OldValue,CreatedBy.Name,CreatedDate FROM '+type.removeEnd('c')+'History WHERE ParentId = :sobjId AND (Field = :fieldName OR Field = \'created\') ORDER BY CreatedDate';
            else if (type == 'Opportunity') //for whatever reason Opportunity is the only type that has a "FieldHistory" suffix
                query = 'SELECT OldValue,CreatedBy.Name,CreatedDate FROM '+type+'FieldHistory WHERE '+type+'Id =  :sobjId AND (Field = :fieldName OR Field = \'created\') ORDER BY CreatedDate';
            else
                query = 'SELECT OldValue,CreatedBy.Name,CreatedDate FROM '+type+'History WHERE '+type+'Id =  :sobjId AND (Field = :fieldName OR Field = \'created\') ORDER BY CreatedDate';
            System.debug(query);
            this.history = Database.query(query);
        }
    }

//this method is from https://glyntalkssalesforce.blogspot.com/2018/08/dependent-picklist-values-in-apex.html
    public static Map<Object,List<String>> getDependentPicklistValues( Schema.sObjectField dependToken ) {
        Schema.DescribeFieldResult depend = dependToken.getDescribe();
        Schema.sObjectField controlToken = depend.getController();
        if ( controlToken == null ) return null;
        Schema.DescribeFieldResult control = controlToken.getDescribe();
        List<Schema.PicklistEntry> controlEntries =
        (   control.getType() == Schema.DisplayType.Boolean
        ?   null
        :   control.getPicklistValues()
        );
    
        String base64map = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
        Map<Object,List<String>> dependentPicklistValues = new Map<Object,List<String>>();
        for ( Schema.PicklistEntry entry : depend.getPicklistValues() ) if ( entry.isActive() ) {
            List<String> base64chars = String.valueOf(
                ((Map<String,Object>) JSON.deserializeUntyped( JSON.serialize( entry ) )).get( 'validFor' )
                ).split( '' );
            for ( Integer index = 0; index < (controlEntries != null ? controlEntries.size() : 2); index++ ) {
                Object controlValue =
                (   controlEntries == null
                ?   (Object) (index == 1)
                :   (Object) (controlEntries[ index ].isActive() ? controlEntries[ index ].getLabel() : null)
                );
                Integer bitIndex = index / 6, bitShift = 5 - Math.mod( index, 6 );
                if (bitIndex >= base64chars.size()) break; //I added this line to avoid index out of bounds
                if  (   controlValue == null
                ||  (base64map.indexOf( base64chars[ bitIndex ] ) & (1 << bitShift)) == 0
                ) continue;
                if ( !dependentPicklistValues.containsKey( controlValue ) )
                    dependentPicklistValues.put( controlValue, new List<String>() );
                dependentPicklistValues.get( controlValue ).add( entry.getLabel() );
            }
        }
        return dependentPicklistValues;
    }

    private class Transition {
        String currentState, nextState, color;
        List<Field> fields;

        public transition(Journey_Transition__mdt mdt, List<Field> fields) {
            this.currentState = mdt.CurrentState__c;
            this.nextState = mdt.NextState__c;
            this.color = mdt.Color__c;
            this.fields = fields;
        }
    }
    
    private class Field {
        String name;
        String label;
        String type;
        List<String> values;

        public field(String name,String type, List<String> values) {
            this.name = name;
            this.label = name.replace('__c','').replaceAll('_',' ');
            this.type = type;
            this.values = values;
        }
    }
}