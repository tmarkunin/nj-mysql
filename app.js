var express = require('express');
var app = express();
var mysql = require("mysql");
require('log-timestamp');

app.set('host', process.env.MYSQL_HOST || 'localhost');
app.set('dbname', process.env.DBNAME || 'test');
app.set('user', process.env.UNAME || 'user1');
app.set('password', process.env.DBPASS || 'pass1');


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