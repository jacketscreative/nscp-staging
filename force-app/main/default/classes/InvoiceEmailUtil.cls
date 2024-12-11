public class InvoiceEmailUtil {
	public static void sendInvoiceEmail(String recipient, String firstName, String subject) {
        OrgWideEmailAddress[] orgWideEmail = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'registrations@nspharmacists.ca' LIMIT 1];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {recipient});
        mail.setSubject(subject);
        EmailTemplate emailTemplate = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE Name ='Payment Request With Invoice'];
        
        //Replace template htmlBody value
        String htmlBody = emailTemplate.HtmlValue;
        mail.setHtmlBody(htmlBody);
       
        
		mail.setSubject('5:15 test subject');
        
        // Set the Org-Wide Email Address
        if (!orgWideEmail.isEmpty()) {
            mail.setOrgWideEmailAddressId(orgWideEmail[0].Id);
        }
        
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
  
    }
}