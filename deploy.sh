#!/bin/bash
gem install bundler
bundle install --verbose
bundle exec mina deploy --verbose