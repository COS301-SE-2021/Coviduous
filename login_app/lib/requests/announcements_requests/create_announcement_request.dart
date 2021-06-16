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

	String getType()
	{
		return this.type;
	}

	String getMessage()
   	{
		return this.message;
	}

	String getAdminID()
   	{
		return this.AdminID;
	}

	String getCompanyID()
   	{
		return this.CompanyID;
	}
}