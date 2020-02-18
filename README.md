# DOSE Community
DOSE Community

## 1. Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### 1.1. Prerequisites

Please make sure you've already installed Truffle and enabled MetaMask extension in your browser.

```
* Truffle v5.0.41 (core: 5.0.41)
* Solidity >= v0.5.8 (solc-js)
* Node >= v10.16.3
* Web3.js >= v1.2.1
```

### 1.2. Installing

Follow the steps below to have development environment running:
1. Clone the repository:
```
git clone https://github.com/olisystems/dose-community.git
```

2. Change directory to `app` folder and install all requisite npm packages (as listed in `package.json`):
```
cd app
npm install
```

3. Compiles and hot-reloads for development, run the following command inside `app` directory:
```
npm run serve
```
Navigate to `localhost:8080` in your browser.

4. Compiles and minifies for production:
```
npm run build
```

## 2. Smart Contract Development
1. Compile the smart contracts:
Change directory to the current project root directory and run:

```
truffle compile
```

This will create the smart contract artifacts in folder `src\assets\js\contracts`.

2. Migrate smart contracts to `volta` chain:

```
npm run migrate
```

3. Test smart contracts:

```
npm run test
```