require 'rails_helper'

describe MyJob do
  it "Runs successfully" do
    described_class.perform_later(job_id: [ 0, 0 ])
  end
end
