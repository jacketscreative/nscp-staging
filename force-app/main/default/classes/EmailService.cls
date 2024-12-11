public class EmailService {
    public static void sendInvoiceEmail(String recipient, String subject, String body, String fileName, Blob pdfBlob) {
        OrgWideEmailAddress[] orgWideEmail = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'registrations@nspharmacists.ca' LIMIT 1];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {recipient});
        mail.setSubject(subject);
        mail.setHtmlBody(body);
        
        // Set the Org-Wide Email Address
        if (!orgWideEmail.isEmpty()) {
            mail.setOrgWideEmailAddressId(orgWideEmail[0].Id);
        }
        
        // Attach PDF to the email
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setFileName(fileName);
        attachment.setBody(pdfBlob);
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        
    }
}