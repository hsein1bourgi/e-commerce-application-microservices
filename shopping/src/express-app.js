const express = require('express');
const cors  = require('cors');
const path = require('path');
const { shopping, appEvents } = require('./api');
const { CreateChannel } = require('./utils')

module.exports = async (app) => {

    app.use(express.json());
    app.use(cors());
    app.use(express.static(__dirname + '/public'))
    app.get('/health', (req, res) => {
        res.status(200).json({ status: "OK", service: "shopping" });
    });
 
    //api
    // appEvents(app);

    const channel = await CreateChannel()

    shopping(app, channel);
    // error handling
    
}
