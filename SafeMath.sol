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
