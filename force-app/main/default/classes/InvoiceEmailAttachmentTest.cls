@IsTest
public class InvoiceEmailAttachmentTest {
    
    @IsTest
    public static void testGeneratePDF() {
        // Set up data for the test
        String customerName = 'John Doe';
        String street = '123 Main St';
        String city = 'Anytown';
        String state = 'CA';
        String postalCode = '12345';
        String invoiceNumber = 'INV-123';
        String paymentMethod = 'Credit Card';
        String date2 = '2024-10-01';
        
        // Create a list of Fee_Line_Item_Template__c records
        List<Fee_Line_Item_Template__c> feeItems = new List<Fee_Line_Item_Template__c>();
        feeItems.add(new Fee_Line_Item_Template__c(Name = 'Service Fee', Amount__c = 100));
        feeItems.add(new Fee_Line_Item_Template__c(Name = 'Late Fee', Amount__c = 50));
        
        // Create a list of fees as strings
        List<String> fees = new List<String>{'100', '200'};
        
        // Instantiate the InvoiceEmailAttachment class
        InvoiceEmailAttachment attachmentGenerator = new InvoiceEmailAttachment();
        
        // Call the generatePDF method
        Blob pdfBlob;
        try {
            pdfBlob = attachmentGenerator.generatePDF(customerName, street, city, state, postalCode, invoiceNumber, paymentMethod, date2, feeItems, fees);
        } catch (Exception e) {
            System.assert(false, 'Error generating PDF: ' + e.getMessage());
        }
        
        // Assert that the PDF blob is not null
        System.assertNotEquals(null, pdfBlob, 'PDF blob should not be null');
        
        // Assert that the PDF blob size is greater than zero (indicating content was generated)
        System.assert(pdfBlob.size() > 0, 'PDF blob size should be greater than zero');
    }
    
    @IsTest
    public static void testConvertListToString() {
        
        // Test with a populated list
        List<String> sampleList = new List<String>{'100', '200', '300'};
        String result = InvoiceEmailAttachment.convertListToString(sampleList);
        System.assertEquals('100;200;300', result, 'List should be joined by semicolons');
        
        // Test with an empty list
        List<String> emptyList = new List<String>();
        result = InvoiceEmailAttachment.convertListToString(emptyList);
        System.assertEquals('', result, 'Empty list should return an empty string');
        
        // Test with a null list
        result = InvoiceEmailAttachment.convertListToString(null);
        System.assertEquals('', result, 'Null list should return an empty string');
    }
}