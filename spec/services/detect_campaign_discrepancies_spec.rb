require 'spec_helper'
require_relative '../../lib/services/detect_campaign_discrepancies'

describe DetectCampaignDiscrepancies do
  before :all do
    Campaign.delete_all
    Campaign.create(
      job_id: 'A123', status: 'active', external_reference: '1', ad_description: 'Rails Developer'
    )
  end

  it 'should not detect discrepancy if there is not discrepancies' do
    expect_any_instance_of(RemoteCampaigns).to receive(:all_as_hash).and_return(
      {'1' => { reference: '1', status: 'active', description: 'Rails Developer' }}
    )

    discrepancies = DetectCampaignDiscrepancies.new().call
    expected_discrepancies = [
      {
        remote_reference: '1',
        discrepancies: {}
      }
    ]
    expect(discrepancies).to eq(expected_discrepancies)
  end

  it 'should detect discrepancy if status is different' do
    expect_any_instance_of(RemoteCampaigns).to receive(:all_as_hash).and_return(
      {'1' => { reference: '1', status: 'disabled', description: 'Rails Developer' }}
    )

    discrepancies = DetectCampaignDiscrepancies.new().call
    expected_discrepancies = [
      {
        remote_reference: '1',
        discrepancies: {
          status: {
            remote: 'disabled',
            local: 'active'
          }
        }
      }
    ]
    expect(discrepancies).to eq(expected_discrepancies)
  end

  it 'should detect discrepancy if ad_description is different' do
    expect_any_instance_of(RemoteCampaigns).to receive(:all_as_hash).and_return(
      {'1' => { reference: '1', status: 'active', description: 'React Developer' }}
    )

    discrepancies = DetectCampaignDiscrepancies.new().call
    expected_discrepancies = [
      {
        remote_reference: '1',
        discrepancies: {
          description: {
            remote: 'React Developer',
            local: 'Rails Developer'
          }
        }
      }
    ]
    expect(discrepancies).to eq(expected_discrepancies)
  end

  it 'should detect discrepancy if status and ad_description are different' do
    expect_any_instance_of(RemoteCampaigns).to receive(:all_as_hash).and_return(
      {'1' => { reference: '1', status: 'disabled', description: 'React Developer' }}
    )

    discrepancies = DetectCampaignDiscrepancies.new().call
    expected_discrepancies = [
      {
        remote_reference: '1',
        discrepancies: {
          status: {
            remote: 'disabled',
            local: 'active'
          },
          description: {
            remote: 'React Developer',
            local: 'Rails Developer'
          }
        }
      }
    ]
    expect(discrepancies).to eq(expected_discrepancies)
  end

  it 'should handle if local category exists but remote category is absent' do
    expect_any_instance_of(RemoteCampaigns).to receive(:all_as_hash).and_return({})

    discrepancies = DetectCampaignDiscrepancies.new().call
    expected_discrepancies = []
    expect(discrepancies).to eq(expected_discrepancies)
  end

  it 'should handle if remote category exists but local category is absent' do
    expect_any_instance_of(RemoteCampaigns).to receive(:all_as_hash).and_return(
      {'5' => { reference: '5', status: 'active', description: 'React Developer' }}
    )

    discrepancies = DetectCampaignDiscrepancies.new().call
    expected_discrepancies = []
    expect(discrepancies).to eq(expected_discrepancies)
  end
end