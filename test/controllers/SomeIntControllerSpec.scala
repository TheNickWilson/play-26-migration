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

package controllers

import play.api.libs.json.{JsNumber, Json}
import navigation.{FakeNavigator, Navigator}
import play.api.test.Helpers._
import forms.SomeIntFormProvider
import models.{NormalMode, UserData}
import pages.SomeIntPage
import play.api.mvc.Call
import play.api.test.FakeRequest
import views.html.SomeIntView
import play.api.inject.bind

class SomeIntControllerSpec extends ControllerSpecBase {

  val formProvider = new SomeIntFormProvider()
  val form = formProvider()

  def onwardRoute = Call("GET", "/foo")

  val someIntRoute = routes.SomeIntController.onPageLoad(NormalMode).url

  "SomeIntView Controller" must {

    "return OK and the correct view for a GET" in {

      val application = applicationBuilder(userData = Some(emptyUserData)).build()

      val request = FakeRequest(GET, someIntRoute)

      val result = route(application, request).value

      val view = application.injector.instanceOf[SomeIntView]

      status(result) mustEqual OK

      contentAsString(result) mustEqual
        view(frontendAppConfig, form, NormalMode)(fakeRequest, messages).toString
    }

    "populate the view correctly on a GET when the question has previously been answered" in {

      val userData = UserData(userDataId, Json.obj(SomeIntPage.toString -> JsNumber(1)))

      val application = applicationBuilder(userData = Some(userData)).build()

      val request = FakeRequest(GET, someIntRoute)

      val view = application.injector.instanceOf[SomeIntView]

      val result = route(application, request).value

      status(result) mustEqual OK

      contentAsString(result) mustEqual
        view(frontendAppConfig, form.fill(1), NormalMode)(fakeRequest, messages).toString
    }

    "redirect to the next page when valid data is submitted" in {

      val application =
        applicationBuilder(userData = Some(emptyUserData))
          .overrides(bind[Navigator].toInstance(new FakeNavigator(onwardRoute)))
          .build()

      val request =
        FakeRequest(POST, someIntRoute)
          .withFormUrlEncodedBody(("value", "1"))

      val result = route(application, request).value

      status(result) mustEqual SEE_OTHER

      redirectLocation(result).value mustEqual onwardRoute.url
    }

    "return a Bad Request and errors when invalid data is submitted" in {

      val application = applicationBuilder(userData = Some(emptyUserData)).build()

      val request =
        FakeRequest(POST, someIntRoute)
          .withFormUrlEncodedBody(("value", "invalid value"))

      val boundForm = form.bind(Map("value" -> "invalid value"))

      val view = application.injector.instanceOf[SomeIntView]

      val result = route(application, request).value

      status(result) mustEqual BAD_REQUEST

      contentAsString(result) mustEqual
        view(frontendAppConfig, boundForm, NormalMode)(fakeRequest, messages).toString
    }

    "redirect to Session Expired for a GET if no existing data is found" in {

      val application = applicationBuilder(userData = None).build()

      val request = FakeRequest(GET, someIntRoute)

      val result = route(application, request).value

      status(result) mustEqual SEE_OTHER
      redirectLocation(result).value mustEqual routes.SessionExpiredController.onPageLoad().url
    }

    "redirect to Session Expired for a POST if no existing data is found" in {

      val application = applicationBuilder(userData = None).build()

      val request =
        FakeRequest(POST, someIntRoute)
          .withFormUrlEncodedBody(("value", "1"))

      val result = route(application, request).value

      status(result) mustEqual SEE_OTHER

      redirectLocation(result).value mustEqual routes.SessionExpiredController.onPageLoad().url
    }
  }
}
