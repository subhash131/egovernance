// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract EGovernance is ERC20 {
    address governer;
    address[] representatives;
    address[] contractors;
    uint256 noOfRepresentatives;
    uint256 noOfContractors;

    constructor(uint _totalSupply) ERC20("DIGITAL RUPEE", "DINR") {
        governer = msg.sender;
        totalSupply = _totalSupply;
    }

    struct fundDetails {
        address from;
        address to;
        string cause;
        string description;
        uint amount;
    }

    mapping(address => fundDetails) transferHistory;

    modifier onlyRepresentative() {
        bool memory isRepresentative;
        for (uint256 i = 0; i < noOfRepresentatives; i++) {
            if (msg.sender == representatives[i]) {
                isRepresentative = true;
            }
        }
        if (isRepresentative) {
            _;
        }
    }
    modifier onlyContractor() {
        bool memory isContractor;
        for (uint256 i = 0; i < noOfContractors; i++) {
            if (msg.sender == contractors[i]) {
                isContractor = true;
            }
        }
        if (isContractor) {
            _;
        }
    }
    modifier onlyGoverner() {
        if (governer == msg.sender) {
            _;
        }
    }

    function transferFund(
        uint _amount,
        address _to,
        string memory _cause,
        string memory _description
    ) payable onlyGoverner onlyRepresentative onlyContractor returns (bool) {
        bool sent = transfer(_to, _amount);
        if (sent) {
            transferHistory[msg.sender] = fundDetails(
                msg.sender,
                _to,
                _cause,
                _description,
                _amount
            );
        }
        return sent;
    }

    function updateGoverner(address _newGoverner) onlyGoverner {
        governer = _newGoverner;
    }

    function addRepresentative(address _newRepresentative) onlyGoverner {
        representatives.push(_newRepresentative);
        noOfRepresentatives++;
    }

    function addContractor(
        address _newContractor
    ) onlyGoverner onlyRepresentative {
        contractors.push(_newContractor);
        noOfContractors++;
    }

    function removeContractor(
        address _contractor
    ) onlyGoverner onlyRepresentative {
        for (uint i = 0; i < noOfContractors; i++) {
            if (contractors[i] == _contractor) {
                delete contractors[i];
            }
        }
    }

    function removeRepresentative(address _representative) onlyGoverner {
        for (uint i = 0; i < noOfRepresentatives; i++) {
            if (representatives[i] == _representative) {
                delete representatives[i];
            }
        }
    }

    function getTransactions(address _)

}
