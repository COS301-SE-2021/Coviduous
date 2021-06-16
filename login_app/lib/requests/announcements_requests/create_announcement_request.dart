class CreateAnnouncementRequest {
  	String message;
	String type;
	String AdminID;
	String CompanyID;

	CreateAnnouncementRequest(String type, String message, String AdminID, String CompanyID) 
	{
		this.type = type;
		this.message = message;
		this.AdminID = AdminID;
		this.CompanyID = CompanyID;
	}
}