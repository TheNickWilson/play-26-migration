#!/bin/bash

echo "Applying migration SomeQuestion"

echo "Adding routes to conf/app.routes"

echo "" >> ../conf/app.routes
echo "GET        /someQuestion                        controllers.SomeQuestionController.onPageLoad(mode: Mode = NormalMode)" >> ../conf/app.routes
echo "POST       /someQuestion                        controllers.SomeQuestionController.onSubmit(mode: Mode = NormalMode)" >> ../conf/app.routes

echo "GET        /changeSomeQuestion                  controllers.SomeQuestionController.onPageLoad(mode: Mode = CheckMode)" >> ../conf/app.routes
echo "POST       /changeSomeQuestion                  controllers.SomeQuestionController.onSubmit(mode: Mode = CheckMode)" >> ../conf/app.routes

echo "Adding messages to conf.messages"
echo "" >> ../conf/messages.en
echo "someQuestion.title = someQuestion" >> ../conf/messages.en
echo "someQuestion.heading = someQuestion" >> ../conf/messages.en
echo "someQuestion.field1 = Field 1" >> ../conf/messages.en
echo "someQuestion.field2 = Field 2" >> ../conf/messages.en
echo "someQuestion.checkYourAnswersLabel = someQuestion" >> ../conf/messages.en
echo "someQuestion.error.field1.required = Enter field1" >> ../conf/messages.en
echo "someQuestion.error.field2.required = Enter field2" >> ../conf/messages.en
echo "someQuestion.error.field1.length = field1 must be 100 characters or less" >> ../conf/messages.en
echo "someQuestion.error.field2.length = field2 must be 100 characters or less" >> ../conf/messages.en

echo "Adding to UserAnswersEntryGenerators"
awk '/trait UserAnswersEntryGenerators/ {\
    print;\
    print "";\
    print "  implicit lazy val arbitrarySomeQuestionUserAnswersEntry: Arbitrary[(SomeQuestionPage.type, JsValue)] =";\
    print "    Arbitrary {";\
    print "      for {";\
    print "        page  <- arbitrary[SomeQuestionPage.type]";\
    print "        value <- arbitrary[SomeQuestion].map(Json.toJson(_))";\
    print "      } yield (page, value)";\
    print "    }";\
    next }1' ../test/generators/UserAnswersEntryGenerators.scala > tmp && mv tmp ../test/generators/UserAnswersEntryGenerators.scala

echo "Adding to PageGenerators"
awk '/trait PageGenerators/ {\
    print;\
    print "";\
    print "  implicit lazy val arbitrarySomeQuestionPage: Arbitrary[SomeQuestionPage.type] =";\
    print "    Arbitrary(SomeQuestionPage)";\
    next }1' ../test/generators/PageGenerators.scala > tmp && mv tmp ../test/generators/PageGenerators.scala

echo "Adding to ModelGenerators"
awk '/trait ModelGenerators/ {\
    print;\
    print "";\
    print "  implicit lazy val arbitrarySomeQuestion: Arbitrary[SomeQuestion] =";\
    print "    Arbitrary {";\
    print "      for {";\
    print "        field1 <- arbitrary[String]";\
    print "        field2 <- arbitrary[String]";\
    print "      } yield SomeQuestion(field1, field2)";\
    print "    }";\
    next }1' ../test/generators/ModelGenerators.scala > tmp && mv tmp ../test/generators/ModelGenerators.scala

echo "Adding to CacheMapGenerator"
awk '/val generators/ {\
    print;\
    print "    arbitrary[(SomeQuestionPage.type, JsValue)] ::";\
    next }1' ../test/generators/CacheMapGenerator.scala > tmp && mv tmp ../test/generators/CacheMapGenerator.scala

echo "Adding helper method to CheckYourAnswersHelper"
awk '/class/ {\
     print;\
     print "";\
     print "  def someQuestion: Option[AnswerRow] = userAnswers.get(SomeQuestionPage) map {";\
     print "    x => AnswerRow(\"someQuestion.checkYourAnswersLabel\", s\"${x.field1} ${x.field2}\", false, routes.SomeQuestionController.onPageLoad(CheckMode).url)";\
     print "  }";\
     next }1' ../app/utils/CheckYourAnswersHelper.scala > tmp && mv tmp ../app/utils/CheckYourAnswersHelper.scala

echo "Migration SomeQuestion completed"