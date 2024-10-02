class MyJob < ApplicationJob
  JobNotComplete = Class.new(StandardError)
  retry_on(JobNotComplete, wait: 1, attempts: 10)

  def perform(job_id:, stop: false)
    puts "MyJob: #{job_id}"
    return if stop || job_id.first >= 10

    raise JobNotComplete if job_id.first == 2

    batch = GoodJob::Batch.new
    batch.add do
      (1..5).each do |n|
       MyJob.perform_later(job_id: [ job_id.first,  n ], stop: true)
     end
    end

    batch.enqueue(on_finish: MyBatchCallbackJob, job_id: [ job_id.first + 1, -1 ])
  end
end
