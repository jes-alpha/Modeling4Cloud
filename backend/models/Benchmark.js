const mongoose = require('mongoose');
var mongoosePaginate = require('mongoose-paginate');

var BenchmarkSchema = new Schema({
    provider: String,
    ip: String,
    timestamp: { type : Date, default: Date.now },
    threads: Number,
    duration: Number,
    events: Number,
    eventsPerSec: Number

}).plugin(mongoosePaginate);

const Benchmark = mongoose.model('Benchmark', BenchmarkSchema);

module.exports = Benchmark;