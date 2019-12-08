require_relative '../../lib/wrappers/remote_campaigns'

class DetectCampaignDiscrepancies

  def call
    discrepancies = []
    remote_campaigns_map = RemoteCampaigns.new.all_as_hash

    Campaign.all.each do |campaign|
      remote_campaign = remote_campaigns_map[campaign.external_reference]
      next unless remote_campaign
 
      discrepancies.push(
        { remote_reference: remote_campaign[:reference], discrepancies: get_campaign_discrepancies(remote_campaign, campaign) }
      )
    end

    discrepancies
  end

  private

  def get_campaign_discrepancies(remote_campaign, campaign)
    campaign_discrepancies = {}

    if remote_campaign[:status] != campaign[:status]
      campaign_discrepancies[:status] = { remote: remote_campaign[:status], local: campaign[:status] }
    end

    if remote_campaign[:description] != campaign[:ad_description]
      campaign_discrepancies[:description] = { remote: remote_campaign[:description], local: campaign[:ad_description] }
    end

    campaign_discrepancies
  end
end