({
    /*
     * On initialization, split the design attribute for the data table
     * Proceeds on correct SOQL Statement syntax up to the sObjectType
     * Maps the sObjectType to the fields
     * Passes the Map and currency display Design attribute to the server call
     */
    init: function (cmp, event, helper) {
        const SELECT = 'SELECT';
        const FIND = 'FIND';
        const FROM = 'FROM';
        const SPACE = ' ';
        let requestName = cmp.get('v.requestName');
        let sObjectQuery = cmp.get('v.sObjectQuery');
        let query = 'SELECT ID FROM Account';
        if(query != null){
            
            if(sObjectQuery.indexOf(SELECT) !== -1){
                let fieldsFromQuery = sObjectQuery.split(SELECT)[1];
                let splitQuery = fieldsFromQuery.split(FROM);
                
                fieldsFromQuery = splitQuery[0];
                let sObjectSplit = splitQuery[1].trim();
                
                let fields = fieldsFromQuery.split(',');
                let trimmedFields = [];
                if(fields.length > 0 ){
                    for(let field of fields){
                        trimmedFields.push(field.trim());
                    }
                }
                
                let sObjectType = sObjectSplit.split(SPACE)[0];
                cmp.set('v.sObjectType', sObjectType);
                
                let sObjectTypeToFieldAPINames = {};
                sObjectTypeToFieldAPINames[sObjectType] = trimmedFields;
                
                //helper.callGetDescribeFieldResults(cmp, requestName, sObjectType, sObjectTypeToFieldAPINames);
                
                let describeFieldsResultsFunction = helper.successDescribeFieldResults;
                let parameters = {'requestName' : requestName,
                          		  'objectFieldMaps' : sObjectTypeToFieldAPINames};
                console.log(sObjectTypeToFieldAPINames);
                cmp.find('callApexMethod').CallApexMethod(
                									cmp, 
                									'c.getDescribeFieldResults',
                									parameters,
                									describeFieldsResultsFunction);
                                                    
            }else{
                //Malformed Query Error. Only SOQL Queries Allowed.
            }
            
        }
    },
    
    onFieldsComplete: function(cmp, event, helper){
        let currencyDisplay = cmp.get('v.currencyDisplay');
        let fieldMetadata = cmp.get('v.fieldMetadata');
        helper.buildColumns(cmp, fieldMetadata, currencyDisplay);
    },
    
    /*
     * Fires when columns are completely built
     * Queries for the design attribute SOQL statement
     * Builds rows after query using the columns previously made.
     */
    onColumnsComplete: function(cmp, event, helper){
        let requestName = cmp.get('v.requestName');
        let recordId = cmp.get('v.recordId');
        let query = cmp.get('v.sObjectQuery');
        if(query.includes('||')){
            query = query.replace('||', '\'' + recordId + '\'');
        }
        let parameters = {"requestName" : requestName,
                          "query" : query};
        let querySuccessFunction = helper.querySuccessFunction;
        //helper.callPerformQuery(cmp, requestName, query);
        
        cmp.find('callApexMethod').CallApexMethod(
                									cmp, 
                									'c.performQuery',
                									parameters,
                									querySuccessFunction);
    },
    
    updateSelectedText: function (cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        cmp.set('v.selectedRowIds', selectedRows.Id);
    },

    buildData : function(cmp, event, helper){
        console.log('buildData triggered');
        helper.buildRows(cmp, cmp.get('v.initialData'), cmp.get('v.initialLoad'));
    },
    
    loadMoreData: function(cmp, event, helper){
        let remainingData = cmp.get('v.remainingData');
        let maximum = cmp.get('v.loadMoreOffset');
        helper.buildRows(cmp, remainingData, maximum);
    },
    
    handleSaveEdition: function (cmp, event, helper) {
        const currentData = cmp.get('v.currentData')
        const rowData = event.getParam('draftValues');
        const sObjectType = cmp.get('v.sObjectType');
        const requestName = cmp.get('v.requestName');
        const dmlAction = 'Update';
        
        let updatingObjects = {};
        let sObjects = [];
        let sObject = {};
        for(const row of rowData){
            let rowNumber = row.id.split('row-')[1];
            let foundObject = currentData[rowNumber];
            for(const newKey of Object.keys(row)){
                if(newKey !== 'id'){
                    for(const oldKey of Object.keys(foundObject)){
                        if(newKey === oldKey){
                            foundObject[oldKey] = row[newKey];
                            sObjects.push(foundObject);
                        }
                    }
                }
            }
        }
        cmp.set('v.draftValues', []);
        let parameters = {"dmlType" : dmlAction,
                          "objects" : sObjects,
                          "allOrNone" : true,
                          "requestName" : requestName};
        let successDMLFunction = helper.successDML;
        cmp.find('callApexMethod').CallApexMethod(
                									cmp, 
                									'c.performDML',
                									parameters,
                									successDMLFunction);
        //helper.callPerformDML(cmp, dmlAction, sObjects, true, requestName);
    },
    
    handleCancelEdition: function (cmp) {
    }
})