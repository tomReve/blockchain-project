// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract Exercice3 {
    struct Flight { // Struct
        uint id;
        string departure;
        string destination;
        string date;
        uint price;
        uint seatsNumber;
    }

    struct User {
        uint id;
        address userAdress;
    }

    struct Booking {
        uint id;
        uint userId;
        uint flightId;
    }
    

    uint numFlight;
    mapping (uint => Flight) flights;

    uint256 blockId;
    uint256 blockTimestamp;
    uint256 userCount;
    address userAddress;
    address ownerAddress = 0x3FC03E09150c96b1d0B41E6253Aea95B3cda2E2F;

    event GetEvent(address indexed _from, string operation, uint _value);
    event SetEvent(address indexed _from, string operation, uint _value);

    modifier onlyOwner {
        require(ownerAddress == msg.sender, "Unauthorized user, access denied");
    _;}

    function getBlockId() public view returns (uint256, address){
        return (blockId, userAddress);
    }

    function getBlockTimestamp() public view returns (uint256, address){
        return (blockTimestamp, userAddress);
    }

    function setBlockId() public onlyOwner{
        userCount++;
        blockId = block.number;
        userAddress = msg.sender;
    }

    function setBlockTimestamp() public onlyOwner{
        userCount++;
        blockTimestamp = block.timestamp;
        userAddress = msg.sender;
    }

    function getUserCount() public view returns (uint256){
        return userCount;
    }

    function transferEthers(address payable _to) public payable {
        _to.transfer(msg.value);
    }

    function sendEthers(address payable _to) public payable {
        bool sent = _to.send(msg.value);
        require(sent, "Failed to send Ether");
    }

    function callEthers(address payable _to) public payable {
        (bool sent, bytes memory data) = _to.call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }

    function newFlight(Flight memory flight) public returns (uint flightID) {
        flightID = numFlight++; // campaignID is return variable
        // We cannot use "campaigns[campaignID] = Campaign(beneficiary, goal, 0, 0)"
        // because the right hand side creates a memory-struct "Campaign" that contains a mapping.
        Flight storage f = flights[flightID];
        f.id = flightID;
        f.departure = flight.departure;
        f.destination = flight.destination;
        f.date = flight.date;
        f.price = flight.price;
        f.seatsNumber = flight.seatsNumber;
    }

    function updateFlight(uint id, Flight memory flight) public returns (uint returnedID) {
        Flight storage f = flights[id];
        returnedID = id;
        f.departure = flight.departure;
        f.destination = flight.destination;
        f.date = flight.date;
        f.price = flight.price;
        f.seatsNumber = flight.seatsNumber;
    }

    function getFlight(uint id) public view returns (Flight memory flight){
        flight = flights[id];
    }
}