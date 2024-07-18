#!/bin/bash --
gems='rodauth-rails rotp rqrcode sequel-activerecord_connection'

for i in $gems; do
    gem list | grep $i >&/dev/null
    if [ $? -eq 1 ]; then
        gem install $i
        bundle add $i
    else
        echo "$i is already installed"
    fi
done

bundle add rodauth-rails
bundle add rotp rqrcode sequel-activerecord_connection
rails generate rodauth:install
rails db:migrate
rails generate rodauth:migration otp
rails db:migrate

rails generate rodauth:views --css=tailwind