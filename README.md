# ChainShield — Web3 Security Operations Center

ChainShield is a portfolio-ready Web3 security application combining a SOC-style dashboard, on-chain incident registry, role-based access control, transaction risk scoring, and browser-native cryptography.

## Features
- Solidity smart contract with Admin / Analyst / Responder roles
- On-chain incident registration and resolution
- MetaMask wallet connection
- Transaction risk scoring with explainable signals
- SHA-256 hashing and AES-GCM encrypted security notes
- SOC dashboard with severity metrics and incident timeline
- Local demo mode so the UI works without a wallet
- Hardhat tests and GitHub Actions CI

## Run the dashboard
```bash
cd frontend
python -m http.server 5500
```
Open http://localhost:5500

## Smart contract
```bash
npm install
npx hardhat test
npx hardhat node
# in another terminal
npx hardhat run scripts/deploy.js --network localhost
```

Never use a real wallet private key in this project. Use a disposable test wallet only.

## Resume bullet
Built a Web3 Security Operations Center using Solidity, role-based access control, on-chain incident logging, transaction risk scoring, SHA-256/AES-GCM cryptography, MetaMask integration, and automated smart-contract testing with GitHub Actions.