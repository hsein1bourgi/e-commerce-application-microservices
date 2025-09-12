const express = require('express');
const { PORT } = require('./config');
const { databaseConnection } = require('./database');
const expressApp = require('./express-app');

const StartServer = async() => {

    const app = express();
    
    await databaseConnection();
    
    await expressApp(app);

    app.listen(PORT, () => {
        console.log(`listening to port ${PORT}`);
    })
    .on('error', (err) => {
        console.log(err);
        process.exit();
    })

}

StartServer();
<<<<<<< HEAD
console.log("Starting Products Service...");
console.log("Fix bugs in products service");    
=======

console.log("Fix bugs in products service");
console.log("Starting Products Service...");
>>>>>>> 3449b0f98ec8ba8408f9fc55862f0c8d542ee5b5
