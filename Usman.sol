pragma solidity ^0.4.16;

library SafeMath{
    function add (uint256 a,uint256 b) internal returns (uint256){
       uint c = a+b;
        assert(c >= a);
        return c;
    }
    
    function sub(uint256 a,uint256 b) internal returns (uint c){
         assert(b <= a);
            c = a-b;
    }
    function mul(uint a,uint b) internal returns (uint){
       uint c = a*b;
        assert(a == 0 || c / a == b);
        return c;
    }
    function div(uint a,uint b) internal returns (uint c){
        c = a/b;
    }
}


contract Ownable {
    address public owner;


    function Ownable() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

}


contract ERC20Basic {
    uint256 public totalSupply;
    function balanceOf(address who) constant returns (uint256);
    function transfer(address to, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);
}


contract ERC20 is ERC20Basic {
    function allowance(address owner, address spender) constant returns (uint256);
    function transferFrom(address from, address to, uint256 value);
    function approve(address spender, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract BasicToken is ERC20Basic, Ownable {
    using SafeMath for uint256;

    mapping(address => uint256) balances;

   
    function transfer(address _to, uint256 _value) {
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        Transfer(msg.sender, _to, _value);
    }

    
    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }
}


contract StandardToken is ERC20, BasicToken {
    mapping (address => mapping (address => uint256)) allowed;

   
    function transferFrom(address _from, address _to, uint256 _value) {
        var _allowance = allowed[_from][msg.sender];

    

        balances[_to] = balances[_to].add(_value);
        balances[_from] = balances[_from].sub(_value);
        allowed[_from][msg.sender] = _allowance.sub(_value);
        Transfer(_from, _to, _value);
    }

    function approve(address _spender, uint256 _value) {
        require((_value == 0) || (allowed[msg.sender][_spender] == 0));
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
    }

  
    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
     
    function increaseAllowance(address _spender, uint _value)returns (bool done){
     allowed[msg.sender][_spender] =  allowed[msg.sender][_spender].add(_value);
     return true;
     
     //event call
     Approval(msg.sender , _spender , _value);
    }
    
    
    function deccreaseAllowance(address _spender, uint _value)returns (bool done){
       uint Allowed =allowed[msg.sender][_spender];
        if (_value <= Allowed){
    allowed[msg.sender][_spender] =  allowed[msg.sender][_spender].sub(_value);
     return true;
     
     //event call
     Approval(msg.sender , _spender , _value);
        }
        else{
            return false;
        }
    }
    
    
}


contract MyToken is StandardToken {
    event Destroy(address indexed _from);

    string public name = "MyToken";
    string public symbol = "MT";
    uint256 public decimals = 18;
    uint256 public initialSupply = 500000;

    function MyToken() {
        totalSupply = initialSupply;
        balances[msg.sender] = initialSupply;
    }

   
function Burn(uint _value) onlyOwner returns (bool done){
        require (balances[msg.sender]>=_value || _value >0);
        balances[msg.sender] -=_value;
        initialSupply -= _value;
        done =true;
    }
}



contract Sale is MyToken {
    uint constant price = 1000;
  //  address constant Storage = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    
    function buyToken(uint _value) payable returns (bool done){
      require (_value > 0);
       
       uint Tokencreate = _value.mul(price).div(1 ether);
       balances[msg.sender]= Tokencreate.add(balances[msg.sender]);
       
       return true;
     
    }
    
    //fall back function
    function () payable{
        
    }
}


