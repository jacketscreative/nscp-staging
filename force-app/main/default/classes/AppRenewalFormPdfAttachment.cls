public class AppRenewalFormPdfAttachment {
    public Blob generatePDF(String renewalYear, String nscpRegistrationNum, String accountId, List<String> pharmacyStaff, String pharManagerId, String pharOwnerId, String pharOwnerRepId, String providesMethadoneServ, String useOtherPharForPckg, String avgPriscriptionFilled, String totalOpenHour, String avgSchulPharHours, String avgSchulPharTechHours, String avgSchulDispensaryStaffHours, String pharOfferedServ, List<String> directors) {
        try{
            // Create the page reference
            PageReference pdfPage = Page.PharmacyLicenseRenewalApplication;
            
            // Pass parameters to the Visualforce page
            pdfPage.getParameters().put('renewalYear', renewalYear);
            pdfPage.getParameters().put('nscpRegistrationNum', nscpRegistrationNum);
            pdfPage.getParameters().put('accountId', accountId);
            pdfPage.getParameters().put('pharManagerId', pharManagerId);
            pdfPage.getParameters().put('pharOwnerId', pharOwnerId);
            pdfPage.getParameters().put('pharOwnerRepId', pharOwnerRepId);
            pdfPage.getParameters().put('providesMethadoneServ', providesMethadoneServ);
            pdfPage.getParameters().put('useOtherPharForPckg', useOtherPharForPckg);
            pdfPage.getParameters().put('avgPriscriptionFilled', avgPriscriptionFilled);
            pdfPage.getParameters().put('totalOpenHour', totalOpenHour);
            pdfPage.getParameters().put('avgSchulPharHours', avgSchulPharHours);
            pdfPage.getParameters().put('avgSchulPharTechHours', avgSchulPharTechHours);
            pdfPage.getParameters().put('avgSchulDispensaryStaffHours', avgSchulDispensaryStaffHours);
            pdfPage.getParameters().put('pharOfferedServ', pharOfferedServ);
            pdfPage.getParameters().put('pharmacyStaff', convertListToString(pharmacyStaff));
            pdfPage.getParameters().put('directors', convertListToString(directors));
    
            // Generate the PDF
            Blob pdfBlob;
            if(Test.isRunningTest()) { 
                pdfBlob = blob.valueOf('Unit.Test');
            } else {
                pdfBlob = pdfPage.getContentAsPDF();
            }
            return pdfBlob;
        }
        //catch (VisualforceException e) {
        //    System.debug('--Error generating PDF: ' + e.getMessage());
            // Handle Visualforce specific exceptions, if needed
    	//}
        catch (Exception e) {
            System.debug('--Unexpected error: ' + e.getMessage());
        }
        return null; 
    }
    
    public static String convertListToString(List<String> stringList) {
        // Check if the list is null or empty
        if (stringList == null || stringList.isEmpty()) {
            return ''; // Return an empty string if the list is empty or null
        }
        
        // Use String.join() to join the list elements with a semicolon
        return String.join(stringList, ';');
    }
}