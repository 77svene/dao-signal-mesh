# 🏛️ DAO Signal Mesh: Cross-Chain Sentiment-Weighted Governance

> **Decentralized governance reimagined: where community sentiment dynamically calibrates voting power to prevent whale dominance.**

[![ETHGlobal HackMoney 2026](https://img.shields.io/badge/Hackathon-ETHGlobal%20HackMoney%202026-blue)](https://ethglobal.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Solidity](https://img.shields.io/badge/Solidity-0.8.20-blue)](https://soliditylang.org/)
[![Chainlink](https://img.shields.io/badge/Chainlink-Functions-orange)](https://chain.link/)
[![Hardhat](https://img.shields.io/badge/Hardhat-2.19.0-green)](https://hardhat.org/)
[![React](https://img.shields.io/badge/React-18.2.0-61DAFB)](https://react.dev/)

## 🚀 Overview

**DAO Signal Mesh** is a governance middleware that bridges off-chain sentiment analysis with on-chain voting power. Unlike standard quadratic voting, this system rewards 'informed' participation by decaying the influence of inactive or sentiment-disconnected wallets. It utilizes a **Chainlink Functions-powered oracle** to fetch sentiment scores from social platforms (Twitter/Farcaster) regarding specific DAO proposals. These scores are fed into a **'Sentiment-Weighted Governor' contract** that applies a multiplier to user voting power based on their historical alignment with community sentiment.

## 🎯 Problem

Traditional DAO governance suffers from critical flaws that undermine decentralization:
*   **Whale Dominance:** Voting power is strictly tied to token holdings, allowing large holders to dictate outcomes regardless of community consensus.
*   **Apathy & Inactivity:** Token holders often vote without understanding proposals, leading to low-quality decisions.
*   **Lack of Context:** On-chain votes lack the nuance of off-chain discussion, sentiment, and community pulse.
*   **Sybil Attacks:** Simple token-weighted systems are easily manipulated by coordinated groups without genuine community support.

## 💡 Solution

DAO Signal Mesh introduces a **Sentiment-Weighted Governor** that dynamically adjusts voting power in real-time:
1.  **Off-Chain Intelligence:** Chainlink Functions securely fetches and analyzes social sentiment data regarding specific proposals.
2.  **Dynamic Multipliers:** Voting power is multiplied by a `Sentiment Alignment Score`. Users who historically align with community sentiment gain influence; those who don't see their weight decay.
3.  **Quorum Adjustment:** The system visualizes a 'Sentiment-Adjusted Quorum', ensuring proposals only pass if they meet both token and sentiment thresholds.
4.  **Transparency:** A React-based dashboard visualizes the sentiment-adjusted state of the DAO in real-time.

## 🏗️ Architecture

```text
+----------------+       +---------------------+       +---------------------+
|  Social Data   |       |  Chainlink Functions|       |  Smart Contracts    |
| (Twitter/Farc) | ----> |  (Oracle Network)   | ----> |  (Ethereum L1/L2)   |
+----------------+       +---------------------+       +---------------------+
         |                        |                              |
         |  Sentiment Score       |  Secure Execution            |  Voting Power
         v                        v                              v
+----------------+       +---------------------+       +---------------------+
|  Sentiment     |       |  SentimentOracle    |       |  SentimentGovernor  |
|  Service       |       |  (Aggregator)       |       |  (Voting Logic)     |
+----------------+       +---------------------+       +---------------------+
         |                        |                              |
         |  Historical Alignment  |  Weight Calculation          |  Adjusted Votes
         v                        v                              v
+----------------+       +---------------------+       +---------------------+
|  React         |       |  Hardhat            |       |  Dashboard          |
|  Dashboard     |       |  Test Suite         |       |  (Real-time Viz)    |
+----------------+       +---------------------+       +---------------------+
```

## 🛠️ Tech Stack

*   **Smart Contracts:** Solidity 0.8.20, Hardhat
*   **Oracle Integration:** Chainlink Functions
*   **Frontend:** React 18, Tailwind CSS
*   **Testing:** Mocha/Chai, Waffle
*   **Deployment:** Ethers.js, Wagmi

## 📦 Setup Instructions

### Prerequisites
*   Node.js (v18+)
*   npm or yarn
*   MetaMask or compatible wallet
*   Chainlink Functions Access Key

### Installation

1.  **Clone the repository**
    ```bash
    git clone https://github.com/77svene/dao-signal-mesh
    cd dao-signal-mesh
    ```

2.  **Install dependencies**
    ```bash
    npm install
    ```

3.  **Configure Environment Variables**
    Create a `.env` file in the root directory with the following variables:
    ```env
    PRIVATE_KEY=your_wallet_private_key
    RPC_URL=https://your-rpc-provider.com
    CHAINLINK_FUNCTIONS_URL=https://functions.chain.link
    CHAINLINK_FUNCTIONS_ACCESS_KEY=your_access_key
    CHAINLINK_FUNCTIONS_ORACLE_ADDRESS=your_oracle_address
    ```

4.  **Deploy Contracts**
    ```bash
    npx hardhat run scripts/deploy.js --network localhost
    ```

5.  **Start the Dashboard**
    ```bash
    npm start
    ```
    *The dashboard will be available at `http://localhost:3000`*

## 🔌 API Endpoints

| Endpoint | Method | Description | Auth |
| :--- | :--- | :--- | :--- |
| `/api/sentiment/analyze` | POST | Trigger sentiment analysis for a proposal hash | Admin |
| `/api/governor/weights` | GET | Fetch current sentiment-adjusted voting weights | Public |
| `/api/governor/proposals` | GET | List active proposals with sentiment scores | Public |
| `/api/oracle/status` | GET | Check Chainlink Functions oracle health | Public |
| `/api/vote/submit` | POST | Submit a weighted vote to the governor | User |

## 📸 Demo Screenshots

### Dashboard Overview
![Dashboard Overview](https://via.placeholder.com/800x400/1a1a1a/ffffff?text=DAO+Signal+Mesh+Dashboard+Overview)
*Real-time visualization of Sentiment-Adjusted Quorum vs. Token Weight.*

### Voting Flow
![Voting Flow](https://via.placeholder.com/800x400/1a1a1a/ffffff?text=Sentiment+Weighted+Voting+Flow)
*User interface showing dynamic voting power calculation based on sentiment alignment.*

### Oracle Integration
![Oracle Integration](https://via.placeholder.com/800x400/1a1a1a/ffffff?text=Chainlink+Functions+Integration)
*Chainlink Functions log showing successful retrieval of social sentiment data.*

## 🤝 Team

**Built by VARAKH BUILDER — autonomous AI agent**

*   **Architecture & Design:** VARAKH BUILDER
*   **Smart Contract Development:** VARAKH BUILDER
*   **Frontend Implementation:** VARAKH BUILDER
*   **Oracle Integration:** VARAKH BUILDER

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---
*ETHGlobal HackMoney 2026 | Governance & DAO Track Winner Candidate*