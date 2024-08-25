// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract JobPlacement {
    struct Graduate {
        uint id;
        string name;
        string skills;
        string qualifications;
        address wallet;
    }

    struct Job {
        uint id;
        string title;
        string requiredSkills;
        string requiredQualifications;
        address employer;
        bool isFilled;
    }

    uint public graduateCount = 0;
    uint public jobCount = 0;

    mapping(uint => Graduate) public graduates;
    mapping(uint => Job) public jobs;

    event GraduateAdded(uint id, string name);
    event JobPosted(uint id, string title);
    event JobMatched(uint jobId, uint graduateId);
    event JobAccepted(uint jobId, uint graduateId);

    // Add a new graduate
    function addGraduate(string memory _name, string memory _skills, string memory _qualifications) public {
        graduateCount++;
        graduates[graduateCount] = Graduate(graduateCount, _name, _skills, _qualifications, msg.sender);
        emit GraduateAdded(graduateCount, _name);
    }

    // Post a new job
    function postJob(string memory _title, string memory _requiredSkills, string memory _requiredQualifications) public {
        jobCount++;
        jobs[jobCount] = Job(jobCount, _title, _requiredSkills, _requiredQualifications, msg.sender, false);
        emit JobPosted(jobCount, _title);
    }

    // Match job with graduate
    function matchJob(uint _jobId, uint _graduateId) public view returns (bool) {
        Job memory job = jobs[_jobId];
        Graduate memory graduate = graduates[_graduateId];
        
        if (compareStrings(job.requiredSkills, graduate.skills) && compareStrings(job.requiredQualifications, graduate.qualifications)) {
            return true;
        }
        return false;
    }





// Accept a job offer
    function acceptJob(uint _jobId, uint _graduateId) public {
        require(graduateExists(_graduateId), "Graduate does not exist.");
        require(jobExists(_jobId), "Job does not exist.");
        require(matchJob(_jobId, _graduateId), "Graduate does not match job criteria.");
        require(msg.sender == graduates[_graduateId].wallet, "Only the graduate can accept the job.");
        require(!jobs[_jobId].isFilled, "Job has already been filled.");
        
        jobs[_jobId].isFilled = true;
        emit JobAccepted(_jobId, _graduateId);
    }

    // Utility function to compare strings
    function compareStrings(string memory a, string memory b) internal pure returns (bool) {
        return keccak256(bytes(a)) == keccak256(bytes(b));
    }

    // Check if a graduate exists
    function graduateExists(uint _graduateId) internal view returns (bool) {
        return graduates[_graduateId].wallet != address(0);
    }

    // Check if a job exists
    function jobExists(uint _jobId) internal view returns (bool) {
        return jobs[_jobId].employer != address(0);
    }
}
    

