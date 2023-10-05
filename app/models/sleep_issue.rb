class SleepIssue < ApplicationRecord
  belongs_to :user, optional: true
  has_many :issue_routines, dependent: :destroy
  has_many :routines, through: :issue_routines
  
  enum issue_type: {
    night_life: 0, #夜型生活をしている 0:瞑想 アロマ 1:日記 ホットドリンク 3:パワーナップ 運動
    late_falling_asleep: 1, #寝付きが悪い 0:音楽鑑賞 瞑想 1:ホットドリンク デジタル・デトックス 3:運動 家事、整理整頓
    waking_up_in_the_middle: 2 #夜中に目が覚める 0:アロマ ストレッチ 1:部屋の明かりを暗くする  デジタル・デトックス 3:運動 家事、整理整頓
  }
end
