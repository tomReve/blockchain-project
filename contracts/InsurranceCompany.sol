// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract InsurranceCompanyContract {
    enum insurancePolicy { ThirdParty, AllRisk }

    struct Client {
        uint id;
        string name;
        insurancePolicy policyType;
        uint validityDate;
    }

    struct Claim {
        uint id;
        uint clientId;
        insurancePolicy policyType;
        bool assesment;
        uint claimDate;
        uint damagePercentage;
    }

    struct Repair {
        uint id;
        uint claimId;
        uint damage;
        uint cost;
        bool isDone;
    }
}