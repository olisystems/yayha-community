<template>
  <div class="main">
    <h2>DOSE Local Energy Sharing Community</h2>
    <div class="container">
      <!-- customer functionality starts from here -->
      <div class="admin">
        <div class="section register">
          <form @submit.prevent="registerConsumer">
            <input v-model="name" placeholder="customer name" required />
            <button type="submit">Register Consumer</button>
          </form>
        </div>

        <div class="section tariff">
          <form @submit.prevent="setTariff">
            <select v-model="tariff" required>
              <option disabled value>Please select one</option>
              <option>Share</option>
              <option>Classic</option>
              <option>Exchange</option>
            </select>
            <!-- <input v-model="tariff" placeholder="tariff details" required /> -->
            <button type="submit">Set Tariff</button>
          </form>
        </div>

        <div class="section energy">
          <form @submit.prevent="sendEnergy">
            <input type="number" v-model="energy" placeholder="market energy" required />
            <button type="submit">Send Energy</button>
          </form>
        </div>
      </div>

      <!-- display panel starts from here -->
      <div class="display">
        <div class="section customers" v-if="customers.length>0">
          <ul>
            <li
              class="customer-list"
              v-for="(customer, index) in customers"
              v-bind:key="index"
              v-on:click="getCustomer"
            >{{customer.address}}</li>
          </ul>
        </div>
        <div v-else>
          <h3>No customer is registered yet!</h3>
        </div>

        <div class="section customer-details" v-if="Object.entries(customerDetails).length>0">
          Name: {{customerDetails.name}}
          <br />
          Tariff: {{customerDetails.tariff}}
        </div>

        <div class="section energy-values" v-if="energyValues.length>0">
          <ul class="energy-values-list">
            <li
              v-for="(value, index) in energyValues"
              v-bind:key="index"
            >{{value.address}}, {{value.energy}}</li>
          </ul>
        </div>
        <div v-else>
          <h4>No market energy value is sent yet!</h4>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import web3 from "../assets/js/web3";
import ContractInstance from "../assets/js/ContractInstance";

export default {
  name: "DoseCommunity",
  data() {
    return {
      account: "",
      contract: "",
      name: "",
      tariff: "",
      energy: "",
      currentCustomer: "",
      customerDetails: {},
      customers: [],
      energyValues: []
    };
  },
  methods: {
    getMetamaskAccount() {
      web3.eth.getAccounts((err, res) => {
        if (err) {
          console.log(err);
          return;
        }
        this.account = res[0];
      });
    },
    registerConsumer() {
      this.contract.methods
        .registerCustomer(this.name)
        .send({ from: this.account, gasPrice: "1" });

      this.name = "";
    },
    watchRegistration() {
      this.contract.events
        .NewCustomer({
          fromBlock: 4168667
        })
        .on("data", event => {
          let obj = {};

          obj.address = event.returnValues[0];
          obj.name = event.returnValues[1];
          this.customers.push(obj);
        })
        .on("error", console.error);
    },
    getCustomer() {
      this.currentCustomer = event.target.innerHTML;
      this.contract.methods
        .getCustomer(this.currentCustomer)
        .call()
        .then(result => {
          this.customerDetails = {};
          this.customerDetails.name = result[0];
          this.customerDetails.tariff = result[1];
        });

      // removing the background color for ul-selected items
      document.querySelectorAll("ul>li").forEach(list => {
        list.classList.remove("active-customer");
      });
      // add background to selected account
      event.target.classList.add("active-customer");
    },
    setTariff() {
      this.contract.methods
        .setTariff(this.tariff)
        .send({ from: this.account, gasPrice: "1" });

      this.tariff = "";
    },
    sendEnergy() {
      const today = new Date();
      const min = today.getMinutes();
      if (min == 0 || min == 15 || min == 30 || min == 45) {
        this.contract.methods
          .sendMarketEnergy(this.energy)
          .send({ from: this.account, gasPrice: "1" });

        this.energy = "";
      } else {
        alert("This is not quarter hour time!");
        this.energy = "";
      }
    },

    watchEnergy() {
      this.energyValues = [];
      this.contract.events
        .MarketEnergy({
          fromBlock: 4168667
        })
        .on("data", event => {
          let obj = {};

          obj.address = event.returnValues[0];
          obj.energy = event.returnValues[1];
          this.energyValues.push(obj);
        })
        .on("error", console.error);
    }
  },
  async created() {
    this.getMetamaskAccount();
    this.contract = await ContractInstance();
    this.watchRegistration();
    this.watchEnergy();
  }
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.container {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  margin: 2rem;
}

.admin,
.display {
  width: 44%;
  padding: 2rem;
  display: flex;
  flex-direction: column;
  border: 1px rgb(218, 215, 215) solid;
}

input,
select {
  outline: none;
  background-color: white;
  margin: 0.5rem;
  padding: 0.5rem;
  border: rgb(207, 202, 202) solid 0.1px;
}

button {
  outline: none;
  margin: 0.5rem;
  padding: 0.5rem;
  cursor: pointer;
  border-radius: 2px;
  transition-duration: 0.4s;
  border: 0.1px solid rgb(138, 135, 135);
}

button:hover {
  background-color: #55ad58;
  color: white;
}

.admin {
  text-align: left;
}

.section {
  padding: 0.5rem;
}

.section:after {
  content: "";
  display: block;
  margin: 0 auto;
  width: 50%;
  padding-top: 1rem;
  border-bottom: 0.5px solid rgb(235, 180, 79);
}

ul > li {
  width: 75%;
  list-style-position: inside;
  font-size: 1rem;
  padding: 0.5rem;
  transition: font-size 0.3s ease, background-color 0.3s ease;
  list-style: none;
  text-align: left;
}
.customer-list {
  cursor: pointer;
}

.customer-details {
  text-align: left;
  margin-left: 40px;
}

.active-customer {
  background-color: #9be99b;
}

.energy-values-list {
  height: 150px;
  overflow-y: auto;
}
</style>
