module TacticsHelper
  def fill_squad(record)
    record.transaction do
      for a in DEFAULT_TACTICS_POSITIONS
        TacticsPlayer.new(
          :tactics => record,
          :player => nil,
          :position => a
        ).save!
      end
    end
    
    Rails.logger.info "TacticsPlayer for tactics ##{record.id.to_s} created"
    return true
  rescue ActiveRecord::RecordInvalid => invalid
    # TODO rescue logging or  something else
    Rails.logger.error "error during creating TacticsPlayer for tactics ##{record.id.to_s}"
    return false
  end
end
