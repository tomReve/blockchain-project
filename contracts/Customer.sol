// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
import "./InsurranceCompany.sol";

contract CustomerContract is InsurranceCompanyContract {
    uint numCustomer = 0;
    Customer[] customers;

    constructor(){
        addCustomer("Tom", insurancePolicy.AllRisk, 300);
    }

    function addCustomer(string memory name, insurancePolicy policyType, uint validityInDays) public {
        numCustomer++;
        customers.push(
            Customer(
                numCustomer, 
                name, 
                policyType, 
                block.timestamp + (validityInDays * 1 days)
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

    function updateCustomerInformations(uint customerId, string memory newName) public returns (bool) {
        for(uint i = 0; i < customers.length; i++) {
            if(customers[i].id == customerId) {
                customers[i].name = newName;
                return true;
            }
        }
        return false;
    }
}