const Migrations = artifacts.require("Migrations");
const Donation = artifacts.require("Donation");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(Donation);
};
