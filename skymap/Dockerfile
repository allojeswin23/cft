FROM ruby:2.7.1-alpine as builder

ARG BUNDLE_GEMS__CONTRIBSYS__COM="xyz"
ENV BUNDLE_GEMS__CONTRIBSYS__COM=$BUNDLE_GEMS__CONTRIBSYS__COM

ENV INSTALL_PATH /app
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH

RUN mkdir -p tmp/pids

RUN apk add --no-cache postgresql-dev npm tzdata nodejs build-base shared-mime-info > /dev/null
# Cache the bundle install
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN npm install -g yarn && yarn install

RUN bundle config https://gems.contribsys.com $BUNDLE_GEMS__CONTRIBSYS__COM && \
    bundle install --quiet

RUN rm -rf /usr/local/bundle/cache/*.gem \
    && find /usr/local/bundle/gems/ -name "*.c" -delete \
    && find /usr/local/bundle/gems/ -name "*.o" -delete

COPY . .

RUN bundle exec rake assets:precompile

####################################################################

FROM 423594114171.dkr.ecr.us-east-2.amazonaws.com/eq/ruby-base-image:ruby-2.7.1-latest as rails

ARG BUILD_VERSION="abcdefg"
ENV BUILD_VERSION=$BUILD_VERSION
ARG MAJOR_VERSION="D"
ENV MAJOR_VERSION=$MAJOR_VERSION
ARG MINOR_VERSION="E"
ENV MINOR_VERSION=$MINOR_VERSION
ARG PATCH_VERSION="V"
ENV PATCH_VERSION=$PATCH_VERSION
ARG BUNDLE_GEMS__CONTRIBSYS__COM="xyz"
ENV BUNDLE_GEMS__CONTRIBSYS__COM=$BUNDLE_GEMS__CONTRIBSYS__COM

ENV INSTALL_PATH /app

ENV RAILS_LOG_TO_STDOUT true
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH

COPY . .
RUN rm -rf tmp/cache app/assets vendor lib/assets spec

COPY --from=builder /root/.bundle/config /root/.bundle/config
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=builder /app/public/ /app/public/

RUN bundle exec rake create_version

# Setup Entrypoint
RUN cp ./docker/entrypoint.sh ./docker/start-rails.sh ./docker/start-sidekiq.sh ./docker/clear-migrate-seed.sh ./docker/rake-task.sh /usr/bin/ && chmod 555 /usr/bin/entrypoint.sh && chmod 555 /usr/bin/start-rails.sh && chmod 555 /usr/bin/start-sidekiq.sh && chmod 555 /usr/bin/clear-migrate-seed.sh && chmod 555 /usr/bin/rake-task.sh
ENTRYPOINT ["entrypoint.sh"]
CMD ["start-rails.sh"]
EXPOSE 3000
