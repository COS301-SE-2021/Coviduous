class Announcement {
    constructor(announcementId, type, message, timestamp, companyId, adminId)
    {
        this.announcementId = announcementId;
        this.type = type;
        this.message = message;
        this.timestamp = timestamp;
        this.companyId = companyId;
        this.adminId = adminId;

        console.log("created announcement class");
    }

    createAnnouncement(announcementId, type, message, timestamp, companyId, adminId) {
        return new Announcement(announcementId, type, message, timestamp, companyId, adminId);
    }

    // getAnnouncementId(){
    //     return this.announcementId;
    // }
}

module.exports=Announcement;