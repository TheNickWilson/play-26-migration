#!/bin/bash

echo "Applying migration YesOrNo"

echo "Adding routes to conf/app.routes"

echo "" >> ../conf/app.routes
echo "GET        /yesOrNo                        controllers.YesOrNoController.onPageLoad(mode: Mode = NormalMode)" >> ../conf/app.routes
echo "POST       /yesOrNo                        controllers.YesOrNoController.onSubmit(mode: Mode = NormalMode)" >> ../conf/app.routes

echo "GET        /changeYesOrNo                  controllers.YesOrNoController.onPageLoad(mode: Mode = CheckMode)" >> ../conf/app.routes
echo "POST       /changeYesOrNo                  controllers.YesOrNoController.onSubmit(mode: Mode = CheckMode)" >> ../conf/app.routes

echo "Adding messages to conf.messages"
echo "" >> ../conf/messages.en
echo "yesOrNo.title = yesOrNo" >> ../conf/messages.en
echo "yesOrNo.heading = yesOrNo" >> ../conf/messages.en
echo "yesOrNo.checkYourAnswersLabel = yesOrNo" >> ../conf/messages.en
echo "yesOrNo.error.required = Select yes if yesOrNo" >> ../conf/messages.en

echo "Adding to UserAnswersEntryGenerators"
awk '/trait UserAnswersEntryGenerators/ {\
    print;\
    print "";\
    print "  implicit lazy val arbitraryYesOrNoUserAnswersEntry: Arbitrary[(YesOrNoPage.type, JsValue)] =";\
    print "    Arbitrary {";\
    print "      for {";\
    print "        page  <- arbitrary[YesOrNoPage.type]";\
    print "        value <- arbitrary[Boolean].map(Json.toJson(_))";\
    print "      } yield (page, value)";\
    print "    }";\
    next }1' ../test/generators/UserAnswersEntryGenerators.scala > tmp && mv tmp ../test/generators/UserAnswersEntryGenerators.scala

echo "Adding to PageGenerators"
awk '/trait PageGenerators/ {\
    print;\
    print "";\
    print "  implicit lazy val arbitraryYesOrNoPage: Arbitrary[YesOrNoPage.type] =";\
    print "    Arbitrary(YesOrNoPage)";\
    next }1' ../test/generators/PageGenerators.scala > tmp && mv tmp ../test/generators/PageGenerators.scala

echo "Adding to CacheMapGenerator"
awk '/val generators/ {\
    print;\
    print "    arbitrary[(YesOrNoPage.type, JsValue)] ::";\
    next }1' ../test/generators/CacheMapGenerator.scala > tmp && mv tmp ../test/generators/CacheMapGenerator.scala

echo "Adding helper method to CheckYourAnswersHelper"
awk '/class/ {\
     print;\
     print "";\
     print "  def yesOrNo: Option[AnswerRow] = userAnswers.get(YesOrNoPage) map {";\
     print "    x => AnswerRow(\"yesOrNo.checkYourAnswersLabel\", if(x) \"site.yes\" else \"site.no\", true, routes.YesOrNoController.onPageLoad(CheckMode).url)"; print "  }";\
     next }1' ../app/utils/CheckYourAnswersHelper.scala > tmp && mv tmp ../app/utils/CheckYourAnswersHelper.scala

echo "Migration YesOrNo completed"
