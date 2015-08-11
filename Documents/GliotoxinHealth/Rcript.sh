#!/usr/bin/env Rscript
library(rzmq)
library(Hmisc) #<-- need to load package for SAS files .xpt
context = init.context()
socket = init.socket(context,"ZMQ_REP")
bind.socket(socket,"tcp://*:5556") # bind to self

# Practice function for debug
c<-function(geez){
 sqrt(geez) 
}

# searches CDC NHANES dataset
# takes an argument "vars" from client and returns a data frame with the variables requested.

# Need to learn how to return the data frame without printing it to the console,
# store in a local file on the client's machine instead of sending head(df).

d<-function(file_name,url.A){

download.file(url.A,destfile=file_name,method="curl") ## send back the file
#mydata <- sasxport.get("CDC")
  #means<-aggregate(.~seqn,FUN=mean,data=mydata)
  #masses<-means[,vars]
  #head(masses)
  return(file_name)
}

disconnect.socket <- function(socket, address) {
      invisible(.Call("connectSocket", socket, address, PACKAGE="rzmq"))
  }

## The Rep.sh code, is this what "boilerplate" means?
while(1) {
  msg = receive.socket(socket);
  fun <- msg$fun
  args <- msg$args
  print(args)
  print(fun)
  ans <- do.call(fun,args)
  send.socket(socket,ans);
    disconnect.socket(socket,"tcp://127.0.0.1:5556") 
}

