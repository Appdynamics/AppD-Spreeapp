FROM spreecommerce/spree:3.6.4
#
# Maintainer: David Ryder
#
# https://hub.docker.com/r/spreecommerce/spree/tags?page=1&ordering=last_updated

ARG USER
ARG HOME_DIR

#USER $USER
COPY ctl.sh /spree/sandbox/
RUN mkdir ${HOME_DIR}/spreeapp-config/
ADD spreeapp-config ${HOME_DIR}/spreeapp-config/
# Backups
RUN cp /spree/sandbox/config/application.rb ${HOME_DIR}/spreeapp-config/orig-application.rb
RUN cp /spree/sandbox/config/database.yml ${HOME_DIR}/spreeapp-config/orig-database.yml
RUN cp /spree/sandbox/Gemfile ${HOME_DIR}/spreeapp-config/orig-Gemfile

# Overwrite
RUN cp ${HOME_DIR}/spreeapp-config/application.rb /spree/sandbox/config/application.rb
#RUN cp ${HOME_DIR}/spreeapp-config/postgresql-database.yml /spree/sandbox/config/database.yml
RUN cp ${HOME_DIR}/spreeapp-config/sandbox-Gemfile /spree/sandbox/Gemfile
RUN cp ${HOME_DIR}/spreeapp-config/appdynamics.yml /spree/sandbox/config/appdynamics.yml

EXPOSE 3000

ENTRYPOINT [ "/spree/spreeapp-config/container-start.sh" ]
