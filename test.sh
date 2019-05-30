if [ $1 = "local" ]; then
#run localy
echo "run tests locally"
sudo mkdir /app
sudo cp -r . /app
cd /app
npm update
sudo npm install -g mocha
mocha tests/test.js --reporter spec --exit
sudo rm -rf /app
else
 echo "run tests as Docker container" 
 #run as docker container
sudo docker build --target test -t tst_api .
sudo docker run --rm tst_api
fi




