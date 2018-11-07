#!/bin/bash

echo "Applying migration SomeInfo"

echo "Adding routes to conf/app.routes"
echo "" >> ../conf/app.routes
echo "GET        /someInfo                       controllers.SomeInfoController.onPageLoad()" >> ../conf/app.routes

echo "Adding messages to conf.messages"
echo "" >> ../conf/messages.en
echo "someInfo.title = someInfo" >> ../conf/messages.en
echo "someInfo.heading = someInfo" >> ../conf/messages.en

echo "Migration SomeInfo completed"
