# Gack

Gack helps you build [Gemini](https://gemini.circumlunar.space/) protocol applications with Ruby.

## Usage

Install gem:

    gem install gack

Build an app:

```ruby
require 'gack'

class App < Gack::Application
  route '/' do
    'Hello, World!'
  end
end

App.run!
```

### TLS

Gemini requires TLS handshakes. Gack does not do TLS handshakes. You need to setup a TLS terminator. I use Nginx. Below is some quick information on how you might begin to use Nginx to terminate TLS.

#### Certs

Generate a self-signed `.crt` and `.key`. Example:

    openssl req -newkey rsa:2048 -nodes -keyout localhost.key -nodes -x509 -out localhost.crt -subj "/CN=localhost"

#### Nginx

Nginx will be used for the TLS handshake and termination:

    stream {

      upstream backend {
        # change this to reflect what port your Gack server is running on (default is 6565)
        server localhost:6565;
      }

      server {
        # 1965 is the default Gemini protocol port
        listen 1965 ssl;
        proxy_pass backend;

        # change these to match the directory and filename of your crt and key
        ssl_certificate     /your/localtion/to/certs/localhost.crt;
        ssl_certificate_key /your/localtion/to/localhost.key;

        ssl_protocols TLSv1.1 TLSv1.2;

        ssl_prefer_server_ciphers on;
        ssl_ciphers ECDH+AESGCM:ECDH+AES256:ECDH+AES128:DH+3DES:!ADH:!AECDH:!MD5;

        ssl_session_cache    shared:SSL:20m;
        ssl_session_timeout  4h;

        ssl_handshake_timeout 20s;
      }
    }
