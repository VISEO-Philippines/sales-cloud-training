trigger AccountTrigger on Account (after insert) {
    
    if(trigger.isAfter && trigger.isInsert){

        AccountTriggerHandler.createContactWithAccountName(Trigger.new);
        
    }

}