// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract InsuranceCompanyContract {
    enum insurancePolicy { ThirdParty, AllRisk }

    struct Customer {
        uint id;
        string name;
        insurancePolicy policyType;
        uint validityDate;
        address paymentAddress;
    }

    struct Claim {
        uint id;
        uint customerId;
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