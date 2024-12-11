public class ConditionalButtonController {
    private final ChargentOrders__ChargentOrder__c record;
    public List<Fee__c> fees {get; set;}
    
    
    
    public ConditionalButtonController(ApexPages.StandardController stdController) {
        this.record = (ChargentOrders__ChargentOrder__c) stdController.getRecord();
        this.fees = [SELECT Id, Name, Amount__c, Total_With_HST__c from Fee__c where Payment__r.Id = :this.record.Id];
        
    }
    
    public Boolean getHasFee() {
        return !fees.isEmpty();
    }
    
    
    public PageReference buttonAction() {
        try {
          //  String baseUrl =  URL.getOrgDomainUrl().toExternalForm(); // Get correct base URL
            Site site = [select id , name From Site where Name='NSCP_Registrant_Portal'].get(0) ;
            Domainsite ds = [select id, Domain.Domain  From DomainSite Where SiteId =: site.id].get(0) ;
            String baseUrl = 'https://' + ds.Domain.Domain  ;//{!Get_Domain_Site_To_Build_URL.Domain.Domain} ;
            PageReference p = new PageReference(baseUrl+'/apex/InvoicePDFController?id=' + this.record.Id);
            // PageReference p = new PageReference('/apex/HelloVFP');
            // PageReference p = new PageReference('https://novascotiacollegeofpharmacists.lightning.force.com/apex/InvoicePDFController?id=a0WJQ000000wFBZ2A2');
            p.setRedirect(true);
            return p; 
        } catch (Exception err) {
            System.debug('Error: ' + err.getMessage());
            return null;
        }
    }
    
    
}