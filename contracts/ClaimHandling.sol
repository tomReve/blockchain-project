// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
import "./InsuranceCompany.sol";
import "./Customer.sol";

contract ClaimHandlingContract is InsuranceCompanyContract {

    CustomerContract customerContract = new CustomerContract();

    uint numClaim = 0;
    mapping (uint => Claim) claims;

    event CustomerAdvNotif(uint indexed _customerId, string _notification);

    function newClaim(Claim memory claim) public {
        Claim storage c = claims[numClaim];
        c.id = numClaim;
        c.customerId = claim.customerId;
        c.policyType = claim.policyType;
        c.claimDate = claim.claimDate;
        c.damagePercentage = claim.damagePercentage;
        numClaim++; 
    }

    function receiveAClaim(uint customerId, insurancePolicy policyType, uint damagePercentage) public checkIdentity(customerId)
            isPolicyValidOnClaimDate(customerId,  block.timestamp) arePoliciesTheSame(customerId, policyType){
        Claim memory claim;
        claim.customerId = customerId;
        claim.policyType = policyType;
        claim.claimDate = block.timestamp;
        claim.damagePercentage = damagePercentage;
        newClaim(claim);
    }

    function getClaim(uint id) public view returns (Claim memory claim){
        claim = claims[id];
    }

    modifier checkIdentity(uint customerId) {
        require(customerContract.getCustomer(customerId).id != 0, "Customer not found.");
        emit CustomerAdvNotif(customerId, "Customer identity is not valid.");
        _;
    }

    modifier isPolicyValidOnClaimDate(uint customerId, uint claimDate){
        require(customerContract.getCustomer(customerId).validityDate > claimDate, "Policy has expired.");
        emit CustomerAdvNotif(customerId, "Policy date has expired, please update your contract.");
        _;
    }

    modifier arePoliciesTheSame(uint customerId, insurancePolicy policyType){
        require(customerContract.getCustomer(customerId).policyType == policyType, "Customer and claim policy cannot be different.");
        emit CustomerAdvNotif(customerId, "Customer and claim policy have to be the same.");
        _;
    }
}