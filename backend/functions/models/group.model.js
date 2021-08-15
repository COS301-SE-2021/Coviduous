class Group {
    constructor(groupNumber, groupName, userEmails, shiftNumber, adminId) {
        this.groupNumber = groupNumber;
        this.groupName = groupName;
        this.userEmails = userEmails;
        this.shiftNumber = shiftNumber;
        this.adminId = adminId;

        console.log("Created group class");
    }

    Group(groupNumber, groupName, userEmails, shiftNumber, adminId) {
        return new Group(groupNumber, groupName, userEmails, shiftNumber, adminId)
    }
}

module.exports = Group;