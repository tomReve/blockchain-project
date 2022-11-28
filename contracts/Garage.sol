// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
import "./InsurranceCompany.sol";

contract GarageContract is InsurranceCompanyContract{
    uint numRepair;
    mapping (uint => Repair) repairs;

    function receiveRepairRequest(uint claimId, uint damage) public returns (uint repairId){
        repairId = numRepair++; 
        Repair storage repairStorage = repairs[repairId];
        repairStorage.id = repairId;
        repairStorage.claimId = claimId;
        repairStorage.damage = damage;
        repairStorage.cost = 0;
        repairStorage.isDone = false;
    }

    function estimateCost(uint damagePercentage) public pure returns (uint){
        if(damagePercentage > 0 && damagePercentage <= 30){
            return 300;
        } else if(damagePercentage > 30 && damagePercentage <= 60) {
            return 600;
        } else if(damagePercentage > 60 && damagePercentage <= 100) {
            return 900;
        } else {
            return 0;
        }
    }

    function achieveRepairRequest(uint repairId) public returns (bool){
        uint repairCost = estimateCost(repairs[repairId].damage);
        if(repairCost > 0){
            repairs[repairId].isDone = true;
        }

        return repairs[repairId].isDone;
    }

    function sendRepairReceipt(uint repairId) external view returns (uint, uint){
        return (repairs[repairId].claimId, repairs[repairId].cost);
    }
}