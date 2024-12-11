import { LightningElement, api, wire, track } from 'lwc';
import { getRelatedListRecords } from 'lightning/uiRelatedListApi';

export default class DownloadReceipt extends LightningElement {
    @api recordId;
    hasfees = false;

    @wire(getRelatedListRecords, {
        parentRecordId: '$recordId',  // Use $ to make it reactive
        relatedListId: 'Payment_Fees__r',     // Ensure this is the correct related list API name
        fields: ['Fee__c.Id']
    })listInfo({ error, data }) {
        if (data) {
            console.log('Data: ', data);
            if (data.records.length > 0) {
                this.hasfees = true;
            } else {
                this.hasfees = false;
            }
        } else if (error) {
            console.error('Error fetching related records: ', error);
            this.hasfees = false;
        }
    }

    handleClick() {
        console.log('Record ID: ' + this.recordId);
        const vfPageUrl = 'https://nscp--staging--c.sandbox.vf.force.com/apex/InvoicePDFController?id=' + this.recordId;
       // const vfPageUrl = 'https://novascotiacollegeofpharmacists--c.vf.force.com/apex/InvoicePDFController?id=' + this.recordId;
        // Open the Visualforce page in a new browser tab
        window.open(vfPageUrl, '_blank');
    }
}