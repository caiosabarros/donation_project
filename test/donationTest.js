const Donation = artifacts.require("Donation");

contract('Donation', (accounts) => {
	it('Description of this unit test', async () => {
	console.log(accounts);
	});

	it('Description of this unit test', async () => {
	contract = await Donation.deployed();
	console.log(await contract.options.address);
	});

});

