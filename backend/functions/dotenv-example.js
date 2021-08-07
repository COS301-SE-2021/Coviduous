//Should return undefined
console.log('No value for Firebase URL yet:', process.env.FirebaseDatabaseURL);

// If you'd like to only run this code from a production environment: NODE_ENV=production node dotenv-example.js
// if (process.env.NODE_ENV !== 'production') {
//     require('dotenv').config();
// }

//Otherwise just do: node dotenv-example.js
require('dotenv').config();

//Should return a URL
console.log('Now the value for Firebase URL is:', process.env.FirebaseDatabaseURL);