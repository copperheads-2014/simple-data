module UsersHelper
  def activity_log(user)
    collect_logs(user)
  end

  def collect_logs(user)
    collection = []
    services = Service.where(creator_id: user.id).to_a
    updates = ServiceUpdate.where(user_id: user.id).to_a
    collection << services
    collection << updates
    collection.flatten!
    sort_collection(collection)
  end

  def sort_collection(collection)
    @log = collection[0..-1].sort_by { |item| item.created_at }
  end
end
