var express = require('/app/node_modules/express');
var app = express();
var mysql = require("/app/node_modules/mysql");
require('/app/node_modules/log-timestamp');
const client = require('prom-client');
const Registry = client.Registry;
const register = new Registry();

app.set('host', process.env.MYSQL_HOST || 'localhost');
app.set('dbname', process.env.DBNAME || 'test');
app.set('user', process.env.UNAME || 'user1');
app.set('password', process.env.DBPASS || 'pass1');

const counter = new client.Counter({name: 'njs_health', help: 'Health status of nodejs app'});

setInterval(() => { c.inc();}, 2000);

server.get('/metrics', (req, res) => {
	res.set('Content-Type', register.contentType);
	res.end(register.metrics());
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
