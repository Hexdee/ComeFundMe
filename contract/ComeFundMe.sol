// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract ComeFundMe {
    struct Campaign {
        uint id;
        address payable creator;
        uint created_at;
        string title;
        string description;
        string image;
        uint amount;
        uint contributors;
        uint raised;
        bool ended;
    }

    uint private total;
    Campaign[] internal campaigns;

    function createCampaign(
        string memory _title,
        string memory _description,
        string memory _image,
        uint _amount
    ) public {
        Campaign memory newCampaign = Campaign(
            total,
            payable(msg.sender),
            block.timestamp,
            _title,
            _description,
            _image,
            _amount,
            0,
            0,
            false
        );
        campaigns.push(newCampaign);
        total++;
    }

    function getCampaign(uint _id) public view returns (Campaign memory) {
        require(_id < total, "Invalid id");
        return campaigns[_id];
    }

    function getTotal() public view returns (uint) {
        return total;
    }

    function donate(uint _id) public payable {
        require(_id < total, "Invalid id");
        require(msg.value > 0, "Amount must be greater than 0!");
        require(campaigns[_id].ended == false, "Campaign has ended");
        campaigns[_id].contributors++;
        campaigns[_id].raised += msg.value;
    }

    function withdraw(uint _id) public {
        require(_id < campaigns.length, "Invalid id");
        require(
            campaigns[_id].creator == msg.sender,
            "Only creator can withdraw"
        );
        require(campaigns[_id].ended == false, "Funds has been withdrawn!");
        campaigns[_id].creator.transfer(campaigns[_id].raised);
        campaigns[_id].ended = true;
    }
}
