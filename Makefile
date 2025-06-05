VRF_ABI_ARTIFACT := ./abis/DappLinkVRF.sol/DappLinkVRF.json
FACTORY_ABI_ARTIFACT := ./abis/DappLinkVRFFactory.sol/DappLinkVRFFactory.json

contract-caller:
	env GO111MODULE=on go build -v $(LDFLAGS) ./cmd/contract-caller

clean:
	rm contract-caller

test:
	go test -v ./...

lint:
	golangci-lint run ./...

bindings: binding-vrf binding-factory


binding-vrf:
	$(eval temp := $(shell mktemp))

	cat $(VRF_ABI_ARTIFACT) \
    	| jq -r .bytecode.object > $(temp)

	cat $(VRF_ABI_ARTIFACT) \
		| jq .abi \
		| abigen --pkg bindings \
		--abi - \
		--out bindings/dapplinkvrf.go \
		--type DappLinkVRF \
		--bin $(temp)

		rm $(temp)

binding-factory:
	$(eval temp := $(shell mktemp))

	cat $(FACTORY_ABI_ARTIFACT) \
    	| jq -r .bytecode.object > $(temp)

	cat $(FACTORY_ABI_ARTIFACT) \
		| jq .abi \
		| abigen --pkg bindings \
		--abi - \
		--out bindings/dapplinkfactory.go \
		--type DappLinkVRFFactory \
		--bin $(temp)

		rm $(temp)

.PHONY: \
	contract-caller \
	bindings \
	binding-vrf \
	binding-factory \
	clean \
	test \
	lint