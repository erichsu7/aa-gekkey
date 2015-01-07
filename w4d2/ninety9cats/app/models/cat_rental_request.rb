class CatRentalRequest < ActiveRecord::Base
  validates :status, inclusion: ["PENDING", "APPROVED", "DENIED"]
  validates :cat_id, :start_date, :end_date, presence: true
  validate :no_overlapping_approved_requests?

  belongs_to :cat

  def deny!
    self.status = "DENIED"
    self.save!
  end

  def approve!
    ActiveRecord::Base.transaction do
      overlapping_requests.each { |r| r.deny! }
      self.status = "APPROVED"
      self.save!
    end
  end

  def overlapping_requests
    overlapping = []

    self.class.all.each do |r|
      next unless r.cat_id == self.cat_id
      if (self.start_date..self.end_date).cover?(r.start_date) ||
         (self.start_date..self.end_date).cover?(r.end_date) ||
         (self.start_date > r.start_date && self.end_date < r.end_date)
        overlapping << r
      end
    end

    overlapping
  end

  def overlapping_approved_requests
    overlapping_requests.select { |r| r.status == 'APPROVED' }
  end

  def no_overlapping_approved_requests?
    unless overlapping_approved_requests.empty?
      errors.add(:new_request, "can't overlap with approved request")
    end
  end
end
