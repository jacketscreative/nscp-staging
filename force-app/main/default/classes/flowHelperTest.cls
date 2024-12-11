@isTest
public class flowHelperTest {
    @isTest
    static void unitTest1() {
        List<List<String>> testIds = new List<List<String>>();
        testIds.add(new List<String>{'001Aw00000LMY8bIAH;001Aw00000LMYySIAX'});
        testIds.add(new List<String>{'001Aw00000LMY8bIAH;001Aw00000LMYySIAX'});
        testIds.add(new List<String>{'001Aw00000LMgCbIAL'});
        testIds.add(new List<String>{'001Aw00000LjwAJIAZ;001Aw00000LjwxqIAB;001Aw00000LkFMZIA3'});
        testIds.add(new List<String>{'001Aw00000MkLKzIAN'});
        testIds.add(new List<String>{'001Aw00000MmDpWIAV'});
        testIds.add(new List<String>{'001Aw00000MmEgtIAF;001Aw00000MmmiWIAR'});
        List<List<String>> testIdsRet =  flowHelper.processCompetencyIds(testIds);
    }
}