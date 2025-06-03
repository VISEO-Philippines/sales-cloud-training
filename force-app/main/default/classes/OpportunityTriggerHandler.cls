public with sharing class OpportunityTriggerHandler {

    public static void createOpportunityContactRole(List<Opportunity> opportunityList) {

        Set<Id> opportunityAccountIds = new Set<Id>();
        List<OpportunityContactRole> opportunityContactRolesList = new List<OpportunityContactRole>();
        
        for (Opportunity opp : opportunityList) {
        {
            if(opp.AccountId <> null){
                opportunityAccountIds.add(opp.AccountId);
            }
        }
        List<Contact> contactList = [SELECT Id, AccountId FROM Contact WHERE AccountId IN : opportunityAccountIds];

        for(Contact con :contactList) {
            opportunityContactRolesList.add(
                new OpportunityContactRole(
                    OpportunityId = opp.Id,
                    ContactId = con.Id,
                    Role = 'Business User',
                    IsPrimary = true) 
                );
            }
        }
        insert opportunityContactRolesList; 
    }
}
