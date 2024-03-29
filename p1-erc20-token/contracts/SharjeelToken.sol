// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract SharjeelToken {
  uint public immutable totalSupply;
  string public constant name = "SharjeelToken";
  string public constant symbol = "SHR";
  uint8 public constant decimals = 18;
  mapping(address => uint) balances;
  mapping(address => mapping(address => uint)) allowed;

  event Transfer(address indexed from, address indexed to, uint tokens);
  event Approval(address indexed tokenOwner, address indexed spender, uint tokens);

  error NotEnoughBalance(uint avaiable, uint required);
  error NotEnoughAllowance(uint allowed, uint required);

  constructor(uint _totalSupply) {
    totalSupply = _totalSupply;
    balances[msg.sender] = _totalSupply;
  }

  function balanceOf(address tokenOwner) public view returns(uint) {
    return balances[tokenOwner];
  }

  function transfer(address receiver, uint numTokens)
    public
    hasEnoughBalance(msg.sender, numTokens)
    returns(bool)
  {
    balances[msg.sender] -= numTokens;
    balances[receiver] += numTokens;
    emit Transfer(msg.sender, receiver, numTokens);
    return true;
  }

  function approve(address delegate, uint numTokens)
    public
    returns(bool)
  {
    allowed[msg.sender][delegate] += numTokens;
    emit Approval(msg.sender, delegate, numTokens);
    return true;
  }

  function allowance(address owner, address delegate)
    public
    view
    returns(uint)
  {
    return allowed[owner][delegate];
  }

  function transferFrom(address owner, address buyer, uint numTokens)
    public
    hasEnoughBalance(owner, numTokens)
    hasEnoughAllowance(owner, buyer, numTokens)
    returns(bool)
  {
    balances[owner] -= numTokens;
    balances[buyer] += numTokens;
    allowed[owner][buyer] -= numTokens;
    emit Transfer(owner, buyer, numTokens);
    return true;
  }

  modifier hasEnoughBalance(address owner, uint numTokens) {
    if (balances[owner] < numTokens) {
      revert NotEnoughBalance(balances[owner], numTokens);
    }
    _;
  }

  modifier hasEnoughAllowance(address owner, address buyer, uint numTokens) {
    if (allowed[owner][buyer] < numTokens) {
      revert NotEnoughAllowance(allowed[owner][buyer], numTokens);
    }
    _;
  }
}
