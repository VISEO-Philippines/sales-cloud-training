public with sharing class OpportunityHelperClass {
    
    private static final String CLOSED_WON_STAGE_NAME = 'Closed Won';

    public static void sendEmailAfterOppClosedWonWithSpecificAmount(List<Opportunity> opportunities,  Map<Id, Opportunity> mapToOldOpportunity) {

        Set<Id> oppIds = new Set<Id>();
        Decimal deal = 500000;
        for(Opportunity opp : opportunities){
            if(opp.StageName == CLOSED_WON_STAGE_NAME && opp.Amount > deal &&
                (mapToOldOpportunity == null || 
                (mapToOldOpportunity.get(opp.Id).StageName != CLOSED_WON_STAGE_NAME )))
                    {
                oppIds.add(opp.Id);
            }
        }

        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        for (Opportunity opp : [SELECT Id, Name, Amount FROM Opportunity WHERE Id IN :oppIds]) {
            if (opp != null) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new String[] {'claude231040@gmail.com'});
                mail.setSubject('New Opp Won Closed : ' + opp.Name);
                mail.setPlainTextBody('Opportunity: ' + opp.Id + ' with Amount: ' + opp.Amount + ' is set to Closed Won.');
                mail.setHtmlBody('Opportunity <b>' + opp.Id + '</b> with Amount <b>' + opp.Amount + '</b> is set to Closed Won.');
                
                emails.add(mail);
            }
        }

        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }

    }
}