public with sharing class generateCIHIReportController {
    static final String NOT_COLLECTED = 'Not applicable';
    static final string PROVIDER_TYPE = '206';
    static final string NATIONAL_UNIQUE_IDENTIFIER = '9999999999999999999999999999999999999999999999999999999999999998';
    @AuraEnabled(cacheable=false)
    public static List<String> generateCIHIReport(String renewalYear) {
        // Define the object and field set API names
        String cihiRow = '';
        List<String> cihiOutput = new List<String>();
        String objectAPIName = 'CIHI__c';
        String fieldSetName = 'CIHI_Fields';
        String sfAndCIHI_mdt = 'CIHI_and_Salesforce_Field__mdt';
        String CIHI_Master = 'Main_CIHI_Fields__mdt';
        String CIHI_Codes = 'CIHI_Code_and_Value__mdt';
        List<String> fieldList  = new List<String>();
        DateTime currentDt = Datetime.now();
        Map<String,Map<String,String>> CIHiFieldAndValueCodeMap = new Map<String,Map<String,String>>();

        // Get the field set information
        Schema.SObjectType objectType = Schema.getGlobalDescribe().get(objectAPIName);
        Schema.DescribeSObjectResult objectDescribe = objectType.getDescribe();
        Schema.FieldSet fieldSet = objectDescribe.fieldSets.getMap().get(fieldSetName);

        // Retrieve the field set fields
        List<Schema.FieldSetMember> fieldSetMembers = fieldSet.getFields();

        // Create a dynamic query to fetch the fields specified in the field set
        String query = 'SELECT Date_of_Initial_Registration__c,Registration_Status__c,Provider_Registration_Number__c,';
        for (Schema.FieldSetMember fieldSetMember : fieldSetMembers) {
            query += fieldSetMember.getFieldPath() + ', ';
            fieldList.add(fieldSetMember.getFieldPath());
        }
        query = query.removeEnd(', ') + ' FROM ' + objectAPIName+' where Renewal_Year__c=:renewalYear';
        List<CIHI_Code_and_Value__mdt> CIHI_CodeMap = CIHI_Code_and_Value__mdt.getAll().values();
        for(CIHI_Code_and_Value__mdt cvmdt : CIHI_CodeMap){
            if(CIHiFieldAndValueCodeMap.get(cvmdt.Main_CIHI_Field__c) == null){
                CIHiFieldAndValueCodeMap.put(cvmdt.Main_CIHI_Field__c, new Map<String,String>{cvmdt.CIHI_Value__c=>cvmdt.CIHI_Code__c});
            }else{
                CIHiFieldAndValueCodeMap.get(cvmdt.Main_CIHI_Field__c).put(cvmdt.CIHI_Value__c,cvmdt.CIHI_Code__c);
            }
        }
        // Execute the query
        List<CIHI__c> records = Database.query(query);
        cihiOutput.add(getControlRow(renewalYear,records,currentDt));
        for(CIHI__c rec: records){
            Date d = rec.Date_of_Initial_Registration__c;
            cihiRow+=PROVIDER_TYPE+rec.Registration_Status__c+DateTime.newInstance(d.year(), d.month(), d.day()).format('yyyyMM')+NATIONAL_UNIQUE_IDENTIFIER+' '.repeat(16-rec.Provider_Registration_Number__c.length())+rec.Provider_Registration_Number__c;
            for(String fieldName : fieldList){
                System.debug(fieldName);
                try{
                    CIHI_and_Salesforce_Field__mdt csf = CIHI_and_Salesforce_Field__mdt.getInstance(removePostfix(fieldName));
                    if(rec.get(fieldName)==null){
                        cihiRow +=CIHiFieldAndValueCodeMap.get(csf.Main_CIHI_Field__c).get(NOT_COLLECTED);
                    }else{
                        switch on fieldName {
                            when 'Primary_Employer_Organization_Identifier__c','Secondary_Employer_Organization_Identifi__c','Tertiary_Employer_Organization_Identifie__c'{
                                cihiRow+='9999999998';
                            }
                            when  'Concurrent_Reg_Province_Territory__c'{
                                Integer count = 0;
                                for(String str : getFieldValue(rec,fieldName).split(';')){
                                    cihiRow += fetchDataFromMD(CIHiFieldAndValueCodeMap,csf.Main_CIHI_Field__c,str);
                                    count+=1;
                                    if(count==3){
                                        break;
                                    }
                                }
                                if(count<3){
                                    cihiRow+='98'.repeat(3-count);
                                }          
                            }
                            when  'Concurrent_Registration_Country__c'{
                                Integer count = 0;
                                for(String str : getFieldValue(rec,fieldName).split(';')){
                                    cihiRow += fetchDataFromMD(CIHiFieldAndValueCodeMap,csf.Main_CIHI_Field__c,str);
                                    count+=1;
                                    if(count==3){
                                        break;
                                    }
                                }
                                if(count<3){
                                    cihiRow+='998'.repeat(3-count);
                                }          
                            }
                            when 'Year_of_Initial_Registration__c'{
                                cihiRow+=rec.get(fieldName);
                            }
                            when 'Year_of_Birth__c'{
                                cihiRow+=rec.get(fieldName);
                            }
                            when 'Racialized_Group_1__c','Racialized_Group_2__c','Racialized_Group_3__c'{
                                cihiRow+=rec.get(fieldName);
                            }
                            when 'Postal_Code_of_Residence__c','Postal_Code_of_Primary_Employment__c','Postal_Code_of_Secondary_Employment__c','Postal_Code_of_Third_Employment__c'{
                                String tempStr = (String)rec.get(fieldName);
                                tempStr=tempStr.replace(' ','');
                                tempStr = tempStr.replace('-','');
                                if(tempStr.length()!=6){
                                    cihiRow+='999998';
                                }else{
                                    cihiRow+=tempStr.toUpperCase();
                                }
                            }
                            when 'Year_of_Grad_Highest_of_Post_Basic_Edu__c'{
                                cihiRow+=rec.get(fieldName);
                            }
                            when 'Year_of_Grad_Basic_Education_in_Pharmacy__c'{
                                cihiRow+=rec.get(fieldName);
                            }
                            when 'Basic_Education_Institution_Code__c','Highest_Education_Institution_Code__c'{
                                cihiRow+=rec.get(fieldName);
                            }
                            when 'Primary_Employment_Annual_Earned_Hours__c','Secondary_Employment_Annual_Earned_Hours__c','Third_Employment_Annual_Earned_Hours__c'{
                                cihiRow+=' '.repeat(4-calHours(rec,fieldName).length())+calHours(rec,fieldName);
                            }
                            when else {
                                cihiRow += fetchDataFromMD(CIHiFieldAndValueCodeMap,csf.Main_CIHI_Field__c,getFieldValue(rec,fieldName));
                            }
                        }
                    }
                }catch(Exception e){
                    System.debug('Error--'+e.getMessage()+' : '+fieldName);
                }
                System.debug(cihiRow);
            }
            cihiOutput.add(cihiRow);
            cihiRow = '';
        }
        return cihiOutput;
    }

    public static String removePostfix(String fieldName){
        return fieldName.removeEnd('__c');
    }

    public static String getFieldValue(CIHI__c rec, String fieldName){
        return String.valueOf(rec.get(fieldName));
    }
    public static String calHours(CIHI__c rec, String fieldName){
        Decimal d = (Decimal)rec.get(fieldName);
        return String.valueOf(d.intValue()).right(4);
    }
    public static String getControlRow(String renewalYear,List<CIHI__c> records,DateTime currentDt){
        Integer length = String.valueOf(records.size()).length();
        String nOfRecords = '0'.repeat(6-length)+String.valueOf(records.size());
        return 'PHANS001'+renewalYear+nOfRecords+currentDt.format('yyyyMMdd')+'R'+'X'.repeat(363);
    }
    public static String fetchDataFromMD(Map<String,Map<String,String>> CIHiFieldAndValueCodeMap,String CIHIField,String Value){
        if(CIHiFieldAndValueCodeMap.get(CIHIField)!=null){
            if(CIHiFieldAndValueCodeMap.get(CIHIField).get(Value)!=null){
                return CIHiFieldAndValueCodeMap.get(CIHIField).get(Value);
            }else{
                return NOT_COLLECTED;
            } 
        }else{
            return null;
        }
    }
}