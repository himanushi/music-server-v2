# ログ出力すべきでないものはマスク
Rails.application.config.filter_parameters += [
  :password, :passw, :secret, :token, :_key, :crypt, :salt, :certificate, :otp, :ssn
]
