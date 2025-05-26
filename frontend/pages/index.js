import { useEffect, useState } from "react";
import { ethers } from "ethers";
import ArtNFTPlatformABI from "../contracts/ArtNFTPlatform.json";

const CONTRACT_ADDRESS = "DEPLOYED_CONTRACT_ADDRESS_HERE";

export default function Home() {
  const [provider, setProvider] = useState(null);
  const [signer, setSigner] = useState(null);
  const [contract, setContract] = useState(null);
  const [account, setAccount] = useState(null);
  const [tokenURI, setTokenURI] = useState("");
  const [minting, setMinting] = useState(false);
  const [nfts, setNfts] = useState([]);
  const [erc20Balance, setErc20Balance] = useState("0");

  // Connect wallet & setup provider, signer, contract
  async function connectWallet() {
    if (!window.ethereum) {
      alert("Please install MetaMask!");
      return;
    }
    const provider = new ethers.BrowserProvider(window.ethereum);
    await provider.send("eth_requestAccounts", []);
    const signer = await provider.getSigner();
    const contract = new ethers.Contract(CONTRACT_ADDRESS, ArtNFTPlatformABI, signer);
    const account = await signer.getAddress();

    setProvider(provider);
    setSigner(signer);
    setContract(contract);
    setAccount(account);
  }

  // Mint NFT function
  async function mintNFT() {
    if (!contract) return;
    if (!tokenURI) {
      alert("Please enter a tokenURI");
      return;
    }
    setMinting(true);
    try {
      const tx = await contract.mintNFT(tokenURI);
      await tx.wait();
      alert("NFT minted successfully!");
      setTokenURI("");
      loadNFTs();
      loadERC20Balance();
    } catch (e) {
      console.error(e);
      alert("Minting failed");
    }
    setMinting(false);
  }

  // Load NFTs minted on the contract
  async function loadNFTs() {
    if (!contract) return;
    try {
      const totalSupply = await contract.totalSupply();
      const nftData = [];
      for (let i = 0; i < totalSupply; i++) {
        const tokenId = await contract.tokenByIndex(i);
        const uri = await contract.tokenURI(tokenId);
        const owner = await contract.ownerOf(tokenId);
        nftData.push({ tokenId: tokenId.toString(), uri, owner });
      }
      setNfts(nftData);
    } catch (e) {
      console.error("Failed to load NFTs:", e);
    }
  }

  // Load ERC20 balance of connected user
  async function loadERC20Balance() {
    if (!contract || !account) return;
    try {
      const balance = await contract.balanceOf(account);
      setErc20Balance(ethers.formatUnits(balance, 18)); // adjust decimals if needed
    } catch (e) {
      console.error("Failed to load ERC20 balance:", e);
    }
  }

  // When account or contract changes, load data
  useEffect(() => {
    if (contract && account) {
      loadNFTs();
      loadERC20Balance();
    }
  }, [contract, account]);

  return (
    <div style={{ maxWidth: 800, margin: "auto", padding: 20, fontFamily: "Arial" }}>
      <h1>ArtNFTPlatform</h1>

      {!account ? (
        <button onClick={connectWallet} style={{ padding: 10, fontSize: 16 }}>
          Connect Wallet
        </button>
      ) : (
        <div>
          <p>
            Connected: <b>{account}</b>
          </p>
          <p>ERC20 Token Balance: {erc20Balance}</p>

          <h2>Mint NFT</h2>
          <input
            type="text"
            placeholder="Token URI"
            value={tokenURI}
            onChange={(e) => setTokenURI(e.target.value)}
            style={{ width: "80%", padding: 8 }}
          />
          <button onClick={mintNFT} disabled={minting} style={{ padding: 10, marginLeft: 10 }}>
            {minting ? "Minting..." : "Mint NFT"}
          </button>

          <h2>Minted NFTs</h2>
          {nfts.length === 0 ? (
            <p>No NFTs minted yet.</p>
          ) : (
            <ul>
              {nfts.map(({ tokenId, uri, owner }) => (
                <li key={tokenId} style={{ marginBottom: 12 }}>
                  <b>Token ID:</b> {tokenId} <br />
                  <b>Owner:</b> {owner} <br />
                  <b>Token URI:</b> <a href={uri} target="_blank" rel="noreferrer">{uri}</a>
                </li>
              ))}
            </ul>
          )}
        </div>
      )}
    </div>
  );
}
