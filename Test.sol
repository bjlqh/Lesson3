// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

abstract contract Parent {
    uint256 public a;

    function addOne() public {
        a++;
    }

    function addTwo() public virtual;
}

contract Child is Parent {

    function addTwo() public override {
        a += 2;
    }
}