import {LightningElement, api} from 'lwc';
import {loadScript} from "lightning/platformResourceLoader";

// Static resources
import JSPDF from '@salesforce/resourceUrl/jspdf_latest';
import signatureImage from '@salesforce/resourceUrl/signatureImageTrans';
import logoImage from '@salesforce/resourceUrl/NSCP_Logo_wMission';

// DB call
import getLetterOfStandingPharmTechController from '@salesforce/apex/PdfGenerator.getLetterOfStandingPharmTechController';
export default class Let_std_act_lic extends LightningElement {
	@api recordId;
  
	currentRecordId;

	connectedCallback() {
		this.currentRecordId = this.recordId;
	}

	renderedCallback() {
		Promise.all([
			loadScript(this, JSPDF),
			fetch(signatureImage).then(response => response.blob()),
			fetch(logoImage).then(response => response.blob()),
		])
		.then(([jspdf, signatureBlob, logoBlob]) => {
			const signatureReader = new FileReader();
            signatureReader.readAsDataURL(signatureBlob);
            signatureReader.onloadend = () => {
                this.signatureDataURL = signatureReader.result;
            };

			const logoReader = new FileReader();
			logoReader.readAsDataURL(logoBlob);
            logoReader.onloadend = () => {
                this.logoDataURL = logoReader.result;
            };
        });
	}

	async generatePdf(){
		let result;
		try{
			result = await getLetterOfStandingPharmTechController({currentRecordId: this.currentRecordId});
		}
		catch(err){
			console.log('api call err', err);
		}

		try{

		const { jsPDF } = window.jspdf;
		const doc = new jsPDF('p', 'mm', [279.4, 215.9]);

		// Define margins
        const margin = {
            top: 30,
            right: 10,
            bottom: 20,
            left: 50
		};

		const pageWidth = doc.internal.pageSize.getWidth();

		let yPos = margin.top;


		// Logo Image
        const imageHeight = 25; // Set the desired height for the image
		const imageWidth = 140; // Set the desired width for the image
        const imageX = (pageWidth - imageWidth) / 2;
		doc.addImage(this.logoDataURL, 'PNG', imageX, yPos - imageHeight/2, imageWidth, imageHeight);
		yPos += 30;


		// TITLE
		let xLine = 30;
		doc.setFontSize(18);
		doc.setTextColor("#3598db");
		doc.text("Letter of Standing", xLine, yPos);

		//TABLE 1
		yPos += 13;
		doc.setFontSize(11);
		doc.setTextColor("#000000");

		const today  = new Date();

		let _address = [
			result?.Registrant__r?.PersonMailingAddress?.street, 
			result?.Registrant__r?.PersonMailingAddress?.city, 
			result?.Registrant__r?.PersonMailingAddress?.province,
			result?.Registrant__r?.PersonMailingAddress?.postalCode
		  ].filter(Boolean).join(', ');

		const tableDataTop = [
            ["Date:", today.toLocaleDateString("en-US", { month: '2-digit', day: '2-digit', year: 'numeric' })],
            ["Regarding:", result?.Registrant__r?.Name ?? ''],
            ["Registration No:", result?.Name ?? ''],
            ["Date of Birth:", this.convertDate(result?.Registrant__r?.PersonBirthdate) ?? ''],
            ["Address:", _address],
        ];


		let startX = xLine;
		// const rowHeight = 7;
        const colWidth = 60;

        // Loop through each row
        tableDataTop.forEach((row) => {
            // Loop through each column
            row.forEach((cell, colIndex) => {
                // Calculate the X position for each cell
                const cellX = startX + colIndex * colWidth;
                // const cellY = yPos + rowIndex * rowHeight;

				if (colIndex === 1 && row[0] === "Address:") {
					// Wrap long text for Address field
					const wrappedText = doc.splitTextToSize(cell, (pageWidth - (margin.right + margin.left + colWidth)));
					doc.text(wrappedText, cellX, yPos);
		
					// Adjust row height based on the number of lines
					// already yPos += 7 is calculated for 1 line, so we just need to increase the yPos for consecutive lines
					yPos += (wrappedText.length - 1) * 3;
					// maxHeight = Math.max(maxHeight, textHeight);
				} else {
					// For other fields, just add the text normally
					doc.text(cell, cellX, yPos);
				}
            });
			yPos += 7;
        });

		// DRAW LINE
		doc.setDrawColor(128, 128, 128); 

		doc.line(startX, yPos, startX + (pageWidth - (margin.right + margin.left)), yPos);

		// TABLE 2 - First Part
		const tableDataBottom = [
            ["Convocation:", `${result?.Convocation__c ?? ''}, ${this.fetchYear(result?.Graduation_Date__c) ?? ''}`],
			["Initial NSCP Registration Date:", this.convertDate(result?.Initial_Registration_Date__c ?? '')],
            ["Current Status:", `${result?.Type__c ?? ''}, ${result?.Class__c ?? ''}`],
            ["Conditions on Licence:", result?.Conditions_on_Licence__c ?? ''],
        ];

		yPos+=10;
        // Loop through each row
        tableDataBottom.forEach((row) => {
            // Loop through each column
            row.forEach((cell, colIndex) => {
                // Calculate the X position for each cell
                const cellX = startX + colIndex * colWidth;

                // Add text to the cell
                doc.text(cell, cellX, yPos);
            });
			yPos += 7;
        });

		// TABLE 2 - Second Part
		const tableDataBottomSecPart = [
            ["Authorized to Administer Drug \nTherapy by Injection: ", result?.Authorized_To_Administer_By_Injection__c ?? ''],
            ["Licence/Registration Valid \nFrom/To:", `${this.convertDate(result?.Valid_from_Date__c)} - ${this.convertDate(result?.Expiry_Date__c)}`],
        ];

		// yPos+=5;
        // Loop through each row
        tableDataBottomSecPart.forEach((row) => {
            // Loop through each column
            row.forEach((cell, colIndex) => {
                // Calculate the X position for each cell
                const cellX = startX + colIndex * colWidth;

                // Add text to the cell
                doc.text(cell, cellX, yPos);
            });
			yPos += 12;
        });

		//Passage 1
		
		const para1 = `${result?.Registrant__r?.Name ?? ''} is currently a practicing member with the Nova Scotia College of Pharmacists and is entitled to practice pharmacy in a direct patient care setting without conditions in Nova Scotia until ${this.convertDate(result?.Expiry_Date__c) ?? ''}.`
        let textWidth = pageWidth - margin.left - margin.right;
		const para1Lines = doc.splitTextToSize(para1, textWidth);
		yPos+=5;
		doc.setFontSize(10.5);
		doc.setFont('helvetica', 'italic');
		para1Lines.forEach((line) => {
            // Calculate the x position to center the line
            const textWidthLine = doc.getTextWidth(line);
            const textX = (pageWidth - textWidthLine) / 2;
            doc.text(line, textX, yPos);
			yPos += 5;
        });
		
		//Passage 2
		const para2 = [
			"The pharmacy professional information reported in this letter is accurate as of the date it",
			"was issued and is subject to change.To confirm a pharmacy professional's standing with",
			"the College please refer to the member's profile on \"Find a Practitioner / Pharmacy\" at",
        ];
		yPos+=5;
		doc.setFontSize(10.5);
		doc.setFont('helvetica', 'normal');
        para2.forEach((line) => {
            const textWidth = doc.getTextWidth(line);
            const textX = (pageWidth - textWidth) / 2;
            doc.text(line, textX, yPos);
			yPos += 5; // Increment y position for each line
        });


		// Link 
		doc.setTextColor("#0000ff");
		const linkText = "www.nspharmacists.ca"
		textWidth = doc.getTextWidth(linkText);
		const xPoint = (pageWidth - textWidth) / 2
		doc.text(linkText, xPoint, yPos);

		yPos += 0.5;
		doc.setDrawColor("#0000ff");
		doc.line(xPoint, yPos, xPoint + textWidth, yPos);

		// Reset text and line color to black
		doc.setTextColor("#000000");
		doc.setDrawColor("#000000");

		// Signature - Left
		yPos += 3;

		// Sign Image
		const signatureImageHeight = 20; // Adjust as needed
        const signatureImageWidth = 50;
		doc.addImage(this.signatureDataURL, 'JPEG', xLine, yPos, signatureImageWidth, signatureImageHeight);

		// Sign Line
		yPos+=20;
		const yPosTemp = yPos;
		doc.line(xLine, yPos, xLine + 70, yPos);


		// Sign Text
		yPos+=4;
		const signatureTexts = ["Beverley Zwicker", "CEO and Registrar"];
		signatureTexts.forEach((line) => {
            const textWidth = doc.getTextWidth(line);
            const textX = (pageWidth - textWidth) / 2;
            doc.text(line, xLine, yPos);
			yPos += 4; // Increment y position for each line
        });
        
		// Signature Date - Right
		doc.text(today.toLocaleDateString("en-US", { month: '2-digit', day: '2-digit', year: 'numeric' }), xLine + 72, yPosTemp-2);
		doc.line(xLine + 72, yPosTemp, xLine + 155, yPosTemp);
		doc.text("Date", xLine + 72, yPosTemp+4);

		// footer
		const footer = [
			"Nova Scotia College of Pharmacists, 800 - 1801 Hollis Street, Halifax, NS B3J 3N4",
			"Phone: (902) 422-8528 Fax: (902) 701-3540 Email: registrations@nspharmacists.ca",
        ];
		yPos+=12;
		doc.setFontSize(11);
        footer.forEach((line) => {
            const textWidth = doc.getTextWidth(line);
            const textX = (pageWidth - textWidth) / 2;
            doc.text(line, textX, yPos);
			yPos += 4.5; // Increment y position for each line
        });

		doc.save("Letter of Standing Active Licensee.pdf");
		}
		catch(err){
			console.log('Stack trace', err.stack);
		}
	}

	convertDate(dateString='') {
		if (!dateString) {
			return '';
		}
		let parts = dateString.split('-');
	
		let formattedDate = `${parts[1]}/${parts[2]}/${parts[0]}`;
	
		return formattedDate;
	}

	fetchYear(dateString) {
		if (!dateString) {
			return '';
		}
		let parts = dateString.split('-');
		return parts[0];
	}

}