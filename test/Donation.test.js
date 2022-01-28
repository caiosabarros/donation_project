const assert = require("assert");
const ganache = require("ganache-cli");
const Web3 = require("web3");
const web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:8545"));

const {abi, bytecode } = require("../compile");

let accounts;
let donation;
let ong;
let projeto;

beforeEach(async () => {
	accounts =  await web3.eth.getAccounts();

	//Deploy
	donation = await new web3.eth.Contract(abi)
		.deploy({data: bytecode})
		.send({from: accounts[0],gas:'5000000'});

	//Criando ONG	
	await donation.methods.criarONG("ONG1").send({
		from: accounts[0], gas: '5000000'
	});	

	//Criando Projeto
	await donation.methods
	.criarProjeto("Projeto1", web3.utils.toWei('10', 'ether'))
	.send({from: accounts[0], gas: '5000000'});

	projeto = await donation.methods.verProjetos(accounts[0])
		.call({from: accounts[0]});

});	

describe('Donation', () => {
	it('Displaying contract address', async () => {
	console.log(await donation.options.address);
	});

	it('Usuario 1 criar ONG', async () => {
		await donation.methods.criarONG("ONG1").send({
			from: accounts[1], gas: '5000000'
		});

		ong = await donation.methods.verONGs().call({
			from: accounts[2]
		});

		assert.equal(ong[0][1], "ONG1");
		assert.equal(accounts[0],ong[0][0]);

	});
	
	it('Doador Visualizar Projeto 0', async () => {
		const proj = await donation.methods.verProjetos(accounts[0])
		.call({from: accounts[2]});
		
		//projeto[0]; address do projeto;


		console.log(proj);
	});

	it('Doador Doar Para Projeto 0', async () => {
		const recibo = await donation.methods
			.fazerDoacao(accounts[0], 0)
			.send({from: accounts[1], gas: '5000000', value: web3.utils.toWei('1','ether')});
		
		console.log(recibo.events);
		assert.equal(await web3.eth.getBalance(projeto[0]), web3.utils.toWei('1','ether'));

		//getBalance of contrato from recibo
	});

});

