/**
 * This class holds the response object for registering a company
 */
class RegisterCompanyResponse {
  bool response;
  String responseMessage;

  RegisterCompanyResponse(bool response, String responsemessage) {
    this.response = response;
    this.responseMessage = responsemessage;
  }

  bool getResponse() {
    return this.response;
  }

  String getResponseMessage() {
    return this.responseMessage;
  }
}
