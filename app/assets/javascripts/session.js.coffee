$ ->
  $('.recovery-password-link, .forgot-back-to-signin').on 'click', (event) ->
    event.preventDefault()
    $('.signin-form, .reset-form').toggle()
    
  $('.social-login-link, .social-back-to-signin').on 'click', (event) ->
    event.preventDefault()
    $('.signin-form, .social-login-form').toggle()