@isTest
public class AppRenewalFormPdfAttachmentTest {
    
    @isTest
    static void testGeneratePDF() {
         // Set up the Visualforce page in test context
        PageReference pdfPage = Page.PharmacyLicenseRenewalApplication;
        Test.setCurrentPage(pdfPage);

        // Initialize test data
        String renewalYear = '2024';
        String nscpRegistrationNum = '12345';
        String accountId = '001XXXXXXXXXXXXXXX';
        List<String> pharmacyStaff = new List<String>{'Staff1', 'Staff2'};
        String pharManagerId = '005XXXXXXXXXXXXXXX';
        String pharOwnerId = '005XXXXXXXXXXXXXXX';
        String pharOwnerRepId = '005XXXXXXXXXXXXXXX';
        String providesMethadoneServ = 'Yes';
        String useOtherPharForPckg = 'No';
        String avgPriscriptionFilled = '75';
        String totalOpenHour = '24';
        String avgSchulPharHours = '10';
        String avgSchulPharTechHours = '8';
        String avgSchulDispensaryStaffHours = '6';
        String pharOfferedServ = 'Room Service, Laundry';
        List<String> directors = new List<String>{'Director1', 'Director2'};

        // Instantiate the class under test
        AppRenewalFormPdfAttachment pdfAttachment = new AppRenewalFormPdfAttachment();
        
        // Call the method and capture the result
        Blob pdfBlob = pdfAttachment.generatePDF(
            renewalYear,
            nscpRegistrationNum,
            accountId,
            pharmacyStaff,
            pharManagerId,
            pharOwnerId,
            pharOwnerRepId,
            providesMethadoneServ,
            useOtherPharForPckg,
            avgPriscriptionFilled,
            totalOpenHour,
            avgSchulPharHours,
            avgSchulPharTechHours,
            avgSchulDispensaryStaffHours,
            pharOfferedServ,
            directors
        );

        // Verify the PDF Blob is not null, indicating the PDF generation was successful
        System.assertNotEquals(null, pdfBlob, 'The PDF Blob should not be null');
    }

    @isTest
    static void testConvertListToString() {
        // Test data
        List<String> sampleList = new List<String>{'Value1', 'Value2', 'Value3'};
        String expectedString = 'Value1;Value2;Value3';
        
        // Call the convertListToString method
        String result = AppRenewalFormPdfAttachment.convertListToString(sampleList);
        
        // Verify the conversion result matches the expected output
        System.assertEquals(expectedString, result, 'The conversion result should match the expected output');
    }

    @isTest
    static void testConvertListToStringWithEmptyList() {
        // Test with an empty list
        List<String> emptyList = new List<String>();
        
        // Call the convertListToString method
        String result = AppRenewalFormPdfAttachment.convertListToString(emptyList);
        
        // Verify the result is an empty string
        System.assertEquals('', result, 'The result should be an empty string for an empty list');
    }

    @isTest
    static void testGeneratePDFWithNullList() {
        // Test case with null list parameters
        AppRenewalFormPdfAttachment pdfAttachment = new AppRenewalFormPdfAttachment();
        
        Blob pdfBlob = pdfAttachment.generatePDF(
            '2025',
            '67890',
            '001XXXXXXXXXXXXXXX',
            null, // null pharmacyStaff
            '005XXXXXXXXXXXXXXX',
            '005XXXXXXXXXXXXXXX',
            '005XXXXXXXXXXXXXXX',
            'Yes',
            'No',
            '85',
            '20',
            '8',
            '5',
            '4',
            'Medicine, Injection',
            null // null directors
        );
        
        // Verify the PDF Blob is not null
        System.assertNotEquals(null, pdfBlob, 'The PDF Blob should not be null');
    }
}