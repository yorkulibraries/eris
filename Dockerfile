FROM ruby:2.2.7

WORKDIR /app

# Copy only Gemfile first (caches dependencies)
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Now copy the rest of the app
COPY . .  

CMD ["bundle", "exec", "puma", "-C", "/app/config/puma.rb"]
