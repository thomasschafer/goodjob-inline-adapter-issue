To create this repo I performed the following steps:

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

When run, the following will happen:

```
$ bundle exec rspec
MyJob: [0, 0]
MyJob: [0, 1]
MyJob: [0, 2]
MyJob: [0, 3]
MyJob: [0, 4]
MyJob: [0, 5]
MyBatchCallbackJob: [1, -1]
MyJob: [1, 0]
MyJob: [1, 1]
MyJob: [1, 2]
MyJob: [1, 3]
MyJob: [1, 4]
MyJob: [1, 5]
MyBatchCallbackJob: [2, -1]
MyJob: [2, 0]
.
```

This is occuring because `JobNotComplete` is being thrown from `MyJob`, which is a retriable error, but the error is not being retried, and the spec incorrectly passes.

If `retry_on()` is commented out, we see the following:

```
$ bundle exec rspec
MyJob: [0, 0]
MyJob: [0, 1]
MyJob: [0, 2]
MyJob: [0, 3]
MyJob: [0, 4]
MyJob: [0, 5]
MyBatchCallbackJob: [1, -1]
MyJob: [1, 0]
MyJob: [1, 1]
MyJob: [1, 2]
MyJob: [1, 3]
MyJob: [1, 4]
MyJob: [1, 5]
MyBatchCallbackJob: [2, -1]
MyJob: [2, 0]
F

Failures:

  1) MyJob Runs successfully
     Failure/Error: raise JobNotComplete if job_id.first == 2

     MyJob::JobNotComplete:
       MyJob::JobNotComplete
     # ./app/jobs/my_job.rb:9:in `perform'
     # ./app/jobs/my_batch_callback_job.rb:6:in `perform'
     # ./app/jobs/my_job.rb:18:in `perform'
     # ./app/jobs/my_batch_callback_job.rb:6:in `perform'
     # ./app/jobs/my_job.rb:18:in `perform'
     # ./spec/jobs/my_job_spec.rb:5:in `block (2 levels) in <top (required)>'

Finished in 0.3505 seconds (files took 1.13 seconds to load)
1 example, 1 failure

Failed examples:

rspec ./spec/jobs/my_job_spec.rb:4 # MyJob Runs successfully
```

If the error is not thrown, all jobs succeed:

```
> goodjob-batches (main) $ bundle exec rspec
MyJob: [0, 0]
MyJob: [0, 1]
MyJob: [0, 2]
MyJob: [0, 3]
MyJob: [0, 4]
MyJob: [0, 5]
MyBatchCallbackJob: [1, -1]
MyJob: [1, 0]
MyJob: [1, 1]
MyJob: [1, 2]
MyJob: [1, 3]
MyJob: [1, 4]
MyJob: [1, 5]
MyBatchCallbackJob: [2, -1]
MyJob: [2, 0]
...
yJob: [9, 3]
MyJob: [9, 4]
MyJob: [9, 5]
MyBatchCallbackJob: [10, -1]
MyJob: [10, 0]
.

Finished in 0.62028 seconds (files took 1.05 seconds to load)
1 example, 0 failures
```
