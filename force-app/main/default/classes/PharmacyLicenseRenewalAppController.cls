public without sharing class PharmacyLicenseRenewalAppController {
    public String formattedDate { get; set; }
    
	public Account pharmacy { get; set; }
    public Contact pharManager { get; set; }
    public Account pharmacyOwner { get; set; }
    public Contact pharOwnerRep { get; set; }
    
    public String offeredServices { get; set; }
    public List<String> staffMember { get; set; }
    public List<String> directors { get; set; }
    
    

    public PharmacyLicenseRenewalAppController() {
        try{
            formattedDate = DateTime.now().format('MM/dd/yyyy');
        
            String accountId = ApexPages.currentPage().getParameters().get('accountId');
            
            if (!String.isBlank(accountId)) {
                pharmacy = [SELECT Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, Phone, Email__c, Website, Fax from Account where Id = :accountId];
            }
            
            String pharManagerId = ApexPages.currentPage().getParameters().get('pharManagerId');
            
            if (!String.isBlank(pharManagerId)) {
                pharManager = [SELECT Id, Name, Email from Contact  where Id = :pharManagerId];
            }  
            
            String pharOwnerId = ApexPages.currentPage().getParameters().get('pharOwnerId');
            
            if (!String.isBlank(pharOwnerId)) {
                pharmacyOwner = [SELECT Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, Email__c from Account where Id = :pharOwnerId];
            }
            
            String pharOwnerRepId = ApexPages.currentPage().getParameters().get('pharOwnerRepId');
            
            if (!String.isBlank(pharOwnerRepId)) {
                pharOwnerRep = [SELECT Id, Name, MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry, Email from Contact where Id = :pharOwnerRepId];
            }
            
            offeredServices = formatOffering(ApexPages.currentPage().getParameters().get('pharOfferedServ'));
            staffMember = formatEmployees(ApexPages.currentPage().getParameters().get('pharmacyStaff'));
            directors = formatEmployees(ApexPages.currentPage().getParameters().get('directors'));

        } catch(Exception e){
            System.debug('--vfp controller error: '+e.getMessage());
        }
        
        
    }
    
	public void setStaffMember(List<String> staffMember) {
        this.staffMember = staffMember;
    }

    public String formatOffering(String unformattedString) {
        // Check if the input string is null or empty
        if (String.isEmpty(unformattedString)) {
            return '';
        }
        
        // Split the input string by semicolon
        List<String> splitStrings = unformattedString.split(';');
        
        // Trim each splitString and prepare for output
        List<String> formattedString = new List<String>();
        for (String splitString : splitStrings) {
            formattedString.add(splitString.trim());
        }
        
        // Join the formatted splitStrings with a comma and space
        return String.join(formattedString, ', ');
	}
    

    public List<String> formatEmployees(String unformattedString) {
        // Check if the input string is null or empty
        if (String.isEmpty(unformattedString)) {
            return new List<String>();
        }
        
        // Split the input string by semicolon
        List<String> splitStrings = unformattedString.split(';');
        
        // Create a new list to hold the formatted splitString names
        List<String> formattedString = new List<String>();
        for (String splitString : splitStrings) {
            // Trim each splitString and convert to lowercase
            formattedString.add(splitString.trim());
        }
        
        return formattedString;
    }
}