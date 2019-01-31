const mongoose = require('mongoose');
var mongoosePaginate = require('mongoose-paginate');

let Schema = mongoose.Schema;

var BandwidthSchema = new Schema({
    provider: String,
    from_zone: String,
    to_zone: String,
    from_host: String,
    to_host: String,
    timestamp: { type : Date, default: Date.now },
    bandwidth: Number,
    duration: Number,
    parallel: Number,
    transfer: Number,
    retransmissions: Number
}).plugin(mongoosePaginate);

const Bandwidth = mongoose.model('Bandwidth', BandwidthSchema);

module.exports = Bandwidth;