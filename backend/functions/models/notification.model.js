class Notification {
    constructor(notificationId, userId, userEmail, subject, message, timestamp, adminId, companyId)
    {
        this.notificationId = notificationId;
        this.userId = userId;
        this.userEmail = userEmail;
        this.subject = subject;
        this.message = message;
        this.timestamp = timestamp;
        this.adminId = adminId;
        this.companyId = companyId;

        console.log("created notification class");
    }

    // getNotificationId(){
    //     return this.notificationId;
    // }
}

module.exports = Notification;