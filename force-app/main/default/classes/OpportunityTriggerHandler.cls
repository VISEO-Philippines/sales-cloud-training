public with sharing class OpportunityTriggerHandler {
    public static void validateDelete(List<Opportunity> oppToDeleteList) {
        
        // validate if the Opportunity Stage is Closed Won, then don't allow the delete
        for(Opportunity opp : oppToDeleteList) {
            if(opp.StageName == 'Closed Won') {
                opp.addError('You cannot delete Opportunity with ' + opp.StageName + ' stage');
            }
        }    
    }
}