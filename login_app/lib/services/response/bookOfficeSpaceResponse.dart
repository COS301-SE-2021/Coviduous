class bookOfficeSpaceResponse {
  //add code for response object
  bool successful = false;

  bookOfficeSpaceResponse(bool sucess) {
    this.successful = sucess;
  }

  bool getResponse() {
    return successful;
  }
}
