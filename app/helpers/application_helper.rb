# frozen_string_literal: true

module ApplicationHelper
  def flash_message(type)
    color_mapping = { success: 'green', alert: 'red', notice: 'blue' }
    content_tag(:div, flash[type], class: "bg-#{color_mapping[type]}-500 text-white p-4 rounded") if flash[type]
  end

  def format_date_for_device(record_date)
    if browser.device.mobile?
      record_date.strftime('%-m/%-d') # スマホでは月日のみ
    else
      record_date.strftime('%Y/%m/%d') # デスクトップでは年月日
    end
  end

  def default_meta_tags
    {
      site: 'ZzzCrafter',
      title: '睡眠に役立つ習慣作りをサポートするサービス',
      reverse: true,
      charset: 'utf-8',
      description: 'ZzzCrafterを使えば時間帯・行動を好きな組み合わせで、睡眠の質が向上しているかどうかを管理することができます。',
      keywords: '睡眠,習慣,ルーティーン',
      canonical: request.original_url,
      separator: '|',
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: 'website',
        url: request.original_url,
        image: image_url('ogp.png'), # 配置するパスやファイル名によって変更すること
        local: 'ja_JP'
      },
      # Twitter用の設定を個別で設定する
      twitter: {
        card: 'summary_large_image', # Twitterで表示する場合は大きいカードにする
        image: image_url('ogp.png') # 配置するパスやファイル名によって変更すること
      }
    }
  end
end
