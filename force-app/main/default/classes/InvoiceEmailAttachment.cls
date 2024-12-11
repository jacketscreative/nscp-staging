public class InvoiceEmailAttachment {
    public Blob generatePDF(String customerName, String street, String city, String state, String postalCode, String invoiceNumber, String paymentMethod, String date2, List<Fee_Line_Item_Template__c> feeItems, List<String> fees) {
        // Create the page reference
        PageReference pdfPage = Page.InvoiceFeeItem;
        
        // Pass parameters to the Visualforce page
        pdfPage.getParameters().put('customerName', customerName);
        pdfPage.getParameters().put('street', street);
        pdfPage.getParameters().put('city', city);
        pdfPage.getParameters().put('street', street);
        pdfPage.getParameters().put('state', state);
        pdfPage.getParameters().put('postalCode', postalCode);
        pdfPage.getParameters().put('invoiceNumber', invoiceNumber);
        pdfPage.getParameters().put('paymentMethod', paymentMethod);
        pdfPage.getParameters().put('date2', date2);
        pdfPage.getParameters().put('fees', convertListToString(fees));
        // Serialize the list of fee items into a JSON string
        String jsonFeeItems = JSON.serialize(feeItems);
        
        // Add the serialized JSON string to the parameters (only String allowed in Map<String, String>)
        pdfPage.getParameters().put('feeItems', jsonFeeItems);
        
        // Serialize the list of fee items into a JSON string
     
        
        // Generate the PDF
        Blob pdfBlob;
        if(Test.isRunningTest()) { 
            pdfBlob = blob.valueOf('Unit.Test');
        } else {
            pdfBlob = pdfPage.getContentAsPDF();
        }
        return pdfBlob;
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