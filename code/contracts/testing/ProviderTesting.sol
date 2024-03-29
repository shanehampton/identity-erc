pragma solidity ^0.4.24;

contract IdentityRegistry {
    function mintIdentityDelegated(string identity, address identityAddress, uint8 v, bytes32 r, bytes32 s) public;
    function getIdentity(address _address) public view returns (string identity);
    function addResolvers(string identity, address[] resolvers) public;
    function removeResolvers(string identity, address[] resolvers) public;
    function addAddress(
        string identity,
        address approvingAddress,
        address addressToAdd,
        uint8[2] v, bytes32[2] r, bytes32[2] s, uint salt) public;
    function removeAddress(string identity, address addressToRemove, uint8 v, bytes32 r, bytes32 s, uint salt) public;
}

contract ProviderTesting {
    IdentityRegistry registry;

    constructor (address identityRegistryAddress) public {
        registry = IdentityRegistry(identityRegistryAddress);
    }

    function stringsEqual(string memory first, string memory second) public pure returns (bool) {
        return keccak256(abi.encodePacked(first)) == keccak256(abi.encodePacked(second));
    }

    function mintIdentityDelegated(string identity, address identityAddress, uint8 v, bytes32 r, bytes32 s) public {
        registry.mintIdentityDelegated(identity, identityAddress, v, r, s);
    }


    function addResolvers(address[] resolvers) public {
        registry.addResolvers(registry.getIdentity(msg.sender), resolvers);
    }

    function removeResolvers(string identity, address[] resolvers) public {
        require(
            stringsEqual(registry.getIdentity(msg.sender), identity),
            "This provider only allows resolvers to be removed from addresses associated with the identity in question"
        );
        registry.removeResolvers(identity, resolvers);
    }

    function addAddress(
        string identity,
        address approvingAddress,
        address addressToAdd,
        uint8[2] v, bytes32[2] r, bytes32[2] s, uint salt
    ) public {
        registry.addAddress(identity, approvingAddress, addressToAdd, v, r, s, salt);
    }

    function removeAddress(string identity, address addressToRemove, uint8 v, bytes32 r, bytes32 s, uint salt) public {
        registry.removeAddress(identity, addressToRemove, v, r, s, salt);
    }
}
