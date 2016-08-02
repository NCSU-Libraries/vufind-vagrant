#!/bin/sh

fetch_composer() {
    pushd /tmp
    EXPECTED_SIGNATURE=$(wget https://composer.github.io/installer.sig -O - -q)
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');")

    if [ "$EXPECTED_SIGNATURE" = "$ACTUAL_SIGNATURE" ]
    then
        php composer-setup.php --quiet
        RESULT=$?
        rm composer-setup.php
        return $RESULT
    else
        >&2 echo 'ERROR: Invalid installer signature'
        rm composer-setup.php
        return 1
    fi
}


if [ ! -e /usr/local/bin/composer.phar ]; then
    if [ fetch_composer ]; then
            popd
            cp /tmp/composer.phar /usr/local/bin
    else
        echo "Installation of composer failed."
        exit 1
    fi
fi
