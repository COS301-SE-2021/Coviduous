class Announcement {
    constructor(announcementId, type, message, timestamp, adminId, companyId)
    {
        this.announcementId = announcementId;
        this.type = type;
        this.message = message;
        this.timestamp = timestamp;
        this.adminId = adminId;
        this.companyId = companyId;

        console.log("created announcement class");
    }

    createAnnouncement(announcementId, type, message, timestamp, adminId, companyId) {
        return new Announcement(announcementId, type, message, timestamp, adminId, companyId);
    }
}

module.exports = Announcement;