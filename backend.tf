terraform {
 backend "s3" {
   bucket = "sctp-ce9-tfstate"
   key    = "arpita-ce9-module2-lesson7.tfstate" # Replace the value of key to <your suggested name>.tfstat   
   region = "us-east-1"
 }
}



