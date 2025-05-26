trigger AutoConvertLeadsTrigger on Lead (after insert) {
    List<Lead> leadsToConvertList = new List<Lead>();

    for(Lead lds : Trigger.new) {
        if(lds.LeadSource == 'Web' && lds.Rating == 'Hot') {
            leadsToConvertList.add(lds);
        }
    }

    if(!leadsToConvertList.isEmpty()) {
        AutoConvertLeadsHandler.convertLeads(leadsToConvertList);
    }

}