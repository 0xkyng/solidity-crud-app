// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

contract CrudApp {
    struct Country {
        string name;
        string leader;
        uint256 population;
    }

    Country[] public countries;

    uint256 public totalCountries;

    constructor() {
        totalCountries = 0;
    }

    event CountryEvent(string countryName, string leader, uint256 population);

    event LeaderUpdated(string countryName, string leader);

    event CountryDelete(string countryName);

    function insert(
        string calldata countryName,
        string calldata leader,
        uint256 population
    ) public returns (uint256) {
        Country memory newCountry = Country(countryName, leader, population);
        countries.push(newCountry);
        totalCountries++;
        //emit event
        emit CountryEvent(countryName, leader, population);
        return totalCountries;
    }

    function updateLeader(
        string calldata countryName,
        string calldata newLeader
    ) public returns (bool) {
        //This has a problem we need loop
        for (uint256 i = 0; i < totalCountries; i++) {
            if (compareStrings(countries[i].name, countryName)) {
                countries[i].leader = newLeader;
                emit LeaderUpdated(countryName, newLeader);
                return true;
            }
        }
        return false;
    }

    function deleteCountry(string calldata countryName) public returns (bool) {
        require(totalCountries > 0);
        for (uint256 i = 0; i < totalCountries; i++) {
            if (compareStrings(countries[i].name, countryName)) {
                countries[i] = countries[totalCountries - 1]; // pushing last into current arrray index which we gonna delete
                totalCountries--; //total count decrease
                countries.pop(); // array length decrease
                //emit event
                emit CountryDelete(countryName);
                return true;
            }
        }
        return false;
    }

    function getCountry(
        string memory countryName
    ) public view returns (string memory name, string memory leader, uint256 population) {
        Country[] memory _countries = countries;
        for (uint256 i = 0; i < totalCountries; i++) {
            if (compareStrings(_countries[i].name, countryName)) {
                //emit event
                return (
                    countries[i].name,
                    countries[i].leader,
                    countries[i].population
                );
            }
        }
        revert("Country not found");
    }

    function compareStrings(string memory a, string memory b) internal pure returns (bool) {
        return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
    }

    function getTotalCountries() public view returns (uint256 length) {
        return countries.length;
    }
}