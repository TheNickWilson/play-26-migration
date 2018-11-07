#!/bin/bash

echo "Applying migration SomeString"

echo "Adding routes to conf/app.routes"

echo "" >> ../conf/app.routes
echo "GET        /someString                        controllers.SomeStringController.onPageLoad(mode: Mode = NormalMode)" >> ../conf/app.routes
echo "POST       /someString                        controllers.SomeStringController.onSubmit(mode: Mode = NormalMode)" >> ../conf/app.routes

echo "GET        /changeSomeString                  controllers.SomeStringController.onPageLoad(mode: Mode = CheckMode)" >> ../conf/app.routes
echo "POST       /changeSomeString                  controllers.SomeStringController.onSubmit(mode: Mode = CheckMode)" >> ../conf/app.routes

echo "Adding messages to conf.messages"
echo "" >> ../conf/messages.en
echo "someString.title = someString" >> ../conf/messages.en
echo "someString.heading = someString" >> ../conf/messages.en
echo "someString.checkYourAnswersLabel = someString" >> ../conf/messages.en
echo "someString.error.required = Enter someString" >> ../conf/messages.en
echo "someString.error.length = SomeString must be 100 characters or less" >> ../conf/messages.en

echo "Adding to UserAnswersEntryGenerators"
awk '/trait UserAnswersEntryGenerators/ {\
    print;\
    print "";\
    print "  implicit lazy val arbitrarySomeStringUserAnswersEntry: Arbitrary[(SomeStringPage.type, JsValue)] =";\
    print "    Arbitrary {";\
    print "      for {";\
    print "        page  <- arbitrary[SomeStringPage.type]";\
    print "        value <- arbitrary[String].suchThat(_.nonEmpty).map(Json.toJson(_))";\
    print "      } yield (page, value)";\
    print "    }";\
    next }1' ../test/generators/UserAnswersEntryGenerators.scala > tmp && mv tmp ../test/generators/UserAnswersEntryGenerators.scala

echo "Adding to PageGenerators"
awk '/trait PageGenerators/ {\
    print;\
    print "";\
    print "  implicit lazy val arbitrarySomeStringPage: Arbitrary[SomeStringPage.type] =";\
    print "    Arbitrary(SomeStringPage)";\
    next }1' ../test/generators/PageGenerators.scala > tmp && mv tmp ../test/generators/PageGenerators.scala

echo "Adding to CacheMapGenerator"
awk '/val generators/ {\
    print;\
    print "    arbitrary[(SomeStringPage.type, JsValue)] ::";\
    next }1' ../test/generators/CacheMapGenerator.scala > tmp && mv tmp ../test/generators/CacheMapGenerator.scala

echo "Adding helper method to CheckYourAnswersHelper"
awk '/class/ {\
     print;\
     print "";\
     print "  def someString: Option[AnswerRow] = userAnswers.get(SomeStringPage) map {";\
     print "    x => AnswerRow(\"someString.checkYourAnswersLabel\", s\"$x\", false, routes.SomeStringController.onPageLoad(CheckMode).url)";\
     print "  }";\
     next }1' ../app/utils/CheckYourAnswersHelper.scala > tmp && mv tmp ../app/utils/CheckYourAnswersHelper.scala

echo "Migration SomeString completed"
