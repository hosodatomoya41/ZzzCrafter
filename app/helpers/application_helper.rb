module ApplicationHelper
  def flash_classname(message_type)
    case message_type.to_sym
    when :success
      "bg-green-500 text-white"
    when :danger
      "bg-red-500 text-white"
    else
      "bg-gray-500 text-white"
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
