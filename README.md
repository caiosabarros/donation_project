# godonation-contracts


# Proposito

<p>Com o intuito de tornar o processo de ONGs receberem doacoes e de doadores fazerem doacoes a ONGs mais seguro, acessivel, descentralizado, facil e rapido, a GoBlockchain torna publica uma solucao que usa da tecnologia do Blockchain a fim de alcancar o intuito descrito.</p>

# Funcionalidades

<p>Nesta secao, estao descritas todas as funcionalidades possiveis ao usuario, tanto o usuario que sera apenas um doador, tanto o usuario que sera apenas uma ONG, e tambem para um usuario que sera ambos. De forma visual, as funcionalidade estao descritas no diagrama UML.</p>

## Diagrama UML

Anexar Diagrama UML

## Descricao do UML:

## Contrato Doacao:

<p>Responsabilidade: Responsavel por definir as principais funcoes de interacao do usuario com o DApp de doacoes para as ONGs, assim como permite um usuario de criar suas propria ONG e criar projetos atrelada a mesma a fim de receber doacoes.</p>

### Funcoes:

`criarONG(string _ongNome)`: cria uma struct ONG com o ongNome igual a string passada como argumento.

`criarProjeto(string _projetoNome, uint128 _meta)`: cria uma struct de um projeto, com seu respectivo nome e meta de doacoes a ser alcancada.

`mudarResponsavel(address _novoResponsavel)`: delega outro endereco na rede blockchain para ser o responsavel pelos saques dos fundos doados aos projetos da ONG.

`sacarSaldo(uint16 _projetoID)`: permite apenas ao responsavel pela ONG sacar o saldo armazenado dentro de um projeto a partir das doacoes realizadas pelos doadores.

`finalizarProjeto()`: finaliza a oportunidade de o projeto continuar recebendo doacoes. A funcao sacarSaldo() deve ser usada a fim de o saldo de doacoes ser sacado mesmo depois de o projeto haver sido finalizado.

`fazerDoacao(uint16 _projetoID)`: Usuario escolhe um projeto por meio do seu ID e realiza a doacao por meio do msg.value

### Funcoes de Leitura:

Estas funcoes abaixo apenas fazem a requisicao de dados contidos na blockchain a fim de usuario ter um registro do que realmente esta' acontecendo na aplicacao.

`verONGs() => Array<struct:ONG>`: retorna uma lista de todas as ONGs atualmente cadastradas na aplicacao.

`verProjetos(uint16 _ongID) => Array<struct:Projetos>`: retornar uma lsita de todos os projetos de uma determinada ONG.

`verDoadores(uint16 _projetoID) => array<address: Projetos.doadores>`: retorna uma lista de enderecos que fizeram uma doacao para um determinado projeto.

`verValores(uint16 _projetoID) => array<uint128: Projetos.valores>`: retorna uma lista de todos os valores doados a um determinado projeto.

`verSomaSaldosONG(uint16 _ongID) => uint128 ONG.ongSaldo`: retorna o valor da soma de todas as doacoes de todos os projetos dentro daquela ONG por meio do struct ONG e do parametro ongSaldo dentro do struct.

`verSaldo(uint16_ projetoID) => uint128 Projetos.saldo`: retorna o valor doado ate' agora para um determinado projeto.

`verDoacaoTotalDApp() => uint 128 doacaoTotalDApp`: retorna o valor acumlado de todas as doacoes entre todos os projetos dentro da DApp.

`verDoacoes(address _address) => ************`: retorna o registro de todas as doacoes de determinado usuario.

	 
### Descricao de Variaveis:

<p>Algumas variaveis fazem-se necessarias para que as funcoes acima desempenhem os seus papeis:</p>

`struct Projeto`: um novo smart contract e' criado quando a funcao `criarProjeto()` e' chamada. Este novo smart contract conte'm as caracteristicas do projeto determinado em uma struct. O smart contract pode entao receber doacoes que ficarao nele e serao sacadas apenas pelo responsavel da ONG. Um projeto segue a seguinte estrutura: 
```
Projeto:
projetoNome: string,
projetoID: uin16,
responsavel: address,
saldo: uint128,
doadores: array<address>,
valores: array<uint128>,
projetoDoacoes: mapping(address, uint128),
meta: uint128
```

<p>Todos os parametros que nao foram passados na funcao `criarProjeto()` serao desenvolvidos por tra's das cameras 'a medida que o dono do projeto e os doadores interagem com o projeto.</p>

<p>No contrato Doacao, entretanto, havera muitas outras variaveis:</p>

Estrutura ONG:
```
ONG:
owner: address,
ongNome: string,
ongSaldo: uint128,
ongID: uint16
```

---

`projetosNumero`: atuara como um contador de projetos para identificar cada projeto com um ID especifico.

---

`mapping(uint16 projetoID, struct Projeto) projetos`: responsavel por ligar cada ID a uma determinada estrutura de projeto.

---

`ongsLista: Array<struct>` 

----

`projetosONG: mapping(uint16 ongID, projetosLista)`: conecta uma lista de estruturas de Projetos e uma determinada ONG por meio do seu ID.

----

`ongsNumero uint16`: atuara como contador para identificar cada ONG com um determinado ID especifico e unico.

----

`mapping(ongsNumero uint16, struct ONG)`: conecta cada estrutura de uma ONG a um determinado ID.

---

`enum statusProjeto{ Aberto, Finalizado, Sacado}`: enumera  tres estados possiveis para um projeto em relacao a sua disponibilidade de receber doacoes. Modo Aberto: projeto aceita doacoes e ainda nao pode ter o saque efetuado. Modo Finalizado: projeto nao aceita mais doacoes e pode ter o saque efetuado. Modo Sacado: projeto nao aceita mais doacoes e ja teve seu saldo sacado, ficando apenas disponivel para visualizacao agora.

|                |Aberto                          |Finalizado                         |   Sacado                                 |
|----------------|----------------|----------------|------------------
|Doacoes |         Aceita         |  Nao Aceita            |      Nao Aceita      |
|Saque          |      Nao Aceita | Aceita           |         Nao Aceita       |

----

`doacoes`:

----

`listaDoacoes: mapping(string projetoNome, uint128)`: armazena uma lista com todos os valores individuais sendo doados a um determinado projeto.

----

`doacaoTotalDApp: uint128`: armazena o valor total de doacoes da DApp ate' o momento.

