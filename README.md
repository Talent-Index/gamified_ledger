## Gamified Ledger Starter

This repo is the starter template for the in-person session. The `main` branch will stay lightweight and only contain the template skeleton. The full working codebase lives on the `complete` branch.

If you want to follow along live, stay on `main`. If you want the finished reference implementation, switch to `complete`.

## Setup Guide

### 1. Fork and clone your own copy

Fork this repository to your own GitHub account, then clone your fork locally.

```shell
git clone https://github.com/<your-username>/gamified_ledger.git
cd gamified_ledger
```

If you already cloned the repo, make sure you are on the branch you want to work from:

```shell
git checkout main
```

### 2. Install Foundry

If Foundry is not installed yet, run:

```shell
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

After installation, verify the tools are available:

```shell
forge --version
cast --version
anvil --version
```

### 3. Set up environment variables

Create a local `.env` file at the root of the project and add your deployment values.

```shell
touch .env
```

Example `.env` values:

```bash
AVALANCHE_FUJI_RPC_URL=https://api.avax-test.network/ext/bc/C/rpc
PRIVATE_KEY=0xYOUR_PRIVATE_KEY_HERE
```

Use the private key setup instructions in this deck before adding your wallet key:

https://docs.google.com/presentation/d/1Me52eDyLuugxrlMwyPq4Ek-nDnu_e7_4eZHapkNEZqA/mobilepresent?slide=id.p22

Load the variables into your shell before running Forge commands:

```shell
source .env
```

### 4. Build and test locally

```shell
forge build
forge test
forge fmt
```

## Deploying To Avalanche Fuji

This contract has no constructor arguments, so deployment is straightforward.

### Option 1: Deploy directly with `forge create`

```shell
source .env
forge create \
	--rpc-url "$AVALANCHE_FUJI_RPC_URL" \
	--private-key "$PRIVATE_KEY" \
	src/LoyaltyPoints.sol:LoyaltyPoints
```

### Option 2: Deploy with the Forge script

If you prefer a scripted deployment, use the included Forge script with the same `AVALANCHE_FUJI_RPC_URL` and `PRIVATE_KEY` values.

```shell
source .env
forge script \
	--rpc-url "$AVALANCHE_FUJI_RPC_URL" \
	--broadcast \
	script/LoyaltyPoints.s.sol:LoyaltyPointsScript
```

### Before you deploy

Make sure the wallet you use for deployment has test AVAX on Fuji. If not, use the Avalanche Fuji faucet before running the deployment command.

## Session Notes

- `main` is the template skeleton only.
- `complete` contains the full codebase.
- We will write the main code together during the session.

## Useful Commands

```shell
forge build
forge test
forge fmt
forge create --rpc-url "$AVALANCHE_FUJI_RPC_URL" --private-key "$PRIVATE_KEY" src/LoyaltyPoints.sol:LoyaltyPoints
forge script --rpc-url "$AVALANCHE_FUJI_RPC_URL" --broadcast script/LoyaltyPoints.s.sol:LoyaltyPointsScript
```
