// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
import "./InsuranceCompany.sol";

contract CustomerContract is InsuranceCompanyContract {
    uint numCustomer = 0;
    Customer[] customers;

    constructor(){
        addCustomer("Tom", insurancePolicy.AllRisk, 300, 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4);
    }

    function addCustomer(string memory name, insurancePolicy policyType, uint validityInDays, address paymentAddress) public {
        numCustomer++;
        customers.push(
            Customer(
                numCustomer, 
                name, 
                policyType, 
                block.timestamp + (validityInDays * 1 days),
                paymentAddress
            )
        );
    }

    function getCustomer(uint customerId) public view returns (Customer memory customer){
        // Si l'id retourné est égal à 0, on sait que l'utilisateur n'existe pas
        for (uint i = 0; i < customers.length; i++){
            if(customers[i].id == customerId){
                return customers[i];
            }
        }
    }

    function updateCustomerInformations(uint customerId, string memory newName, insurancePolicy newInsurancePolicy, uint newValidity, address newPaymentAddress) public returns (bool) {
        for(uint i = 0; i < customers.length; i++) {
            if(customers[i].id == customerId) {
                customers[i].name = newName;
                customers[i].policyType = newInsurancePolicy;
                customers[i].validityDate = block.timestamp + (newValidity * 1 days);
                customers[i].paymentAddress = newPaymentAddress;
                return true;
            }
        }
        return false;
    }
}