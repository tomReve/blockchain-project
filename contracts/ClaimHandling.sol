// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
import "./InsuranceCompany.sol";
import "./Customer.sol";

contract ClaimHandlingContract is InsuranceCompanyContract {

    CustomerContract customerContract;

    uint numClaim = 0;
    Claim[] claims;

    event CustomerAdvNotif(uint indexed _customerId, string _notification);

    constructor(address customerContractAddress) {
        customerContract = CustomerContract(customerContractAddress);
    }

    function receiveAClaim(uint customerId, insurancePolicy policyType, uint damagePercentage) public checkIdentity(customerId)
            isPolicyValidOnClaimDate(customerId,  block.timestamp) arePoliciesTheSame(customerId, policyType){
        numClaim++;
        claims.push(
            Claim(
                numClaim, 
                customerId, 
                policyType,
                block.timestamp, 
                damagePercentage
            )
        );
    }

    function getClaim(uint id) public view returns (Claim memory claim){
        // Si l'id retourné est égal à 0, on sait que la claim n'existe pas
        for (uint i = 0; i < claims.length; i++){
            if(claims[i].id == id){
                return claims[i];
            }
        }
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