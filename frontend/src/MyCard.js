import React from 'react';
import { Card, Tabs, Tab, FontIcon, DatePicker, Toggle, GridList, GridTile, SelectField, MenuItem, RaisedButton, TextField } from 'material-ui/';
import MyGraph from './MyGraph';
import moment from "moment/moment";

var backendAddress = 'http://3.83.232.170:3100/api/';

var styles = {
    root: {
        display: 'flex',
        flexWrap: 'wrap',
        justifyContent: 'space-around',
        margin: '0 auto'
    },
    gridList: {
        width: 220,
        height: 650,
        overflowY: 'auto',
        verticalAlign: 'middle'
    },
};

// would be nice if this data was loaded automatically from the db
/*
const providers = [
    'Amazon',
    'Azure',
    'IBM'
  ];
const threads = [1,2,4,8,16,32,64]
*/

const horizontalBarHelper = {
    labels: [],
    datasets: [
        {
            borderColor: 'rgba(255,99,132,1)',
            borderWidth: 1,
            hoverBackgroundColor: 'rgba(255,99,132,0.4)',
            hoverBorderColor: 'rgba(255,99,132,1)',
            backgroundColor: [
                'rgba(255, 99, 132, 0.6)',
                'rgba(54, 162, 235, 0.6)',
                'rgba(255, 206, 86, 0.6)',
                'rgba(75, 192, 192, 0.6)',
                'rgba(153, 102, 255, 0.6)',
                'rgba(255, 159, 64, 0.6)',
                'rgba(255, 99, 132, 0.6)',
                'rgba(255, 99, 132, 0.6)',
                'rgba(54, 162, 235, 0.6)',
                'rgba(255, 206, 86, 0.6)',
                'rgba(75, 192, 192, 0.6)',
                'rgba(153, 102, 255, 0.6)',
                'rgba(255, 159, 64, 0.6)',
                'rgba(255, 99, 132, 0.6)',
                'rgba(255, 99, 132, 0.6)',
                'rgba(54, 162, 235, 0.6)',
                'rgba(255, 206, 86, 0.6)',
                'rgba(75, 192, 192, 0.6)',
                'rgba(153, 102, 255, 0.6)',
                'rgba(255, 159, 64, 0.6)',
                'rgba(255, 99, 132, 0.6)',
                'rgba(255, 99, 132, 0.6)',
                'rgba(54, 162, 235, 0.6)',
                'rgba(255, 206, 86, 0.6)',
                'rgba(75, 192, 192, 0.6)',
                'rgba(153, 102, 255, 0.6)',
                'rgba(255, 159, 64, 0.6)',
                'rgba(255, 99, 132, 0.6)',
                'rgba(255, 99, 132, 0.6)',
                'rgba(54, 162, 235, 0.6)',
                'rgba(255, 206, 86, 0.6)',
                'rgba(75, 192, 192, 0.6)',
                'rgba(153, 102, 255, 0.6)',
                'rgba(255, 159, 64, 0.6)',
                'rgba(255, 99, 132, 0.6)',
                'rgba(255, 99, 132, 0.6)',
                'rgba(54, 162, 235, 0.6)',
                'rgba(255, 206, 86, 0.6)',
                'rgba(75, 192, 192, 0.6)',
                'rgba(153, 102, 255, 0.6)',
                'rgba(255, 159, 64, 0.6)',
                'rgba(255, 99, 132, 0.6)',
                'rgba(255, 99, 132, 0.6)',
                'rgba(54, 162, 235, 0.6)',
                'rgba(255, 206, 86, 0.6)',
                'rgba(75, 192, 192, 0.6)',
                'rgba(153, 102, 255, 0.6)',
                'rgba(255, 159, 64, 0.6)',
                'rgba(255, 99, 132, 0.6)',
                'rgba(255, 99, 132, 0.6)',
                'rgba(54, 162, 235, 0.6)',
                'rgba(255, 206, 86, 0.6)',
                'rgba(75, 192, 192, 0.6)',
                'rgba(153, 102, 255, 0.6)',
                'rgba(255, 159, 64, 0.6)',
                'rgba(255, 99, 132, 0.6)',
                'rgba(255, 99, 132, 0.6)',
                'rgba(54, 162, 235, 0.6)',
                'rgba(255, 206, 86, 0.6)',
                'rgba(75, 192, 192, 0.6)',
                'rgba(153, 102, 255, 0.6)',
                'rgba(255, 159, 64, 0.6)',
                'rgba(255, 99, 132, 0.6)',
                'rgba(255, 99, 132, 0.6)',
                'rgba(54, 162, 235, 0.6)',
                'rgba(255, 206, 86, 0.6)',
                'rgba(75, 192, 192, 0.6)',
                'rgba(153, 102, 255, 0.6)',
                'rgba(255, 159, 64, 0.6)',
                'rgba(255, 99, 132, 0.6)',
                'rgba(255, 99, 132, 0.6)',
                'rgba(54, 162, 235, 0.6)',
                'rgba(255, 206, 86, 0.6)',
                'rgba(75, 192, 192, 0.6)',
                'rgba(153, 102, 255, 0.6)',
                'rgba(255, 159, 64, 0.6)',
                'rgba(255, 99, 132, 0.6)',
                'rgba(255, 99, 132, 0.6)',
                'rgba(54, 162, 235, 0.6)',
                'rgba(255, 206, 86, 0.6)',
                'rgba(75, 192, 192, 0.6)',
                'rgba(153, 102, 255, 0.6)',
                'rgba(255, 159, 64, 0.6)',
                'rgba(255, 99, 132, 0.6)',
                'rgba(255, 99, 132, 0.6)',
                'rgba(54, 162, 235, 0.6)',
                'rgba(255, 206, 86, 0.6)',
                'rgba(75, 192, 192, 0.6)',
                'rgba(153, 102, 255, 0.6)',
                'rgba(255, 159, 64, 0.6)',
                'rgba(255, 99, 132, 0.6)',
                'rgba(255, 99, 132, 0.6)',
                'rgba(54, 162, 235, 0.6)',
                'rgba(255, 206, 86, 0.6)',
                'rgba(75, 192, 192, 0.6)',
                'rgba(153, 102, 255, 0.6)',
                'rgba(255, 159, 64, 0.6)',
                'rgba(255, 99, 132, 0.6)',
                'rgba(54, 162, 235, 0.6)',
                'rgba(255, 206, 86, 0.6)',
                'rgba(75, 192, 192, 0.6)',
                'rgba(153, 102, 255, 0.6)',
                'rgba(255, 159, 64, 0.6)',
                'rgba(255, 99, 132, 0.6)',
                'rgba(54, 162, 235, 0.6)',
                'rgba(255, 206, 86, 0.6)',
                'rgba(75, 192, 192, 0.6)',
                'rgba(153, 102, 255, 0.6)',
                'rgba(255, 159, 64, 0.6)',
                'rgba(255, 99, 132, 0.6)',
                'rgba(54, 162, 235, 0.6)',
                'rgba(255, 206, 86, 0.6)',
                'rgba(75, 192, 192, 0.6)',
                'rgba(153, 102, 255, 0.6)',
                'rgba(255, 159, 64, 0.6)',
                'rgba(255, 99, 132, 0.6)',
                'rgba(54, 162, 235, 0.6)',
                'rgba(255, 206, 86, 0.6)',
                'rgba(75, 192, 192, 0.6)',
                'rgba(153, 102, 255, 0.6)',
                'rgba(255, 159, 64, 0.6)',
                'rgba(255, 99, 132, 0.6)',
                'rgba(54, 162, 235, 0.6)',
                'rgba(255, 206, 86, 0.6)',
                'rgba(75, 192, 192, 0.6)',
                'rgba(153, 102, 255, 0.6)',
                'rgba(255, 159, 64, 0.6)',
                'rgba(255, 99, 132, 0.6)',
                'rgba(54, 162, 235, 0.6)',
                'rgba(255, 206, 86, 0.6)',
                'rgba(75, 192, 192, 0.6)',
                'rgba(153, 102, 255, 0.6)',
                'rgba(255, 159, 64, 0.6)',
                'rgba(255, 99, 132, 0.6)'
            ],
            data: []
        }
    ]
}

/*
const lineHelper = {
    labels: [],
    datasets: [{
        label: 'Average ping for every day for selected provider and year',
        data: [],
        fill: false,
        lineTension: 0.1,
        backgroundColor: 'rgba(75,192,192,0.4)',
        borderColor: 'rgba(75,192,192,1)',
        borderCapStyle: 'butt',
        borderDash: [],
        borderDashOffset: 0.0,
        borderJoinStyle: 'miter',
        pointBorderColor: 'rgba(75,192,192,1)',
        pointBackgroundColor: '#fff',
        pointBorderWidth: 1,
        pointHoverRadius: 5,
        pointHoverBackgroundColor: 'rgba(75,192,192,1)',
        pointHoverBorderColor: 'rgba(220,220,220,1)',
        pointHoverBorderWidth: 2,
        pointRadius: 1,
        pointHitRadius: 10
    }]
}
*/
export default class MyCard extends React.Component {
    constructor(props) {
        super(props)

        this.state = {
            testType: null,         // benchmark or network
            dataType: null,         // latency, bandwidth
            queryNumber: null,      // all providers, single provider etc..
            start: null,            // start date
            end: null,              // end date
            provider: null,         // ibm, amazon, azure etc
            zone: null,
            crossRegion: true,
            buttonDisabled: true,
            buttonClicked: false,
            graphType: null,
            graphData: null
        }
    }

    //#region  HANDLERS 
    handleTestTypeChange = (event, index, value) => {
        this.setState({ testType: value }, this.check);
    }

    handleProviderChange = (event, value) => {
        this.setState({ provider: value }, this.check);
    }

    handleZoneChange = (event, value) => {
        this.setState({ zone: value }, this.check);
    }

    handleQueryNumberChange = (event, index, value) => {
        this.setState({ queryNumber: value, buttonDisabled: true }, this.check);
    }

    handleDataTypeChange = (event, index, value) => {
        this.setState({ dataType: value, buttonDisabled: true });
    }

    //#endregion HANDLERS */

    check() {
        // network settings
        if (this.state.testType === 'network') {
            // check if all data is present
            if (this.state.dataType && this.state.queryNumber && this.state.start && this.state.end) {
                switch (this.state.queryNumber) {
                    case 1:
                        this.setState({ buttonDisabled: false })
                        break;
                    case 2:
                        if (this.state.provider) {
                            this.setState({ buttonDisabled: false })
                        }
                        break;
                    case 3:
                        if (this.state.provider && this.state.zone) {
                            this.setState({ buttonDisabled: false })
                        }
                        break;
                    default:
                        this.setState({ buttonDisabled: true })
                        break;
                }
            }
            else {
                this.setState({ buttonDisabled: true })
            }
            //benchmark settings
        }
        else if (this.state.testType === 'benchmark') {
            console.log("benchmarks case in check");
            if (this.state.start && this.state.end) {
                this.setState({ buttonDisabled: false });
            }
        }
    }
    //#region HANDLERS
    handleStartDateChange = (event, date) => {
        this.setState({
            start: date,
        }, this.check);
    };

    handleEndDateChange = (event, date) => {
        this.setState({
            end: date,
        }, this.check);
    };

    handleCrossRegionChange = (event, isInputChecked) => {
        this.setState({ crossRegion: isInputChecked });
        console.log("crss region switch " + isInputChecked);
    }

    handleRadioButton = (event, value) => {
        this.setState({ graphType: value });
    }
    handleClick = (event) => {
        console.log("handle click ");
        this.callApi()
            .then(res => {

                res.sort(function (a, b) {
                    var keyA = a.avg,
                        keyB = b.avg;
                    // Compare the 2 values
                    if (keyA < keyB) return -1;
                    if (keyA > keyB) return 1;
                    return 0;
                });

                var graphType = 'Bar';
                var graphDataModified = horizontalBarHelper;
                //var graphDataModified = lineHelper;
                let datasetsModified = graphDataModified.datasets;
                let labelsModified = graphDataModified.labels;

                datasetsModified[0].data.length = 0;
                labelsModified.length = 0;

                for (let resource of res) {
                    if (this.state.testType === 'network') {
                    switch (this.state.queryNumber) {
                        case 1:
                            datasetsModified[0].label = "Comparison between providers based on average of all " + this.state.dataType;
                            labelsModified.push(resource.provider)
                            datasetsModified[0].data.push(resource.avg)
                            break;
                        case 2:
                        case 3:
                            datasetsModified[0].label = "Comparison between zones based on average of all " + this.state.dataType;
                            labelsModified.push(resource.provider + ":" + resource.from_zone + "->" + resource.to_zone)
                            datasetsModified[0].data.push(resource.avg)
                            break;
                        default:
                    }
                }
            if (this.state.testType === 'benchmark') {
                datasetsModified[0].label = "Comparison between providers based on average of all benchmark tests";
                labelsModified.push(resource.provider)
                datasetsModified[0].data.push(resource.avg)
            }
                this.setState({ graphData: graphDataModified, graphType: graphType, buttonClicked: true, redraw: true })
        }

            })
            .then(() => {
                this.resetForm()
            })
            .catch(err => console.log(err))
    } // TODO
    //#endregion HANDLERS

    async callApi() {
        var query;
        console.log("call api: " + this.state.queryNumber);
        if (this.state.testType === 'network') {
            switch (this.state.queryNumber) {
                case 1:
                    query = backendAddress + this.state.dataType + '/query/avgOfSelectedDate?crossRegion=' + ((this.state.crossRegion === true) ? 1 : 0) + '&start=' + moment(this.state.start).format('YYYY-MM-DD') + '&end=' + moment(this.state.end).format('YYYY-MM-DD')
                    break;
                case 2:
                    query = backendAddress + this.state.dataType + '/query/avgOfProviderOfSelectedDate?provider=' + this.state.provider + '&start=' + moment(this.state.start).format('YYYY-MM-DD') + '&end=' + moment(this.state.end).format('YYYY-MM-DD')
                    break;
                case 3:
                    query = backendAddress + this.state.dataType + '/query/avgOfZoneOfSelectedDate?provider=' + this.state.provider + '&zone=' + this.state.zone + '&start=' + moment(this.state.start).format('YYYY-MM-DD') + '&end=' + moment(this.state.end).format('YYYY-MM-DD')
                    break;
                default:
            }
            //var query = (this.state.queryNumber == 1)
            //    ? 'http://localhost:3100/api/pings/query/avgOfEveryPingOfSelectedDate?start='+moment(this.state.start).format('YYYY-MM-DD')+'&end='+moment(this.state.end).format('YYYY-MM-DD')+'&crossRegion='+((this.state.crossRegion === true) ? -1 : 1)
            //    : 'http://localhost:3100/api/pings/query/avgOfEveryDayOfSelectedYear?year='+this.state.year+'&crossRegion='+((this.state.crossRegion === true) ? -1 : 1)+'&provider='+this.state.provider;
        }
        else if (this.state.testType === 'benchmark') {
            query = backendAddress +'/benchmarks/query/avgOfSelectedDate?&start=' + moment(this.state.start).format('YYYY-MM-DD') + '&end=' + moment(this.state.end).format('YYYY-MM-DD')
        }
        const response = await fetch(query);
        const body = await response.json();

        return body;
    }

    resetForm = () => {
        //this.setState({start: null, end: null, buttonDisabled: true})
    }

    //renders start and end dates for benchmarking
    renderDates() {
        return (
            <div>
                <DatePicker floatingLabelText="Start Date" hintText="Select start date" value={this.state.start} onChange={this.handleStartDateChange} />
                <DatePicker floatingLabelText="End Date" hintText="Select end date" value={this.state.end} onChange={this.handleEndDateChange} />
            </div>
        )
    }

    //TODO get list of providers from db and put them in multiple select menu.
    renderProviderSelection() {
        if (this.state.queryNumber === 2) {
            return (
                <TextField hintText="Select provider (ex: 'AWS, AZR, IBM')" onChange={this.handleProviderChange} />
            )
        }
    }
    //#region RENDERERS
    renderFirst() {
        switch (this.state.queryNumber) {
            case 1:
                return (
                    <DatePicker hintText="Select start date" value={this.state.start} onChange={this.handleStartDateChange} />
                )
            case 2:
            case 3:
                return (
                    <TextField hintText="Select provider (es: 'AWS')" onChange={this.handleProviderChange} />
                )
            /*  case 4:
                 return (
                     <DatePicker hintText="Select start day" value={this.state.start} onChange={this.handleStartDateChange} />
                 ) */
            default:
        }
    }

    renderSecond() {
        switch (this.state.queryNumber) {
            case 1:
                return (
                    <DatePicker hintText="Select end date" value={this.state.end} onChange={this.handleEndDateChange} />
                    //<TextField hintText="Es: 'AWS'" floatingLabelText="Insert provider"/>
                    //<DatePicker hintText="Select end year" value={this.state.end} onChange={this.handleEndDateChange}/>
                )
            case 2:
            case 3:
                return (
                    <DatePicker hintText="Select start date" value={this.state.start} onChange={this.handleStartDateChange} />
                )
            /* case 4:
                return (
                    <DatePicker hintText="Select end day" value={this.state.end} onChange={this.handleEndDateChange} />
                ) */
            default:
        }
    }

    renderThird() {
        switch (this.state.queryNumber) {
            case 1:
                return (<Toggle label="Cross Region" style={{ padding: '10px', width: '90%' }} defaultToggled={true} onToggle={this.handleCrossRegionChange} />)
            case 2:
            case 3:
                return (
                    <DatePicker hintText="Select end date" value={this.state.end} onChange={this.handleEndDateChange} />
                )
            /*  case 4:
                 return (
                     <DatePicker hintText="Select end day" value={this.state.end} onChange={this.handleEndDateChange} />
                 ) */
            default:
        }
    }

    renderFourth() {
        switch (this.state.queryNumber) {
            case 1:
                return (null)
            case 2:
                return (null)
            case 3:
                return (
                    <TextField hintText="Select zone (es: 'eu-west-1')" onChange={this.handleZoneChange} />
                )
            case 4:
                return (null)
            default:
        }
    }
    //#endregion RENDERERS
    renderUI() {
        if (this.state.testType === "network") {
            return (
                <div>
                    <SelectField
                        floatingLabelText="Data"
                        value={this.state.dataType}
                        onChange={this.handleDataTypeChange}
                    >
                        <MenuItem value={'pings'} primaryText="Latency" />
                        <MenuItem value={'bandwidths'} primaryText="Bandwidth" />
                    </SelectField>

                    <SelectField
                        floatingLabelText="Query"
                        value={this.state.queryNumber}
                        onChange={this.handleQueryNumberChange}
                    >
                        <MenuItem value={1} primaryText="All Providers" />
                        <MenuItem value={2} primaryText="Single Provider" />
                        <MenuItem value={3} primaryText="Single Zone" />
                    </SelectField>

                    {this.renderFirst()}
                    {this.renderSecond()}
                    {this.renderThird()}
                    {this.renderFourth()}
                </div>
            )
        }
        //TODO add providers multi select, threads and times
        else if (this.state.testType === "benchmark") {
            return (
                <div>
                    {this.renderDates()}
                    {/* <SelectField
                        floatingLabelText="Providers"
                        value={this.state.queryNumber}
                        onChange={this.handleQueryNumberChange}
                    >
                        <MenuItem value={1} primaryText="All Providers" />
                        <MenuItem value={2} primaryText="Single Provider" />
                    </SelectField> */}
                    {this.renderProviderSelection()}
                </div>
            )
        }
    }

    render() {
        return (
            <Card>
                <Tabs>
                    <Tab icon={<FontIcon className="material-icons" >date_range</FontIcon>} label="Pick">
                        <div style={styles.root}>
                            <GridList
                                cols={1}
                                cellHeight={600}
                                padding={1}
                                style={styles.gridList}
                            >
                                <GridTile>
                                    <SelectField
                                        floatingLabelText="Test Type"
                                        value={this.state.testType}
                                        onChange={this.handleTestTypeChange}
                                    >
                                        <MenuItem value={'benchmark'} primaryText="Benchmark" />
                                        <MenuItem value={'network'} primaryText="Network" />
                                    </SelectField>

                                    {this.renderUI()}

                                    <RaisedButton label="Send" secondary={true} disabled={this.state.buttonDisabled} onClick={this.handleClick} style={{ marginLeft: '27%' }} />

                                </GridTile>
                            </GridList>
                        </div>
                    </Tab>
                    <Tab icon={<FontIcon className="material-icons" >pie_chart</FontIcon>} label="Graph">
                        <div>
                            {this.state.buttonClicked ? <MyGraph data={this.state.graphData} graphType={this.state.graphType} /> : null}
                        </div>
                    </Tab>
                </Tabs>
            </Card>
        );
    }
}