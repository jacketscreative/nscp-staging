import { LightningElement, track, wire } from 'lwc';
import generateCIHIReport from '@salesforce/apex/generateCIHIReportController.generateCIHIReport';
import JSZipResource from './jszip';;
// import { loadScript } from 'lightning/platformResourceLoader';
const startYear = 2025;
export default class GenerateCihiReport extends LightningElement {
    value = ''; // To store the selected value
    @track options = [];
    cihiRows = '';
    connectedCallback(){
        let currentDate = new Date();
        this.value = currentDate.getFullYear()+1;
        console.log('hello')
        for(let i=0;i<10;i++){
            if(this.value-i<2025){
                break;
            }else{
                const option = {
                    label:this.value-i,
                    value:this.value-i
                }
                this.options = [ ...this.options, option ];
            }
        }
    }

    // Handle change of combobox selection
    handleChange(event) {
        this.value = event.target.value;
    }

    // Handle button click
    handleSubmit() {
        console.log('Selected Value:', this.value);
        // Add any logic for submission here
        generateCIHIReport({ renewalYear: this.value })
		.then(result => {
			this.cihiRows = result;
			this.error = undefined;
            console.log(this.cihiRows);
            this.downloadZippedFile();
		})
		.catch(error => {
			this.error = error;
			this.accounts = undefined;
            console.log('Failure');
		})
    }

    generateFile(){
        return this.cihiRows.join('\n');
    }
    downloadZippedFile() {

        // Generate CSV data from the records
        const txtContent = this.generateFile(this.cihiRows);

        // Create a new zip file
        const zip = new JSZipResource();

        // Add CSV file to the zip
        zip.file(this.generateFileName('.txt'), txtContent);

        // Generate the zip file asynchronously
        zip.generateAsync({ type: 'blob' })
            .then(content => {
                // Create a downloadable link for the zip file
                const link = document.createElement('a');
                link.href = URL.createObjectURL(content);
                link.download = this.generateFileName('.zip');  // Set the downloaded file's name
                link.click();  // Trigger the download
            })
            .catch(error => {
                console.error('Error generating zip file', error);
            });
    }
    generateFileName(fileExt){
        var curDate = new Date();
        var orgIdentifier = 'A4926';
        var Version = '001';
        return 'HHR'+curDate.getFullYear()+'00'+orgIdentifier+'NS'+'07'+Version+fileExt;
    }
}