// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
import "./InsuranceCompany.sol";

contract GarageContract is InsuranceCompanyContract {
    uint numRepair;
    Repair[] repairs;

    event SendReceipt(uint indexed _repairId, uint indexed _claimId, uint repairCost, string _notification);

    function receiveRepairRequest(uint claimId, uint damage) public {
        numRepair++;
        repairs.push(
            Repair(
                numRepair, 
                claimId, 
                damage, 
                0,
                false
            )
        );
    }

    function getRepair(uint id) public view returns (Repair memory repair){
        // Si l'id retourné est égal à 0, on sait que la réparation n'existe pas
        for (uint i = 0; i < repairs.length; i++){
            if(repairs[i].id == id){
                return repairs[i];
            }
        }
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
        uint repairCost = estimateCost(getRepair(repairId).damage);
        if(repairCost > 0){
            repairs[repairId].isDone = true;
            emit SendReceipt(repairId, getRepair(repairId).claimId, repairCost, "The repair has been done. Please proceed to payment.");
        }
        emit SendReceipt(repairId, getRepair(repairId).claimId, repairCost, "No reparations needed.");
    }
}