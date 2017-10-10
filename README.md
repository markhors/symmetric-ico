# symmetric-ico
ICO Platform

Supposed Working of DecentralizedEscrow Contract:
1. Seller will add an item through addItem() by giving item price and deadline in which the item can be delivered.
2. Item id will be assigned automatically.
3. Buyer will buy the item through buyItem() by giving the item id and a hashcode of a secret key to ensure the delivery.
4. If Buyer recieves the item then he will call verifyAndSend() giving the itemId and the secretKey to approve the funds.
5. if the item is not recived by buyer or the delivery deadline is met then the notDelivered() method is called and the funds is sent back to buyers.


# We have tested the code on private Blockchain every function is working fine except for verifyAndApprove function. the verifyAndApprove() is not working properly, the funds are lost somewhere when this function is called.
