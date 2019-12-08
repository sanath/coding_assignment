require 'spec_helper'
require_relative '../../lib/models/campaign'

describe Campaign do
  it "should have all the required attributes" do
    Campaign.delete_all
    campaign = Campaign.create(
      job_id: 'A123', status: 'active', external_reference: '2', ad_description: 'Rails Developer'
    )

    expect(campaign.job_id).to eq('A123')
    expect(campaign.status).to eq('active')
    expect(campaign.external_reference).to eq('2')
    expect(campaign.ad_description).to eq('Rails Developer')
  end
end