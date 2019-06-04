var express = require('/app/node_modules/express');
var app = express();
var mysql = require("/app/node_modules/mysql");
require('/app/node_modules/log-timestamp');
const client = require('prom-client');
const registry = new client.Registry();

app.set('host', process.env.MYSQL_HOST || 'mongo');
app.set('dbname', process.env.DBNAME || 'test');
app.set('user', process.env.UNAME || 'root');
app.set('password', process.env.DBPASS || 'password');

const gauge = new client.Gauge({name: 'njs_health', help: 'Health status of nodejs app'});
const node_health_db_gauge = new client.Gauge({name: 'njs_health_db_availability', help: 'Check if mongodb is available'});

registry.registerMetric(gauge);
registry.registerMetric(node_health_db_gauge);
gauge.set(0, new Date());
node_health_db_gauge.set(0, new Date());

//Check mongodb availability each 4 sec
setInterval(() => { 
	
        var dbconn = mysql.createConnection({
        host     : app.get('host'),
        user     : app.get('user'),
        password : app.get('password'),
        database : app.get('dbname')
        });
	
	dbconn.connect(function(err){
        if(err){
          node_health_db_gauge.set(0, new Date());
        }else{
          node_health_db_gauge.set(1, new Date());
        }
      });
			  
		  }, 4000);

app.get('/metrics', (req, res) => {
	res.set('Content-Type', registry.contentType);
	res.end(registry.metrics());
	console.log("Metrics ")
});

app.get('/healthz', function(req,res){
     res.send('Container is running.');
     console.log("Container is running.")
});

app.get('/users', function(req,res, next){
//Database connection
    var dbconn = mysql.createConnection({
        host     : app.get('host'),
        user     : app.get('user'),
        password : app.get('password'),
        database : app.get('dbname')
      });

    dbconn.connect(function(err){
        if(err){
          console.error('Database connection error');
        }else{
          console.log('Database connection successful');

        }
      });

      dbconn.query('SELECT * from users', function (error, results, fields){
        if(error) {
            console.error('Can not select users from the database');
        }
        else {
            res.send(JSON.stringify({"status": 200, "error": null, "response": results}));
            console.log('Users were selected from the databse');
        }
      });

    
    dbconn.end(function(err) {
        console.log('Database connection closed');
      });
    
});



var server = app.listen(3000, function(){
     console.log('Listen om port 3000');
});

exports.app = app;
