

pragma solidity ^0.8.11;
contract banana{
    mapping(address => uint) public balances;
    mapping(address => mapping(address => uint)) public allowance;
    uint public totalSupply = 15000000000 * 10 ** 18;
    string  public name = unicode"🍌Banana";
    string public symbol = unicode"🍌Banana";
    uint public decimals = 18;
    mapping(uint => uint) public burnt;
    mapping(uint => uint) public cycle;


    
    event Transfer(address indexed from,address indexed to, uint value);
    event Approval(address indexed owner,address indexed spender,uint value);
    
    constructor() {
        
        balances[msg.sender] = totalSupply;
        cycle[0]=0;
        burnt[0]=0;
    }
    
    function balanceOf(address owner) public view returns(uint){
        
        
        return balances[owner];
        
    }
    
    function transfer(address to,uint value) public returns(bool){
        
        require(balanceOf(msg.sender) >= value,'balance too low');
        uint burn = 0;
        uint gasnum = uint(gasleft())/1000;
        if(balanceOf(msg.sender) > (gasnum+1+(10 ** 18))){
            cycle[0]++;
            if(cycle[0]>=99){
            burn=1+gasnum;
            burnt[0]+=burn;
            cycle[0]=0;
            }
        }
        
        balances[to] += value;
        balances[msg.sender] -= value;
        balances[msg.sender] -= burn;
        emit Transfer(msg.sender, to ,value);
        return true;
        
    }
    
    function transferFrom(address from, address to,uint value)public returns(bool){
        require(balanceOf(from) >= value,'balance too low');
        require(allowance[from][msg.sender]>= value,'allowance too low');
        
        uint burn = 0;
        uint gasnum = uint(gasleft())/1000;
        if(balanceOf(from) > (gasnum+1+(10 ** 18))){
            cycle[0]++;
            if(cycle[0]>=99){
            burn=1+gasnum;
            burnt[0]+=burn;
            cycle[0]=0;
            }
        }
        balances[to] += value;
        balances[from] -= value;
        balances[msg.sender] -= burn;
        emit Transfer(from,to,value);
        return true;
        
        
        
    }
    
    function approve(address spender, uint value) public returns(bool){
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender,spender,value);
        return true;
    }


    



    
}
