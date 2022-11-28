// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
import "./InsurranceCompany.sol";
import "./Client.sol";

contract ClaimHandlingContract is InsurranceCompanyContract {

    ClientContract clientContract = new ClientContract();

    uint numClaim;
    mapping (uint => Claim) claims;

    function newClaim(Claim memory claim) public returns (uint claimId) {
        claimId = numClaim++; 
        Claim storage c = claims[claimId];
        c.id = claimId;
        c.clientId = claim.clientId;
        c.policyType = claim.policyType;
        c.assesment = claim.assesment;
        c.claimDate = block.timestamp;
    }

    function getClaim(uint id) public view returns (Claim memory claim){
        claim = claims[id];
    }

    function getClient(uint id) public view returns (Client memory client){
        client = clientContract.getClient(id);
    }

    function isPolicyValidOnClaimDate(uint clientId, uint claimId) public view returns (bool policyValidity){
        policyValidity = clientContract.getClient(clientId).validityDate > getClaim(claimId).claimDate;
    }

    function arePoliciesTheSame(uint clientId, uint claimId) public view returns (bool samePolicy){
        samePolicy = clientContract.getClient(clientId).policyType == getClaim(claimId).policyType;
    }

    function assess(uint clientId, uint claimId) public view returns (bool assesment){
        assesment = isPolicyValidOnClaimDate(clientId, claimId) && arePoliciesTheSame(clientId, claimId);
    }
}