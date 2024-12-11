// wireListViewToken.js
import { LightningElement, wire,track,api } from 'lwc';
import { getListUi } from 'lightning/uiListApi';
import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';
import { refreshApex } from '@salesforce/apex';

export default class TerrabbitListView1 extends NavigationMixin(LightningElement) {
    @wire(CurrentPageReference) pageRef;
     @track pageToken = null;
      @track nextPageToken = null;
     @track previousPageToken = null;
     @track records=[];
     @track error;
    @track columns; //JSON.parse('[{"label":"Case Number","fieldName":"CaseNumber","sortable":true,"type":"text"},{"label":"Subject","fieldName":"Subject","sortable":true,"type":"text"},{"label":"Status","fieldName":"Status","sortable":true,"type":"text"},{"label":"Priority","fieldName":"Priority","sortable":true,"type":"text"},{"label":"Date/Time Opened","fieldName":"CreatedDate","sortable":true,"type":"text"}]');
    @track showTable = false;
    defaultSortDirection = 'desc';
    sortDirection = 'desc';
    sortedBy;
    @api viewName;
    @api objectName;
    @api hyperlinkField;
     @track columnsHeader ;
    connectedCallback() { 
       

    }
    get caseRecords() {
        return this.records;
     }
    // Used to sort the 'Age' column
    sortBy(field, reverse, primer) {
        const key = primer
            ? function (x) {
                  return primer(x[field]);
              }
            : function (x) {
                  return x[field];
              };

        return function (a, b) {
            a = key(a); 
            b = key(b);
            return reverse * ((a > b) - (b > a));
        };
    }

    onHandleSort(event) {
        const { fieldName: sortedBy, sortDirection } = event.detail;
        const cloneData = [...this.records];

        cloneData.sort(this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1));
        this.records = cloneData;
        this.sortDirection = sortDirection;
        this.sortedBy = sortedBy;
    }

     
    @wire(getListUi, {
        objectApiName: '$objectName',
        listViewApiName:'$viewName',
        pageSize: 50,
        pageToken: '$pageToken'
    }) listView({ error, data }) {
        this.showTable = true; 
        if (data && data.info && data.info.displayColumns) {
            this.columns = [];
            this.records = [];
             this.columnsHeader = [];
           
            for (var i = 0; i < data.info.displayColumns.length; i++){
                var field = data.info.displayColumns[i];
                 if (field.fieldApiName == this.hyperlinkField) {
                    this.columnsHeader.push({
                        'label': field.label,
                        'fieldName': 'link',
                        'sortable': field.sortable,
                        'type': 'url',
                        typeAttributes: { label: { fieldName: field.fieldApiName }, target: '_self' }
                    });
                    this.sortedBy = field.fieldApiName;
                     
                } else { 
                   this.columnsHeader.push({ 'label': field.label, 'fieldName': field.fieldApiName,  'sortable': field.sortable,'type': 'text'  });
                 }
               this.columns.push({ 'label': field.label, 'fieldName': field.fieldApiName,  'sortable': field.sortable,'type': 'text'  });
            }
            for (var i = 0; i < data.records.records.length; i++) { 
                var record = data.records.records[i];
                var r = {'Id':record.fields.Id.value,'link':'/s/detail/'+record.fields.Id.value}; 
                for (var j = 0; j<this.columns.length; j++){
                    var column = this.columns[j];
                    if (column.fieldName.includes('.')){
                        var fields = column.fieldName.split(".");
                        if (record.fields && record.fields[fields[0]].value && record.fields[fields[0]].value.fields && record.fields[fields[0]].value.fields[fields[1]].displayValue) {
                            r[column.fieldName] =record.fields[fields[0]].value.fields[fields[1]].displayValue;
                        } else if(record.fields && record.fields[fields[0]].value && record.fields[fields[0]].value.fields){
                             r[column.fieldName] =record.fields[fields[0]].value.fields[fields[1]].value;
                        } else {
                            r[column.fieldName] = record.fields[fields[0]].value;
                        }
                      
                    } else {
                        if (record.fields[column.fieldName].displayValue) {
                            r[column.fieldName] = record.fields[column.fieldName].displayValue;
                        } else {
                            r[column.fieldName] = record.fields[column.fieldName].value;
                        }
                    }
                } 
                this.records.push(r);

            }
              this.columns= this.columnsHeader;
           this.columns.push({
                type: 'action',
                typeAttributes: { rowActions: [{ label: 'View', name: 'view' }] },
           });
           
      var  cloneData = [...this.records];

        cloneData.sort(this.sortBy(this.sortedBy, this.sortDirection === 'asc' ? 1 : -1));
        this.records = cloneData;
        
          
            
           
            this.error = undefined;
            this.nextPageToken = data.records.nextPageToken;
            this.previousPageToken = data.records.previousPageToken;
        } else if (error) {
            this.error = error;
            this.records = undefined;
        }
    }

    handleNextPage(e) {
        this.pageToken = this.nextPageToken;
    }

    handlePreviousPage(e) {
        this.pageToken = this.previousPageToken;
    }
    refreshView(e) {
        document.location.reload();
    }
    get hasPrevious() { 
        if (this.previousPageToken) {
            return false;
        } else return true;
        
    }
    get hasNext() { 
        if (this.nextPageToken) {
            return false;
        } else return true;
        
    }
    handleRowAction(event) {
        console.log(event);
          const actionName = event.detail.action.name;
const row = event.detail.row;
        switch(actionName) { 
case 'view':this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: row.Id,
                        actionName: 'view'
                    }
                });
                break;

        }
    }
}