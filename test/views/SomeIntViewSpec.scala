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

package views

import play.api.data.Form
import controllers.routes
import forms.SomeIntFormProvider
import models.NormalMode
import views.behaviours.IntViewBehaviours
import views.html.someInt

class SomeIntViewSpec extends IntViewBehaviours {

  val messageKeyPrefix = "someInt"

  val form = new SomeIntFormProvider()()

  def createView = () => someInt(frontendAppConfig, form, NormalMode)(fakeRequest, messages)

  def createViewUsingForm = (form: Form[_]) => someInt(frontendAppConfig, form, NormalMode)(fakeRequest, messages)

  "SomeInt view" must {
    behave like normalPage(createView, messageKeyPrefix)

    behave like pageWithBackLink(createView)

    behave like intPage(createViewUsingForm, messageKeyPrefix, routes.SomeIntController.onSubmit(NormalMode).url)
  }
}
