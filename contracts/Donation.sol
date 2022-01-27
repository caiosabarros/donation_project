// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

//Deixar uma variavel constante fora de escopo dos contratos
//permite ela ser acessivel a todos os contratos.
struct Projeto {
  uint16 projetoID;
  string projetoNome;
  address responsavel;
  uint256 saldo;
  uint128 meta;
  StatusProjeto status;
}

enum StatusProjeto {Aberto, Finalizado}

contract Donation {

  uint16 ongsNumero;
  mapping(address => ONG) ongs;
  ONG[] public ongsLista;

  StatusProjeto public statusProjeto;

  modifier onlyStatus(StatusProjeto statusEsperado){ 
    if(statusEsperado == statusProjeto){_;} 
    else {revert("Ola");}
  }

//  modifier onlyOwner(address _address){
//    ONG memory o = ongs[msg.sender];
//  }

  struct ONG {
    address owner;
    string ongNome;
    uint256 ongSaldo;
    uint16 ongID;
    uint16 projetosNumero;
    contratoProjeto[] contratos;
  }

  function criarONG(string memory _ongNome) public  {
    ONG storage o = ongs[msg.sender];
    o.owner = msg.sender;
    o.ongNome = _ongNome;
    o.ongID = ongsNumero;
    ongsNumero++;
    o.ongSaldo = 0;
    ongsLista.push(o);
   }

  function criarProjeto(string memory _projetoNome, uint128 _meta) public {   
    //Throw revert automatically if caller hasn't an ONG
    ONG storage o = ongs[msg.sender];
    //Cheack Why this is no updating
    o.projetosNumero++;
    contratoProjeto novoProjeto = new contratoProjeto(o.projetosNumero, _projetoNome, msg.sender, 0, _meta);
    o.contratos.push(novoProjeto);   
   }

    //function mudarResponsavel(address _novoResponsavel) public {
    //IMPLEMENT LATER
    //The easist and cheapest way of doing it is allowing only the ONG.owner to be
    //changed, instead of looping through all the projects to change the owner.
    //Thus, the project's owner will continue to be the old one, but the withdraw is
    //only doable from the ONG.owner
    //ONG storage o = ongs[msg.sender];
    //o.owner = _novoResponsavel;
    //}

  function fazerDoacao(address _ongOwner, uint16 _projetoID) public payable {
    //The project's address is dependent on the ONGs address and the projectID 
    ONG memory o = ongs[_ongOwner];
    //Check if contract is finalizado, then revert if so!
    (,,,,,StatusProjeto status) = o.contratos[_projetoID].projeto();
    if(status != StatusProjeto.Aberto){revert("Projeto finalizado");}
    //https://solidity-by-example.org/sending-ether/
    (bool sent, bytes memory data) = payable(address(o.contratos[_projetoID])).call{value: msg.value}("");
    o.contratos[_projetoID].projetoUpdate(msg.value, msg.sender);
  }

  function finalizarProjeto(uint16 _projetoID) public {
    //Impossibilaremos de alguem usar este contrato para depositar no outro.
    //Mas ainda sim o contrato permancera ativo, podendo receber transferencias
    //diretamente. Nao apagaremos o endereco do contrato da lista de ONGs, pois 
    //alguem pode mandar ETH para o contrato 0x0...00.
    ONG memory o = ongs[msg.sender];
    o.contratos[_projetoID].projetoFinalizar();    
  }

  function sacarSaldo (uint16 _projetoID) public payable{
    ONG memory o = ongs[msg.sender];
    o.contratos[_projetoID].projetoSacar(msg.sender);   
  }

  function verONGs() public view returns(ONG[] memory) {
    return ongsLista;
  }

  function verProjetos(address _address) public view returns(contratoProjeto[] memory){
    ONG memory o = ongs[_address];
    return o.contratos;
  }

  function verProjeto(address _address, uint16 _id) public view returns(Projeto memory ){
    ONG memory o = ongs[_address];
    Projeto memory con = o.contratos[_id].projetoVer();
    return con;
  }

  function verDoadores(address _address, uint16 _id) public view returns(address[] memory ){
    ONG memory o = ongs[_address];
    address[] memory con = o.contratos[_id].projetoDoacoes();
    return con;
  }  

  function verValores(address _address, uint16 _id) public view returns(uint256[] memory ){
    ONG memory o = ongs[_address];
    uint256[] memory con = o.contratos[_id].projetoValores();
    return con;
  }

  function getBalance() public view returns (uint256) {
    return address(this).balance;
  }
  
  // function verProjetoOwner(){} 

}

contract contratoProjeto {
  Projeto public projeto;
  address[] doadores;
  uint256[] valores;

//  StatusProjeto projetoStatus;

  modifier onlyOwner(address _owner){
    require(_owner == projeto.responsavel, "Not authorized");
    _;
  }

  modifier onlyStatus(StatusProjeto statusEsperado){ 
    require(statusEsperado == projeto.status);
    _;     
  }

  constructor (
    uint16 _projetoID, 
    string memory _projetoNome, 
    address _responsavel,
    uint256 _saldo,
    uint128 _meta
    ){
    projeto.projetoID = _projetoID;
    projeto.projetoNome = _projetoNome;
    projeto.responsavel = _responsavel;
    projeto.saldo = _saldo;
    projeto.meta = _meta;
//    projetoStatus = StatusProjeto.Aberto;
    }  
  
    function projetoVer() public view returns(Projeto memory) {
      return projeto;
    }

    function projetoDoacoes() public view returns(address[] memory){
      return doadores;
    }

    function projetoValores() public view returns(uint256[] memory){
      return valores;
    }

    function projetoUpdate(uint256 _doacao, address _doador) public {
      projeto.saldo = address(this).balance;
      doadores.push(_doador);
      valores.push(_doacao);
    }

    function projetoFinalizar() onlyStatus(StatusProjeto.Aberto) public {
      projeto.status = StatusProjeto.Finalizado;
    } 

    function projetoSacar(address _owner) onlyOwner(_owner) onlyStatus(StatusProjeto.Finalizado) public payable{
    //Devemos restringir essa funcao? Pois, alguem pode doar depositar
    //depois que o projeto estiver finalizado, mas tabem o dono pode sacar
    //a qualquer momento
      (bool sent, bytes memory data) = payable(projeto.responsavel).call{value: address(this).balance}("");     
      projeto.saldo = address(this).balance;
    }

    //https://solidity-by-example.org/sending-ether/
    receive() external payable {}

    //https://solidity-by-example.org/sending-ether/
    fallback() external payable {}

  }

