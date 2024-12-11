public class AppRenwalForOwner {
    	@InvocableVariable(required=true)
        public String firstName;
   		
    	@InvocableVariable(required=true)
        public String renewalYear;
        
        @InvocableVariable(required=false)
        public String accountId;
    
        @InvocableVariable(required=false)
        public String nscpRegistrationNum;
        
        @InvocableVariable(required=false)
        public List<String> pharmacyStaff;
        
        @InvocableVariable(required=false)
        public String pharManagerId;
        
        @InvocableVariable(required=false)
        public String pharOwnerId;
        
        @InvocableVariable(required=false)
        public String pharOwnerRepId;
        
        @InvocableVariable(required=false)
        public String providesMethadoneServ;
        
    	@InvocableVariable(required=false)
        public String useOtherPharForPckg;
    
        @InvocableVariable(required=false)
        public String avgPriscriptionFilled;
    
        @InvocableVariable(required=false)
        public String totalOpenHour;
    
        @InvocableVariable(required=false)
        public String avgSchulPharHours;
    
        @InvocableVariable(required=false)
        public String avgSchulPharTechHours;
        
        @InvocableVariable(required=false)
        public String avgSchulDispensaryStaffHours;
    
    	@InvocableVariable(required=false)
        public String pharOfferedServ;
    
    	@InvocableVariable(required=true)
        public String recipientEmail;
    
        @InvocableVariable(required=false)
        public List<String> directors;
    
    	@InvocableVariable(required=true)
        public String caseId;
        

}