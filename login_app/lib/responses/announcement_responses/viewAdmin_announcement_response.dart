class ViewAdminAnnouncementResponse {
  String message;
  String type;
  String date;

  ViewAnnouncementResponse(String message, String type, String date) {
    this.message = message;
    this.date = date;
    this.type = type;
  }

  /*  String getDate() {
        return date;
    }

     String getMessage() {
        return message;
    }

     String getType() {
        return type;
    }

     void setType(String type) {
        this.type = type;
    }*/
}
