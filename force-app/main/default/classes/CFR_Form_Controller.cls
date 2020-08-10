public without sharing class CFR_Form_Controller {

    @TestVisible
    private class InitData {
        List<Product2> models = [SELECT Id,Name,Family,Cab_Types__c FROM Product2 WHERE (Family = 'Freightliner' OR Family = 'Western Star')
                AND Cab_Types__c != NULL AND isActive = true AND Id IN ( SELECT Product2Id FROM PricebookEntry WHERE Pricebook2.Name = 'CFR Models Price Book' )];
        Id recordType = [SELECT ID FROM RecordType WHERE SObjectType = 'Opportunity' and Name = 'Customer Focused Request' LIMIT 1].Id;
        Opportunity opp = null;
        List<Note> notes = null;
        List<Opportunity_Account__c> oppAccs = null;
        List<ContentDocument> files = null;
        
        public initData(Id oppId) {
            if (oppId == null) return;
            List<Opportunity> opps = [SELECT Request_Review_Date__c,Application__c,Currently_Paying__c,Willing_To_Pay__c,Where_Installed__c,
                    Body_Type__c,Trailer_Type__c,Estimated_Volume__c,Priority__c,Construction_Impact__c,Multiple_Segments_Impacted__c,
                    Published_Customer_Specific__c,High_Volume__c,Top_Customer_New_Customer__c,Top_5_Issue__c,Upfit_Fuel_Savings__c,
                    Segment__c,Orders_in_Backlog_Urgent_Timing__c,Regulation_Blackout__c,Name,CloseDate,StageName,User_Can_Edit_Submitted_CFR__c,
                    Substatus__c FROM Opportunity WHERE Id = :oppId];
            
            if (opps.size() == 1) this.opp = opps[0];
            if (this.opp == null) return;
            this.notes = [SELECT Title,Body,ParentId FROM Note WHERE ParentId = :oppId];
            this.oppAccs = [SELECT Account__c,Primary_Customer__c,Account_Name__c,Account__r.CreatedDate, Account__r.Top_Customer__c FROM Opportunity_Account__c WHERE Opportunity__c = :oppId];
            
            List<ContentDocumentLink> cdls = [SELECT ContentDocumentId FROM ContentDocumentLink where LinkedEntityId = :oppId];
            List<Id> cdIds = new List<Id>();
            for (ContentDocumentLink cdl : cdls)
                cdIds.add(cdl.ContentDocumentId);
            this.files = [SELECT Id,Title,FileExtension FROM ContentDocument WHERE Id IN :cdIds];
        }
    }

    @AuraEnabled
    public static String getInitData(Id oppId) {
        InitData data = new InitData(oppId);
        return JSON.serialize(data);
    }

    private class Response {
        String err;
        Id id;
        public response(String err, Id id) {
            this.err = err;
            this.id = id;
        }
    }
    
    @AuraEnabled
    public static String submitRequest(Opportunity opp, List<Note> notesToUpsert, List<Note> notesToDelete, 
            List<Opportunity_Account__c> newOppAccs, List<Opportunity_Account__c> oppAccsToDelete, String cfrName){
        List<Note> opportunityNotes = new List<Note>();
        List<Note> upsertionNotes = new List<Note>();
        Savepoint sp = Database.setSavepoint();
        try {
            opp.Name = getName(opp, cfrName);
            //allows you to save if the CFR connected to the form was deleted
            if (opp.Id != null && [SELECT COUNT() FROM Opportunity WHERE Id = :opp.Id] == 0)
                opp.Id = null;
            //if submitted without ever saving first, make stage New first for when we show field's history
            if (opp.Id == null && opp.StageName == 'Submitted') {
                    opp.StageName = 'New';
                    insert opp;
                    opp.StageName = 'Submitted';
            }
            opportunityNotes = [SELECT Id, Title, ParentId FROM Note WHERE ParentId =: opp.Id];
            Pricebook2 pb = [SELECT Id FROM Pricebook2 WHERE Name='CFR Models Price Book'];
            opp.Pricebook2Id = pb.Id;
            upsert opp;
            Response r = new Response(null, opp.Id);
            
            for(Note newNote : notesToUpsert){
                Boolean isUpdate = false;
                for(Note existingNote : opportunityNotes){
                    if(newNote.Title == existingNote.Title){
                        isUpdate = true;
                        existingNote.Body = newNote.Body;
                        newNote = existingNote;
                        upsertionNotes.add(existingNote);
                    }
                }
                if(!isUpdate) upsertionNotes.add(newNote);
            }
            
            for (Note note : upsertionNotes)
                if (note.ParentId == null)
                    note.ParentId = opp.Id;
            if (notesToUpsert.size() > 0) upsert upsertionNotes;
            if (notesToDelete.size() > 0) delete notesToDelete;

            for (Opportunity_Account__c oppAcc : newOppAccs)
                oppAcc.Opportunity__c = opp.Id;
            if (newOppAccs.size() > 0) upsert newOppAccs;
            if (oppAccsToDelete.size() > 0) delete oppAccsToDelete;

            System.debug('CFR Form submitRequest response '+r);
            return JSON.serialize(r);
        } catch(Exception e) {
            Database.rollback(sp);
            Response r = new Response(e.getMessage(),null);
            System.debug('CFR Form submitRequest error response '+r);
            return JSON.serialize(r);
        }
    }

    @AuraEnabled
    public static string deleteCFR(Id oppId){
        try {
            Opportunity opp = [SELECT Id FROM Opportunity WHERE Id = :oppId];
            delete opp;
            return 'Deleted';
        } catch (Exception e) {
            return e.getMessage();
        }
    }

    @AuraEnabled
    public static string deleteFile(Id fileId){
        try {
            ContentDocument cd = [SELECT Id FROM ContentDocument WHERE Id = :fileId];
            delete cd;
            return 'Deleted';
        } catch (Exception e) {
            return e.getMessage();
        }
    }

    @TestVisible
    private static String getName(Opportunity opp, String cfrName) {
        try {
            if (opp == null || cfrName == null || cfrName == '') return null;
            if (opp.StageName == 'New') return 'xx-xxxx: '+cfrName; //don't give number until submission
            Integer year = Date.Today().Year();
            String yearNum = String.valueOf(year).right(2); //last two digits of year
            String beginning = 'xx-';
            if (opp.Name != null) {
                if (opp.Name.left(2).isNumeric()) beginning = opp.Name.left(2)+'-'; //already given a year, reuse it
                String between = opp.Name.substringBetween('-',':');
                if (between != null && between.isNumeric())
                    return beginning+between+': '+cfrName; //already been numbered, don't number again, otherwise 
            }
            AggregateResult ar = [SELECT MAX(CFR_Number__c) maxNum FROM Opportunity
                                WHERE RecordType.Name = 'Customer Focused Request' AND CALENDAR_YEAR(Submitted_Date__c) = :year ];
            Integer num = Integer.valueOf(ar.get('maxNum'));
            String numStr = (num != null) ? String.valueOf(num+1).leftPad(4,'0') : '0001';
            return beginning+numStr+': '+cfrName;
        } catch(Exception e) {
            System.debug('getName error '+e.getMessage());
            return null;
        }
    }
}