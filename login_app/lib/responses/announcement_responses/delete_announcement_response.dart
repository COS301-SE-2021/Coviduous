class DeleteAnnouncementResponse {
  bool successful;
  String response;

  DeleteAnnouncementResponse(bool succsess, String resp) {
    this.successful = succsess;
    this.response = resp;
  }

  String getResponse() {
    return this.response;
  }

  bool isSuccessful() {
    return this.successful;
  }
}
