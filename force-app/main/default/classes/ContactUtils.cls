public class ContactUtils {
    
    public static Integer getOppsFromContact(List<Contact> listOfContacts){

        Set<Id> accountIds = new Set<Id>();
        
        for(Contact con : listOfContacts){
            if(con.AccountId != null){
                accountIds.add(con.accountId);
            }
        }

        List<AggregateResult> oppCount = [SELECT AccountId, COUNT(Id) totalOpps, Account.Name FROM Opportunity WHERE AccountId IN: accountIds GROUP BY AccountId, Account.Name];
                                   
        Map<Id, Integer> opportunityCountMap = new Map<Id, Integer>();

        for(AggregateResult ar : oppCount){
            Integer numberOfOpps = (Integer) ar.get('totalOpps');
            Id accountId = (Id) ar.get('AccountId');
            opportunityCountMap.put(accountId, numberOfOpps);
        
        }

        return opportunityCountMap.size();
    }
}