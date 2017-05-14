desc 'Generate RSA key pair'
task :gen_key do
  require 'openssl'
  puts OpenSSL::PKey::RSA.generate(4096).to_pem
end
