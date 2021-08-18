class User {
    constructor(userId, type, firstName, lastName, email, userName, companyId, companyName, companyAddress) {
        this.userId = userId;
        this.type = type;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.userName = userName;
        this.companyId = companyId;
        this.companyName = companyName;
        this.companyAddress = companyAddress;

        console.log("created user class");
    }
}

module.exports = User;