public class ContactUtils {
    public static Map<Id, Integer> getOpportunityCountByContact(List<Contact> contacts) {
        Map<Id, Integer> contactToOppCount = new Map<Id, Integer>();

        //Get all related AccountIds
        Set<Id> accountIds = new Set<Id>();
        for(Contact c : contacts){
            if(c.AccountId != null){
                accountIds.add(c.AccountId);
            }
        }

        //Query all Opportunities related to those Accounts
        Map<Id, Integer> accountToOppCountMap = new Map<Id, Integer>();
        for(AggregateResult result : [SELECT AccountId, COUNT(Id) totalOpps
                                    FROM Opportunity 
                                    WHERE AccountId IN :accountIds
                                    GROUP BY AccountId]){
            accountToOppCountMap.put((Id)result.get('AccountId'), (Integer)result.get('totalOpps'));
                                    }
                                    


        //Map back to Contacts
        for(Contact c:contacts){
            Integer count = 0;
            if(c.AccountId != null && accountToOppCountMap.containsKey(c.AccountId)){
                count = accountToOppCountMap.get(c.AccountId);
            }
            contactToOppCount.put(c.Id, count);
        }

        return contactToOppCount;
    }
}
