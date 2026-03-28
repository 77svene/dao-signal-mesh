// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/governance/Governor.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorSettings.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotesQuorumFraction.sol";

interface ISentimentOracle {
    function proposalSentiment(uint256 proposalId) external view returns (int256);
}

/**
 * @title SentimentGovernor
 * @dev Governance contract that adjusts voting power based on community sentiment.
 */
contract SentimentGovernor is 
    Governor, 
    GovernorSettings, 
    GovernorCountingSimple, 
    GovernorVotes, 
    GovernorVotesQuorumFraction 
{
    address public oracle;

    constructor(IVotes _token, address _oracle)
        Governor("SentimentGovernor")
        GovernorSettings(1, 50400, 0) // 1 block delay, 1 week period
        GovernorVotes(_token)
        GovernorVotesQuorumFraction(4) // 4% quorum
    {
        require(_oracle != address(0), "Invalid oracle address");
        oracle = _oracle;
    }

    /**
     * @dev Overrides _getVotes to multiply base voting power by sentiment score.
     * Multiplier logic: (Base Votes * (100 + SentimentScore)) / 100
     * SentimentScore is expected to be in range [-100, 100].
     * If sentiment is -50, voting power is halved. If +50, it's 1.5x.
     */
    function _getVotes(
        address account,
        uint256 timepoint,
        bytes memory params
    ) internal view override(Governor, GovernorVotes) returns (uint256) {
        uint256 baseVotes = super._getVotes(account, timepoint, params);
        
        // If no params or invalid length, return base votes
        if (params.length < 32) {
            return baseVotes;
        }

        uint256 proposalId = abi.decode(params, (uint256));
        int256 sentiment = ISentimentOracle(oracle).proposalSentiment(proposalId);

        // Apply sentiment multiplier: (baseVotes * (100 + sentiment)) / 100
        // We use 100 as the base to handle percentage-based adjustment
        int256 adjustedVotes = (int256(baseVotes) * (100 + sentiment)) / 100;
        
        return adjustedVotes > 0 ? uint256(adjustedVotes) : 0;
    }

    // Required overrides by Solidity

    function votingDelay() public view override(Governor, GovernorSettings) returns (uint256) {
        return super.votingDelay();
    }

    function votingPeriod() public view override(Governor, GovernorSettings) returns (uint256) {
        return super.votingPeriod();
    }

    function quorum(uint256 timepoint) public view override(Governor, GovernorVotesQuorumFraction) returns (uint256) {
        return super.quorum(timepoint);
    }

    function state(uint256 proposalId) public view override(Governor, GovernorSettings) returns (ProposalState) {
        return super.state(proposalId);
    }

    function proposalThreshold() public view override(Governor, GovernorSettings) returns (uint256) {
        return super.proposalThreshold();
    }

    function _propose(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        string memory description,
        address proposer
    ) internal override(Governor) returns (uint256) {
        return super._propose(targets, values, calldatas, description, proposer);
    }

    function _execute(
        uint256 proposalId,
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    ) internal override(Governor) {
        super._execute(proposalId, targets, values, calldatas, descriptionHash);
    }

    function _cancel(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    ) internal override(Governor) returns (uint256) {
        return super._cancel(targets, values, calldatas, descriptionHash);
    }

    function _executor() internal view override(Governor) returns (address) {
        return super._executor();
    }
}