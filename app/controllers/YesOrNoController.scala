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

import javax.inject.Inject
import play.api.data.Form
import play.api.i18n.{I18nSupport, MessagesApi}
import controllers.actions._
import forms.YesOrNoFormProvider
import models.{Mode, UserAnswers}
import pages.YesOrNoPage
import navigation.Navigator
import play.api.mvc.{Action, AnyContent, MessagesControllerComponents}
import repositories.SessionRepository
import views.html.YesOrNoView

import scala.concurrent.{ExecutionContext, Future}

class YesOrNoController @Inject()(
                                  override val messagesApi: MessagesApi,
                                  sessionRepository: SessionRepository,
                                  navigator: Navigator,
                                  identify: IdentifierAction,
                                  getData: DataRetrievalAction,
                                  requireData: DataRequiredAction,
                                  formProvider: YesOrNoFormProvider,
                                  val controllerComponents: MessagesControllerComponents,
                                  view: YesOrNoView
                                         )(implicit ec: ExecutionContext) extends FrontendBaseController with I18nSupport {

  val form: Form[Boolean] = formProvider()

  def onPageLoad(mode: Mode): Action[AnyContent] = (identify andThen getData) {
    implicit request =>

      val preparedForm = request.userAnswers.getOrElse(UserAnswers(request.internalId)).get(YesOrNoPage) match {
        case None => form
        case Some(value) => form.fill(value)
      }

      Ok(view(preparedForm, mode))
  }

  def onSubmit(mode: Mode): Action[AnyContent] = (identify andThen getData).async {
    implicit request =>

      form.bindFromRequest().fold(
        (formWithErrors: Form[_]) =>
          Future.successful(BadRequest(view(formWithErrors, mode))),

        value => {
          val updatedAnswers = request.userAnswers.getOrElse(UserAnswers(request.internalId)).set(YesOrNoPage, value)

          sessionRepository.set(updatedAnswers.userData).map(
            _ =>
              Redirect(navigator.nextPage(YesOrNoPage, mode)(updatedAnswers))
          )
        }
      )
  }
}
