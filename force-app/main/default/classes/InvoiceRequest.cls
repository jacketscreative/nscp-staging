public class InvoiceRequest {
        @InvocableVariable(required=true)
        public String customerName;
        
        @InvocableVariable(required=false)
        public String street;
        
        @InvocableVariable(required=false)
        public String city;
        
        @InvocableVariable(required=false)
        public String state;
        
        @InvocableVariable(required=false)
        public String postalCode;
        
        @InvocableVariable(required=false)
        public String invoiceNumber;
        
        @InvocableVariable(required=false)
        public String paymentMethod;
        
        @InvocableVariable(required=false)
        public String date2;
    
        @InvocableVariable(required=true)
        public String recipientEmail;
    
        @InvocableVariable(required=true)
        public String subject;
    
        @InvocableVariable(required=true)
        public String body;
    
    	@InvocableVariable(required=true)
        public String ownerName;
    
    	@InvocableVariable(required=true)
        public String paymentLink;
    
    	@InvocableVariable(required=true)
        public String orgName;
        
        @InvocableVariable(required=false)  // Make sure to set the list as not required
        public List<Fee_Line_Item_Template__c> feeItems;
    
    	@InvocableVariable(required=true)
        public String caseId;
    
    	@InvocableVariable(required=true)
        public List<String> fees;
    
    	@InvocableVariable(required=false)
        public String renewalYear;
        
        public static void tempMethod(String temp){
            System.debug(temp);
        }
    }