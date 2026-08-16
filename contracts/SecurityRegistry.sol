// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract SecurityRegistry is AccessControl {
    bytes32 public constant ANALYST_ROLE = keccak256("ANALYST_ROLE");
    bytes32 public constant RESPONDER_ROLE = keccak256("RESPONDER_ROLE");

    enum Severity { LOW, MEDIUM, HIGH, CRITICAL }
    enum Status { OPEN, INVESTIGATING, RESOLVED }

    struct Incident {
        uint256 id;
        bytes32 evidenceHash;
        string title;
        Severity severity;
        Status status;
        address reporter;
        uint256 createdAt;
        uint256 resolvedAt;
    }

    uint256 public nextIncidentId;
    mapping(uint256 => Incident) public incidents;

    event IncidentRegistered(uint256 indexed id, bytes32 indexed evidenceHash, Severity severity, address indexed reporter);
    event IncidentStatusChanged(uint256 indexed id, Status status, address indexed actor);

    constructor(address admin) {
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
        _grantRole(ANALYST_ROLE, admin);
        _grantRole(RESPONDER_ROLE, admin);
    }

    function registerIncident(string calldata title, bytes32 evidenceHash, Severity severity)
        external onlyRole(ANALYST_ROLE) returns (uint256 id)
    {
        id = nextIncidentId++;
        incidents[id] = Incident({
            id: id,
            evidenceHash: evidenceHash,
            title: title,
            severity: severity,
            status: Status.OPEN,
            reporter: msg.sender,
            createdAt: block.timestamp,
            resolvedAt: 0
        });
        emit IncidentRegistered(id, evidenceHash, severity, msg.sender);
    }

    function updateStatus(uint256 id, Status newStatus) external onlyRole(RESPONDER_ROLE) {
        require(id < nextIncidentId, "Incident does not exist");
        incidents[id].status = newStatus;
        if (newStatus == Status.RESOLVED) incidents[id].resolvedAt = block.timestamp;
        emit IncidentStatusChanged(id, newStatus, msg.sender);
    }

    function grantAnalyst(address account) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _grantRole(ANALYST_ROLE, account);
    }

    function grantResponder(address account) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _grantRole(RESPONDER_ROLE, account);
    }
}