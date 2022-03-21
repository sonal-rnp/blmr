/**
 * Created by sonal on 2021-07-07.
 */

public with sharing class CampaignMemberTriggerHandler {

    public static void handleTrigger(List<SObject> newList, List<SObject> oldList, System.TriggerOperation triggerEvent) {
        Set<Id> campaignIds = new Set<Id>();

        switch on triggerEvent {

            when AFTER_UPDATE {
                // Check whether status or amount has been changed for any campaign member. If yes, add the campaign Id
                for (CampaignMember member : (List<CampaignMember>) newList) {
                    if ((Utils.isChanged(member, CampaignMember.Status) || Utils.isChanged(member, CampaignMember.Amount__c)) && member.Amount__c > 0) {
                        campaignIds.add(member.CampaignId);
                    }
                }
            }
            when AFTER_INSERT, AFTER_DELETE {
                List<CampaignMember> members = triggerEvent == TriggerOperation.AFTER_DELETE
                        ? (List<CampaignMember>) oldList
                        : (List<CampaignMember>) newList;
                for (CampaignMember member : members) {
                    // If status is Received, then only TotalAmountCollected should get calculated
                    if (member.Status == 'Received' && member.Amount__c > 0) {
                        campaignIds.add(member.CampaignId);
                    }
                }
            }
            when else {
                //do nothing
            }
        }

        System.debug(LoggingLevel.INFO, campaignIds);
        if (!campaignIds.isEmpty()) {
            Map<Id, Campaign> campaignMap = CampaignSelector.selectCampaignsAndMembers(campaignIds);

            List<Campaign> campaigns = new List<Campaign>();

            // For each campaign, query all campaign members and calculate the amount
            for (Id key : campaignMap.keySet()) {
                List<CampaignMember> campaignMembers = campaignMap.get(key).CampaignMembers;
                Decimal amount = 0;
                if (campaignMembers != null && campaignMembers.size() > 0) {
                    for (CampaignMember member : campaignMembers) {
                        amount += member.Amount__c;
                    }
                }
                // Update the campaigns
                campaigns.add(new Campaign(Id = key, TotalAmountCollected__c = amount));
            }

            update campaigns;
        }
    }
}