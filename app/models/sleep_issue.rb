# frozen_string_literal: true

class SleepIssue < ApplicationRecord
  has_one :user
  has_many :issue_routines, dependent: :destroy
  has_many :routines, through: :issue_routines

  enum issue_type: {
    all_routine: 0,
    night_life: 1,
    late_falling_asleep: 2,
    waking_up_in_the_middle: 3,
  }

  ISSUE_POINTS = {
    night_life: '昼夜逆転してしまい、朝起きれなくなってしまう経験がある人は多いのではないかと思います。<br>朝頑張って起きて、昼寝しないようにし、夜なるべく早めに寝ることを継続し、少しずつ改善していきましょう。<br>ルーティーンの一例として、日記で夜型生活を抜けるという決意を書き出し、アロマを焚きながら眠りにつくというのはいかがでしょうか。<br>もし昼間に眠気が限界になってしまったらパワーナップを行うのがおすすめです。',
    late_falling_asleep: '寝たくても寝れない時間が続くと、ストレスですよね。<br>普段運動する習慣がない人は、運動を始めるのがおすすめです。軽い有酸素運動だけでも、眠気を引き起こす作用があります。<br>他にはホットドリンクを飲んだりデジタル・デトックスをすると、更に入眠作用があるのでおすすめです。<br>ルーティーンの一例として寝る直前にリラックス効果のある音楽を聴きながら寝てみてはいかがでしょうか。',
    waking_up_in_the_middle: 'ストレスやアルコール、カフェインが原因だと言われています。<br>例えばカフェインを夜に摂ってしまっている場合、眠りを浅くしてしまう原因になるので18時以降は摂ってしまわないように注意が必要です。<br>デジタル・デトックスや部屋の明かりを早めに暗くしておくことで寝る準備を行っておき、もし夜中に目が覚めてしまって眠れなくても、焦らずにストレッチや読書をして眠たくなったら再び眠りについてみてください。'
  }.transform_values(&:html_safe)
end
