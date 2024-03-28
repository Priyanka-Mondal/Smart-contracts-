// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MajorityQuorum {
    struct Proposal {
        string description;
        uint256 yesVotes;
        uint256 noVotes;
        bool executed;
        mapping(address => bool) voted;
    }

    Proposal[] public proposals;
    mapping(address => bool) public members;
    uint256 public quorumPercentage;
    
    event ProposalAdded(uint256 indexed proposalId, string description);
    event Voted(uint256 indexed proposalId, address indexed voter, bool vote);
    event ProposalExecuted(uint256 indexed proposalId);

    constructor(uint256 _quorumPercentage) {
        require(_quorumPercentage > 0 && _quorumPercentage <= 100, "Invalid quorum percentage");
        quorumPercentage = _quorumPercentage;
        members[msg.sender] = true; // Contract deployer is automatically a member
    }

    modifier onlyMember() {
        require(members[msg.sender], "Not a member");
        _;
    }

    function addProposal(string memory _description) external onlyMember {
        proposals.push(Proposal({
            description: _description,
            yesVotes: 0,
            noVotes: 0,
            executed: false
        }));
        emit ProposalAdded(proposals.length - 1, _description);
    }

    function vote(uint256 _proposalId, bool _vote) external onlyMember {
        require(_proposalId < proposals.length, "Invalid proposal ID");
        require(!proposals[_proposalId].voted[msg.sender], "Already voted");

        proposals[_proposalId].voted[msg.sender] = true;
        if (_vote) {
            proposals[_proposalId].yesVotes++;
        } else {
            proposals[_proposalId].noVotes++;
        }
        emit Voted(_proposalId, msg.sender, _vote);
        
        if (proposalPassed(_proposalId)) {
            executeProposal(_proposalId);
        }
    }

    function proposalPassed(uint256 _proposalId) public view returns (bool) {
        Proposal memory proposal = proposals[_proposalId];
        uint256 totalVotes = proposal.yesVotes + proposal.noVotes;
        if (totalVotes == 0) {
            return false;
        }
        uint256 yesPerc
