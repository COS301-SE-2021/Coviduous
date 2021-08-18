class Permission {
    constructor(permissionId, userId, timestamp, officeAccess, grantedBy)
    {
        this.permissionId = permissionId;
        this.userId = userId;
        this.timestamp = timestamp;
        this.officeAccess = officeAccess;
        this.grantedBy = grantedBy;

        console.log("created permission class");
    }
}

module.exports = Permission