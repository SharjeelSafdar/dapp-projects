const FakeDai = artifacts.require("FakeDai");
const ApiToken = artifacts.require("ApiToken");
const MySplitter = artifacts.require("MySplitter");
const accounts = require("./ganacheAccounts.json");

module.exports = async (callback, acc) => {
  const fakeDai = await FakeDai.deployed();
  const apiToken = await ApiToken.deployed();
  const mySplitter = await MySplitter.deployed();

  const shareHolders = accounts.slice(0, 5);
  const daiSender = accounts[5];

  const amount = "500" + "000000000000000000";

  console.log("Shares Before:");
  for (let i = 0; i < shareHolders.length; ++i) {
    let shares = await apiToken.getShares(shareHolders[i]);
    console.log(`\tAcc${i}:`, shares.toString() / 1e18, "ATKN");
  }
  console.log("");

  const fromIndex = 0;
  const toIndex = 1;
  console.log(
    `Sending ${amount / 1e18} ATKN from Acc${fromIndex} to Acc${toIndex}...`
  );
  await apiToken.transfer(shareHolders[toIndex], amount, {
    from: shareHolders[fromIndex],
  });
  console.log("");

  console.log("Shares After:");
  for (let i = 0; i < shareHolders.length; ++i) {
    let shares = await apiToken.getShares(shareHolders[i]);
    console.log(`\tAcc${i}:`, shares.toString() / 1e18, "ATKN");
  }

  callback();
};
