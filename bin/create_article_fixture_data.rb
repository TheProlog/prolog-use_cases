#!/usr/bin/env ruby
#
# create_article_fixture_data.rb
#
# Quick and dirty script to generate new Article fixture data and store it in a
# file in `/tmp`. Will overwrite output file.
#
# Run this from the project root directory as 'ruby bin/create_article_fixture_data.rb'.
#
# Once regenerated, the output YAML may be read in and inspected before moving
# into place in `test/fixtures/articles.yaml`. For example, it might be useful
# to verify a sufficient number/variety of generated keywords or timestamps.
#
require 'yaml'
require 'colorize'

require 'prolog/core'
require_relative '../test/support/article_fixture_builder'

require_relative '../support/summary_reporter'

fixture_article_count = 50
output_file = '/tmp/articles.yaml'

builder = ArticleFixtureBuilder.new fixture_article_count
articles = builder.list
puts "Generated #{articles.count} Articles as fixture data."
output_data = articles.to_yaml;
File.open(output_file, 'w') { |f| f.puts output_data };
puts "Wrote YAML dumping generated Articles to #{output_file}."

keywords = articles.map(&:keywords).map(&:to_a).flatten.sort;

puts SummaryReporter.new(articles)
