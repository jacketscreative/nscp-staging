public class AppRenewalForOwnerEmail2 {
	public static void sendEmail(String recipient, String firstName, String fileName, Blob pdfBlob) {
        try{
            OrgWideEmailAddress[] orgWideEmail = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'registrations@nspharmacists.ca' LIMIT 1];
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] {recipient});
            EmailTemplate emailTemplate = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE Name ='Pharmacy Owner Form Email'];
            
            //Replace template htmlBody value
            String htmlBody = emailTemplate.HtmlValue;
           
            htmlBody = htmlBody.replace('{!customerName}', firstName);
            mail.setHtmlBody(htmlBody);
            mail.setSubject('Pharmacy License Renewal Application');
            
            //Replace template plainBody value
            String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!customerName}', firstName);
            mail.setPlainTextBody(plainBody);
            
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            attachment.setFileName(fileName);
            attachment.setBody(pdfBlob);
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });
            
            // Set the Org-Wide Email Address
            if (!orgWideEmail.isEmpty()) {
                mail.setOrgWideEmailAddressId(orgWideEmail[0].Id);
            }
            
    
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }catch(Exception e){
            System.debug('--email error: '+e.getMessage());
        }
  
    }
}