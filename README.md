To create this repo I:

1. `rails new goodjob-batches --database=postgresql`
1. `bundle add good_job`
1. `bin/rails db:setup`
1. `bin/rails g good_job:install`
1. `bin/rails db:migrate`
1. Added `config.active_job.queue_adapter = :good_job` and `# config.eager_load_paths << Rails.root.join("extras")` to `config/application.rb`
1. Created `app/jobs/my_batch_callback_job.rb` and `spec/jobs/my_batch_callback_job_spec.rb`
1. `bundle add rspec`
1. `bundle add --group development,test rspec-rails`
1. `bin/rails generate rspec:install`
1. `bundle exec rspec`
