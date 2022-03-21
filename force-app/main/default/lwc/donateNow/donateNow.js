/**
 * Created by sonal on 2021-07-07.
 */

import { LightningElement, wire, track } from "lwc";
import activeCampaigns from "@salesforce/apex/DonationController.getActiveCampaigns";
import saveDonationDetails from "@salesforce/apex/DonationController.saveDonationDetails";
import { reduceErrors } from "c/ldsUtils";

export default class DonateNow extends LightningElement {

  donateType;
  fundId;
  firstName;
  lastName;
  email;
  amount;
  message;
  rendered = false;

  @track funds = [];

  get donateTypes() {
    return [
      { label: "Donate Now", value: "One-time" },
      { label: "Donate Monthly", value: "Monthly" }
    ];
  }

  @wire(activeCampaigns, {})
  wiredCampaigns({ error, data }) {
    if (data) {
      for (const dt of data) {
        this.funds.push({ label: dt.Name, value: dt.Id });
      }
      this.rendered = true;

    } else if (error) {
      console.error(error);
    }
  };

  firstNameChange(event) {
    this.firstName = event.target.value;
  }

  lastNameChange(event) {
    this.lastName = event.target.value;
  }

  emailChange(event) {
    this.email = event.target.value;
  }

  amountChange(event) {
    this.amount = event.target.value;
  }

  messageChange(event) {
    this.message = event.target.value;
  }

  handleFundName(event) {
    this.fundId = event.detail.value;
  }

  handleDonateType(event) {
    this.donateType = event.detail.value;
  }

  handleClick(event) {

    const data = {
      firstName: this.firstName,
      lastName: this.lastName,
      amount: this.amount,
      email: this.email,
      message: this.message,
      fundId: this.fundId,
      donateType: this.donateType
    };

    saveDonationDetails({ data: JSON.stringify(data) })
      .then((result) => {
        console.log(result);
        this.template
          .querySelector("c-notification-panel")
          .notifySuccess('Success');
        setTimeout(function(){
          window.location.reload(1);
        }, 500);
      })
      .catch((error) => {
        console.error(error);
        this.template
          .querySelector("c-notification-panel")
          .notifyError(reduceErrors(error).join(", "));
      });
  }
}