public with sharing class CaseTriggerHandler {

    // Cache the queue Id to avoid repeated SOQL
    private static Id vipSupportQueueId;

    public static void assignHighPriorityCaseToQueue(List<Case> newCases, Map<Id, Case> mapToOldCase) {
        if (vipSupportQueueId == null) {
            vipSupportQueueId = [
                SELECT Id FROM Group WHERE Name = 'VIP Support' AND Type = 'Queue' LIMIT 1
            ].Id;
        }

        for (Case cs : newCases) {
            // INSERT: old map is null, so check new case directly
            if (mapToOldCase == null) {
                if (cs.Priority == 'High') {
                    cs.OwnerId = vipSupportQueueId;
                }
            }
            // UPDATE: compare new vs old
            else {
                Case oldCase = mapToOldCase.get(cs.Id);
                if (oldCase.Priority != 'High' && cs.Priority == 'High') {
                    cs.OwnerId = vipSupportQueueId;
                }
            }
        }
    }
}
