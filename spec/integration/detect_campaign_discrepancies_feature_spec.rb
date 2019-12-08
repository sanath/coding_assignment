require 'spec_helper'
require_relative '../../lib/services/detect_campaign_discrepancies'

describe 'DetectCampaignDiscrepancies feature' do
  it 'should detect discrepancies' do
    Campaign.create(
      job_id: 'A123', status: 'enabled', external_reference: '1', ad_description: 'Rails Developer'
    )
    Campaign.create(
      job_id: 'A124', status: 'disabled', external_reference: '2', ad_description: 'React Developer'
    )
    Campaign.create(
      job_id: 'A125', status: 'enabled', external_reference: '3', ad_description: 'Java Developer'
    )
    Campaign.create(
      job_id: 'A126', status: 'disabled', external_reference: '4', ad_description: '.NET Developer'
    )
    Campaign.create(
      job_id: 'A127', status: 'enabled', external_reference: '5', ad_description: 'Python Developer'
    )

    response_body = '{
      "ads": [ 
        { "reference": "1", "status": "disabled", "description": "Rails Developer" },
        { "reference": "2", "status": "disabled", "description": "React Front End Developer" },
        { "reference": "8", "status": "disabled", "description": "SQL Developer" },
        { "reference": "3", "status": "disabled", "description": "Java/J2EE Developer" }
      ]
    }'

    stub_request(:get, "https://mockbin.org/bin/fcb30500-7b98-476f-810d-463a0b8fc3df")
      .with(
        headers: {
         'Accept'=>'*/*',
         'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
         'Host'=>'mockbin.org',
         'User-Agent'=>'Ruby'
         })
      .to_return(status: 200, body: response_body, headers: {})

    discrepancies = DetectCampaignDiscrepancies.new().call
    expected_discrepancies = [
      {
        remote_reference: '1',
        discrepancies: {
          status: {
            remote: 'disabled',
            local: 'enabled'
          }
        }
      },
      {
        remote_reference: '2',
        discrepancies: {
          description: {
            remote: 'React Front End Developer',
            local: 'React Developer'
          }
        }
      },
      {
        remote_reference: '3',
        discrepancies: {
          status: {
            remote: 'disabled',
            local: 'enabled'
          },  
          description: {
            remote: 'Java/J2EE Developer',
            local: 'Java Developer'
          }
        }
      }
    ]
    expect(discrepancies).to eq(expected_discrepancies)
  end
end