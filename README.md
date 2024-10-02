# GoodJob inline adapter issue

This repo is used to show an issue with the GoodJob inline adapter, used in tests. I have created a job in `app/jobs/my_job.rb` which has a retryable error. When the error is thrown, the inline adapter does not attempt to run the job again, leading to tests incorrectly passing.

When `bundle exec rspec` is run, the following will happen:

```
$ bundle exec rspec
MyJob: 0
MyJob: 1
MyJob: 2
.

Finished in 0.18838 seconds (files took 0.99919 seconds to load)
1 example, 0 failures
```

This is occurring because `JobNotComplete` is being thrown from `MyJob`, which is a retriable error, but the error is not being retried, and the spec incorrectly passes.

If `retry_on(JobNotComplete)` is commented out, we see the following:

```
$ bundle exec rspec
MyJob: 0
MyJob: 1
MyJob: 2
F

Failures:

  1) MyJob Runs successfully
     Failure/Error: raise JobNotComplete if job_id == 2

     MyJob::JobNotComplete:
       MyJob::JobNotComplete
     # ./app/jobs/my_job.rb:13:in `perform'
     # ./app/jobs/my_job.rb:15:in `perform'
     # ./app/jobs/my_job.rb:15:in `perform'
     # ./spec/jobs/my_job_spec.rb:5:in `block (2 levels) in <top (required)>'

Finished in 0.17487 seconds (files took 1.03 seconds to load)
1 example, 1 failure

Failed examples:

rspec ./spec/jobs/my_job_spec.rb:4 # MyJob Runs successfully
```

If the error is not thrown, all jobs succeed:

```
$ bundle exec rspec
MyJob: 0
MyJob: 1
MyJob: 2
MyJob: 3
MyJob: 4
MyJob: 5
MyJob: 6
MyJob: 7
MyJob: 8
MyJob: 9
MyJob: 10
Succeeded
.

Finished in 0.22215 seconds (files took 1.01 seconds to load)
1 example, 0 failures
```

# Creating this repo

To create this repo I performed the following steps:

1. `rails new goodjob-batches --database=postgresql`
1. `bundle add good_job`
1. `bin/rails db:setup`
1. `bin/rails g good_job:install`
1. `bin/rails db:migrate`
1. Added `config.active_job.queue_adapter = :good_job` to `config/application.rb`
1. Created `app/jobs/my_job.rb` and `spec/jobs/my_job_spec.rb`
1. `bundle add rspec`
1. `bundle add --group development,test rspec-rails`
1. `bin/rails generate rspec:install`
1. `bundle exec rspec`

