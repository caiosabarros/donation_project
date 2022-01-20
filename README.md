Project: ONGs

Purpose: Make it possible for anyone to donate to an ONG project using cryptocurrencies assets. Make it possible for anyone that represents an ONGto create a campaign to receive a donation in cryptocurrencies from anyone that uses the blockchain, for the ONG being represented.

The project is divided into groups of functionalities that share similar purposes within the project as follows:

Organization

Donation

There is also an interface that acts as an standard if there is any more querys to launch more ONG donation projects.

IDonation

Let's dive into the functionalities and variables within each group of functions:

Organization:
address ongsRepresentative: identifies the address of who represents the ONG.
ongId: identifies the ONG with a numerical number. 
function changeRepresentative(): makes it possible for the current representative to change the address of that represents the ONG.

Donation:
mapping donatingList: it's a mapping of the addresses that donated to a specific project and the amount they have donated.
Project: it is a data structure that contains the main information about the project's.
Donor: data structure that contains the main information about the address that is donating the assets into a specific project.
function addProject(): functionality of letting anyone to add a new project into the ecossystem and represent an ONG.
function getBalance(): functionality of retrieving a project's balance.
function donate(): it allows an individual to make a donation to a specific project.
function withdraw(): function that withdraws all the cryptocurrency assets donated to a project till such a time of being called. The function is restricted to the representative of the ONG through his address. The function also is called receiving the id of the project from which the money is being withdrawn. 

#Questions: 
Is there a limit to how many projects can be added into the DApp?

Here are some important data for gas costs:
type(uint8).max = 255, type(int8).max = 127


