public class AppRenewalForOwner {
    @InvocableVariable(required=true)
    public String firstName;
    
	@InvocableVariable(required=true)
    public Integer renewalYear;
    
    @InvocableVariable(required=true)
    public String accountId;
    
    @InvocableVariable(required=true)
    public String nscpRegistrationNum;
    
    @InvocableVariable(required=true)
    public List<String> pharStaffNames;
    
    @InvocableVariable(required=true)
    public String pharManagerId;
    
    @InvocableVariable(required=true)
    public String pharOwnerId;
    
    @InvocableVariable(required=true)
    public String pharOwnerRepId;
    
    @InvocableVariable(required=true)
    public String providesMethdoneServ;
    
    @InvocableVariable(required=true)
    public Integer usesServOfOtherPharForPackg;
    
    @InvocableVariable(required=true)
    public Integer totalOpenHours;
    
    @InvocableVariable(required=true)
    public Integer avgSchulPharmacistHours;
    
    @InvocableVariable(required=true)
    public Integer avgSchulPharmacyTechHours;
    
    @InvocableVariable(required=true)
    public Integer avgSchulDispenseStaffHours;
    
    @InvocableVariable(required=true)
    public String pharOfferedServ;
    
}