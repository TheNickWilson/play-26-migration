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

import config.FrontendAppConfig
import controllers.actions._
import forms.SomeOptionsFormProvider
import javax.inject.Inject
import models.{Enumerable, Mode}
import navigation.Navigator
import pages.SomeOptionsPage
import play.api.data.Form
import play.api.i18n.{I18nSupport, MessagesApi}
import play.api.mvc.{Action, AnyContent, MessagesControllerComponents}
import repositories.SessionRepository
import views.html.SomeOptionsView

import scala.concurrent.{ExecutionContext, Future}

class SomeOptionsController @Inject()(
                                       appConfig: FrontendAppConfig,
                                       override val messagesApi: MessagesApi,
                                       sessionRepository: SessionRepository,
                                       navigator: Navigator,
                                       identify: IdentifierAction,
                                       getData: DataRetrievalAction,
                                       requireData: DataRequiredAction,
                                       formProvider: SomeOptionsFormProvider,
                                       val controllerComponents: MessagesControllerComponents,
                                       view: SomeOptionsView
                                      )(implicit ec: ExecutionContext) extends FrontendBaseController with I18nSupport with Enumerable.Implicits {

  val form = formProvider()

  def onPageLoad(mode: Mode): Action[AnyContent] = (identify andThen getData andThen requireData) {
    implicit request =>

      val preparedForm = request.userAnswers.get(SomeOptionsPage) match {
        case None => form
        case Some(value) => form.fill(value)
      }

      Ok(view(appConfig, preparedForm, mode))
  }

  def onSubmit(mode: Mode): Action[AnyContent] = (identify andThen getData andThen requireData).async {
    implicit request =>

      form.bindFromRequest().fold(
        (formWithErrors: Form[_]) =>
          Future.successful(BadRequest(view(appConfig, formWithErrors, mode))),

        value => {
          val updatedAnswers = request.userAnswers.set(SomeOptionsPage, value)

          sessionRepository.set(updatedAnswers.userData).map(
            _ =>
              Redirect(navigator.nextPage(SomeOptionsPage, mode)(updatedAnswers))
          )
        }
      )
  }
}
