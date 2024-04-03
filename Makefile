-include .env

fork-sepolia:
	@echo "Building broker binary..."
	@anvil --fork-url ${SEPOLIA_RPC_URL}

deploy-sepolia:
	@echo "Deploying to sepolia..."
	@forge script ./script/Deploy.s.sol --rpc-url ${SEPOLIA_RPC_URL}  --broadcast --private-key ${PRIVATE_KEY} --etherscan-api-key ${ETHERSCAN_KEY} --verify -vvvvv


test-fix:
	@echo "Testing fix..."
	@forge t --match-path test/Bankfix.t.sol -vvvv


test-bank:
	@echo "Testing fix..."
	@forge t --match-path test/Bank.t.sol -vvvv
