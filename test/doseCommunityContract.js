
const truffleAssert = require('truffle-assertions');


const DoseCommunity = artifacts.require('DoseCommunity')
contract('DoseCommunity', function (accounts) {

    let metamaskAccount = accounts[0]
    let customer = '0x4b3bF5DF0fbF3d1848550E77536dC3f414002aAd'

    let doseCommunity;
    before('setup contract', async () => {
        doseCommunity = await DoseCommunity.deployed()
    });

    // test for registerCustomer function
    it("can register customer", async () => {
        // set data value
        const result = await doseCommunity.registerCustomer('Customer 1', { from: customer });

        // listen for the event
        truffleAssert.eventEmitted(result, 'NewCustomer');

    })

    // test for getCustomer function
    it("can return customer details", async () => {
        // set data value
        const result = await doseCommunity.getCustomer(customer, { from: customer });

        // listen for the event
        assert.equal(result[0], 'Customer 1', 'failed to get correct customer name');
        assert.equal(result[1], 'not set', 'failed to get correct tariff value');
        assert.equal(result[2], true, 'failed to get the correct customer status');

    })

    // test for setTariff fucntion
    it('can set tariff', async () => {

        // initial tariff
        const initialTariff = await doseCommunity.getCustomer(customer, { from: customer });
        await doseCommunity.setTariff('Weekly', { from: customer })
        const updatedTariff = await doseCommunity.getCustomer(customer, { from: customer });

        assert.equal(initialTariff[1], 'not set', 'failed to get the initial tariff value');
        assert.equal(updatedTariff[1], 'Weekly', 'failed to get the updated tariff value');
    })

    // test for send market energy
    it('can send market energy', async () => {
        const result = await doseCommunity.sendMarketEnergy(450, { from: customer });

        // listen for the event
        truffleAssert.eventEmitted(result, 'MarketEnergy', (event) => {
            return event.energy == 450;
        });
    })

});