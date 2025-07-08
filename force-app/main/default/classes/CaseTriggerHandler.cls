public with sharing class CaseTriggerHandler {
    public static void caseAssignHighPriority(List<Case> caseList, Map<Id, Case> oldCaseMap) {
        
        List<Case> highPrioCases = new List<Case>();
        for(Case cs : caseList) {
            if(cs.Priority == 'High' && (oldCaseMap == null || oldCaseMap.get(cs.Id) == null || oldCaseMap.get(cs.Id).Priority != 'High')) {
                highPrioCases.add(cs);
            }
        }

        if(highPrioCases.isEmpty()) return;
        
        // VIP Support Queue group for high-priority case assignment
        List<Group> vipQueue = [
            SELECT Id
            FROM Group
            WHERE Name = 'VIP Support Queue' AND Type = 'Queue' LIMIT 1
        ];

        if(vipQueue.isEmpty()) return;

        // assigning case to the VIP Support Queue for high-priority cases
        for(Case cs : highPrioCases) {
            cs.OwnerId = vipQueue[0].Id;
        }
    }
}