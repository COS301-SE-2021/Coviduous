class PermissionRequest {
    constructor(permissionRequestId, permissionId,userId, userEmail,shiftNumber, timestamp, reason, adminId, companyId)
    {
        this.permissionRequestId = permissionRequestId;
        this.permissionId=permissionId;
        this.userId = userId;
        this.userEmail = userEmail;
        this.shiftNumber = shiftNumber;
        this.timestamp = timestamp;
        this.reason = reason;
        this.adminId = adminId;
        this.companyId = companyId;

        console.log("created permission request class");
    }
}

module.exports = PermissionRequest