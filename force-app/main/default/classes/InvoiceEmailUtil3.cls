public class InvoiceEmailUtil3 {
public static void sendInvoiceEmail(String recipient, String firstName, String ownerName, String paymentLink, String orgName,  String subject, String fileName) {
        OrgWideEmailAddress[] orgWideEmail = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'registrations@nspharmacists.ca' LIMIT 1];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {recipient});
        mail.setSubject(subject);
        EmailTemplate emailTemplate = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE Name ='Payment Request w Invoice'];
        
        //Replace template htmlBody value
        mail.setTargetObjectId('003Aw00000I3ybaIAB');
        
        // Set the email template
        mail.setTemplateId(emailTemplate.Id);
    
    	mail.setWhatId('a0pAw000001Z7KbIAK');
    
        mail.setSaveAsActivity(false);
        
        PageReference pdfPage = Page.InvoiceFeeItem2;
        Blob pdfBlob2 = pdfPage.getContentAsPDF();
        
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setFileName(fileName);
        attachment.setBody(pdfBlob2);
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });
        
        // Set the Org-Wide Email Address
        if (!orgWideEmail.isEmpty()) {
            mail.setOrgWideEmailAddressId(orgWideEmail[0].Id);
        }
        

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
  
    }
}