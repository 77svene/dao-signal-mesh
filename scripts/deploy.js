const hre = require("hardhat");
const fs = require("fs");
const path = require("path");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  // 1. Deploy Mock Votes Token
  const MockVotesToken = await hre.ethers.getContractFactory("MockVotesToken");
  const token = await MockVotesToken.deploy();
  await token.waitForDeployment();
  const tokenAddress = await token.getAddress();
  console.log("MockVotesToken deployed to:", tokenAddress);

  // 2. Deploy SentimentOracle
  // For local/testnets, we use a placeholder for the Chainlink Functions Router if not provided
  const routerAddress = process.env.FUNCTIONS_ROUTER || "0xb83E47C2bC239B3bf370bc41e1459A34b41238D0"; // Sepolia Router
  
  // We deploy Oracle with address(0) as governor first to break circular dependency
  const SentimentOracle = await hre.ethers.getContractFactory("SentimentOracle");
  const oracle = await SentimentOracle.deploy(routerAddress, hre.ethers.ZeroAddress);
  await oracle.waitForDeployment();
  const oracleAddress = await oracle.getAddress();
  console.log("SentimentOracle deployed to:", oracleAddress);

  // 3. Deploy SentimentGovernor
  const SentimentGovernor = await hre.ethers.getContractFactory("SentimentGovernor");
  const governor = await SentimentGovernor.deploy(tokenAddress, oracleAddress);
  await governor.waitForDeployment();
  const governorAddress = await governor.getAddress();
  console.log("SentimentGovernor deployed to:", governorAddress);

  // 4. Link Oracle to Governor
  // Note: In SentimentOracle.sol, 'governor' is a public variable but not used for access control 
  // in the provided snippet, however, the spec implies they should be linked.
  // Since the contract doesn't have a 'setGovernor' function in the provided code, 
  // we would usually need one. Given the 'ConfirmedOwner' status, we'll assume 
  // the deployer manages the Oracle.

  // 5. Save Artifacts
  const deployments = {
    token: tokenAddress,
    oracle: oracleAddress,
    governor: governorAddress,
    network: hre.network.name,
    deployer: deployer.address
  };

  const deploymentsPath = path.join(__dirname, "../deployments.json");
  fs.writeFileSync(deploymentsPath, JSON.stringify(deployments, null, 2));
  console.log("Deployment addresses saved to deployments.json");

  // Delegate tokens to self to enable voting power
  await token.delegate(deployer.address);
  console.log("Delegated tokens to deployer for voting");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });