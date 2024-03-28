
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MaliciousNodeVoting {
    address public owner;
    uint256 public threshold;
    mapping(address => bool) public nodes;
    mapping(address => uint256) public maliciousVotes;

    event NodeAdded(address indexed node);
    event NodeRemoved(address indexed node);
    event Voted(address indexed voter, address indexed node, bool malicious);

    constructor(uint256 _threshold) {
        owner = msg.sender;
        threshold = _threshold;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier onlyNode() {
        require(nodes[msg.sender], "Only registered node can call this function");
        _;
    }

    function addNode(address _node) external onlyOwner {
        require(_node != address(0), "Invalid node address");
        require(!nodes[_node], "Node already registered");
        nodes[_node] = true;
        emit NodeAdded(_node);
    }

    function removeNode(address _node) external onlyOwner {
        require(nodes[_node], "Node not registered");
        delete nodes[_node];
        emit NodeRemoved(_node);
    }

    function vote(address _node, bool _malicious) external onlyNode {
        require(nodes[_node], "Node not registered");
        maliciousVotes[_node] += _malicious ? 1 : 0;
        emit Voted(msg.sender, _node, _malicious);
        if (maliciousVotes[_node] >= threshold) {
            removeNode(_node);
        }
    }
}
