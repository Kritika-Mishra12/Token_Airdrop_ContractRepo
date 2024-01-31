//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        _setOwner(_msgSender());
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        _setOwner(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _setOwner(newOwner);
    }

    function _setOwner(address newOwner) private {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

contract Airdrop is Ownable {
    address public tokenAddr;
    uint256 public airdropAmount;

    event BNBTransfer(address beneficiary, uint amount);

    constructor(address _tokenAddr, uint256 _initialAirdropAmount)  {
        tokenAddr = _tokenAddr;
        airdropAmount = _initialAirdropAmount;
    }

    receive() external payable {
    }

    function dropTokens(address[] memory _recipients) public onlyOwner returns (bool) {
        for (uint i = 0; i < _recipients.length; i++) {
            require(_recipients[i] != address(0));
            require(IERC20(tokenAddr).balanceOf(msg.sender) >= airdropAmount);
            require(IERC20(tokenAddr).transfer(_recipients[i], airdropAmount));
        }

        return true;
    }

    function updateAirdropQuantity(uint256 _newAirdropAmount) external onlyOwner {
        require(_newAirdropAmount > 0, "Airdrop amount must be greater than zero");
        airdropAmount = _newAirdropAmount;
    }

    function dropBNB(address[] memory _recipients, uint256[] memory _amount) public payable onlyOwner returns (bool) {
        uint total = 0;

        for(uint j = 0; j < _amount.length; j++) {
            total = total + _amount[j];
        }

        require(total <= msg.value);
        require(_recipients.length == _amount.length);


        for (uint i = 0; i < _recipients.length; i++) {
            require(_recipients[i] != address(0));

            payable(_recipients[i]).transfer(_amount[i]);

            emit BNBTransfer(_recipients[i], _amount[i]);
        }

        return true;
    }

    function updateTokenAddress(address newTokenAddr) public onlyOwner {
        require(newTokenAddr != address(0),"Invalid address");
        tokenAddr = newTokenAddr;
    }

    function withdrawTokens(address beneficiary) public onlyOwner {
        require(IERC20(tokenAddr).transfer(beneficiary, IERC20(tokenAddr).balanceOf(address(this))));
    }

    function withdrawBNB(address payable beneficiary) public onlyOwner {
        beneficiary.transfer(address(this).balance);
    }
}