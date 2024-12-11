global class terrabbitMultiSelectFlowValuesBulk {

   @InvocableMethod
   public static List<list<string>> CheckValues(List<string> values) {
       
       List<list<string>> finalLst = new List<list<string>>();
       for(String multiSelectString : values){
           if(!String.isBlank(multiSelectString)){
               List<String> lstnew = multiSelectString.split(';');
               finalLst.add(lstnew);
           }else{
               finalLst.add(new list<string>());
           }
       }
       return finalLst;
   }

}