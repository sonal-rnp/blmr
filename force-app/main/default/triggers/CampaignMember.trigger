/**
 * Created by sonal on 2021-07-07.
 */

trigger CampaignMember on CampaignMember (after insert, after update, after delete) {

    CampaignMemberTriggerHandler.handleTrigger(Trigger.new, Trigger.old, Trigger.operationType);
}