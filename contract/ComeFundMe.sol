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
            uint deadline;


        }

        uint private total;
        Campaign[] internal campaigns;
            event CampaignCreated(
                uint indexed id,
                address indexed creator,
                string title,
                string description,
                string image,
                uint amount,
                uint deadline
            );

            event DonationMade(
                uint indexed id,
                address indexed contributor,
                uint amount
            );

            event CampaignEnded(
                uint indexed id
            );



        function createCampaign(
            string memory _title,
            string memory _description,
            string memory _image,
            uint _amount,
            uint _deadline
        ) public {
             require(bytes(_title).length > 0, "Title cannot be empty");
             require(bytes(_description).length > 0, "Description cannot be empty");
             require(_amount > 0, "Amount must be greater than 0");

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
                false,
                _deadline
            );
            campaigns.push(newCampaign);
            total++;

        emit CampaignCreated(newCampaign.id, newCampaign.creator, newCampaign.title, newCampaign.description, newCampaign.image, newCampaign.amount, newCampaign.deadline);

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

          emit DonationMade(_id, msg.sender, msg.value);

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

                emit CampaignEnded(_id);

        }

        function getDaysLeft(uint _id) public view returns (uint) {
            require(_id < total, "Invalid id");
            require(campaigns[_id].ended == false, "Campaign has ended");
            Campaign memory campaign = campaigns[_id];
            uint timeLeft = campaign.deadline - block.timestamp;
            if (timeLeft > 0) {
                return timeLeft / 86400; // 86400 seconds in a day
            } else {
                return 0;
            }
        }

    }
