require 'spec_helper'
require_relative '../../lib/clients/ad_service_client'

describe AdServiceClient do
  it 'should get all ads' do
    response_body = '{
      "ads": [
        { "reference": "1", "status": "enabled", "description": "Description for campaign 11" },
        { "reference": "2", "status": "disabled", "description": "Description for campaign 12" },
        { "reference": "3", "status": "enabled", "description": "Description for campaign 13" }
      ]
    }'
    stub_request(:get, "https://mockbin.org/bin/fcb30500-7b98-476f-810d-463a0b8fc3df").
      to_return(
        status: 200, 
        body: response_body,
        headers: {}
      )

    ad_service_client = AdServiceClient.new
    ads_response = ad_service_client.get_ads
    ads = ads_response[:ads]
    expect(ads.length).to eq(3)
    expect(ads[0]).to eq({ reference: '1', status: 'enabled', description: 'Description for campaign 11' })
    expect(ads[1]).to eq({ reference: '2', status: 'disabled', description: 'Description for campaign 12' })
    expect(ads[2]).to eq({ reference: '3', status: 'enabled', description: 'Description for campaign 13' })
  end
end