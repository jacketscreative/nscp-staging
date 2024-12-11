public class PharLicenRenewalAppEmailService {
	@invocablemethod(label='Generate and send renewal form' description='Send Owner Renewal PDF Form')
	 public static void generateAndSendRenewalForm(List<AppRenwalForOwner> requests) {
         try{
             AppRenwalForOwner request = requests[0];
         
            // Generate the PDF
            Blob pdfBlob = new AppRenewalFormPdfAttachment().generatePDF(request.renewalYear, request.nscpRegistrationNum, request.accountId, request.pharmacyStaff, request.pharManagerId, request.pharOwnerId, request.pharOwnerRepId, request.providesMethadoneServ, request.useOtherPharForPckg, request.avgPriscriptionFilled, request.totalOpenHour, request.avgSchulPharHours, request.avgSchulPharTechHours, request.avgSchulDispensaryStaffHours, request.pharOfferedServ, request.directors);
            
            // Send the email with the generated PDF
            AppRenewalForOwnerEmail2.sendEmail(request.recipientEmail, request.firstName, 'Pharmacy Licence Renewal Application_For Owner.pdf', pdfBlob);
    
            // Upload the PDF to Case  
            ContentVersion cv = new ContentVersion();
            cv.Title = 'ApplicationForm.pdf';
            cv.PathOnClient = '/ApplicationForm.pdf';
            cv.VersionData = pdfBlob;
            cv.FirstPublishLocationId = request.caseId;  // Case ID as Parent

         	
            
            Network network = [SELECT Id FROM Network WHERE Name = 'NSCP Registrant Portal' LIMIT 1];
    
            if (network.Id != null) {
                cv.NetworkId = network.Id;
            } 
        
        	insert cv;
         
         }catch(Exception e){
             System.debug('--Error: ' + e.getMessage());
         }
    }
}