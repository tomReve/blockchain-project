// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
import "./InsurranceCompany.sol";
import "./Customer.sol";
import "./ClaimHandling.sol";
import "./Garage.sol";

contract ClaimProcessingContract is InsurranceCompanyContract {

    CustomerContract customerContract = new CustomerContract();
    ClaimHandlingContract claimHandlingContract = new ClaimHandlingContract();
    GarageContract garageContract = new GarageContract();

    mapping (uint => Claim) claims;

    event PaymentToCustomer(address indexed _customerAddress, uint indexed _customerId, uint _value);

    function receiveAClaim(uint claimId) public {
        Claim memory claim = claimHandlingContract.getClaim(claimId);
        Claim storage c = claims[claimId];
        c.id = claimId;
        c.customerId = claim.customerId;
        c.policyType = claim.policyType;
        c.claimDate = claim.claimDate;
    }

    function getClaim(uint id) public view returns (Claim memory claim){
        claim = claims[id];
    }

    function isPolicyValidOnClaimDate(uint customerId, uint claimId) public view returns (bool policyValidity){
        policyValidity = customerContract.getCustomer(customerId).validityDate > getClaim(claimId).claimDate;
    }

    function makePayment(uint customerId, uint amount) public payable {
        Customer memory customer = customerContract.getCustomer(customerId);
        (bool sent, ) = customer.paymentAddress.call{value: amount}("");
        require(sent, "Failed to send Ether");
        emit PaymentToCustomer(customer.paymentAddress, customerId, amount);
    }

    function makeADecision(uint claimId) public {
        Claim memory claim = getClaim(claimId);

        if (claim.policyType == insurancePolicy.ThirdParty) {
            uint amount = garageContract.estimateCost(claim.damagePercentage);
            makePayment(claim.customerId, amount);
        }

        if (claim.policyType == insurancePolicy.AllRisk) {
            garageContract.receiveRepairRequest(claimId, claim.damagePercentage);
        }
    }
}