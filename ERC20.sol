pragma solidity ^0.4.16;

import './SafeMath.sol';
import './Ownable.sol';

contract ERC20 is Ownable{
    using SafeMath for uint256;
    
    uint256 public totalSupply;
    
    mapping (address => uint256) public Balances;
    mapping (address =>mapping (address=>uint256)) public allowances;
    
    
    event Transfer(address a,address b,uint value);
    event TokenBurned(address burner, uint value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
    
    
    function _transfer (address _to,uint256 amount) public returns (bool done){
        require (_to != 0x0 || amount <= Balances[msg.sender] || Balances[_to]<= amount + Balances[_to]);
        Balances[msg.sender] = Balances[msg.sender].sub(amount);
        Balances[_to] = Balances[_to].add(amount);
        done=true;
        
        Transfer (msg.sender,_to,amount);
        
    }
    
    function balanceOf()public constant returns (uint256) {
        return Balances[msg.sender];
    }
    
    function transferFrom(address _from , address _to , uint _value )public returns (bool success){
        require(allowances[_from][msg.sender] >= _value);
        allowances[_from][msg.sender] -= _value;
        Balances[_to] = Balances[_to].add(_value);
        Balances[_from] = Balances[_from].add(_value);
        return true;
        
        Transfer(_from,_to,_value);
    }
    
    function approve(address _spender, uint _value)public returns (bool done){
        allowances[msg.sender][_spender] = _value;
        return true;

         Approval(msg.sender , _spender , _value);
    }
    
    function allowance(address _owner, address _spender)public constant returns (uint256 remaining) {
        return allowances[_owner][_spender];
    }
    
    function increaseAllowance(address _spender, uint _value)public returns (bool done){
     allowances[msg.sender][_spender] =  allowances[msg.sender][_spender].add(_value);
     return true;
     
 
     Approval(msg.sender , _spender , _value);
    }
    
    
    function deccreaseAllowance(address _spender, uint _value)public returns (bool done){
       uint Allowed =allowances[msg.sender][_spender];
        
        if (_value > Allowed){
            allowances[msg.sender][_spender] = 0;
        }
        
        else{
           allowances[msg.sender][_spender] =  Allowed.sub(_value);
        }
          Approval(msg.sender , _spender , _value);
          return true;
    }
     

}
