import web3 from './web3';
import doseCommunityArtifact from "./contracts/DoseCommunity";

const ContractInstance = async () => {

    //This method find the network id to retrieve the configuration from truffle-config.js file
    const networkId = await web3.eth.net.getId();
    // Retrieve the Network configuration from truffle-config.js file
    const deployedNetwork = doseCommunityArtifact.networks[networkId];
    // Initializing the contract
    const SampleContract = new web3.eth.Contract(
        doseCommunityArtifact.abi,
        deployedNetwork.address
    );

    return SampleContract;
}

export default ContractInstance;