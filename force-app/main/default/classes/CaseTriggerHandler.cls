public with sharing class CaseTriggerHandler {

    private static Id vipSupportQueueId;

    public static void assignHighPriorityCaseToQueue(List<Case> newCases, Map<Id, Case> mapToOldCase) {
        if (vipSupportQueueId == null) {
            vipSupportQueueId = [
                SELECT Id FROM Group WHERE Name = 'VIP Support' AND Type = 'Queue' LIMIT 1
            ].Id;
        }

        for (Case cs : newCases) {
            if (mapToOldCase == null) {
                if (cs.Priority == 'High') {
                    cs.OwnerId = vipSupportQueueId;
                }
            }
            else {
                Case oldCase = mapToOldCase.get(cs.Id);
                if (oldCase.Priority != 'High' && cs.Priority == 'High') {
                    cs.OwnerId = vipSupportQueueId;
                }
            }
        }
    }
}
