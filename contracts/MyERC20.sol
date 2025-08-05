// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8;

// import "@OpenZeppelin/contracts/token/ERC20/IERC20.sol";"

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function approve(address spender, uint256 amount) external returns (bool);
    
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    
    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract MyERC20 is IERC20 {
    
    address private admin;
    // 账户余额
    mapping(address => uint256) private balances;
    // 授权信息
    mapping(address => mapping(address => uint256)) private allowances;
    
    constructor (uint256 initialSupply) {
        admin = msg.sender;
        _mint(msg.sender, initialSupply);
    }

    // 查询余额
    function balanceOf(address account) public view override returns (uint256) {
        return balances[account];
    }
    
    // 转账
    function transfer(address recipient, uint256 amount) public returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    // 授权
    function approve(address spender, uint256 amount) external returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;    
    }

    // 代扣转账
    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        uint256 currentAllowance = allowances[sender][msg.sender];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        _approve(sender, msg.sender, currentAllowance - amount);

        _transfer(sender, recipient, amount);

        return true;
    }

    function mint(address to, uint256 amount) public {
        require(msg.sender == admin, "Only admin can mint tokens");
        _mint(to, amount);
    }


    // 封装的内部方法
    function _mint(address account, uint256 amount) internal {
        require(amount > 0, "mint amount must be greater than zero");

        balances[account] += amount;
        
        // 记录转账事件
        emit Transfer(address(0), account, amount); 
    }

    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "transfer from the zero address");
        require(recipient != address(0), "transfer to the zero address");
        require(amount > 0, "transfer amount must be greater than zero");

        uint256 senderBalance = balances[sender];
        require(senderBalance >= amount, "transfer amount exceeds balance");

        balances[sender] = senderBalance - amount;
        balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        
        allowances[owner][spender] = amount;

        // 记录授权事件
        emit Approval(owner, spender, amount); 
    }

}