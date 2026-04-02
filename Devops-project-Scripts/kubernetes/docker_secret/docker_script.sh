#!/bin/bash


kubectl create secret docker-registry docker-cred   --docker-server=https://index.docker.io/v1/   --docker-username=vaidhi   --docker-password=$password   --docker-email=vaidhi.r03@gmail.com   -n frontend


kubectl create secret docker-registry docker-cred   --docker-server=https://index.docker.io/v1/   --docker-username=vaidhi   --docker-password=$password   --docker-email=vaidhi.r03@gmail.com   -n backend






