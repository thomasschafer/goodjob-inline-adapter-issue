class MyBatchCallbackJob < ApplicationJob
  def perform(batch, _params)
    job_id = batch.properties[:job_id]
    puts "MyBatchCallbackJob: #{job_id}"

    MyJob.perform_later(job_id: [ job_id.first, 0 ])
  end
end
