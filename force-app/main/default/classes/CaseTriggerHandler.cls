public with sharing class CaseTriggerHandler {
    public static void caseAssignHighPriority(List<Case> caseList) {
        // Creating a VIP Support Queue group for high-priority case assignment
        Group vipQueue = [
            SELECT Id
            FROM Group
            WHERE Name = 'VIP Support Queue' AND Type = 'Queue' LIMIT 1
        ];

        // assigning case to the VIP Support Queue for high-priority cases
        for (Case cs : caseList) {
            if (cs.Priority == 'High') {
                cs.OwnerId = vipQueue.Id;
            }
        }
    }
}