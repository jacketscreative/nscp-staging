public class InvoiceFeeLineItemService2 {
     @invocablemethod(label='Generate and send invoice2')
	 public static void generateAndSendInvoice(List<InvoiceRequest> requests) {
        InvoiceRequest request = requests[0];
         
        // Generate the PDF
        //Blob pdfBlob = new InvoiceEmailAttachment().generatePDF(request.customerName, request.street, request.city, request.state, request.postalCode, request.invoiceNumber, request.paymentMethod, request.date2, request.feeItems, '2025');
        
        // Send the email with the generated PDF
        InvoiceEmailUtil.sendInvoiceEmail(request.recipientEmail, request.customerName, 'test subject');
         
        // Upload the PDF to Case  
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Invoice.pdf';
        cv.PathOnClient = '/Invoice.pdf';

        cv.FirstPublishLocationId = request.caseId;  // Case ID as Parent
         
        Network network = [SELECT Id FROM Network WHERE Name = 'NSCP Registrant Portal' LIMIT 1];

        if (network.Id != null) {
        	cv.NetworkId = network.Id;
        }
         
        //insert cv;  
        
    }
  
           
}