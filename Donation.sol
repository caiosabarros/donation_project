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

    
    //Project Structure
    struct Project {
        address payable representant;
        uint256 fundingGoal;
        uint256 balance;
    }

    constructor(){

    }

    //Variable to Enumerate Projects
    uint256 numProjects;
    //projetcs mappings that maps an ID to a Project Structure
    mapping(uint256 => Project) public projects;

    function addProject (uint256 _goal, address payable _representant) public payable returns (uint256 project_Id) {
        //Each time a project is created, project_Id is receive numProjects and is incremented 
        project_Id = numProjects++;
        //variable p to refer to a Project Strucutre of a Specific Id from the projects mapping
        Project storage p = projects[project_Id];
        //Define the goal and the representant of the Project of ID equals to project_Id
        p.representant = _representant;
        p.fundingGoal =  _goal;
    }

    function getBalance(uint256 _projectId) public view returns (uint256) {
        //variable p to refer to a Project Strucutre of a Specific Id from the projects mapping
        Project storage p = projects[_projectId];
        return p.balance;
    }

    function donate(uint256 _projectId) public payable returns (bool){
        //variable p to refer to a Project Strucutre of a Specific Id from the projects mapping
        Project storage p = projects[_projectId];
        //I think I can better this part. If the value is 0, the person cant donate, but
        //it will require some gas for the person even if the transaction doesnt go through.
        //So, I need a way to reject the 0 donation without executing the function fail
        require(msg.value > 0, "Your donate a value");
        p.balance += msg.value;
        return true;
    }

    function withdraw(uint256 _projectId) public payable returns(bool){
        Project storage p = projects[_projectId];
        //Same as in the donate() function. Need somehow to abort function execution before
        //knowing that the msg.sender is not the representant
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
        //Same as in donate(). I think I can use modifier here, but I'll need to handle its creation
        require(msg.sender == p.representant, "You're not allowed to do this!");
        p.representant = _newRepresentant;
        return true;
    }


}
