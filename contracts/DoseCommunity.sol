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
    function registerCustomer(address _address, string calldata _name)
    external
    requireNotRegistered(_address)
    {
        // create new customer from customer struct
        Customer memory newCustomer = Customer(_name, "not set", true);
        customers[_address] = newCustomer;
        emit NewCustomer(_address, _name);
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
    function setTariff(address _address, string calldata _tariff)
    external
    requireIsRegistered(_address)
    {
        customers[_address].tariff = _tariff;
    }

    /// send market energy values
    function sendMarketEnergy(address _address, uint256 _energy)
    external
    requireIsRegistered(_address)
    {
        emit MarketEnergy(_address, _energy);
    }

    /// utility functions

    /// check if customer is already registered
    function isRegistered(address _address) public view returns (bool) {
        bool status = customers[_address].isRegistered;
        return status;
    }

}
