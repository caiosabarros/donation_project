//https://ethereum.stackexchange.com/questions/82903/trying-to-compile-running-node-compile-js-but-get-error-assert-js350-thro
const path = require('path');
const fs = require('fs');
const solc = require('solc');

const inboxpath = path.resolve(__dirname, 'contracts', 'Donation.sol');
const source = fs.readFileSync(inboxpath, 'UTF-8');

var input = {
    language: 'Solidity',
    sources: {
        'Donation.sol' : {
            content: source
        }
    },
    settings: {
        outputSelection: {
            '*': {
                '*': [ '*' ]
            }
        }
    }
};

var output = JSON.parse(solc.compile(JSON.stringify(input)));

exports.abi = output.contracts['Donation.sol']['Donation'].abi;
exports.bytecode = output.contracts['Donation.sol']['Donation'].evm.bytecode.object;

