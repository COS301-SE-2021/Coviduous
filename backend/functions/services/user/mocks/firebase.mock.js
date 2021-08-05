let _messagesDb = null;

class Firebase {
    constructor() {
        _messagesDb = "Mock message DB";
    }

    async addMessage(message) {
        console.log("Mock add message to DB operation");
    }

    getCurrentUser() {
        return "Mock current user";
    }

    async updateProfile(profile) {
        console.log("Mock update profile operation");
    }

    async signOut() {
        console.log("Mock sign out operation");
    }

    setAuthStateListener(listener) {
        console.log("Mock set auth state listener operation");
    }

    setMessagesListener(listener) {
        return "Mock message listener";
    }

    getMessage() {
        return "Mock message";
    }

    async setToken(token) {
        console.log("Mock set token operation");
    }
}

module.exports = Firebase;