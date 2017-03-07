FROM debian:jessie
MAINTAINER Mitry Pyostrovsky <mitrypyostrovsky@gmail.com>

## Стандартная процедура апдейта системы, а также установка утилиты Wget
##
RUN    apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get clean \
    && apt-get install -y wget locales \
    && apt-get clean

## Инсталляция "Nimble Streamer" и преренос конфигурационных файлов внутрь конейнера в /etc/nimble.conf
##
RUN    echo "deb http://nimblestreamer.com/debian/ jessie/" > /etc/apt/sources.list.d/nimblestreamer.list \
    && wget -q -O - http://nimblestreamer.com/gpg.key | apt-key add - \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y nimble \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && mkdir /etc/nimble.conf \
    && mv /etc/nimble/* /etc/nimble.conf

## Создание отдельного волюма с папкой, содержащей настройки
##
VOLUME /etc/nimble

## Volume для кэша аудио и видеофайлов стриминга
##
VOLUME /var/cache/nimble

## WMS-panel: имя пользователя и пароль
## Сперва Вы должны быть зарегистрированы на сайте wmspanel.com
## Но это не обязательно, если Вы не собираетесь пользоваться WMS-панелью
##
ENV WMSPANEL_USER	""
ENV WMSPANEL_PASS	""
ENV WMSPANEL_SLICES	""

## Файлы с конфигурацей сервиса (сервера)
##
ADD files/my_init.d	/etc/my_init.d
ADD files/service	/etc/service
ADD files/logrotate.d	/etc/logrotate.d

## Порты, выставляемые наружу контейнера
##
EXPOSE 1935 8081
