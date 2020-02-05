pragma solidity >=0.4.16 <0.6.0;

contract DoseCommunity {
    struct Customer {
        string name;
        string tariff;
        bool isRegistered;
    }

    mapping(address => Customer) customers;

    /// @notice event fired when a new customer is registered
    event NewCustomer(address customerAddress, string name);

    /// @notice event fired when market energy is sent
    event MarketEnergy(address customerAddress, uint256 energy);

    /// modifier to make sure user is not already registered
    modifier requireNotRegistered(address _address) {
        require(
            isRegistered(_address) == false,
            "Customer is already registered"
        );
        _;
    }
    /// modifier to check if user is a registered user
    modifier requireIsRegistered(address _address) {
        require(isRegistered(_address) == true, "Customer is not registered");
        _;
    }

    /// register customer
    function registerCustomer(string calldata _name)
        external
        requireNotRegistered(msg.sender)
    {
        // create new customer from customer struct
        Customer memory newCustomer = Customer(_name, "not set", true);
        customers[msg.sender] = newCustomer;
        emit NewCustomer(msg.sender, _name);
    }

    /// get customer details
    function getCustomer(address _address)
        public
        view
        returns (string memory, string memory, bool)
    {
        string memory name = customers[_address].name;
        string memory tariff = customers[_address].tariff;
        bool status = customers[_address].isRegistered;
        return (name, tariff, status);
    }

    /// set tariff
    function setTariff(string calldata _tariff)
        external
        requireIsRegistered(msg.sender)
    {
        customers[msg.sender].tariff = _tariff;
    }

    /// send market energy values
    function sendMarketEnergy(uint256 _energy)
        external
        requireIsRegistered(msg.sender)
    {
        emit MarketEnergy(msg.sender, _energy);
    }

    /// utility functions

    /// check if customer is already registered
    function isRegistered(address _address) public view returns (bool) {
        bool status = customers[_address].isRegistered;
        return status;
    }

}
