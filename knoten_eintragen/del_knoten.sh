#!/bin/bash

# löschen von alten Knoten 
cd fastd-peers
git add -A
git commit -m "alte Knoten löschen"
git push origin master
git push ff-harz master

