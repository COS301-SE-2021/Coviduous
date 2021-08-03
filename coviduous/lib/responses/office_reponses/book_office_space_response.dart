/**
 * This class holds the response object for booking an office space
 */

class BookOfficeSpaceResponse {
  bool successful = false;

  BookOfficeSpaceResponse(bool success) {
    this.successful = success;
  }

  bool getResponse() {
    return successful;
  }
}
