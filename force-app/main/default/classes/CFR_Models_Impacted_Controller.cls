public class CFR_Models_Impacted_Controller {

    private class Data {
        
        List<Product2> models = [SELECT Id,Name,Family,Cab_Types__c FROM Product2 WHERE Cab_Types__c != NULL
                                 AND Id IN ( SELECT Product2Id FROM PricebookEntry WHERE Pricebook2.Name = 'CFR Models Price Book' )];
        List<OpportunityLineItem> products = null;
        public data(Id oppId) {
            List<Id> modelIds = new List<Id>();
            for (Product2 model : models) modelIds.add(model.Id);
            this.products = [SELECT Quantity,Cab_Type__c,Product2.Name,Product2.Family FROM OpportunityLineItem
                             WHERE OpportunityId = :oppId AND Product2Id IN :modelIds];
        }
    }

    @AuraEnabled
    public static String getModels(Id oppId) {
        return JSON.serialize(new Data(oppId));
    }

    @AuraEnabled
    public static String updateModels(Map<String, Map<String,String>> models, Id oppId) {
        try {
            List<OpportunityLineItem> existing = [SELECT Product2Id,Cab_Type__c,Quantity FROM OpportunityLineItem WHERE OpportunityId=:oppId];
            List<OpportunityLineItem> toDelete = new List<OpportunityLineItem>();
            Map<String,OpportunityLineItem> oliMap = new Map<String,OpportunityLineItem>();
            for (OpportunityLineItem oli : existing)
                oliMap.put(oli.Product2Id+' '+oli.Cab_Type__c, oli);

            Set<String> modelIds = models.keySet();
            List<Product2> products = [SELECT Name, Family FROM Product2 WHERE Id IN :modelIds];
            List<PricebookEntry> pbes = [SELECT Product2Id,UnitPrice FROM PricebookEntry
                        WHERE Product2Id IN :modelIds AND Pricebook2.Name = 'CFR Models Price Book'];
            Map<Id,PricebookEntry> pToPbe = new Map<Id,PricebookEntry>();
            for (PricebookEntry pbe : pbes) pToPbe.put(pbe.Product2Id, pbe);

            Map<String,OpportunityLineItem> toUpsertMap = new Map<String,OpportunityLineItem>();
            for (String modelId : modelIds) {
                Map<String,String> model = models.get(modelId);
                for (String type : model.keySet()) {
                    PricebookEntry pbe = pToPbe.get(modelId);
                    Decimal quant;
                    try { quant = Decimal.valueOf(Double.valueOf(model.get(type))); }
                    catch(Exception e) { continue; } //don't want to upsert values without a valid quantity
                    Decimal price = pbe.UnitPrice * quant;
                    OpportunityLineItem oli = oliMap.get(modelId+' '+type);
                    if (oli != null) {// && oli.Quantity != quant
                        oli.Quantity = quant;
                        oli.TotalPrice = price;
                        toUpsertMap.put(oli.Id + ' ' + oli.Cab_Type__c, oli);
                    } else {
                        toUpsertMap.put(modelId + ' ' + type, new OpportunityLineItem(
                            OpportunityId=oppId, Product2Id=modelId, PricebookEntryId=pbe.Id, Cab_Type__c=type, Quantity=quant, TotalPrice=price));
                    }
                }
            }
            
            for (OpportunityLineItem oli : existing) {
                OpportunityLineItem exists = toUpsertMap.get(oli.Id + ' ' + oli.Cab_Type__c);
                if (exists == null) {
                    toDelete.add(oli);
                }
            }
            upsert toUpsertMap.values();
            delete toDelete;
            return null;
        } catch(Exception e) {
            return 'Line '+e.getLineNumber()+': '+e.getMessage();
        }
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // upsertProducts and deleteProducts have not been fully tested so are staying private with TestVisible for now //
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    @TestVisible
    private static String upsertProducts(List<String> names, List<String> families, List<String> cabTypes, List<Integer> prices) {
        try {
            Integer sz = names.size();
            if (families.size()!=sz || cabTypes.size()!=sz || prices.size()!=sz) return 'Lists must all be the same size';
            List<Product2> existing = [SELECT Id FROM Product2 WHERE Name IN :names AND IsDeleted = FALSE AND IsArchived = FALSE];
            Map<String,Product2> nameToProd = new Map<String,Product2>();
            for (Product2 prod : existing) nameToProd.put(prod.Name, prod); //fill map to get product2 from its name
            Map<String,Integer> nameToPrice = new Map<String,Integer>();
            List<Product2> prodsToUpsert = new List<Product2>(), newProds = new List<Product2>(), updatedProds = new List<Product2>();
            for (Integer i=0; i<sz; i++) { //change the products and add to prodsToUpsert
                String name = names[i], fam = families[i], cabs = cabTypes[i];
                nameToPrice.put(name, prices[i]); //for pricebookentry
                Product2 p = nameToProd.get(name);
                if (p == null) { //create new
                    p = new Product2(Name=name, Family=fam, Cab_Types__c=cabs);
                    newProds.add(p);
                } else { //update
                    p.Name = name;  p.Family = fam;  p.Cab_Types__c = cabs;
                    updatedProds.add(p);
                }
                prodsToUpsert.add(p);
            }
            upsert prodsToUpsert;
            //get pricebooks
            Id StandardPbId;
            if (Test.isRunningTest()) StandardPbId = Test.getStandardPricebookId();
            else StandardPbId = [SELECT Id FROM Pricebook2 WHERE Name='Standard Price Book' AND IsStandard = TRUE LIMIT 1].Id;
            List<Pricebook2> pbs = [SELECT Id FROM Pricebook2 WHERE Name='CFR Models Price Book'];
            Pricebook2 cfrPb;
            if (pbs.size() > 1) return 'Found multiple pricebooks called "CFR Models Price Book"';
            else if (pbs.size() == 0) { //if CFR pricebook doesn't exist, create it
                cfrPb = new Pricebook2(Name='CFR Models Price Book', IsActive=true);
                insert cfrPb;
            } else cfrPb = pbs[0]; //use existing one
            //create pricebookentries to insert. Must be in standard pricebook before they can be put into custom pricebooks
            List<PricebookEntry> existingPbes = [SELECT Product2.Name,UnitPrice FROM PricebookEntry
                                        WHERE Product2.Name IN :names AND IsActive = TRUE];
            List<PricebookEntry> pbesToUpsert = new List<PricebookEntry>();
            for (Product2 p : newProds) {
                Integer price = nameToPrice.get(p.Name);
                pbesToUpsert.add(new PricebookEntry(Product2Id=p.Id, Pricebook2Id=StandardPbId, UnitPrice=price, UseStandardPrice=false, IsActive=true));
                pbesToUpsert.add(new PricebookEntry(Product2Id=p.Id, Pricebook2Id=cfrPb.Id, UnitPrice=price, UseStandardPrice=false, IsActive=true));
            }
            for (PricebookEntry pbe : existingPbes) {
                Integer price = nameToPrice.get(pbe.Product2.Name);
                if (pbe.UnitPrice != price) {
                    pbe.UnitPrice = price;
                    pbesToUpsert.add(pbe);
                }
            }
            upsert pbesToUpsert;
            return 'Success';
        } catch(Exception e) { return 'Line '+e.getLineNumber()+': '+e.getMessage(); }
    }

    @TestVisible
    private static String deleteProducts(List<String> names) {
        Savepoint sp = Database.setSavepoint();
        try {
            Map<Id,Product2> prods = new Map<Id,Product2>( [SELECT Id FROM Product2 WHERE Name IN :names] );
            Set<Id> pIds = prods.keySet();
            if (prods.size() == 0) return 'No products found';
            List<OpportunityLineItem> olis = [SELECT Id FROM OpportunityLineItem WHERE Product2Id IN :pIds];
            delete olis;
            List<PricebookEntry> pbes = [SELECT Id FROM PricebookEntry WHERE Product2Id IN :pIds];
            for (PricebookEntry pbe : pbes) pbe.IsActive = false;
            update pbes;
            delete prods.values();
            return 'Success';
        } catch(Exception e) {
            Database.rollback(sp);
            return 'Error, no changes made. Line '+e.getLineNumber()+': '+e.getMessage();
        }
    }
}