// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LargestBalance {
    function getLargestBalance(address _address1, address _address2) external view returns (address) {
        uint256 balance1 = address(_address1).balance;
        uint256 balance2 = address(_address2).balance;

        if (balance1 > balance2) {
            return _address1;
        } else if (balance1 < balance2) {
            return _address2;
        } else {
            // If balances are equal, return address 0x0
            return address(0);
        }
    }
}
