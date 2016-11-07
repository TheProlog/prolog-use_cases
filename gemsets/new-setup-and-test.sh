#!env zsh

usecase_setup_dry_gems() {
  gem install dry-types -v 0.9.1
  gem install dry-struct -v 0.1.0
  gem install dry-validation -v 0.10.3
}

usecase_setup_markup_markdown_gems() {
  gem install gemoji -v 2.1.0
  gem install github-markdown -v 0.6.9
  gem install nokogiri -v 1.6.8.1
  gem install ox -v 2.4.5
  gem install rinku -v 2.0.2
  gem install html-pipeline -v 2.4.2
}

usecase_setup_prolog_core_deps() {
  gem install validates_email_format_of -v 1.6.3
  gem install virtus -v 1.0.5
  gem install wisper -v 2.0.0.rc1
}

usecase_setup_runtime_gems() {
  mkdir -p gemsets/runtime
  rbenv gemset init './gemsets/runtime'
  echo './gemsets/runtime' > .rbenv-gemsets
  gem install awesome_print -v 1.7.0
  gem install activemodel -v 4.2.7.1
  gem install semantic_logger -v 3.4.0
  gem install uuid -v 2.3.8
  usecase_setup_prolog_core_deps
  usecase_setup_dry_gems
  usecase_setup_markup_markdown_gems
  rbenv rehash
}

usecase_setup_prolog_gems() {
  mkdir -p gemsets/prolog
  rbenv gemset init './gemsets/prolog'
  echo "./gemsets/prolog\n./gemsets/runtime" > .rbenv-gemsets
  gem install prolog_core -v 0.4.0
  gem install prolog-dry_types -v 0.3.0
  gem install prolog-entities-result-base -v 0.2.0
  gem install prolog-services-markdown_to_html -v 1.0.2
  gem install prolog-services-replace_content -v 0.1.2
  gem install prolog-use_cases-publish_new_article -v 0.2.4
  gem install prolog-use_cases-register_new_member -v 0.2.0
  gem install prolog-use_cases-retrieve_article -v 0.1.1
  rbenv rehash
}

usecase_setup_dev_gems() {
  mkdir -p gemsets/dev
  rbenv gemset init './gemsets/dev'
  echo "./gemsets/dev\n./gemsets/prolog\n./gemsets/runtime" > .rbenv-gemsets
  gem install benchmark-ips -v 2.7.2
  gem install bundler -v 1.13.6
  gem install ffaker -v 2.2.0
  gem install flay -v 2.8.1
  gem install flog -v 4.4.0
  gem install fury -v 0.0.5
  gem install license_finder -v 2.1.2
  gem install rake -v 11.3.0
  gem install reek -v 4.5.1
  gem install rubocop -v 0.45.0
  gem install simplecov -v 0.12.0
  gem install pry -v 0.10.4
  gem install pry-byebug -v 3.4.0
  gem install pry-doc -v 0.9.0
  gem install minitest-matchers -v 1.4.1
  gem install minitest-reporters -v 1.1.12
  gem install minitest-tagz -v 1.5.2
  # gem install colorize -v 0.7.7
  rbenv rehash
}

usecase_setup_error_gems() {
  mkdir -p gemsets/error
  rbenv gemset init './gemsets/error'
  # This *shouldn't* have an Gems installed.
  echo "./gemsets/error\n./gemsets/dev\n./gemsets/prolog\n./gemsets/runtime" > .rbenv-gemsets
}

usecase_setup() {
  usecase_setup_runtime_gems
  usecase_setup_prolog_gems
  usecase_setup_dev_gems
  usecase_setup_error_gems
}

usecase_bundle_and_test() {
  bundle install --local
  rm -rf o-rdoc
  bundle exec rake
}

if [[ $1 == 'setup' ]]; then
  usecase_setup
fi
echo "./gemsets/error\n./gemsets/dev\n./gemsets/prolog\n./gemsets/runtime" > .rbenv-gemsets
usecase_bundle_and_test

unfunction `functions | egrep 'usecase_.* ()' | sed 's/ () {//'`
# echo "Deleting .rbenv-gemsets file with contents" ; cat .rbenv-gemsets
# rm .rbenv-gemsets
echo 'All done'
