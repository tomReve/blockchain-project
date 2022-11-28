// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
import "./InsurranceCompany.sol";

contract ClientContract is InsurranceCompanyContract {
    uint numClient;
    mapping (uint => Client) clients;

    constructor(){
        newClient("Tom", insurancePolicy.AllRisk, 300);
    }

    function newClient(string memory name, insurancePolicy policyType, uint validityInDays) public returns (uint clientId) {
        clientId = numClient++; 
        Client storage c = clients[clientId];
        c.id = clientId;
        c.name = name;
        c.policyType = policyType;
        c.validityDate = block.timestamp + (validityInDays * 1 days);
    }

    function getClient(uint id) public view returns (Client memory client){
        client = clients[id];
    }
}