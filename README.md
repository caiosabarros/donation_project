# godonation-contracts


# Propósito

<p>Com o intuito de tornar o processo de ONGs receberem doações e de doadores fazerem doações a ONGs mais seguro, acessível, descentralizado, transparente e rápido, a GoBlockchain torna publica uma solução que usa da tecnologia do Blockchain a fim de alcançar o intuito descrito.</p>

# Funcionalidades

<p>Nesta seção, estão descritas todas as funcionalidades possíveis ao usuário, tanto o usuário como um doador, quanto o usuário como uma ONG, e também para o usuário que será ambos. De forma visual, as funcionalidade estão representadas no diagrama UML.</p>

## Diagrama UML

![image](https://user-images.githubusercontent.com/82603176/151069691-bf9c87ea-ec5d-4681-bd5b-f75cdd5cbddc.png)


## Descricao do UML:

## Contrato Doação:

<p>Responsabilidade: Responsável por definir as principais funções de interação do usuário com o DApp de doações para as ONGs, assim como permite um usuário de criar suas propria ONG e criar projetos atrelada a mesma a fim de receber doações.</p>

## Eventos:

`DoacaoRealizada:Projeto.saldo (uint128,bool)` : Evento retorna ao usuário informação relevantes sobre a função fazerDoacao()

`ResponsavelAlterado(address to, address from)`: Evento retorna o antigo responsável pelo contrato e o novo, será emitida ao final da função mudarResponsável

`SaqueRealizado(uint128, address)` Evento retorna o responsável pelo saque e o valor sacado, será emitida ao final da função FinalizarProjeto()

`ProjetoFinalizado(saldo,address)`Evento retorna o responsável pelo projeto finalizado e o valor arrecadado, será emitida ao final da função sacarSaldo()

`ProjetoCriado(Struct Projeto): address' Evento retorna o endereço do contrato do projeto e a struct Projeto, será emitida ao final da função CriarProjeto()

### Funções:

`criarONG(string _ongNome)`: cria uma struct ONG com o ongNome igual a string passada como argumento.

`criarProjeto(string _projetoNome, uint128 _meta)`: cria uma struct de um projeto, com seu respectivo nome e meta de doacoes a ser alcancada.

`mudarResponsavel(address _novoResponsavel)`: delega outro endereço na rede blockchain para ser o responsável pelo contrato inteligente do projetos da ONG ao qual foi indicado a mudança, mudando o dono do projeto e conferindo ao mesmo funções de saque e finalização do projeto.

`sacarSaldo(uint16 _projetoID)`: permite apenas ao responsável pela ONG e pelo contrato inteligente do projeto sacar o saldo armazenado dentro de um projeto a partir das doações realizadas pelos doadores.

`finalizarProjeto()`: finaliza a oportunidade de o projeto continuar recebendo doações. A função sacarSaldo() deve ser usada a o fim de resgatar o saldo de doações mesmo depois de o projeto haver sido finalizado.

`fazerDoacao(uint16 _projetoID)`: Usuário escolhe um projeto por meio do seu ID e realiza a doação via msg.value

### Funções de Leitura:

Estas funções abaixo fazem a requisição de dados contidos na blockchain a fim de trazer ao usuário um registro do que realmente está acontecendo na aplicação.

`verONGs() => Array<struct:ONG>`: retorna uma lista de todas as ONGs atualmente cadastradas na aplicação.

`verProjetos(uint16 _ongID) => Array<struct:Projetos>`: retornar uma lsita de todos os projetos de uma determinada ONG.

`verDoadores(uint16 _projetoID) => array<address: Projetos.doadores>`: retorna uma lista de endereços que fizeram uma doação para um determinado projeto.

`verValores(uint16 _projetoID) => array<uint128: Projetos.valores>`: retorna uma lista de todos os valores doados a um determinado projeto.

`verSomaSaldosONG(uint16 _ongID) => uint128 ONG.ongSaldo`: retorna o valor da soma de todas as doações de todos os projetos dentro daquela ONG por meio do struct ONG e do parâmetro ongSaldo dentro do struct.

`verSaldo(uint16_ projetoID) => uint128 Projetos.saldo`: retorna o valor doado até agora para um determinado projeto.

`verDoacaoTotalDApp() => uint 128 doacaoTotalDApp`: retorna o valor acumlado de todas as doaçães entre todos os projetos dentro da DApp.

`verDoacoes(address _address) => ************`: retorna o registro de todas as doações de determinado usuário.

	 
### Descrição de Variáveis:

<p>Algumas variáveis são necessárias para que as funções acima desempenhem os seus papeis:</p>

`struct Projeto`: Contrato inteligente periferíco ao contrato doação. Quando a função `criarProjeto()` é chamada. E criado um novo contrato inteligente que contém as características do projeto determinado em uma struct. O smart contract pode então receber doações que serão sacadas apenas pelo responsável da ONG/Projeto. Um projeto segue a seguinte estrutura: 
```
struct Projeto:
projetoNome: string,
projetoID: uin16,
responsavel: address,
saldo: uint128,
doadores: array<address>,
valores: array<uint128>,
projetoDoacoes: mapping(address, uint128),
meta: uint128
```

<p>Os inputs necessários por parte da ONG que está criando o projeto são: <projetoNome> e <meta>. Parâmetro responsável será igual ao endereço da carteira <msg.sender> que chamou a função criarProjeto(), <projetoId> será uma uint16 incrementada a cada novo projeto criado.Todos os parâmetros que não foram passados na função `criarProjeto()` serão desenvolvidos no backend a medida que o dono do projeto e os doadores interagem com o projeto. </p>

<p>No contrato Doação, entretanto, haverá outras variáveis:</p>

Estrutura ONG:
```
ONG:
owner: address,
ongNome: string,
ongSaldo: uint128,
ongID: uint16
```

---

`projetosNumero`: atuará como um contador de projetos para identificar cada projeto com um ID específico.

---

`mapping(uint16 projetoID, struct Projeto) projetos`: responsável por ligar cada ID a uma determinada estrutura de projeto.

---

`ongsLista: Array<struct>` 

----

`projetosONG: mapping(uint16 ongID, projetosLista)`: conecta uma lista de estruturas de Projetos e uma determinada ONG por meio do seu ID.

----

`ongsNumero uint16`: atuará como contador para identificar cada ONG com um determinado ID específico e único.

----

`mapping(ongsNumero uint16, struct ONG)`: conecta cada estrutura de uma ONG a um determinado ID.

---

`enum statusProjeto{ Aberto, Finalizado, Sacado}`: enumera  tres estados possíveis para um projeto em relação a sua disponibilidade de receber doações. Modo Aberto: projeto aceita doações e ainda não pode ter o saque efetuado. Modo Finalizado: projeto não aceita mais doações e pode ter o saque efetuado. Modo Sacado: projeto não aceita mais doações e já teve seu saldo sacado, ficando apenas disponível para visualização.

|                |Aberto                          |Finalizado                         |   Sacado                                 |
|----------------|----------------|----------------|------------------
|Doacoes |         Aceita         |  Nao Aceita            |      Nao Aceita      |
|Saque          |      Nao Aceita | Aceita           |         Nao Aceita       |

----

`doacoes`:

----

`listaDoacoes: mapping(string projetoNome, uint128)`: armazena uma lista com todos os valores indivíduais sendo doados a um determinado projeto.

----

`doacaoTotalDApp: uint128`: armazena o valor total de doações da DApp até o momento.

