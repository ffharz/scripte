#!/bin/bash

# hinzufügen von neuen Knoten 
cd fastd-peers
git add *
git commit -m "$1"
git push origin master
git push ff-harz master

