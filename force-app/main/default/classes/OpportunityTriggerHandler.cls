public with sharing class OpportunityTriggerHandler {
    public static void validateDelete(List<Opportunity> oppToDeleteList) {

        // get user profile name
        String profileName = [SELECT Id, Name FROM Profile WHERE Id =: UserInfo.getProfileId()].Name;

        // if user is system admin, allow opportunity deletion
        if(profileName == 'System Administrator') {
            for(Opportunity opp : oppToDeleteList) {
                if(opp.StageName == 'Closed Won') {
                    opp.addError('You cannot delete Opportunity with ' + opp.StageName + ' stage');
                }
            }
        }
    
    }
}