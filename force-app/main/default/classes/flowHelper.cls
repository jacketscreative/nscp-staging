public class flowHelper {
    @InvocableMethod(label='Get processed ids' description='Return processed ids')
    public static List<List<String>> processCompetencyIds(List<List<String>> CompetencyTemplateTextCollection) {
        List<List<String>> returnList = new List<List<String>>();
        for(List<String> listOfIds : CompetencyTemplateTextCollection){
            List<String> temp = new List<String>();
            for(String idStr: listOfIds){
                for(String id: idStr.split(';')){
                    temp.add(id);
                }
            }
            returnList.add(temp);
        }
        return returnList;
    }
}