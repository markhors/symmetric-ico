pragma solidity ^0.4.15;

contract DecentralizedEscrow {
    
    address public thirdParty;

    mapping (uint => Item) items;
    uint public numItems;
    
    struct Item {
        address seller;
        address buyer;
        uint price;
        bool isAvailable;
        bytes32 buyerHash; 
        uint thirdPartyFee;
        uint deliveryDeadline;
        uint itemDeadline;
    }


    modifier onlyBuyer(uint id) {
        require(msg.sender == items[id].buyer);
        _;
    }

    modifier onlySellerOrThirdParty(uint id) {
        require(msg.sender == items[id].seller || msg.sender == thirdParty);
        _;
    }

    modifier deadlineReached(uint id) {
        require(block.number >= items[id].deliveryDeadline);
        _;
    }


    function DecentralizedEscrow(address _thirdParty) {
        thirdParty = _thirdParty;
    }

    function addItem(uint itemPrice, uint _deadline) returns (uint itemId) {
        itemId = numItems++;
        items[itemId].seller = msg.sender;
        items[itemId].price = itemPrice;
        items[itemId].isAvailable = true;
        items[itemId].thirdPartyFee = 1 ether;
        items[itemId].itemDeadline = _deadline;
    }

    function buy(uint _id, bytes32 _hash) payable returns (bool success){
        Item buyItem = items[_id];

        require(buyItem.isAvailable);
        require(msg.value >= buyItem.price);
        require(msg.sender.send(msg.value - buyItem.price));

        buyItem.buyer = msg.sender;
        buyItem.isAvailable = false;
        buyItem.buyerHash = _hash;
        buyItem.deliveryDeadline = block.number + buyItem.itemDeadline;

        return true;

    }

    function verifyAndSend(uint _id, uint key) onlySellerOrThirdParty(_id) returns (bool success) {
        Item buyItem = items[_id];
        require(sha256(key) == buyItem.buyerHash);
        assert(buyItem.seller.send(buyItem.price - buyItem.thirdPartyFee));
        assert(thirdParty.send(buyItem.thirdPartyFee));

        return true;
    }

    function notDelivered(uint _id) onlyBuyer(_id) deadlineReached(_id) returns (bool success) {
        assert(msg.sender.send(items[_id].price));
        items[_id].isAvailable = true;

        return true;
    }

    
    function getItem(uint id) constant returns (address seller , address buyer , uint price , bool isAvailable) {
        return (items[id].seller,items[id].buyer,items[id].price,items[id].isAvailable);
    }

    function getItemDeliveryDeadline(uint id) constant returns (uint deliveryDeadline) {
        return items[id].deliveryDeadline;
    }

    function calculateThirdPartyFee() private constant returns (uint) {
        // Will be implemented in near future.... :D
    }

}
