public class InvoiceEmailUtil2 {
	public static void sendInvoiceEmail(String recipient, String firstName, String ownerName, String paymentLink, String orgName,  String subject, String fileName, Blob pdfBlob, String renewalYear) {
        OrgWideEmailAddress[] orgWideEmail = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'registrations@nspharmacists.ca' LIMIT 1];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {recipient});
        EmailTemplate emailTemplate = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE Name ='Payment Request With Invoice'];
        
        //Replace template htmlBody value
        String htmlBody = emailTemplate.HtmlValue;
       
        htmlBody = htmlBody.replace('{!ChargentOrders__Payment_Request__c.ChargentOrders__Billing_Contact__c}', firstName);
        htmlBody = htmlBody.replace('{!ChargentOrders__ChargentOrder__c.OwnerFullName}', ownerName);
        htmlBody = htmlBody.replace('{!ChargentOrders__Payment_Request__c.ChargentOrders__Payment_Link_Formatted__c}', paymentLink);
        htmlBody = htmlBody.replace('{!Organization.Name}', orgName);        
        mail.setHtmlBody(htmlBody);
		
        //Replace template plainBody value
        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{!ChargentOrders__Payment_Request__c.ChargentOrders__Billing_Contact__c}', firstName);
        plainBody = plainBody.replace('{!ChargentOrders__ChargentOrder__c.OwnerFullName}', ownerName);
        plainBody = plainBody.replace('{!ChargentOrders__Payment_Request__c.ChargentOrders__Payment_Link_Formatted__c}', paymentLink);
        plainBody = plainBody.replace('{!Organization.Name}', orgName);
        //mail.setPlainTextBody(plainBody);
        
        
        String subjectFormatted = 'Amount Owing - ' + renewalYear + ' - renewal application';
		mail.setSubject(subjectFormatted);
        
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setFileName(fileName);
        attachment.setBody(pdfBlob);
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });
        
        // Set the Org-Wide Email Address
        if (!orgWideEmail.isEmpty()) {
            mail.setOrgWideEmailAddressId(orgWideEmail[0].Id);
        }
        

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
  
    }
}