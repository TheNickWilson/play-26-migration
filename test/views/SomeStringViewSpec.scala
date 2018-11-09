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

///*
// * Copyright 2018 HM Revenue & Customs
// *
// * Licensed under the Apache License, Version 2.0 (the "License");
// * you may not use this file except in compliance with the License.
// * You may obtain a copy of the License at
// *
// *     http://www.apache.org/licenses/LICENSE-2.0
// *
// * Unless required by applicable law or agreed to in writing, software
// * distributed under the License is distributed on an "AS IS" BASIS,
// * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// * See the License for the specific language governing permissions and
// * limitations under the License.
// */
//
//package views
//
//import play.api.data.Form
//import controllers.routes
//import forms.SomeStringFormProvider
//import models.NormalMode
//import views.behaviours.StringViewBehaviours
//import views.html.someString
//
//class SomeStringViewSpec extends StringViewBehaviours {
//
//  val messageKeyPrefix = "SomeStringView"
//
//  val form = new SomeStringFormProvider()()
//
//  def createView = () => someString(frontendAppConfig, form, NormalMode)(fakeRequest, messages)
//
//  def createViewUsingForm = (form: Form[String]) => someString(frontendAppConfig, form, NormalMode)(fakeRequest, messages)
//
//  "SomeStringView view" must {
//    behave like normalPage(createView, messageKeyPrefix)
//
//    behave like pageWithBackLink(createView)
//
//    behave like stringPage(createViewUsingForm, messageKeyPrefix, routes.SomeStringController.onSubmit(NormalMode).url)
//  }
//}
