({
    /*
     * Return from a describeFieldResults call using the SOS component
     * The field results are placed in fieldMetadata for use
     * during building columns for the header and body
     */ 
    successDescribeFieldResults: function(cmp, response){
        let sObjectType = cmp.get('v.sObjectType');
        cmp.set('v.fieldMetadata',JSON.parse(response)[sObjectType]);
    },
    
    /*
     * Return from a query call using the SOS component
     * The queried data is placed in remainingData to pull from
     * During buildRows
     */
    querySuccessFunction : function(cmp, response){
        cmp.set('v.initialData', response[0]);
    },
    
    /*
     * Return from a DML call using the SOS Component
     * As the update from in-line doesn't need a component refresh
     * is here just to send in.
     */ 
    successDML : function(cmp, response){},
    
    /*
     * Calls the sObjectServerController's getDescribeFieldResults
     * For the sObjectType mapped to it's field api names
     * On successful return, builds the columns for the data table
     */ 
    callGetDescribeFieldResults : function(cmp, requestName, sObjectType, sObjectTypeToFieldAPINames){
        let currencyDisplay = cmp.get('v.currencyDisplay');
        let action = cmp.get('c.getDescribeFieldResults');
        action.setParams({'requestName' : requestName,
                          'objectFieldMaps' : sObjectTypeToFieldAPINames});
        action.setCallback(this, function(response) {
            let state = response.getState();
            if(state === 'SUCCESS'){
                let results = JSON.parse(response.getReturnValue());
                this.buildColumns(cmp, results[sObjectType], currencyDisplay);
            }else{
                //Error
            }
        })
        $A.enqueueAction(action);
    },
    
    /*
     * Calls the sObjectServerController's performQuery
     * Passing the SOQL from the Design Attribute as a parameter
     * On successful return, builds data rows for the data table
     */ 
    callPerformQuery : function(cmp, requestName, query){
        let action = cmp.get('c.performQuery');
        action.setParams({'requestName' : requestName,
                          'query' : query});
        action.setCallback(this, function(response) {
            let state = response.getState();
            if(state === 'SUCCESS'){
                cmp.set('v.remainingData', response.getReturnValue()[0]);
                this.buildRows(cmp, response.getReturnValue()[0], cmp.get('v.initialLoad'));
            }else{
                console.log('failed');
            }
        })
        $A.enqueueAction(action);
    },
    
    /*
     * Builds the data rows for each queried record
     * once the maximum is reached, places the remaining rows in a list for later offsets
     * sets the remaining data and currently displayed data
     */ 
    buildRows : function(cmp, data, maximum){
        let columns = cmp.get('v.columns');
        let rows = [];
        let count = 0;
        let currentData = cmp.get('v.currentData');
        let remainingData = [];
        let baseURL = this.getBaseURL();
        
        if(data.length > 0){
            for(const queryRow of data){
                if(count == maximum){ 
                    remainingData.push(queryRow)
                }else{
                    let row = {};
                    for(const column of columns){
                    	for(const fieldName of Object.keys(queryRow)){
                            if(column['fieldName'] === fieldName){
                                if(column['type'] === 'url'){
                                    if(column['subtype'] != null && column['subtype'] === 'Id'){
                                       row[fieldName] = baseURL + queryRow[fieldName];
                                       row[fieldName+'Name'] = queryRow[fieldName];
                                    }else{
                                       row[fieldName] = queryRow[fieldName];
                                    }
                                }else{
                                	row[fieldName] = queryRow[fieldName];
                                }
                            }
                        }
                        
                    }
                    /*
                    console.log('Made Row: ');
                    console.log(JSON.stringify(row));
                    */
                    rows.push(row);
                    count++;
                }
            }
            console.log(currentData);
            if(currentData != null){
                for(const row of rows){
                    currentData[currentData.length] = row;
                }
                cmp.set('v.currentData', currentData);
                cmp.set('v.remainingData', remainingData);
            }else{
                cmp.set('v.currentData', rows);
                cmp.set('v.remainingData', remainingData);
            }
        }
    },
    
    /*
     * For loop method that builds columns and adds to a list
     * Sets the columns into the attribute for the data table
     */
    buildColumns : function(cmp, fieldMetadata, currencyDisplay){
		let columns = [];
        for(const field of fieldMetadata){
            columns.push(this.createColumn(field, currencyDisplay));
        }
        cmp.set('v.columns', columns);
    },
    
    /*
     * Uses a switch case to add in non-common attributes to the column
     * Switches on FieldDescribe.Type
     * Returns column in Object Format
     */  
    createColumn: function(field, currencyDisplay){
        let column = {};
        
        switch (field.type){
            
            //No modifications required for columns
            case 'email':
            case 'percent':
            case 'phone': 
            case 'datetime':
            case 'date':
            case 'string':
            case 'boolean':
            case 'address': 
            case 'double':
            case 'integer':
                break;
                
                //Requires special additions
            case 'currency': 
                column['typeAttributes'] = {currencyCode : currencyDisplay};
                break;
                
            case 'url':
            case 'reference':
                column['typeAttributes'] = {target : '_top'};
                break;
                
            case 'id':
                column['typeAttributes'] =  {label: { fieldName: 'IdName' }, target : '_top'};
                column['type'] = 'url';
                column['subtype'] = 'Id';
                column['editable'] = false;
                break;
                
                //Currently Untested, riding on them being auto-populated
            case 'picklist'://No Picklist Display
                
            case 'textarea': //Lack of room to display. Not recommended.
                
            case 'multipicklist'://No Picklist Display
            case 'long'://Not going to display everything, too long
            case 'time':
            case 'combobox':

            //Untestable via Standard
            case 'base64':
            case 'anytype':
            case 'datacategorygroupreference':
            case 'encryptedstring':
            	break;
        }
        column['label'] = field.label;
        column['fieldName'] = field.name;
        
        if(column['type'] == null){
            column['type'] = field.type;
        }
        if(column['editable'] == null){
            column['editable'] = true;
        }
        if(column['sortable'] == null){
            column['sortable'] == true;
        }
        column['initialWidth'] == 100;
        return column;
    },
    
    /*
     * Grabs the URL, splices it apart and returns the baseURL for the page.
     */ 
    getBaseURL : function() {
        var url = location.href;
        var baseURL = url.substring(0, url.indexOf('/', 14));
        
        if (baseURL.indexOf('http://localhost') != -1) {
            var url = location.href;
            var pathname = location.pathname;
            var index1 = url.indexOf(pathname);
            var index2 = url.indexOf("/", index1 + 1);
            var baseLocalUrl = url.substr(0, index2);
            
            return baseLocalUrl + "/";
        }
        
        else {
            return baseURL + "/";
        }
    }
})