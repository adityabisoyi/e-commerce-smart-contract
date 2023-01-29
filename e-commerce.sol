// SPDX-License-Identifier: GP-3.0

pragma solidity 0.8.7;

contract Ecommerce {

    //struct that contains all the details of the product
    struct Product {
        string title;
        string desc;
        address payable seller;
        uint productID;
        uint price;
        address buyer;
        bool deliveryStatus;
    }

    //counter to set product ID 
    uint counter = 1001;
    
    //Dynamic array to store all the products
    Product[] public products;

    //event for registering the product
    event registered(string title, uint productID, address seller);

    //event that is triggered when product is sold
    event productSold(uint productID, address buyer);

    //event that is triggered when product is delivered
    event productDelivered(uint productID);




    function registerProduct(string memory _title, string memory _desc, uint _price) public {
        require(_price > 0, "Price of product cannot be zero");
        //creating a temp variable 
        Product memory tempProduct;
        
        tempProduct.title = _title;
        tempProduct.desc = _desc;

        //converting price from ether into wei
        tempProduct.price = _price * 10**18;
        
        tempProduct.seller = payable(msg.sender);
        tempProduct.productID = counter;

        // pushing the struct into the products array
        products.push(tempProduct);

        //incrementing the counter for product ID
        counter++;

        //triggering the event
        emit registered(_title, tempProduct.productID, msg.sender);
    }




    function buyProduct(uint _productID) payable public {
        //check to see if the buyer is paying correct price
        require(products[_productID-1001].price == msg.value, "Please pay the exact price");
        
        //check to see if the seller is buying its own products
        require(products[_productID-1001].seller != msg.sender, "Seller cannot buy its own products");

        products[_productID-1001].buyer = msg.sender;

        //triggering the event
        emit productSold(_productID, msg.sender);
    }

    function delivery(uint _productID) public {
        require(products[_productID-1001].buyer == msg.sender, "Only buyer can confirm it");

        //setting flag is delivery is completed
        products[_productID-1001].deliveryStatus = true;

        //transfering funds if product is delivered
        products[_productID-1001].seller.transfer(products[_productID-1001].price);

        //triggering the event
        emit productDelivered(_productID);
    }

}
