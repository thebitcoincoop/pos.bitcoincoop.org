g = this

$(->
  $('#username').focus()
  $('#password').pwstrength(showVerdicts: false)


  $('#username').blur(->
    $(this).parent().next('.alert').remove()

    if /^[a-z]+$/.test($(this).val()) and $(this).val().length > 2
      $(this).parent().removeClass('has-error')
    else
      $(this).parent().addClass('has-error')
      $(this).parent().after('<div class="alert alert-danger">Username must be lowecase and have at least 3 characters</div>')
  )

  $('#password').blur(->
    $('#confirm').blur()
    $(this).parent().next('.alert').remove()

    if $('.progress-bar-success').length > 0
      $(this).parent().removeClass('has-error')
    else
      $(this).parent().addClass('has-error')
  )

  $('#confirm').blur(->
    return if $(this).val() == ''
    $(this).parent().next('.alert').remove()

    if $('#password').val() == $('#confirm').val()
      $('#confirm').parent().removeClass('has-error')
    else
      $('#confirm').parent().addClass('has-error')
      $('#confirm').parent().after('<div class="alert alert-danger">Passwords don\'t match</div>')
  )

  $('#email').blur(->
    return if $(this).val() == ''
    $(this).parent().next('.alert').remove()
    if validateEmail($(this).val())
      $(this).parent().removeClass('has-error')
    else
      $(this).parent().addClass('has-error')
      $(this).parent().after('<div class="alert alert-danger">Invalid email</div>')
  )

  $('#register').submit(->
    $('.form-control').blur()
    if $('.has-error').length > 0
      $('.has-error').effect('shake', 500)
      return false
    else
      mnemonic = bip39.generateMnemonic()
      key = bitcoin.HDNode.fromSeedBuffer(bip39.mnemonicToSeed(mnemonic)).deriveHardened(44).deriveHardened(0)
      $('#pubkey').val(key.neutered().toString())
      $('#privkey').val(CryptoJS.AES.encrypt(key.toString(), $('#password').val()).toString())
  )
)
