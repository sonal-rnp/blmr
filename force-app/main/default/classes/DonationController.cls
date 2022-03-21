/**
 * Created by sonal on 2021-07-07.
 */

public with sharing class DonationController {

    @AuraEnabled(Cacheable=true)
    public static List<Campaign> getActiveCampaigns() {
        try {
            return CampaignService.getActiveCampaigns();
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static CampaignMember saveDonationDetails(String data) {
        DonationDetails details = (DonationDetails) JSON.deserialize(data, DonationDetails.class);
        System.debug(details);

        Contact vContact = new Contact(
                FirstName = details.firstName,
                LastName = details.lastName,
                Email = details.email,
                Level__c = details.donateType
        );
        try {
            insert vContact;
        } catch (DmlException e) {
            System.debug(LoggingLevel.ERROR, e);
            throw new AuraHandledException(e.getMessage());
        }

        CampaignMember member = new CampaignMember(
                CampaignId = details.fundId,
                Amount__c = details.amount,
                Message__c = details.message,
                ContactId = vContact.Id,
                Status = 'Processing'
        );
        try {
            insert member;
        } catch (DmlException e) {
            System.debug(LoggingLevel.ERROR, e);
            throw new AuraHandledException(e.getMessage());
        }
        return member;

    }

    private class DonationDetails {
        public String firstName { get; set; }
        public String lastName { get; set; }
        public Decimal amount { get; set; }
        public String email { get; set; }
        public String message { get; set; }
        public String fundId { get; set; }
        public String donateType { get; set; }

    }

}