import admin from "firebase-admin";
import { readFileSync } from "fs";

// Load the service account key from the JSON file
const serviceAccount = JSON.parse(
    readFileSync('./config/serviceAccountKey.json', 'utf8')
);

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
});

export default admin;
