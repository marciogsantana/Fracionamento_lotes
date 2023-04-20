const { expect } = require("chai");

describe("FractionalNFT", function() {   // teste funcao addMInterAuthorized
  let fractionalNFT;
  let owner;
  let minter;

  beforeEach(async () => {
    const FractionalNFT = await ethers.getContractFactory("FractionalNFT");
    fractionalNFT = await FractionalNFT.deploy();
    [owner, minter] = await ethers.getSigners();
  });

  it("Should add a minter as authorized", async function() {
    await fractionalNFT.addMInterAuthorized(minter.address); 
  
  });

  it("Should revert if a non-owner tries to add an authorized minter", async function() {
    const nonOwner = await ethers.getSigner(1);

    await expect(fractionalNFT.connect(nonOwner).addMInterAuthorized(nonOwner.address)).to.be.revertedWith("Ownable: caller is not the owner");

    
    
  });
}); 

describe("FractionalNFT", function () {  // teste funcao removeMinterAuthorized
  let fractionalNFT;

  beforeEach(async () => {   // necessario para iniciar os testes
    const FractionalNFT = await ethers.getContractFactory("FractionalNFT");
    fractionalNFT = await FractionalNFT.deploy();
    await fractionalNFT.deployed();
  });

  it("Should remove a minter as authorized", async function () {
    const [owner, minter] = await ethers.getSigners();

   await fractionalNFT.removeMinterAuthorized(minter.address);

        
  });

  it("Should revert if a non-owner tries to remove an authorized minter", async function () {
    const [owner, nonOwner] = await ethers.getSigners();

    await expect(
      fractionalNFT.connect(nonOwner).removeMinterAuthorized(nonOwner.address)
    ).to.be.revertedWith("Ownable: caller is not the owner");
  
    
  });
});


describe("FractionalNFT", function () {  // teste função mint
  let fractionalNFT;
  let owner;
  let authorizedMinter;
  let accounts;

  beforeEach(async () => {
    [owner, authorizedMinter, ...accounts] = await ethers.getSigners(); // recebendo as contas

    const FractionalNFT = await ethers.getContractFactory("FractionalNFT");
    fractionalNFT = await FractionalNFT.deploy();

    await fractionalNFT.addMInterAuthorized(authorizedMinter.address);
  });

  describe("mint()", function () {  // fazendo o mint
    it("Should mint a new token", async function () {
      await fractionalNFT.connect(authorizedMinter).mint();
     
    });
  });
});

describe("fractionalize()", function () {  // funcao fracionar NFT
  it("Should only allow the AA to fractionalize the token", async function () {
    const FractionalNFT = await ethers.getContractFactory("FractionalNFT");
    const [_owner, _minter, _notAA] = await ethers.getSigners();
   
    // voltar aqui para continuar e pedir ajuda 
    // travou no teste de apenas as AA 
      
  });
});

describe("transferFraction()", function() {
  let fractionalNFT;

  beforeEach(async () => {
    const FractionalNFT = await ethers.getContractFactory("FractionalNFT");
    fractionalNFT = await FractionalNFT.deploy();
    await fractionalNFT.deployed();

    // autorização
  await fractionalNFT.onlyAuthorized("0xbDA5747bFD65F08deb54cb465eB87D40e51B197E");
  });

  it("Should revert if any argument is empty", async function() {
    // Prepare test data
    const tokenId = 1;
    const to = ethers.constants.AddressZero;
    const amount = 0;

    // Call the function and assert
    await expect(
      fractionalNFT.transferFraction(tokenId, to, amount)
    ).to.be.revertedWith("transfer to zero address");

  });
});

describe("transferFraction_populares()", function() {
  let fractionalNFT;

  beforeEach(async () => {
    const FractionalNFT = await ethers.getContractFactory("FractionalNFT");
    fractionalNFT = await FractionalNFT.deploy();
    await fractionalNFT.deployed();
     // autorização
  await fractionalNFT.popularAuthorized("0xbDA5747bFD65F08deb54cb465eB87D40e51B197E");
  });

  it("Should revert if any argument is empty", async function() {
    // Prepare test data
    const tokenId = 1;
    const to = ethers.constants.AddressZero;
    const amount = 0;

    // Call the function and assert
    await expect(
      fractionalNFT.transferFraction(tokenId, to, amount)
    ).to.be.revertedWith("transfer to zero address");

  });
});


