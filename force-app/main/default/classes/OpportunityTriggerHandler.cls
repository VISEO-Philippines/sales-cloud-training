public with sharing class OpportunityTriggerHandler {
    public static void createOpportunityContactRole(List<Opportunity> opportunities) {
        Set<Id> relatedAccountIds = new Set<Id>();

        //Get account Ids of Triggering Opps
        for (Opportunity opp : opportunities) {
            relatedAccountIds.add(opp.AccountId);
        }
        

        //Map to store the related accounts contacts
        Map<Id, List<Contact> > accountIdToContactsMap = new Map<Id, List<Contact>>();

        for (Account acc : [SELECT Id, (SELECT Id FROM Contacts) FROM Account WHERE Id IN :relatedAccountIds]) {
            accountIdToContactsMap.put(acc.Id, acc.Contacts);
        }
        
        //assign OpportunityContactRoles to Opps
        List<OpportunityContactRole> newOppConRoles = new List<OpportunityContactRole>();

        for(Opportunity opp : opportunities) {
            //if opp has a related account and account has contacts, add the contacts as OpportunityContactRoles
            if(opp.AccountId != null && accountIdToContactsMap.containsKey(opp.AccountId)){
                for(Contact con : accountIdToContactsMap.get(opp.AccountId)){
                    newOppConRoles.add(new OpportunityContactRole(
                        OpportunityId = opp.Id,
                        ContactId = con.Id,
                        isPrimary = true
                    ));
                    System.debug('Opportunity Contact Role:' + newOppConRoles);             
                }

            }
        }
            if(newOppConRoles.size() > 0) {
                insert newOppConRoles;
            }
    }
}