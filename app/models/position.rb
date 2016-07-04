class Position < ApplicationRecord

  store_accessor :box, [:position_id, :salary_min, :salary_max]

  ## callbacks
  before_create :extract

  private
  def extract
    self.position_id = self.json['positionId']

    salary_text = self.json['salary']
    if (match_data = salary_text.match(/(\d+)k-(\d+)k/i)).present?
      self.salary_min = match_data[1].to_i * 1000
      self.salary_max = match_data[2].to_i * 1000
    elsif (match_data = salary_text.match(/(\d+)k以下/)).present?
      self.salary_max = match_data[1].to_i * 1000
    elsif (match_data = salary_text.match(/(\d+)k以上/)).present?
      self.salary_min = match_data[1].to_i * 1000
    end
  end
end
