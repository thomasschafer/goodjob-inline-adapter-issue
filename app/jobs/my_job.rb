class MyJob < ApplicationJob
  JobNotComplete = Class.new(StandardError)
  retry_on(JobNotComplete)

  def perform(job_id:)
    puts "MyJob: #{job_id}"

    if job_id >= 10
      puts "Succeeded"
      return
    end

    raise JobNotComplete if job_id == 2

    MyJob.perform_later(job_id: job_id + 1)
  end
end
