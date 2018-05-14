guard :rspec, cmd: 'bundle exec rspec -fh -otmp/spec_results.html', bundler_env: :inherit do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end
