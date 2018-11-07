#!/bin/bash

echo "Applying migration SomeInt"

echo "Adding routes to conf/app.routes"

echo "" >> ../conf/app.routes
echo "GET        /someInt               controllers.SomeIntController.onPageLoad(mode: Mode = NormalMode)" >> ../conf/app.routes
echo "POST       /someInt               controllers.SomeIntController.onSubmit(mode: Mode = NormalMode)" >> ../conf/app.routes

echo "GET        /changeSomeInt                        controllers.SomeIntController.onPageLoad(mode: Mode = CheckMode)" >> ../conf/app.routes
echo "POST       /changeSomeInt                        controllers.SomeIntController.onSubmit(mode: Mode = CheckMode)" >> ../conf/app.routes

echo "Adding messages to conf.messages"
echo "" >> ../conf/messages.en
echo "someInt.title = someInt" >> ../conf/messages.en
echo "someInt.heading = someInt" >> ../conf/messages.en
echo "someInt.checkYourAnswersLabel = someInt" >> ../conf/messages.en
echo "someInt.error.nonNumeric = Enter your someInt using numbers" >> ../conf/messages.en
echo "someInt.error.required = Enter your someInt" >> ../conf/messages.en
echo "someInt.error.wholeNumber = Enter your someInt using whole numbers" >> ../conf/messages.en
echo "someInt.error.outOfRange = SomeInt must be between {0} and {1}" >> ../conf/messages.en

echo "Adding to UserAnswersEntryGenerators"
awk '/trait UserAnswersEntryGenerators/ {\
    print;\
    print "";\
    print "  implicit lazy val arbitrarySomeIntUserAnswersEntry: Arbitrary[(SomeIntPage.type, JsValue)] =";\
    print "    Arbitrary {";\
    print "      for {";\
    print "        page  <- arbitrary[SomeIntPage.type]";\
    print "        value <- arbitrary[Int].map(Json.toJson(_))";\
    print "      } yield (page, value)";\
    print "    }";\
    next }1' ../test/generators/UserAnswersEntryGenerators.scala > tmp && mv tmp ../test/generators/UserAnswersEntryGenerators.scala

echo "Adding to PageGenerators"
awk '/trait PageGenerators/ {\
    print;\
    print "";\
    print "  implicit lazy val arbitrarySomeIntPage: Arbitrary[SomeIntPage.type] =";\
    print "    Arbitrary(SomeIntPage)";\
    next }1' ../test/generators/PageGenerators.scala > tmp && mv tmp ../test/generators/PageGenerators.scala

echo "Adding to CacheMapGenerator"
awk '/val generators/ {\
    print;\
    print "    arbitrary[(SomeIntPage.type, JsValue)] ::";\
    next }1' ../test/generators/CacheMapGenerator.scala > tmp && mv tmp ../test/generators/CacheMapGenerator.scala

echo "Adding helper method to CheckYourAnswersHelper"
awk '/class/ {\
     print;\
     print "";\
     print "  def someInt: Option[AnswerRow] = userAnswers.get(SomeIntPage) map {";\
     print "    x => AnswerRow(\"someInt.checkYourAnswersLabel\", s\"$x\", false, routes.SomeIntController.onPageLoad(CheckMode).url)";\
     print "  }";\
     next }1' ../app/utils/CheckYourAnswersHelper.scala > tmp && mv tmp ../app/utils/CheckYourAnswersHelper.scala

echo "Migration SomeInt completed"
