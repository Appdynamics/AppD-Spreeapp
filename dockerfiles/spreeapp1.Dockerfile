FROM spreecommerce/spree:3.6.4
#
# Maintainer: David Ryder
#
# https://hub.docker.com/r/spreecommerce/spree/tags?page=1&ordering=last_updated

ARG USER
ARG HOME_DIR
ARG SPREE_APP_DIR

#USER $USER
COPY ctl.sh ${HOME_DIR}
COPY envvars.sh ${HOME_DIR}
RUN mkdir ${HOME_DIR}/spreeapp-config/
ADD spreeapp-config ${HOME_DIR}/spreeapp-config/
# Backups
RUN cp ${SPREE_APP_DIR}/config/application.rb ${HOME_DIR}/spreeapp-config/orig-application.rb
RUN cp ${SPREE_APP_DIR}/config/database.yml   ${HOME_DIR}/spreeapp-config/orig-database.yml
RUN cp ${SPREE_APP_DIR}/Gemfile               ${HOME_DIR}/spreeapp-config/orig-Gemfile

# Overwrite
RUN cp ${HOME_DIR}/spreeapp-config/application.rb  ${SPREE_APP_DIR}/config/application.rb
#RUN cp ${HOME_DIR}/spreeapp-config/postgresql-database.yml ${SPREE_APP_DIR}/config/database.yml
RUN cp ${HOME_DIR}/spreeapp-config/sandbox-Gemfile ${SPREE_APP_DIR}/Gemfile
RUN cp ${HOME_DIR}/spreeapp-config/appdynamics.yml ${SPREE_APP_DIR}/config/appdynamics.yml

EXPOSE 3000

ENTRYPOINT ./${HOME_DIR}/ctl.sh start-container
