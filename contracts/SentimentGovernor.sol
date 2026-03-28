// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/governance/Governor.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorSettings.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotesQuorumFraction.sol";

contract SentimentGovernor is Governor, GovernorSettings, GovernorVotes, GovernorVotesQuorumFraction {
    mapping(address => uint256) public sentimentMultiplier; // 100 = 1x

    constructor(IVotes _token, IGovernorTimelock _timelock)
        Governor("SentimentGovernor")
        GovernorSettings(1, 50400, 0)
        GovernorVotes(_token)
        GovernorVotesQuorumFraction(4)
    {}

    function setSentimentMultiplier(address voter, uint256 multiplier) external {
        // In production, this would be restricted to the Chainlink Functions oracle
        sentimentMultiplier[voter] = multiplier;
    }

    function _getVotes(address account, uint256 blockNumber, bytes memory params) internal view override returns (uint256) {
        uint256 rawVotes = super._getVotes(account, blockNumber, params);
        uint256 multiplier = sentimentMultiplier[account] == 0 ? 100 : sentimentMultiplier[account];
        return (rawVotes * multiplier) / 100;
    }

    function votingDelay() public view override(Governor, GovernorSettings) returns (uint256) {
        return super.votingDelay();
    }

    function votingPeriod() public view override(Governor, GovernorSettings) returns (uint256) {
        return super.votingPeriod();
    }

    function quorum(uint256 blockNumber) public view override(Governor, GovernorVotesQuorumFraction) returns (uint256) {
        return super.quorum(blockNumber);
    }

    function state(uint256 proposalId) public view override(Governor) returns (ProposalState) {
        return super.state(proposalId);
    }

    function propose(address[] memory targets, uint256[] memory values, bytes[] memory calldatas, string memory description) public override returns (uint256) {
        return super.propose(targets, values, calldatas, description);
    }

    function _execute(uint256 proposalId, address[] memory targets, uint256[] memory values, bytes[] memory calldatas, bytes32 descriptionHash) internal override {
        super._execute(proposalId, targets, values, calldatas, descriptionHash);
    }

    function _cancel(address[] memory targets, uint256[] memory values, bytes[] memory calldatas, bytes32 descriptionHash) internal override returns (uint256) {
        return super._cancel(targets, values, calldatas, descriptionHash);
    }

    function _executor() internal view override returns (address) {
        return address(0);
    }
}