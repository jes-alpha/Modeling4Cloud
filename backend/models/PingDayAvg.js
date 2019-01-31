const mongoose = require('mongoose');
var mongoosePaginate = require('mongoose-paginate');

let Schema = mongoose.Schema;

var PingSchema = new Schema({
    provider: String,
    from_zone: String,
    to_zone: String,
    day: Date,
    avg: Number,
    count: Number
}).plugin(mongoosePaginate);

const PingDayAvg = mongoose.model('PingDayAvg', PingSchema);

module.exports = PingDayAvg;