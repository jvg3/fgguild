task get_sims: :environment do
  Member.get_all_sims_cloud
end
