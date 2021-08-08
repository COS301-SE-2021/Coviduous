class Notification{
    constructor(notificationId, type, message, timestamp, companyId, adminId)
    {
        this.notificationId = notificationId;
        this.type = type;
        this.message = message;
        this.timestamp = timestamp;
        this.companyId = companyId;
        this.adminId = adminId;

        console.log("created notification class");
    }

    createNotification(notificationId, type, message, timestamp, companyId, adminId) {
        return new Notification(notificationId, type, message, timestamp, companyId, adminId);
    }

    getNotificationId(){
        return this.notificationId;
    }
}

module.exports=Notification;