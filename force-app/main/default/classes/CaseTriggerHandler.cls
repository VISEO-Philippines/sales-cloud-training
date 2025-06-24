public class CaseTriggerHandler {

    public static void assignPriorityCasesToQueue(List<Case> caseList, Map<Id, Case> oldCaseMap) {

        List<Case> highPrioCaseList = new List<Case>();
        Group vipSupportQueueId = [SELECT Id FROM Group WHERE Name = 'VIP Support Queue' AND Type = 'Queue' LIMIT 1];

        for(Case eachCase : caseList){
            if(eachCase.Priority == 'High' && (oldcaseMap == null || oldCaseMap.get(eachCase.Id) == null || oldCaseMap.get(eachCase.Id).Priority != 'High')){
                highPrioCaseList.add(eachCase);
            }
        }

        for(Case eachCase : highPrioCaseList){
            eachCase.OwnerId = vipSupportQueueId.Id;
        }
    }
}