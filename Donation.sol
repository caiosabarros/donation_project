// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
//
//contract Organization {
//    address public representant;
//    uint8 public ongId;
//    mapping(address => uint8) public representantToOng;
//
//    constructor (uint8 _ongId) {
//        representant = msg.sender;
//        ongId = _ongId;
//    }
//
//    modifier onlyOwner() {
//        require(msg.sender == representant, "You're not the representant of this project");
//        _;
//    }
//
//    function changeRepresentative (address _newOwner) onlyOwner() public view returns (bool) {
//        representant = _newOwner;
//    }
//
//
//}
//
contract Donation {

    

    struct Project {
        address payable representant;
        uint256 fundingGoal;
        uint256 balance;
    }

    constructor(){

    }

    uint256 numProjects;
    mapping(uint256 => Project) public projects;

    function addProject (uint256 _goal, address payable _representant) public payable returns (uint256 project_Id) {
        project_Id = numProjects++;
        Project storage p = projects[project_Id];
        p.representant = _representant;
        p.fundingGoal =  _goal;
    }

    function getBalance(uint256 _projectId) public view returns (uint256) {
        Project storage p = projects[_projectId];
        return p.balance;
    }

    function donate(uint256 _projectId) public payable returns (bool){
        Project storage p = projects[_projectId];
        require(msg.value > 0, "Your donate a value");
        p.balance += msg.value;
        return true;
    }

    function withdraw(uint256 _projectId) public payable returns(bool){
        Project storage p = projects[_projectId];
        require(p.representant == msg.sender, "You can't do this operation");
        p.representant.transfer(p.balance);
        return true;
    }

    function changeRepresentant(uint256 _projectId, address payable _newRepresentant)
        public
        payable
        returns (bool)
    {
        Project storage p = projects[_projectId];
        require(msg.sender == p.representant, "You're not allowed to do this!");
        p.representant = _newRepresentant;
        return true;
    }


}
