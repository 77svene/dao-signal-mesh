// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {FunctionsClient} from "@chainlink/contracts/src/v0.8/functions/v0_1_0/FunctionsClient.sol";
import {FunctionsRequest} from "@chainlink/contracts/src/v0.8/functions/v0_1_0/libraries/FunctionsRequest.sol";
import {ConfirmedOwner} from "@chainlink/contracts/src/v0.8/shared/access/ConfirmedOwner.sol";

contract SentimentOracle is FunctionsClient, ConfirmedOwner {
    using FunctionsRequest for FunctionsRequest.Request;

    mapping(uint256 => int256) public proposalSentiment;
    address public governor;

    event SentimentUpdated(uint256 indexed proposalId, int256 score);

    constructor(address router, address _governor) FunctionsClient(router) ConfirmedOwner(msg.sender) {
        governor = _governor;
    }

    function requestSentiment(
        uint64 subscriptionId,
        bytes32 donId,
        string calldata source,
        string[] calldata args,
        uint32 gasLimit
    ) external onlyOwner {
        FunctionsRequest.Request memory req;
        req.initializeRequestForInlineJavaScript(source);
        if (args.length > 0) req.setArgs(args);
        
        _sendRequest(req.encodeCBOR(), subscriptionId, gasLimit, donId);
    }

    function fulfillRequest(bytes32 requestId, bytes memory response, bytes memory err) internal override {
        if (err.length > 0) revert("Request failed");
        
        (uint256 proposalId, int256 score) = abi.decode(response, (uint256, int256));
        proposalSentiment[proposalId] = score;
        emit SentimentUpdated(proposalId, score);
    }
}