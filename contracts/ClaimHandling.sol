// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
import "./InsurranceCompany.sol";
import "./Customer.sol";

contract ClaimHandlingContract is InsurranceCompanyContract {

    CustomerContract customerContract = new CustomerContract();

    uint numClaim = 0;
    mapping (uint => Claim) claims;

    function newClaim(Claim memory claim) public {
        Claim storage c = claims[numClaim];
        c.id = numClaim;
        c.customerId = claim.customerId;
        c.policyType = claim.policyType;
        c.claimDate = claim.claimDate;
        numClaim++; 
    }

    function receiveAClaim(uint customerId, insurancePolicy policyType) public {
        Claim memory claim;
        claim.customerId = customerId;
        claim.policyType = policyType;
        claim.claimDate = block.timestamp;
        newClaim(claim);
    }

    function getClaim(uint id) public view returns (Claim memory claim){
        claim = claims[id];
    }

    function getClient(uint id) public view returns (Customer memory customer){
        customer = customerContract.getCustomer(id);
    }

    function isPolicyValidOnClaimDate(uint customerId, uint claimId) public view returns (bool policyValidity){
        policyValidity = customerContract.getCustomer(customerId).validityDate > getClaim(claimId).claimDate;
    }

    function arePoliciesTheSame(uint customerId, uint claimId) public view returns (bool samePolicy){
        samePolicy = customerContract.getCustomer(customerId).policyType == getClaim(claimId).policyType;
    }

    function assess(uint customerId, uint claimId) public view returns (bool assesment){
        assesment = isPolicyValidOnClaimDate(customerId, claimId) && arePoliciesTheSame(customerId, claimId);
    }
}