#!bin/bash
docker build -t v9db:0.1 .

# run
docker run -d -p 50000:50000 --name c9db2 v9db:0.1 