// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
import "./InsuranceCompany.sol";
import "./Customer.sol";
import "./ClaimHandling.sol";
import "./Garage.sol";

contract ClaimProcessingContract is InsuranceCompanyContract {

    CustomerContract customerContract;
    ClaimHandlingContract claimHandlingContract;
    GarageContract garageContract;

    constructor(address customerContractAddress, address claimHandlingContractAdress, address garageContractAddress) {
        customerContract = CustomerContract(customerContractAddress);
        claimHandlingContract = ClaimHandlingContract(claimHandlingContractAdress);
        garageContract = GarageContract(garageContractAddress);
    }

    uint numClaim = 0;
    Claim[] claims;

    event PaymentToCustomerNotif(address indexed _customerAddress, uint indexed _customerId, uint _value);
    event CustomerAdvNotif(uint indexed _customerId, uint indexed _claimId, string _notification);

    function receiveAClaim(uint claimId) public{
        Claim memory claim = claimHandlingContract.getClaim(claimId);
        numClaim++;
        claims.push(
            Claim(
                claimId, 
                claim.customerId, 
                claim.policyType,
                claim.claimDate, 
                claim.damagePercentage
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

    modifier isPolicyValidOnClaimDate(uint customerId, uint claimId){
        require(customerContract.getCustomer(customerId).validityDate > getClaim(claimId).claimDate, "The policy is not valid.");
        emit CustomerAdvNotif(customerId, claimId, "The policy is not valid.");
        _;
    }

    function makePayment(uint customerId, uint amount) public payable {
        Customer memory customer = customerContract.getCustomer(customerId);
        (bool sent, ) = customer.paymentAddress.call{value: amount}("");
        require(sent, "Failed to send Ether");
        emit PaymentToCustomerNotif(customer.paymentAddress, customerId, amount);
    }

    function insurranceEstimateCost(uint damagePercentage) public pure returns (uint){
        if(damagePercentage > 0 && damagePercentage <= 35){
            return 300;
        } else if(damagePercentage > 35 && damagePercentage <= 65) {
            return 600;
        } else if(damagePercentage > 65 && damagePercentage <= 100) {
            return 900;
        } else {
            return 0;
        }
    }

    function damagePercentageEstimationFromExpert(uint claimId, uint newDamagePercentage) public {
        claims[claimId].damagePercentage = newDamagePercentage;
    }

    function makeADecision(uint claimId) public isPolicyValidOnClaimDate(getClaim(claimId).customerId, claimId) {
        Claim memory claim = getClaim(claimId);

        if (claim.policyType == insurancePolicy.ThirdParty) {
            uint amount = insurranceEstimateCost(claim.damagePercentage);
            makePayment(claim.customerId, amount);
        }

        if (claim.policyType == insurancePolicy.AllRisk) {
            garageContract.receiveRepairRequest(claimId, claim.damagePercentage);
            emit CustomerAdvNotif(claim.customerId, claimId, "The repair request has been sent to the garage.");
        }
    }
}