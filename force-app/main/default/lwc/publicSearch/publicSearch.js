import { LightningElement, wire, track } from 'lwc';
import getPharmacyRecords from '@salesforce/apex/publicSearchDataService.getPharmacyRecords';
import getPharmacistRecords from '@salesforce/apex/publicSearchDataService.getPharmacistRecords';
import { NavigationMixin } from 'lightning/navigation';
import NSCPLogo from "@salesforce/resourceUrl/NSCP_Logo";
import TIME_ZONE  from '@salesforce/i18n/timeZone';
const pcyColumns = [
    {
        type: 'button',
        typeAttributes: {
            label: 'View',
            name: 'view',
            variant: 'base',
        }
    },
    { label: 'Name', fieldName: 'name' },
    { label: 'Licence #', fieldName: 'licenseNumber' },
    { label: 'Licence Valid to', fieldName: 'ExpiryDate',type: 'text' },
    { label: 'Pharmacy Phone', fieldName: 'accountPhone',type:'phone'},
    { label: 'Pharmacy Fax', fieldName: 'accountFax', type:'phone'},
    { label: 'Pharmacy Address', fieldName: 'accountAddress'}
];
const pistColumns = [
    {
        type: 'button',
        typeAttributes: {
            label: 'View',
            name: 'view',
            variant: 'base',
        }
    },
    { label: 'First Name', fieldName: 'firstName' },
    { label: 'Last Name', fieldName: 'lastName' },
    { label: 'Licence #', fieldName: 'licenseNumber' },
    { label: 'Registration Type', fieldName: 'Type__c', type: 'text' },
    { label: 'Licence Status', fieldName: 'Registration_Status__c', type: 'text' },
    { label: 'Licence Type', fieldName: 'Class__c', type: 'text' },
    { label: 'Licence Valid To', fieldName: 'Expiry_Date__c' ,type: 'text'
    }
];
//{ label: 'Conditions on License', fieldName: 'closeAt', type: 'date' },

export default class PublicSearch extends NavigationMixin(LightningElement) {
    NSCPLogoUrl = NSCPLogo;
    value = 'Pharmacies';
    IsPharmacies = true;
    IsPharmacists = false;
    @track pharmacyRecords = []
    @track pharmacistRecords = []
    @track pharmacyColumns = pcyColumns;
    @track pharmacistColumns = pistColumns;
    @track error;
    @track records= [];
    startIndex = 0;
    endIndex = 0;
    totalRecords = 0;
    batchSize = 200;
    nxtBtn = true;
    prevBtn = true;
    @wire(getPharmacyRecords,{filter:true,licenseNumber:'',Address:'',City:'',Street:''}) pharmacies({error,data}){
        if(data){
            this.processPharmacyRecords(data);
        }
        if(error){
            this.error=error;
        }
    };
    get options() {
        return [
            { label: 'Pharmacies', value: 'Pharmacies' },
            { label: 'Practitioners', value: 'Pharmacists' },
        ];
    }
    handleChange(event){
        this.value = event.detail.value;
        if(this.value=='Pharmacists'){
            this.IsPharmacists = true;
            this.IsPharmacies = false;
            getPharmacistRecords({filter:true,licenseNumber:'',firstName:'',lastName:''}).then(result =>{
              this.processPharmacistRecords(result);
            }).catch(error =>{
                this.error=error;
                this.records = undefined;
            });
        }
        if(this.value=='Pharmacies'){
            this.IsPharmacies = true;
            this.IsPharmacists = false;
            getPharmacyRecords({filter:true,licenseNumber:'',Address:'',City:'',Street:''}).then(result =>{
                this.processPharmacyRecords(result);
            }).catch(error=>{
                this.error=error;
                this.records = undefined;
            });
        }
    }
    handleClick(event){
        let inputs = this.template.querySelectorAll('lightning-input');
        let licenseNumb;
        let address;
        let firstName;
        let lastName;
        let street;
        let city;
        if(this.IsPharmacies){
            inputs.forEach(element => {
                if(element.name=='licenseNumberDefault'){
                    licenseNumb = element.value;
                }
                if(element.name=='country'){
                    address = element.value;
                }
                if(element.name=='street'){
                    street = element.value;
                }
                if(element.name=='city'){
                    city = element.value;
                }
            });
            if(licenseNumb || address || street || city){
                getPharmacyRecords({filter:false,licenseNumber:licenseNumb,Address:address,City:city,Street:street}).then(result =>{
                    this.processPharmacyRecords(result);
                }
                ).catch(error =>{
                    this.error=error;
                    this.pharmacistRecords = undefined;
                });
            }else{
                alert('Please enter some values to search');
            }
        }
        if(this.IsPharmacists){
            inputs.forEach(element => {
                if(element.name=='licenseNumber'){
                    licenseNumb = element.value;
                }
                if(element.name=='firstName'){
                    firstName = element.value;
                }
                if(element.name=='lastName'){
                    lastName = element.value;
                }
            });
            if(licenseNumb || firstName || lastName){
                getPharmacistRecords({filter:false,licenseNumber:licenseNumb,firstName:firstName,lastName:lastName}).then(result =>{
                    this.processPharmacistRecords(result);
                }).catch(error =>{
                    this.error=error;
                    this.pharmacistRecords = undefined;
                });
            }else{
                alert('Please enter some values to search');
            }
        }
    }
    generteFile(){
        let tempFile='';
        if(this.IsPharmacies){
            tempFile = this.createFile(this.records);
        }else if(this.IsPharmacists){
            tempFile = this.createFile(this.records);
        }
        this.fileDownloadLink(tempFile);
    }
    createFile(records){
        let fileHeader = Object.keys(records[0]);
        fileHeader.shift();
        if(this.IsPharmacies){
            fileHeader.pop();
            fileHeader.push('Street','City','State','Postal Code','Country');
        }
        let fileBody = records.map((record) => {
            let tempRec = Object.values(record);
            tempRec.shift();
            return tempRec.toString();
        });
        fileHeader = fileHeader.toString();
        return fileHeader+'\n'+fileBody.join('\n');
    }
    fileDownloadLink(tempFile){
        const downloadLink = document.createElement('a');
        downloadLink.href = "data:text/csv;charset=utf-8,"+encodeURIComponent(tempFile);
        downloadLink.target = '_blank';
        downloadLink.download = "download_records.csv";
        downloadLink.click();
    }
    resetInput(){
        let inputs = this.template.querySelectorAll('lightning-input');
        inputs.forEach(input => {
            input.value=null;
        });
        if(this.IsPharmacies){
            getPharmacyRecords({filter:true,licenseNumber:0,Address:''}).then(result =>{
                this.processPharmacyRecords(result);
            }
            ).catch(error =>{
                this.error=error;
                this.pharmacyRecords = undefined;
            });
        }else if(this.IsPharmacists){
            getPharmacistRecords({filter:true,licenseNumber:0,firstName:'',lastName:''}).then(result =>{
                this.processPharmacistRecords(result);
            }).catch(error =>{
                this.error=error;
                this.pharmacistRecords = undefined;
            });
        }
    }
    processPharmacyRecords(result){
        this.pharmacyRecords = result;
        this.records = [];
        this.pharmacyRecords.forEach(rec =>{
            let record = {};
            record.recordId = rec.Id;
            record.name = rec.Registrant__r.Name;
            record.licenseNumber = rec.NSCP_Registration_Number1__c;
            record.ExpiryDate = rec.Expiry_Date__c;
            record.accountPhone = rec.Registrant__r.Phone;
            record.accountFax = rec.Registrant__r.Fax;
            record.accountAddress = '';
            if(rec.Registrant__r.BillingAddress){
                let temp = rec.Registrant__r.BillingAddress;
                let Address = temp.street+', '+temp.city+', '+temp.state+', '+temp.postalCode+', '+temp.country;
                record.accountAddress = Address;
            }
            this.records.push(record);
        })
        this.startIndex = 0;
        this.totalRecords = this.records.length;
        this.nxtBtn = this.totalRecords>=this.batchSize ? false:true;
        this.prevBtn = true;
        this.endIndex = this.batchSize;
        this.pharmacyRecords = this.records.slice(this.startIndex,this.endIndex);
    }
    processPharmacistRecords(result){
        this.pharmacistRecords = result;
        this.records = [];
        this.pharmacistRecords.forEach(rec =>{
            let record = {};
            record.recordId = rec.Id;
            record.firstName = rec.Registrant__r.FirstName;
            record.lastName = rec.Registrant__r.LastName;
            record.licenseNumber = rec.Name;
            record.Type__c = rec.Type__c;
            record.Registration_Status__c = rec.Registration_Status__c;
            record.Class__c = rec.Class__c;
            record.Expiry_Date__c = rec.Expiry_Date__c;
            record.Conditions_on_Licence__c = rec.Conditions_on_Licence__c;
            record.Authorized_To_Administer_By_Injection__c = rec.Authorized_To_Administer_By_Injection__c;
            this.records.push(record);
        })
        this.startIndex = 0;
        this.totalRecords = this.records.length;
        this.endIndex = this.batchSize;
        this.nxtBtn = this.totalRecords>=this.batchSize ? false:true;
        this.prevBtn = true;
        this.pharmacistRecords = this.records.slice(this.startIndex,this.endIndex);
    }
    handleRowAction(event){
        event.preventDefault();
        let item = event.detail.row;
        item.IsPharmacies = this.IsPharmacies;
        item.IsPharmacists = this.IsPharmacists;
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes:{
                name: 'individualRecords__c'
            },
            state:{
                'record':JSON.stringify(item),
            }
        });
    }
    handleNext(event){
        this.startIndex+=this.batchSize;
        this.endIndex+=this.batchSize;
        this.prevBtn = false;
        if(this.IsPharmacies){
            this.pharmacyRecords = this.records.slice(this.startIndex,this.endIndex);
        }else{
            this.pharmacistRecords = this.records.slice(this.startIndex,this.endIndex);
        }
        if(this.endIndex>=this.totalRecords){
            this.nxtBtn=true; 
        }
    }
    handlePrevious(event){
        this.startIndex-=this.batchSize;
        this.endIndex-=this.batchSize;
        this.nxtBtn = false;
        if(this.IsPharmacies){
            this.pharmacyRecords = this.records.slice(this.startIndex,this.endIndex);
        }else{
            this.pharmacistRecords = this.records.slice(this.startIndex,this.endIndex);
        }
        if(this.startIndex<=0){
            this.prevBtn = true;
        }
    }
}