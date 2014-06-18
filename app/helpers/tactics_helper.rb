# Helper module for working with tactics.
module TacticsHelper
  
  # Fills tactics by default positions to contain 18 records. Default positions
  # are taken from +DEFAULT_TACTICS_POSITIONS+ constant.
  #
  # ==== Params
  # _record_:: tactics which chould be updated (instance od Tactics).
  #
  # ==== Returns
  # _boolean_:: true on success, false otherwise.
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
