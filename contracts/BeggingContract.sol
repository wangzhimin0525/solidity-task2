// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8;

contract BeggingContract {
    
    address public owner;

    mapping(address => uint256) public donations;

    // 捐赠者地址
    address[] private donors;

    uint256 public constant START_TIME = 1754355600;

    uint256 public constant END_TIME = 1754388000;

    // 捐赠事件
    event Donation(address indexed donor, uint256 amount);

    // 提款事件
    event Withdrawal(address indexed owner, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

     modifier inDonationTime() {
        require(block.timestamp >= START_TIME && block.timestamp <= END_TIME, "Donations are not allowed at this time");
        _;
    }

    // 捐赠函数
    function donate() external payable inDonationTime {
        require(msg.value > 0, "Donation must be greater than zero");
        if (donations[msg.sender] == 0) {
            donors.push(msg.sender);
        }
        donations[msg.sender] += msg.value;
        emit Donation(msg.sender, msg.value);
    }

    // 提款函数
    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        // 将合约余额转给合约所有者
        payable(owner).transfer(balance);
        emit Withdrawal(owner, balance);
    }

    // 查询某个地址的捐赠金额
    function getDonation(address donor) external view returns (uint256) {
        return donations[donor];
    }

    // 捐赠排行前三
    function getTopDonors() public view returns (address[3] memory topDonors, uint256[3] memory topAmounts) {
        for (uint i = 0; i < donors.length; i++) {
            address donor = donors[i];
            uint256 amount = donations[donor];
            
            if (amount > topAmounts[0]) {
                (topAmounts[1], topAmounts[2]) = (topAmounts[0], topAmounts[1]);
                (topDonors[1], topDonors[2]) = (topDonors[0], topDonors[1]);
                (topAmounts[0], topDonors[0]) = (amount, donor);
            } else if (amount > topAmounts[1]) {
                (topAmounts[2], topDonors[2]) = (topAmounts[1], topDonors[1]);
                (topAmounts[1], topDonors[1]) = (amount, donor);
            } else if (amount > topAmounts[2]) {
                (topAmounts[2], topDonors[2]) = (amount, donor);
            }
        }
    }
}