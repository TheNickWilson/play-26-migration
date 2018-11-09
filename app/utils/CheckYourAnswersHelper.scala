/*
 * Copyright 2018 HM Revenue & Customs
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package utils

import controllers.routes
import models.{CheckMode, UserAnswers}
import pages._
import viewmodels.{AnswerRow, RepeaterAnswerRow, RepeaterAnswerSection}

class CheckYourAnswersHelper(userAnswers: UserAnswers) {

  def yesOrNo: Option[AnswerRow] = userAnswers.get(YesOrNoPage) map {
    x => AnswerRow("yesOrNo.checkYourAnswersLabel", if(x) "site.yes" else "site.no", true, routes.YesOrNoController.onPageLoad(CheckMode).url)
  }

  def someString: Option[AnswerRow] = userAnswers.get(SomeStringPage) map {
    x => AnswerRow("someString.checkYourAnswersLabel", s"$x", false, routes.SomeStringController.onPageLoad(CheckMode).url)
  }

  def someQuestion: Option[AnswerRow] = userAnswers.get(SomeQuestionPage) map {
    x => AnswerRow("someQuestion.checkYourAnswersLabel", s"${x.field1} ${x.field2}", false, routes.SomeQuestionController.onPageLoad(CheckMode).url)
  }

  def someOptions: Option[AnswerRow] = userAnswers.get(SomeOptionsPage) map {
    x => AnswerRow("someOptions.checkYourAnswersLabel", s"SomeOptionsView.$x", true, routes.SomeOptionsController.onPageLoad(CheckMode).url)
  }

  def someInt: Option[AnswerRow] = userAnswers.get(SomeIntPage) map {
    x => AnswerRow("someInt.checkYourAnswersLabel", s"$x", false, routes.SomeIntController.onPageLoad(CheckMode).url)
  }
}
