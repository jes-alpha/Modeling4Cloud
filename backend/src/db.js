//const url = 'mongodb://10.0.0.18:27017/pings';
//const url = 'mongodb://nodeUser:modelingforcloudnode@localhost:27017/pings?authSource=admin';
// const url = 'mongodb://albertobagnacani:modeling4cloud@10.0.0.14/pings'; // TODO secrets?
//const url = 'mongodb://albertobagnacani:modeling4cloud@137.204.57.93:27017/pings'; // TODO secrets?

const url = 'mongodb://jBianco:m4cloud@ds034807.mlab.com:34807/modelling4cloud';

var mongoose = require('mongoose');

mongoose.connect(url, function(err, db){
    if (err) console.log('Unable to connect to DB ' + url + '. Error: ' + err);
    else console.log('Connection established to DB:' + url);
});