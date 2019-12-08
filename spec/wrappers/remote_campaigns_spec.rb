require 'spec_helper'
require_relative '../../lib/wrappers/remote_campaigns'

describe RemoteCampaigns do
  it('should return remote campaigns as hash object with reference as key') do
    expect_any_instance_of(AdServiceClient).to receive(:get_ads).and_return(
      { ads: [ { reference: '1', status: 'enabled', description: 'Description for campaign 11' } ] }
    )
    remote_campaigns = RemoteCampaigns.new.all_as_hash
    expect(remote_campaigns).to eq({'1' => { reference: '1', status: 'enabled', description: 'Description for campaign 11' }})
  end
end