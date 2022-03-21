/**
 * Created by sonal on 2021-07-07.
 */

public with sharing class CampaignService {

    /**
     * @return Get active campaigns after querying CampaignType__mdt custom metadata
     */
    public static List<Campaign> getActiveCampaigns() {
        List<CampaignType__mdt> campaignTypes = CampaignType__mdt.getAll().values();
        Set<String> types = new Set<String>();
        for (CampaignType__mdt campaignType : campaignTypes) {
            if (campaignType.Active__c) {
                types.add(campaignType.Label);
            }
        }
        return CampaignSelector.selectActiveCampaigns(types);
    }
}