// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
import "./InsuranceCompany.sol";

contract GarageContract is InsuranceCompanyContract {
    uint numRepair;
    mapping (uint => Repair) repairs;

    event SendReceipt(uint indexed _repairId, uint indexed _claimId, uint repairCost, string _notification);

    function receiveRepairRequest(uint claimId, uint damage) public returns (uint repairId){
        repairId = numRepair++; 
        Repair storage repairStorage = repairs[repairId];
        repairStorage.id = repairId;
        repairStorage.claimId = claimId;
        repairStorage.damage = damage;
        repairStorage.cost = 0;
        repairStorage.isDone = false;
    }

    function getRepair(uint id) public view returns (Repair memory repair){
        repair = repairs[id];
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

    function achieveRepairRequest(uint repairId) public {
        uint repairCost = estimateCost(repairs[repairId].damage);
        if(repairCost > 0){
            repairs[repairId].isDone = true;
            emit SendReceipt(repairId, getRepair(repairId).claimId, repairCost, "The repair has been done. Please proceed to payment.");
        }
        emit SendReceipt(repairId, getRepair(repairId).claimId, repairCost, "No reparations needed.");
    }
}