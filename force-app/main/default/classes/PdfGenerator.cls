public with sharing class PdfGenerator {
	@AuraEnabled
	public static Registration__c getCertPharmacistLicenseController(String currentRecordId){
		return [SELECT Id, Name, Registrant__r.Name from Registration__c where id = :currentRecordId];
	}

	@AuraEnabled
	public static Registration__c getCertPharmacyTechLicenseController(String currentRecordId){
		return [SELECT Id, Name, Registrant__r.Name from Registration__c where id = :currentRecordId];
	}
	
	@AuraEnabled
	public static Registration__c getCertPharmacyLicenseController(String currentRecordId){
		return [SELECT Id, NSCP_Registration_Number1__c, Registrant__r.Name, Pharmacy_Owner_Account__r.Name, Registrant__r.Pharmacy_Manager__r.FirstName, Registrant__r.Pharmacy_Manager__r.LastName, Registrant__r.BillingStreet,  Registrant__r.BillingCity, Registrant__r.BillingState from Registration__c where id = :currentRecordId];
	}
	
	@AuraEnabled
	public static Registration__c getLetterOfStandingPharmTechController(String currentRecordId){
		return [SELECT Id, Convocation__c, Graduation_Date__c, Name, Registrant__r.Name, Registrant__r.PersonBirthdate, Registrant__r.PersonMailingAddress, Initial_Registration_Date__c, Type__c, toLabel(Class__c), Conditions_on_Licence__c, Authorized_To_Administer_By_Injection__c, Valid_from_Date__c, Expiry_Date__c from Registration__c where id = :currentRecordId];
	}
	
}