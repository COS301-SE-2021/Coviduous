class HealthCheck {
    constructor(healthCheckId, userId, name, surname, email, phoneNumber, temperature, fever, cough, soreThroat, chills, aches, nausea, shortnessOfBreadth, lossOfTasteSmell)
    {
        this.healthCheckId = healthCheckId;
        this.userId = userId;
        this.name = name;
        this.surname = surname;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.temperature = temperature;
        this.fever = fever;
        this.cough = cough;
        this.soreThroat = soreThroat;
        this.chills = chills;
        this.aches = aches;
        this.nausea = nausea;
        this.shortnessOfBreadth = shortnessOfBreadth;
        this.lossOfTasteSmell = lossOfTasteSmell;

        console.log("created health check class");
    }
}