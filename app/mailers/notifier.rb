# -*- coding: utf-8 -*-
# This file is part of Mconf-Web, a web application that provides access
# to the Mconf webconferencing system. Copyright (C) 2010-2012 Mconf
#
# This file is licensed under the Affero General Public License version
# 3 or later. See the LICENSE file.

class Notifier < ApplicationMailer

  #this method is used when a user has sent feedback to the admin.
  def feedback_email(email, subject, body)
    I18n.with_locale(get_user_locale(email,false)) do
      subject += I18n.t("feedback.one").html_safe + " " + subject
      @text = body
      @email = email

      create_email(Site.current.smtp_sender, email, subject)
    end
  end

  def digest_email(receiver_id, date_start, date_end)
    receiver = User.find(receiver_id)
    I18n.with_locale(get_user_locale(receiver,false)) do
      posts, news, attachments, events, inbox = Mconf::DigestEmail.get_activity(receiver, date_start, date_end)
      @posts = posts
      @news = news
      @attachments = attachments
      @events = events
      @inbox = inbox
      @locale = receiver.locale
      if receiver.receive_digest == User::RECEIVE_DIGEST_DAILY
        @type = t('email.digest.type.daily', :locale => @locale)
      else
        @type = t('email.digest.type.weekly', :locale => @locale)
      end
      @subject = t('email.digest.title', :type => @type, :locale => @locale)
      @signature  = Site.current.signature_in_html

      create_email(receiver.email,nil,@subject)
    end
  end

end
