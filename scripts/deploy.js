async function main() {
	// const [deployer] = await hre.ethers.getSigners();
	// console.log("Deploying contracts with the account:", deployer.address);

	// const balance = await deployer.getBalance();
	// console.log("Account balance:", balance.toString());

	const vibesContractFactory = await hre.ethers.getContractFactory(
		"VibesPortal",
	);
	const contractFunds = hre.ethers.utils.parseEther("0.1");
	const vibesContract = await vibesContractFactory.deploy({
		value: contractFunds,
	});
	await vibesContract.deployed();

	console.log("WavePortal address:", vibesContract.address);
}

main()
	.then(() => process.exit(0))
	.catch((error) => {
		console.error(error);
		process.exit(1);
	});
