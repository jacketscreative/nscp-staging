public with sharing class publicSearchDataService {

    @AuraEnabled(cacheable=true)
    public static List<Registration__c> getPharmacyRecords(Boolean filter,String licenseNumber,String Address,String City,String Street){
        Id rcdTypeId = publicSearchDataService.getRecordTypeId('Pharmacy');
        String licenseNumb = String.isNotBlank(licenseNumber)?licenseNumber:null;
        String regStatus = 'Active';
        String queryStr = 'Select id,Expiry_Date__c,Registrant__r.Name,Registrant__r.BillingAddress, Registrant__r.Phone, Registrant__r.Fax,NSCP_Registration_Number1__c from Registration__c where RecordTypeId =:rcdTypeId and Registration_Status__c =: regStatus';
        String searchTerm = String.isNotBlank(Address)?'%'+Address+'%':null;
        String searchCity = String.isNotBlank(City)?'%'+City+'%':null;
        String searchStreet = String.isNotBlank(Street)?'%'+Street+'%':null;
        String tempQuery = '';
        if(filter){
            return Database.query(queryStr);
        }else{
            if(licenseNumb!=null && (String.isNotBlank(Address) || String.isNotBlank(City) || String.isNotBlank(Street))){
                tempQuery='NSCP_Registration_Number1__c =:licenseNumb or (Registrant__r.BillingCountry like :searchTerm or Registrant__r.BillingCity like :searchCity or Registrant__r.BillingStreet like :searchStreet)';
            }else if(licenseNumb!=null){
                tempQuery='NSCP_Registration_Number1__c =:licenseNumb';
            }else if(String.isNotBlank(Address) && String.isNotBlank(City) && String.isNotBlank(Street)){
                tempQuery='Registrant__r.BillingCountry like :searchTerm or Registrant__r.BillingCity like :searchCity or Registrant__r.BillingStreet like :searchStreet';
            }else if(String.isNotBlank(Address) && String.isNotBlank(City)){
                tempQuery='Registrant__r.BillingCountry like :searchTerm or Registrant__r.BillingCity like :searchCity';
            }else if(String.isNotBlank(City) && String.isNotBlank(Street)){
                tempQuery='Registrant__r.BillingCity like :searchCity or Registrant__r.BillingStreet like :searchStreet';
            }else if(String.isNotBlank(Address) && String.isNotBlank(Street)){
                tempQuery='Registrant__r.BillingCountry like :searchTerm or Registrant__r.BillingStreet like :searchStreet';
            }else if(String.isNotBlank(Address)){
                tempQuery='Registrant__r.BillingCountry like :searchTerm';
            }else if(String.isNotBlank(City)){
                tempQuery='Registrant__r.BillingCity like :searchCity';
            }else if(String.isNotBlank(Street)){
               tempQuery='Registrant__r.BillingStreet like :searchStreet';
            }else{
                return new List<Registration__c>();
            }
            System.debug(queryStr + ' and ' +tempQuery);
            return Database.query(queryStr + ' and ' +'('+tempQuery+')');
        }
    }
    @AuraEnabled(cacheable=true)
    public static List<Registration__c> getPharmacistRecords(Boolean filter,String licenseNumber,String firstName,String lastName){
        Id rcdTypeId = publicSearchDataService.getRecordTypeId('Practitioner');
        Set<String> types = new Set<String>{'Pharmacist','Pharmacy Technician'};
        String regStatus = 'Active';
        String regClass = 'Non-Practicing';
        String queryStr = 'Select id,Name,Type__c,Registration_Status__c,toLabel(Class__c),Expiry_Date__c,Registrant__r.FirstName,Registrant__r.LastName,Conditions_on_Licence__c,Authorized_To_Administer_By_Injection__c from Registration__c where RecordTypeId=:rcdTypeId and Type__c in:types and Registration_Status__c =:regStatus and Class__c!=:regClass and Expiry_Date__c >= TODAY';
        String searchTermFN = '%'+firstName+'%';
        String searchTermLN = '%'+lastName+'%';
        String licenseNumb = String.isNotBlank(licenseNumber)?licenseNumber:null;
        String tempQuery = '';
        if(filter){
            return Database.query(queryStr+' order by Registrant__r.LastName');
        }else if(licenseNumb!=null && (String.isNotBlank(firstName) || String.isNotBlank(lastName))){
            System.debug('all good');
            tempQuery=' Name =:licenseNumb or Registrant__r.FirstName like :searchTermFN or Registrant__r.LastName like :searchTermLN';
        }else if(licenseNumb != null){
            System.debug('license good');
            tempQuery=' Name =:licenseNumb';
        }else if(String.isNotBlank(firstName) || String.isNotBlank(lastName)){
            System.debug('first name or last name good');
            if(String.isNotBlank(firstName) && String.isNotBlank(lastName)){
                tempQuery=' Registrant__r.FirstName like :searchTermFN or Registrant__r.LastName like :searchTermLN';
            }else if(String.isNotBlank(firstName)){
                tempQuery=' Registrant__r.FirstName like :searchTermFN';
            }else if(String.isNotBlank(lastName)){
                tempQuery=' Registrant__r.LastName like :searchTermLN';
            }
        }else{
            return new List<Registration__c>();
        }
        return Database.query(queryStr+' and ' +'('+tempQuery+')'+' order by Registrant__r.LastName ASC');
    }

    public static id getRecordTypeId(String recordTypeName){
        return Schema.Sobjecttype.Registration__c.getRecordTypeInfosByDeveloperName().get(recordTypeName).getRecordTypeId();
    }
}