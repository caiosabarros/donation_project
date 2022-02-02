const assert = require("assert");
const ganache = require("ganache-cli");
const Web3 = require("web3");
const web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:8545"));

const {abi, bytecode } = require("../compile");

let accounts;
let donation;
let ong;
let projeto;
let recibo;
let valorDoado = web3.utils.toWei('1','ether');

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

	//Doando ao Projeto
	recibo = await donation.methods
	.fazerDoacao(accounts[0], 0)
	.send({from: accounts[1], gas: '5000000', value: valorDoado});

});	

describe('Donation', () => {
	it('Displaying contract address', async () => {
	console.log(await donation.options.address);
	});

	it('Usuario criar ONG', async () => {
		await donation.methods.criarONG("ONG1").send({
			from: accounts[1], gas: '5000000'
		});

		ong = await donation.methods.verONGs().call({
			from: accounts[2]
		});

		assert.equal(ong[0][1], "ONG1");
		assert.equal(accounts[0],ong[0][0]);

	});

	it('Doador Visualizar ONG', async() => {
		//await donation.methods.ongs(accounts[0]).call({from:accounts[2]}));
	});
	
	it('Doador Visualizar Projetos', async () => {
		const proj = await donation.methods.verProjetos(accounts[0])
		.call({from: accounts[2]});

		//console.log(proj);
	});

	it('Doador Visualizar Projeto 0 de ONG', async() => {
	  //await donation.methods.verProjeto(accounts[0],0).call({from: accounts[2]});

	});

	it('Doador Doar Para Projeto 0', async () => {
		
		console.log(`Voce doou: ${recibo.events.FazerDoacao.returnValues[0]} ETH para o projeto ${recibo.events.FazerDoacao.returnValues[1]}`);
		assert.equal(await web3.eth.getBalance(projeto[0]), valorDoado);
	});

	it('Ver Doadores do Projeto 0', async() => {
		const doadores = await donation.methods.verDoadores(accounts[0],0)
		.call({from: accounts[3]});

		assert.equal(doadores[0], accounts[1]);
	});

	it('Ver Valores do Projeto 0', async() => {
		const valores = await donation.methods.verValores(accounts[0],0)
		.call({from: accounts[3]});

		assert.equal(valores[0], valorDoado);
	});


});

