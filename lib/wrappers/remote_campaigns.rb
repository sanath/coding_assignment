class RemoteCampaigns

  def initialize()
    @remote_client = AdServiceClient.new
  end

  # in over context this helps to keep complexity O(n) instead of O(n^2)
  def all_as_hash
    Hash[all.collect { |item| [item[:reference], item] } ]
  end

  private

  def all
    @remote_client.get_ads[:ads]
  end
end