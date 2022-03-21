/**
 * Created by sonal on 2021-07-07.
 */

public with sharing class CampaignSelector {

    public static List<Campaign> selectActiveCampaigns(Set<String> types) {
        return [SELECT Id, Name FROM Campaign WHERE IsActive = TRUE AND Type = :types WITH SECURITY_ENFORCED];
    }

    public static Map<Id, Campaign> selectCampaignsAndMembers(Set<Id> campaignIds) {
        return new Map<Id, Campaign>([
                SELECT Id, (SELECT Id, Amount__c FROM CampaignMembers WHERE Status = 'Received')
                FROM Campaign
                WHERE Id = :campaignIds
                WITH SECURITY_ENFORCED
        ]);
    }
}