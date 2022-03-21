/**
 * Created by sonal on 2021-07-08.
 */

@RestResource(urlMapping='/v1/payments/*')
global with sharing class PaymentServiceAPI {

    @HttpPost
    global static void doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        Id resourceId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);

        Map<String, Object> payload = (Map<String, Object>) JSON.deserializeUntyped(
                req.requestBody.toString()
        );
        String action = payload.get('action').toString();
        if (action == 'Received') {

            CampaignMember member = new CampaignMember(
                    Id = resourceId,
                    Status = action
            );
            try {
                update member;
            } catch (DmlException e) {
                System.debug(LoggingLevel.ERROR, e);
                throw new CustomException(e.getMessage());
            }
        }
    }

    public class CustomException extends Exception {
    }

}