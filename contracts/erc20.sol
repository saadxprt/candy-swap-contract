// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@thirdweb-dev/contracts/base/ERC20Base.sol";
import "@thirdweb-dev/contracts/extension/PermissionsEnumerable.sol";

contract MyToken is ERC20Base, PermissionsEnumerable {
    bytes32 public constant TRANSFER_ROLE = keccak256("TRANSFER_ROLE");

    constructor(
        address _defaultAdmin,
        string memory _name,
        string memory _symbol
    )
        ERC20Base(
            _defaultAdmin,
            _name,
            _symbol
        )
    {
        _setupRole(DEFAULT_ADMIN_ROLE, _defaultAdmin);
        _setupRole(TRANSFER_ROLE, _defaultAdmin);
    }

    function transfer(address to, uint256 amount) public override returns (bool) {
        require(hasRole(TRANSFER_ROLE, msg.sender), "Sender must have TRANSFER_ROLE");
        _transfer(msg.sender, to, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public override returns (bool) {
        require(hasRole(TRANSFER_ROLE, msg.sender), "Sender must have TRANSFER_ROLE");
        _transfer(from, to, amount);
        _approve(
            from,
            msg.sender,
            allowance(from, msg.sender) - amount
        );
        return true;
    }
}