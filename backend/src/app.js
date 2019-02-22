var express = require('express');
var paginate = require('express-paginate');
var bodyParser = require('body-parser');
var multer = require('multer');
var fs = require('fs');

var db = require('./db');
var Ping = require('../models/Ping');
var Bandwidth = require('../models/Bandwidth');
var PingDayAvg = require('../models/PingDayAvg');
var Benchmark = require('../models/Benchmark');

var app = express();
var router = express.Router();
var readline = require('readline');

const UPLOAD_PATH = '../uploads/';
const upload = multer({ dest: UPLOAD_PATH });

const UPLOADBW_PATH = '../uploadsBW/';
const uploadBW = multer({ dest: UPLOADBW_PATH });

const UPLOADBM_PATH = '../uploadsBM/';
const uploadBM = multer({ dest: UPLOADBM_PATH });

app.use(paginate.middleware(100, 200));

router.use(bodyParser.urlencoded({ extended: true }));
router.use(bodyParser.json());

app.use(function (req, res, next) {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Credentials', 'true');
    res.setHeader('Access-Control-Allow-Methods', 'GET, HEAD, OPTIONS, POST, PUT, DELETE');
    res.setHeader('Access-Control-Allow-Headers', 'Access-Control-Allow-Headers, Origin, Accept, X-Requested-With, Content-Type, Access-Control-Request-Method, Access-Control-Request-Headers');

    // and remove cacheing so we get the most recent
    //res.setHeader('Cache-Control', 'no-cache');
    next();
});

router.get('/', function (req, res) {
    res.json({ message: 'API Initialized!' });
});

router.route('/uploadBenchmarks').post(uploadBM.single('data'), function (req, res) {
    fs.rename(UPLOADBM_PATH + req.file.filename, UPLOADBM_PATH + req.file.originalname, function (err) {
        if (err) return res.status(500).send("Problem in POST\n");
        res.status(200).send("File registered\n");
        console.log("File uploaded(Benchmark test):" + req.file.originalname);
        const { exec } = require('child_process');
        exec('tail -n +2 ' + UPLOADBM_PATH + req.file.originalname + ' |  sed \'/,,/d\' | sed \'/,SA,/d\'  | mongoimport --uri ' + db.url + ' -c benchmarks --type csv"', (err, stdout, stderr) => {
        //exec('tail -n +2 ' + UPLOADBM_PATH + req.file.originalname + ' |  sed \'/,,/d\' | sed \'/,SA,/d\'  | mongoimport --uri ' + db.url + ' -c benchmarks --type csv --columnsHaveTypes --fields "provider.string\(\),ip.string\(\),timestamp.date\(2006-01-02T15:04:05-00:00\),threads.int32\(\),totalTime.int32\(\),totalEvents.int32\(\),cpus.int32\(\)"', (err, stdout, stderr) => {
            if (err) {
                // TODO
                console.log(err)
                return;
            }
        });
    });
});

router.route('/upload').post(upload.single('data'), function (req, res) {
    fs.rename(UPLOAD_PATH + req.file.filename, UPLOAD_PATH + req.file.originalname, function (err) {
        if (err) return res.status(500).send("Problem in POST\n");
        res.status(200).send("File registered\n");
        console.log("File uploaded(Ping):" + req.file.originalname);

        const { exec } = require('child_process'); // TODO secrets?
        exec('tail -n +2 ' + UPLOAD_PATH + req.file.originalname + ' |  sed \'/,,/d\' | sed \'/,SA,/d\' | sed \'/,RA,/d\' | mongoimport --uri "' + db.url + '" -c pings --type csv --columnsHaveTypes --fields "provider.string\(\),from_zone.string\(\),to_zone.string\(\),from_host.string\(\),to_host.string\(\),icmp_seq.int32\(\),ttl.int32\(\),time.double\(\),timestamp.date\(2006-01-02T15:04:05-00:00\)"', (err, stdout, stderr) => {
            //exec('tail -n +2 '+ UPLOAD_PATH+req.file.originalname +' |  sed \'/,,/d\' | sed \'/,SA,/d\' | sed \'/,RA,/d\' | mongoimport -h localhost:27017 -u nodeUser -p modelingforcloudnode -d pings -c pings --authenticationDatabase admin --type csv --columnsHaveTypes --fields "provider.string\(\),from_zone.string\(\),to_zone.string\(\),from_host.string\(\),to_host.string\(\),icmp_seq.int32\(\),ttl.int32\(\),time.double\(\),timestamp.date\(2006-01-02T15:04:05-00:00\)"', (err, stdout, stderr) => {
            //exec('tail -n +2 '+ UPLOAD_PATH+req.file.originalname +' | mongoimport -h 10.0.0.14:27017 -d pings -c pings -u albertobagnacani -p modeling4cloud --type csv --columnsHaveTypes --fields "provider.string\(\),from_zone.string\(\),to_zone.string\(\),from_host.string\(\),to_host.string\(\),icmp_seq.int32\(\),ttl.int32\(\),time.double\(\),timestamp.date\(2006-01-02T15:04:05-00:00\)"', (err, stdout, stderr) => {
            if (err) {
                console.log("Error in uploading file " + req.file.originalname);
                console.log(err)
                return;
            }
            else {
                readFirstLineCSV(UPLOAD_PATH + req.file.originalname);
            }
        });
    });
});

router.route('/uploadBandwidths').post(uploadBW.single('data'), function (req, res) {
    fs.rename(UPLOADBW_PATH + req.file.filename, UPLOADBW_PATH + req.file.originalname, function (err) {
        if (err) return res.status(500).send("Problem in POST\n");
        res.status(200).send("File registered\n");
        console.log("File uploaded(Bandwidth test):" + req.file.originalname);
        const { exec } = require('child_process'); // TODO secrets?
        exec('tail -n +2 ' + UPLOADBW_PATH + req.file.originalname + ' |  sed \'/,,/d\' | sed \'/,SA,/d\'  | mongoimport --uri ' + db.url + ' -c bandwidths --type csv --columnsHaveTypes --fields "provider.string\(\),from_zone.string\(\),to_zone.string\(\),from_host.string\(\),to_host.string\(\),timestamp.date\(2006-01-02T15:04:05-00:00\),bandwidth.double\(\),duration.int32\(\),parallel.int32\(\),transfer.double\(\),retransmissions.int32\(\)"', (err, stdout, stderr) => {

            // exec('tail -n +2 '+ UPLOADBW_PATH+req.file.originalname +' |  sed \'/,,/d\' | sed \'/,SA,/d\'  | mongoimport -h localhost:27017 -d pings -c bandwidths --type csv --columnsHaveTypes --fields "provider.string\(\),from_zone.string\(\),to_zone.string\(\),from_host.string\(\),to_host.string\(\),timestamp.date\(2006-01-02T15:04:05-00:00\),bandwidth.double\(\),duration.int32\(\),parallel.int32\(\),transfer.double\(\),retransmissions.int32\(\)"', (err, stdout, stderr) => {
            // exec('tail -n +2 '+ UPLOAD_PATH+req.file.originalname +' | mongoimport -h 10.0.0.14:27017 -d pings -c pings -u albertobagnacani -p modeling4cloud --type csv --columnsHaveTypes --fields "provider.string\(\),from_zone.string\(\),to_zone.string\(\),from_host.string\(\),to_host.string\(\),icmp_seq.int32\(\),ttl.int32\(\),time.double\(\),timestamp.date\(2006-01-02T15:04:05-00:00\)"', (err, stdout, stderr) => {
            if (err) {
                // TODO
                console.log(err)
                return;
            }
        });
    });
});

router.route('/precomputePings').get(async function (req, res, next) {
    if (req.query.file == null) {
        precomputeAllPings()
    }
    else {
        readFirstLineCSV(UPLOAD_PATH + req.query.file);
    }

    if (req.accepts('json')) {
        res.json({
            result: "Precomputing started"
        });
    }
});

function precomputeAllPings() {
    console.log("Started precompunting for the whole database")
    console.time("precomputeAllPings");
    Ping.aggregate()
        .group({
            _id: {
                provider: "$provider",
                from_zone: "$from_zone",
                to_zone: "$to_zone"
            }
        })
        .exec(async function (err, resp) {
            if (err) {
                // TODO
                console.log(err);
            } else {
                if (resp && resp.length > 0) {
                    for (var i = 0; i < resp.length; i++) {
                        console.log("Precompute for " + resp[i]["_id"]["provider"] + resp[i]["_id"]["from_zone"] + resp[i]["_id"]["to_zone"]);
                        await Ping.aggregate()
                            .match({
                                $and: [
                                    { provider: resp[i]["_id"]["provider"] },
                                    { from_zone: resp[i]["_id"]["from_zone"] },
                                    { to_zone: resp[i]["_id"]["to_zone"] }
                                ]
                            })
                            .group({
                                _id: {
                                    provider: "$provider",
                                    from_zone: "$from_zone",
                                    to_zone: "$to_zone",
                                    day: { $dateToString: { format: "%Y-%m-%d", date: "$timestamp" } }
                                },
                                avg: { $avg: "$time" },
                                count: { $sum: 1 }
                            })
                            .exec(async function (err, resp) {
                                if (err) {
                                    // TODO
                                    console.log(err);
                                } else {
                                    if (resp && resp.length > 0) {
                                        for (var i = 0; i < resp.length; i++) {
                                            await updateDayAvg(resp[i]);
                                        }
                                    }
                                    console.timeEnd("precomputeAllPings");
                                }
                            });
                    }
                }
            }
        });
}

function readFirstLineCSV(inputFile) {
    var lineReader = readline.createInterface({
        input: fs.createReadStream(inputFile),
    });
    var lineCounter = 0;
    var wantedLine;
    lineReader.on('line', function (line) {
        if (lineCounter == 1) {
            wantedLine = line;
            lineReader.close();
        }
        lineCounter++;
    });
    lineReader.on('close', function () {
        var fields = wantedLine.split(',');
        var provider = fields[0];
        var from_zone = fields[1];
        var to_zone = fields[2];
        var date = new Date(fields[8]);
        precomputePings(provider, from_zone, to_zone, date);
    });
}

async function precomputePings(provider, from_zone, to_zone, date) {

    var start = new Date();
    var end = new Date();
    start.setDate(date.getDate());
    start.setHours(0, 0, 0, 0);
    end.setDate(date.getDate());
    end.setHours(23, 59, 59, 999);
    var avg = await Ping.aggregate()
        .match({
            $and: [
                { provider: provider },
                { from_zone: from_zone },
                { to_zone: to_zone },
                {
                    timestamp: {
                        $gte: start,
                        $lte: end
                    }
                }
            ]
        })
        .group({
            _id: {
                provider: "$provider",
                from_zone: "$from_zone",
                to_zone: "$to_zone",
                day: { $dateToString: { format: "%Y-%m-%d", date: "$timestamp" } }
            },
            avg: { $avg: "$time" },
            count: { $sum: 1 }
        })
    console.log("Precompute:" + provider + "/" + from_zone + "/" + to_zone + "/" + date + ":");
    console.log(avg);
    if (avg != null && avg.length != 0)
        return await updateDayAvg(avg[0]);
}

async function updateDayAvg(avg) {
    avg._id.day = new Date(avg._id.day + "T00:00:00");
    var pingDayAvg;
    var query = await PingDayAvg.find({
        provider: avg._id.provider,
        from_zone: avg._id.from_zone,
        to_zone: avg._id.to_zone,
        day: avg._id.day
    });
    if (query && query.length > 0) {
        pingDayAvg = query[0];
        pingDayAvg.avg = avg.avg;
        pingDayAvg.count = avg.count;
    }
    else {
        pingDayAvg = new PingDayAvg({
            provider: avg._id.provider,
            from_zone: avg._id.from_zone,
            to_zone: avg._id.to_zone,
            day: avg._id.day,
            avg: avg.avg,
            count: avg.count
        });
    }

    const res = await pingDayAvg.save();
    return res;
}

router.route('/pings').get(async function (req, res, next) {
    try {
        const [results, itemCount] = await Promise.all([
            Ping.find().limit(req.query.limit).skip(req.skip).lean().exec(),
            Ping.find().count({})
        ]);

        const pageCount = Math.ceil(itemCount / req.query.limit);

        if (req.accepts('json')) {
            res.json({
                object: 'list',
                numberOfItems: results.length,
                totalNumberOfItems: itemCount,
                totalNumberOfPages: pageCount,
                hasMorePages: paginate.hasNextPages(req)(pageCount),
                data: results
            });
        }
    } catch (err) {
        next(err);
    }
});

router.route('/bandwidths').get(async function (req, res, next) {
    try {
        const [results, itemCount] = await Promise.all([
            Bandwidth.find().limit(req.query.limit).skip(req.skip).lean().exec(),
            Bandwidth.find().count({})
        ]);

        const pageCount = Math.ceil(itemCount / req.query.limit);

        if (req.accepts('json')) {
            res.json({
                object: 'list',
                numberOfItems: results.length,
                totalNumberOfItems: itemCount,
                totalNumberOfPages: pageCount,
                hasMorePages: paginate.hasNextPages(req)(pageCount),
                data: results
            });
        }
    } catch (err) {
        next(err);
    }
});

router.route('/pingsAvg').get(async function (req, res, next) {
    try {
        const [results, itemCount] = await Promise.all([
            PingDayAvg.find().limit(req.query.limit).skip(req.skip).lean().exec(),
            PingDayAvg.find().count({})
        ]);

        const pageCount = Math.ceil(itemCount / req.query.limit);

        if (req.accepts('json')) {
            res.json({
                object: 'list',
                numberOfItems: results.length,
                totalNumberOfItems: itemCount,
                totalNumberOfPages: pageCount,
                hasMorePages: paginate.hasNextPages(req)(pageCount),
                data: results
            });
        }
    } catch (err) {
        next(err);
    }
});

//--------------------- QUERY: PING ---------------------------

router.route('/pings/query/avgOfEveryPingOfSelectedDate').get(async (req, res, next) => {
    var start, end, crossRegion;

    start = new Date(req.query.start + "T00:00:00-00:00"); //YYYY-MM-DD
    end = new Date(req.query.end + "T23:59:59-00:00");
    crossRegion = parseInt(req.query.crossRegion); // 0 or 1
    console.log("avgOfPingsOfDate: start:" + start + ";end:" + end + ";crossRegion:" + crossRegion);
    Ping.aggregate()
        .match({ $and: [{ timestamp: { $gte: start, $lte: end } }] })
        .project({ provider: "$provider", from_zone: "$from_zone", to_zone: "$to_zone", time: "$time" })
        .group({
            _id: {
                provider: "$provider",
                from_zone: "$from_zone",
                to_zone: "$to_zone"
            },
            sum_time: { "$sum": "$time" },
            count: { $sum: 1 }
        })
        .addFields({
            crossRegion: { $abs: { $cmp: ["$_id.from_zone", "$_id.to_zone"] } }
        })
        .match({
            crossRegion: crossRegion
        })
        .group({
            _id: {
                provider: "$_id.provider"
            },
            sum_time: { $sum: "$sum_time" },
            count: { $sum: "$count" }
        })
        .project({
            "_id": 0,
            "provider": "$_id.provider",
            "avg": { $divide: ["$sum_time", "$count"] },
            "count": "$count"
        })
        .exec(function (err, resp) {
            if (err) {
                // TODO
                console.log(err);
            } else {
                res.json(resp);
            }
        })
});

router.route('/pings/query/avgOfSelectedDate').get(async (req, res, next) => {
    var start, end, crossRegion;

    start = new Date(req.query.start + "T00:00:00-00:00"); //YYYY-MM-DD
    end = new Date(req.query.end + "T23:59:59-00:00");
    crossRegion = parseInt(req.query.crossRegion); // 0 or 1
    console.log("avgOfPingsOfDate: start:" + start + ";end:" + end + ";crossRegion:" + crossRegion);
    PingDayAvg.aggregate()
        .match({ $and: [{ day: { $gte: start, $lte: end } }] })
        .project({
            provider: "$provider", from_zone: "$from_zone", to_zone: "$to_zone",
            count: "$count",
            weight: { $multiply: ["$avg", "$count"] },
            crossRegion: { $abs: { $cmp: ["$from_zone", "$to_zone"] } }
        })
        .match({
            crossRegion: crossRegion
        })
        .group({
            _id: {
                provider: "$provider",
                from_zone: "$from_zone",
                to_zone: "$to_zone"
            },
            total: { $sum: "$weight" },
            count: { $sum: "$count" }
        })
        .addFields({
            avg: { $divide: ["$total", "$count"] }
        })
        .group({
            _id: "$_id.provider",
            count: { $sum: "$count" },
            total: { $sum: { $multiply: ["$avg", "$count"] } },
        })
        .addFields({
            avg: { $divide: ["$total", "$count"] }
        })
        .project({
            provider: "$_id",
            avg: "$avg",
            "count": "$count"
        })
        .exec(function (err, resp) {
            if (err) {
                // TODO
                console.log(err);
            } else {
                res.json(resp);
            }
        })
});

router.route('/pings/query/avgOfZoneOfSelectedDate').get(async (req, res, next) => {
    var start, end, provider, from_zone, to_zone;

    start = new Date(req.query.start + "T00:00:00-00:00"); //YYYY-MM-DD
    end = new Date(req.query.end + "T23:59:59-00:00");
    from_zone = req.query.from_zone;
    to_zone = req.query.to_zone;
    if (req.query.zone != undefined) {
        from_zone = to_zone = req.query.zone;
    }
    provider = req.query.provider;
    console.log("avgOfZoneOfSelectedDate: start:" + start + ";end:" + end + ";from_zone:" + from_zone + " or to_zone:" + to_zone);
    PingDayAvg.aggregate()
        .match({ $and: [{ day: { $gte: start, $lte: end } }, { provider: provider }, { $or: [{ from_zone: from_zone }, { to_zone: to_zone }] }] })
        .project({
            provider: "$provider", from_zone: "$from_zone", to_zone: "$to_zone",
            count: "$count", weight: { $multiply: ["$avg", "$count"] }
        })
        .group({
            _id: {
                provider: "$provider",
                from_zone: "$from_zone",
                to_zone: "$to_zone"
            },
            total: { $sum: "$weight" },
            count: { $sum: "$count" }
        })
        .addFields({
            crossRegion: { $abs: { $cmp: ["$_id.from_zone", "$_id.to_zone"] } },
            avg: { $divide: ["$total", "$count"] }
        })
        .project({
            "_id": 0,
            "provider": "$_id.provider",
            "from_zone": "$_id.from_zone",
            "to_zone": "$_id.to_zone",
            "avg": "$avg",
            "count": "$count",
            crossRegion: "$crossRegion"
        })
        .exec(function (err, resp) {
            if (err) {
                // TODO
                console.log(err);
            } else {
                res.json(resp);
            }
        })
});

router.route('/pings/query/avgOfProviderOfSelectedDate').get(async (req, res, next) => {
    var start, end, provider, zone;
    start = new Date(req.query.start + "T00:00:00-00:00"); //YYYY-MM-DD
    end = new Date(req.query.end + "T23:59:59-00:00");
    provider = req.query.provider;
    console.log("avgOfZoneOfSelectedDate: start:" + start + ";end:" + end + ";provider:" + provider);
    PingDayAvg.aggregate()
        .match({ $and: [{ day: { $gte: start, $lte: end } }, { provider: provider }] })
        .project({
            provider: "$provider", from_zone: "$from_zone", to_zone: "$to_zone",
            count: "$count", weight: { $multiply: ["$avg", "$count"] }
        })
        .group({
            _id: {
                provider: "$provider",
                from_zone: "$from_zone",
                to_zone: "$to_zone"
            },
            total: { $sum: "$weight" },
            count: { $sum: "$count" }
        })
        .addFields({
            crossRegion: { $abs: { $cmp: ["$_id.from_zone", "$_id.to_zone"] } },
            avg: { $divide: ["$total", "$count"] }
        })
        .project({
            "_id": 0,
            "provider": "$_id.provider",
            "from_zone": "$_id.from_zone",
            "to_zone": "$_id.to_zone",
            "avg": "$avg",
            "count": "$count",
            crossRegion: "$crossRegion"
        })
        .exec(function (err, resp) {
            if (err) {
                // TODO
                console.log(err);
            } else {
                res.json(resp);
            }
        })
});

router.route('/pings/query/threshold').get(async (req, res, next) => { // Threshold is in us
    try {
        var query = {}, sortQuery = {};

        var field = (req.query.field) ? req.query.field : 'time';
        var threshold = (req.query.threshold) ? ((req.query.field == 'time') ? req.query.threshold / 1000 : req.query.threshold) : 0.5;
        var operator = (req.query.operator) ? req.query.operator : 'lte';
        (req.query.sort) ? sortQuery[field] = req.query.sort : sortQuery[field] = 1;
        console.log("threshold: filed:" + field + ";threshold:" + threshold + ";operator:" + operator);
        switch (operator) {
            case 'lt':
                query[field] = { $lt: threshold }
                break;
            case 'lte':
                query[field] = { $lte: threshold }
                break;
            case 'gt':
                query[field] = { $gt: threshold }
                break;
            case 'gte':
                query[field] = { $gte: threshold }
                break;
            case 'eq':
                query[field] = { $eq: threshold }
                break;
            case 'ne':
                query[field] = { $ne: threshold }
                break;
            default:
                query[field] = { $lt: threshold }
        }

        var [results, itemCount] = await Promise.all([
            Ping.find(query).sort(sortQuery).limit(req.query.limit).skip(req.skip).lean().exec(),
            Ping.find(query).count({})
        ]);

        const pageCount = Math.ceil(itemCount / req.query.limit);

        if (req.accepts('json')) {
            res.json({
                object: 'list',
                numberOfItems: results.length,
                totalNumberOfItems: itemCount,
                totalNumberOfPages: pageCount,
                hasMorePages: paginate.hasNextPages(req)(pageCount),
                data: results
            });
        }
    } catch (err) {
        next(err);
    }
});

router.route('/pings/query/range').get(async (req, res, next) => {
    try {
        var query = {}, sortQuery = {};

        var field = req.query.field ? req.query.field : 'timestamp';
        var start, end;
        console.log("range: field:" + field);
        switch (field) {
            case 'timestamp':
                start = new Date(req.query.start + "T00:00:00-00:00");
                end = new Date(req.query.end + "T23:59:59-00:00");
                break;
            case 'time':
                start = req.query.start / 1000;
                end = req.query.end / 1000;
                break;
            case 'ttl':
                start = req.query.start;
                end = req.query.end;
                break;
            default:
                start = new Date(req.query.start + "T00:00:00-00:00");
                end = new Date(req.query.end + "T23:59:59-00:00");
        }

        (req.query.sort) ? sortQuery[field] = req.query.sort : sortQuery[field] = 1;

        query[field] = { $gte: start, $lte: end };

        var [results, itemCount] = await Promise.all([
            Ping.find(query).sort(sortQuery).limit(req.query.limit).skip(req.skip).lean().exec(),
            Ping.find(query).count({})
        ]);

        const pageCount = Math.ceil(itemCount / req.query.limit);

        if (req.accepts('json')) {
            res.json({
                object: 'list',
                numberOfItems: results.length,
                totalNumberOfItems: itemCount,
                totalNumberOfPages: pageCount,
                hasMorePages: paginate.hasNextPages(req)(pageCount),
                data: results
            });
        }
    } catch (err) {
        next(err);
    }
});

router.route('/pings/query/zone').get(async (req, res, next) => { // TODO not working
    try {
        var query = {}, sortQuery = {};

        var zone = req.query.zone ? req.query.zone : 'same';

        (req.query.sort) ? sortQuery['time'] = req.query.sort : sortQuery['time'] = 1;

        (zone == 'same') ? query = { $where: "this.from_zone == this.to_zone" } : query = { $where: "this.from_zone != this.to_zone" };

        var [results, itemCount] = await Promise.all([
            Ping.find(query).sort(sortQuery).limit(req.query.limit).skip(req.skip).lean().exec(),
            Ping.find(query).count({})
        ]);

        const pageCount = Math.ceil(itemCount / req.query.limit);

        if (req.accepts('json')) {
            res.json({
                object: 'list',
                numberOfItems: results.length,
                totalNumberOfItems: itemCount,
                totalNumberOfPages: pageCount,
                hasMorePages: paginate.hasNextPages(req)(pageCount),
                data: results
            });
        }
    } catch (err) {
        next(err);
    }
});

router.route('/pings/query/provider').get(async (req, res, next) => {
    try {
        var provider = (req.query.provider) ? req.query.provider : 'AWS';

        const [results, itemCount] = await Promise.all([
            Ping.find({ provider: provider }).limit(req.query.limit).skip(req.skip).lean().exec(),
            Ping.find({ provider: provider }).count({})
        ]);

        const pageCount = Math.ceil(itemCount / req.query.limit);

        if (req.accepts('json')) {
            res.json({
                object: 'list',
                numberOfItems: results.length,
                totalNumberOfItems: itemCount,
                totalNumberOfPages: pageCount,
                hasMorePages: paginate.hasNextPages(req)(pageCount),
                data: results
            });
        }
    } catch (err) {
        next(err);

    }
});

//-------------------- QUERY: BANDWIDTH ------------------------

router.route('/bandwidths/query/avgOfSelectedDate').get(async (req, res, next) => {
    var start, end, crossRegion;

    start = new Date(req.query.start + "T00:00:00-00:00"); //YYYY-MM-DD
    end = new Date(req.query.end + "T23:59:59-00:00");
    crossRegion = parseInt(req.query.crossRegion); // 0 or 1
    console.log("avgOfBWOfDate: start:" + start + ";end:" + end + ";crossRegion:" + crossRegion);
    Bandwidth.aggregate()
        .project({ crossRegion: { $abs: { $cmp: ['$from_zone', '$to_zone'] } }, provider: "$provider", from_zone: "$from_zone", to_zone: "$to_zone", bandwidth: "$bandwidth", timestamp: "$timestamp" })
        .match({ $and: [{ crossRegion: crossRegion }, { timestamp: { $gte: start, $lte: end } }] })
        .group({
            _id: {
                provider: "$provider",
                from_zone: "$from_zone",
                to_zone: "$to_zone"
            },
            avg: { $avg: "$bandwidth" },
            count: { $sum: 1 }
        })
        .group({
            _id: {
                provider: "$provider"
            },
            avg: { $avg: "$avg" },
            count: { $sum: 1 }
        })
        .project({
            _id: 0,
            provider: "$_id.provider",
            avg: "$avg",
            count: "$count"
        })
        .exec(function (err, resp) {
            if (err) {
                // TODO
                console.log(err);
            } else {
                res.json(resp);
            }
        })
});

router.route('/bandwidths/query/avgOfProviderOfSelectedDate').get(async (req, res, next) => {
    var start, end, provider;

    start = new Date(req.query.start + "T00:00:00-00:00"); //YYYY-MM-DD
    end = new Date(req.query.end + "T23:59:59-00:00");
    provider = req.query.provider;
    console.log("avgOfProviderOfSelectedDate: start:" + start + ";end:" + end + ";provider:" + provider);
    Bandwidth.aggregate()
        .match({ $and: [{ timestamp: { $gte: start, $lte: end } }, { provider: provider }] })
        .project({
            provider: "$provider", from_zone: "$from_zone", to_zone: "$to_zone",
            bandwidth: "$bandwidth", transfer: "$transfer"
        })
        .group({
            _id: {
                provider: "$provider",
                from_zone: "$from_zone",
                to_zone: "$to_zone"
            },
            avg: { $avg: "$bandwidth" },
            count: { $sum: 1 },
            tot_transfer: { $sum: "$transfer" }
        })
        .addFields({
            crossRegion: { $abs: { $cmp: ["$_id.from_zone", "$_id.to_zone"] } },
        })
        .project({
            "_id": 0,
            "provider": "$_id.provider",
            "from_zone": "$_id.from_zone",
            "to_zone": "$_id.to_zone",
            "avg": "$avg",
            "count": "$count",
            "tot_transfer": "$tot_transfer",
            crossRegion: "$crossRegion"
        })
        .exec(function (err, resp) {
            if (err) {
                // TODO
                console.log(err);
            } else {
                res.json(resp);
            }
        })
});

router.route('/bandwidths/query/avgOfZoneOfSelectedDate').get(async (req, res, next) => {
    var start, end, provider, from_zone, to_zone;

    start = new Date(req.query.start + "T00:00:00-00:00"); //YYYY-MM-DD
    end = new Date(req.query.end + "T23:59:59-00:00");
    from_zone = req.query.from_zone;
    to_zone = req.query.to_zone;
    if (req.query.zone != undefined) {
        from_zone = to_zone = req.query.zone;
    }
    provider = req.query.provider;
    console.log("avgOfZoneOfSelectedDate: start:" + start + ";end:" + end + ";from_zone:" + from_zone + " or to_zone:" + to_zone);
    Bandwidth.aggregate()
        .match({ $and: [{ timestamp: { $gte: start, $lte: end } }, { provider: provider }, { $or: [{ from_zone: from_zone }, { to_zone: to_zone }] }] })
        .group({
            _id: {
                provider: "$provider",
                from_zone: "$from_zone",
                to_zone: "$to_zone"
            },
            avg: { $avg: "$bandwidth" }
        })
        .addFields({
            crossRegion: { $abs: { $cmp: ["$_id.from_zone", "$_id.to_zone"] } },
        })
        .project({
            "_id": 0,
            "provider": "$_id.provider",
            "from_zone": "$_id.from_zone",
            "to_zone": "$_id.to_zone",
            "avg": "$avg",
            "count": "$count",
            crossRegion: "$crossRegion"
        })
        .exec(function (err, resp) {
            if (err) {
                // TODO
                console.log(err);
            } else {
                res.json(resp);
            }
        })
});

app.use('/api', router);

module.exports = app;
