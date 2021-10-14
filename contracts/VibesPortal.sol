// SPDX-License-Identifier: UNLICENSE

pragma solidity ^0.8.0;

contract VibesPortal {
	enum Reaction {
		Happy,
		Cool,
		Hype
	}

	struct Vibe {
		Reaction reaction;
		string message;
		address viber;
		uint256 timestamp;
	}

	uint256 totalVibes;
	uint256 private seed;

	Vibe[] public vibeList;
	mapping(address => uint256) public lastVibedAt;

	event NewVibe(
		Reaction reaction,
		string message,
		address indexed from,
		uint256 timestamp
	);

	constructor() payable {}

	function vibe(Reaction _reaction, string memory _message) public {
		// anti-spam check
		require(
			lastVibedAt[msg.sender] + 15 minutes < block.timestamp,
			"Wait 15 minutes to send another vibe."
		);
		lastVibedAt[msg.sender] = block.timestamp;

		// prize randomness
		totalVibes += 1;
		vibeList.push(Vibe(_reaction, _message, msg.sender, block.timestamp));
		emit NewVibe(_reaction, _message, msg.sender, block.timestamp);

		// store private seed to make gaming it more difficult
		uint256 randomNumber = (block.difficulty + block.timestamp + seed) %
			100;
		seed = randomNumber;

		// check preconditions to enter the draw
		bool entersDraw = _reaction != Reaction.Happy ||
			bytes(_message).length > 20;

		// grants prize
		if (entersDraw && randomNumber < 40) {
			uint256 prizeAmount = 0.0001 ether;
			require(
				prizeAmount <= address(this).balance,
				"Contract funds are insufficient to grant prize."
			);
			(bool success, ) = (msg.sender).call{value: prizeAmount}("");
			require(success, "Failed to withdraw money from contract.");
		}
	}

	function getAllVibes() public view returns (Vibe[] memory) {
		return vibeList;
	}

	function getTotalVibes() public view returns (uint256) {
		return vibeList.length;
	}
}
