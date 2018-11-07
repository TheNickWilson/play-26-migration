#!/bin/bash

echo "Applying migration SomeOptions"

echo "Adding routes to conf/app.routes"

echo "" >> ../conf/app.routes
echo "GET        /someOptions               controllers.SomeOptionsController.onPageLoad(mode: Mode = NormalMode)" >> ../conf/app.routes
echo "POST       /someOptions               controllers.SomeOptionsController.onSubmit(mode: Mode = NormalMode)" >> ../conf/app.routes

echo "GET        /changeSomeOptions                  controllers.SomeOptionsController.onPageLoad(mode: Mode = CheckMode)" >> ../conf/app.routes
echo "POST       /changeSomeOptions                  controllers.SomeOptionsController.onSubmit(mode: Mode = CheckMode)" >> ../conf/app.routes

echo "Adding messages to conf.messages"
echo "" >> ../conf/messages.en
echo "someOptions.title = someOptions" >> ../conf/messages.en
echo "someOptions.heading = someOptions" >> ../conf/messages.en
echo "someOptions.option1 = Option 1" >> ../conf/messages.en
echo "someOptions.option2 = Option 2" >> ../conf/messages.en
echo "someOptions.checkYourAnswersLabel = someOptions" >> ../conf/messages.en
echo "someOptions.error.required = Select someOptions" >> ../conf/messages.en

echo "Adding to UserAnswersEntryGenerators"
awk '/trait UserAnswersEntryGenerators/ {\
    print;\
    print "";\
    print "  implicit lazy val arbitrarySomeOptionsUserAnswersEntry: Arbitrary[(SomeOptionsPage.type, JsValue)] =";\
    print "    Arbitrary {";\
    print "      for {";\
    print "        page  <- arbitrary[SomeOptionsPage.type]";\
    print "        value <- arbitrary[SomeOptions].map(Json.toJson(_))";\
    print "      } yield (page, value)";\
    print "    }";\
    next }1' ../test/generators/UserAnswersEntryGenerators.scala > tmp && mv tmp ../test/generators/UserAnswersEntryGenerators.scala

echo "Adding to PageGenerators"
awk '/trait PageGenerators/ {\
    print;\
    print "";\
    print "  implicit lazy val arbitrarySomeOptionsPage: Arbitrary[SomeOptionsPage.type] =";\
    print "    Arbitrary(SomeOptionsPage)";\
    next }1' ../test/generators/PageGenerators.scala > tmp && mv tmp ../test/generators/PageGenerators.scala

echo "Adding to ModelGenerators"
awk '/trait ModelGenerators/ {\
    print;\
    print "";\
    print "  implicit lazy val arbitrarySomeOptions: Arbitrary[SomeOptions] =";\
    print "    Arbitrary {";\
    print "      Gen.oneOf(SomeOptions.values.toSeq)";\
    print "    }";\
    next }1' ../test/generators/ModelGenerators.scala > tmp && mv tmp ../test/generators/ModelGenerators.scala

echo "Adding to CacheMapGenerator"
awk '/val generators/ {\
    print;\
    print "    arbitrary[(SomeOptionsPage.type, JsValue)] ::";\
    next }1' ../test/generators/CacheMapGenerator.scala > tmp && mv tmp ../test/generators/CacheMapGenerator.scala

echo "Adding helper method to CheckYourAnswersHelper"
awk '/class/ {\
     print;\
     print "";\
     print "  def someOptions: Option[AnswerRow] = userAnswers.get(SomeOptionsPage) map {";\
     print "    x => AnswerRow(\"someOptions.checkYourAnswersLabel\", s\"someOptions.$x\", true, routes.SomeOptionsController.onPageLoad(CheckMode).url)";\
     print "  }";\
     next }1' ../app/utils/CheckYourAnswersHelper.scala > tmp && mv tmp ../app/utils/CheckYourAnswersHelper.scala

echo "Migration SomeOptions completed"
